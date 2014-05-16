
//
//  NSObject+CoreDataExchange.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-19.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "NSObject+CoreDataExchange.h"
#import "HandlerCoreDataManager.h"
#import "StringUtils.h"

#define  DialogEntityTableName  @"DialogEntity"


#define  RecentContactEntityTableName @"RecentContactsEntity"

@implementation NSObject (CoreDataExchange)

#pragma mark - 获取当前登陆账号Uid
-(NSString*)GetLoginUserId
{
    return  [NSString stringWithFormat:@"%@",[UserManager shareInstance].user.userId];;
}
-(NSString* )addCurrentLoginUserLimit
{
    return  [NSString stringWithFormat:@" loginUid = '%@' ",[self GetLoginUserId]];
}

#pragma mark - 历史聊天数据操作方法--DialogEntityTableName

-(NSArray*)selectDialogEntitiesWithCondTion:(NSString*)condition  Limit:(NSInteger)limit  ascending:(BOOL)isAscending
{
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName
                                                                                   condition:[NSString stringWithFormat:@" messageType != %d and %@",MessageTypeForIgnoreRecentMessage,condition]
                                                                                   sortByKey:@"time"
                                                                                       limit:limit
                                                                                   ascending:isAscending];
    if (entities_array !=nil  && [entities_array count]>0) {
        NSMutableArray *dialog_array = [[NSMutableArray alloc] initWithCapacity:2] ;
        for (NSManagedObject* MO in entities_array) {
            
            EMEDialogEntity* dialog = [[EMEDialogEntity alloc] init];
            [dialog setAttributeWithMessageId:[MO valueForKey:@"messageId"]
                                      FromUid:[MO valueForKey:@"fromUid"]
                                        ToUid:[MO valueForKey:@"toUid"]
                                  MessageType:[[MO valueForKey:@"messageType"] longValue]
                            MessageStatus:[[MO valueForKey:@"messageSendStatus"] longValue]
                                      Content:[MO valueForKey:@"contents"]
                                         Time:[NSDate dateWithTimeIntervalSince1970:[[MO valueForKey:@"time"] doubleValue]]];
            
            [dialog_array addObject:dialog];
            
        }
        return dialog_array;
    }else{
        return nil;
    }
}

#pragma mark -  最近联系人操作方法

-(NSArray*)selectRecentContactsWithCondition:(NSString*)condition  Limit:(NSInteger)limit
{
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:RecentContactEntityTableName condition:condition  sortByKey:@"time" limit:limit ascending:NO];
    if (entities_array !=nil  && [entities_array count]>0) {
        NSMutableArray *dialog_array = [[NSMutableArray alloc] initWithCapacity:2] ;
        for (NSManagedObject* MO in entities_array) {
            
            EMERecentContactsEntity* dialog = [[EMERecentContactsEntity alloc] init];
            [dialog setAttributeWithMessageId:[MO valueForKey:@"messageId"]
                                      FromUid:[MO valueForKey:@"fromUid"]
                                        ToUid:[MO valueForKey:@"toUid"]
                                  MessageType:[[MO valueForKey:@"messageType"] longValue]
                                MessageStatus:[[MO valueForKey:@"messageSendStatus"] longValue]
                                      Content:[MO valueForKey:@"contents"]
                                         Time:[NSDate dateWithTimeIntervalSince1970:[[MO valueForKey:@"time"] doubleValue]]];
            
            [dialog setAttributeWithContactUid:[MO valueForKey:@"contactUid"]
                                    FromSource:[MO valueForKey:@"fromSource"]
                               ContactNickName:[MO valueForKey:@"contactNickName"]
                                ContactHeadUrl:[MO valueForKey:@"contactHeadUrl"]];
            
            //未读消息
            dialog.unReadMessagesCount =  [[MO valueForKey:@"unReadMessagesCount"] integerValue];
            
            [dialog_array addObject:dialog];
            
        }
        return dialog_array;
    }else{
        return nil;
    }
    
}

//注历msgId作为索引值存放的
//查询指定内容

-(NSArray*)getAllDialogEntitiesWithStatusTypes:(MessageStatusUnit)statusTypesUnit
                            WithToUidOrGroupId:(NSString *)toUidOrGroupId
                                       isGroup:(BOOL)isGroup
                                 SearchContent:(NSString*)searchContent
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    NSInteger backUnit = statusTypesUnit;
    NSInteger one = 1UL;
    
    while (backUnit != 0) {
        [condtion  appendFormat:@" messageSendStatus = %ld ",(long)statusTypesUnit&one];
        backUnit = backUnit>>1;
        one = one << 1;
        if (backUnit != 0) {
            [condtion appendFormat:@" or "];
        }
    }
    
    [condtion  setString:[NSString stringWithFormat:@" (%@) and %@ ",condtion,[self addCurrentLoginUserLimit]]];
    if (isGroup) {
        [condtion appendFormat:@" and groupId ='%@'",toUidOrGroupId];
        
    }else{
        [condtion appendFormat:@" and (toUid ='%@' || fromUid = '%@')  and  groupId = '%@' ",toUidOrGroupId,toUidOrGroupId,[StringUtils getEmptyUUID]];
        
    }
    
    if (searchContent && [CommonUtils stringLengthWithString:searchContent] > 0) {
        [condtion appendFormat:@" and (contents like[cd] '*%@*')",searchContent];
    }
    
    return  [self selectDialogEntitiesWithCondTion:condtion Limit:0 ascending:NO];
}

//注历msgId作为索引值存放的
//查询
-(NSArray*)getAllDialogEntitiesWithStatusTypes:(MessageStatusUnit)statusTypesUnit
                            WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                       isGroup:(BOOL)isGroup
{

  return  [self  getAllDialogEntitiesWithStatusTypes:statusTypesUnit WithToUidOrGroupId:toUidOrGroupId isGroup:isGroup SearchContent:nil];
}

//3--junyi.zhu debug//获取最新的消息,根据时间查询之前的十条记录
-(NSArray*)getlatestDialogEntitiesWithLimitTime:(NSDate*)LimitTime
                             LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                             WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                        isGroup:(BOOL)isGroup{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" time < %0.0lf and  %@ ",[LimitTime timeIntervalSince1970],[self addCurrentLoginUserLimit]];

//    if (isGroup) {
//        [condtion appendFormat:@" and groupId ='%@'",toUidOrGroupId];
//
//    }else{
        [condtion appendFormat:@" and (toUid ='%@' || fromUid = '%@') ",toUidOrGroupId,toUidOrGroupId];
//    }
    
    return  [self selectDialogEntitiesWithCondTion:condtion
                                             Limit:LimitRecordsNumber
                                         ascending:NO];
}






//新的 获取联系人数据方法
-(NSArray*)selectRecentContactsWithCondition:(NSString*)condition
{
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:RecentContactEntityTableName condition:condition  sortByKey:@"time" limit:100 ascending:NO];
    if (entities_array !=nil  && [entities_array count]>0) {
        NSMutableArray *dialog_array = [[NSMutableArray alloc] initWithCapacity:2] ;
        for (NSManagedObject* MO in entities_array) {
            
            EMERecentContactsEntity* dialog = [[EMERecentContactsEntity alloc] init];
            [dialog setAttributeWithMessageId:[MO valueForKey:@"messageId"]
                                      FromUid:[MO valueForKey:@"fromUid"]
                                        ToUid:[MO valueForKey:@"toUid"]
                                  MessageType:[[MO valueForKey:@"messageType"] longValue]
                                MessageStatus:[[MO valueForKey:@"messageSendStatus"] longValue]
                                      Content:[MO valueForKey:@"contents"]
                                         Time:[NSDate dateWithTimeIntervalSince1970:[[MO valueForKey:@"time"] doubleValue]]];
            
            [dialog setAttributeWithContactUid:[MO valueForKey:@"contactUid"]
                                    FromSource:[MO valueForKey:@"fromSource"]
                               ContactNickName:[MO valueForKey:@"contactNickName"]
                                ContactHeadUrl:[MO valueForKey:@"contactHeadUrl"]];
            
            //未读消息
            dialog.unReadMessagesCount =  [[MO valueForKey:@"unReadMessagesCount"] integerValue];
            
            [dialog_array addObject:dialog];
            
        }
        return dialog_array;
    }else{
        return nil;
    }
    
}
//新的3 附件   查询
-(NSArray*)getlatestRecentContactEntiesWithLimitTime{
    
    return  [self selectRecentContactsWithCondition:[NSString stringWithFormat:@"loginUid == '%@'",[UserManager shareInstance].user.userId]];
}

//查询    3附件--junyi.zhu debug   RecentContactEntityTableName
-(NSArray*)getlatestRecentContactEntiesWithLimitTime:(NSDate*)LimitTime
                             LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                             WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                        isGroup:(BOOL)isGroup{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" time < %0.0lf and  %@ ",[LimitTime timeIntervalSince1970],[self addCurrentLoginUserLimit]];
    
    if (isGroup) {
        [condtion appendFormat:@" and groupId ='%@'",toUidOrGroupId];
        
    }else{
        [condtion appendFormat:@" and (toUid ='%@' || fromUid = '%@') ",toUidOrGroupId,toUidOrGroupId];
    }
    
    return  [self selectRecentContactsWithCondition:condtion
                                              Limit:LimitRecordsNumber];
}

//获取指定的一条消息记录
-(EMEDialogEntity*)getDialogEntityWithMessageId:(NSString*)messageId
{
    
    if (messageId == nil) {
        return nil;
    }
    
    NSArray*   recordArray =   [self selectDialogEntitiesWithCondTion:[NSString stringWithFormat:@"messageId =='%@' and %@ ",messageId,[self addCurrentLoginUserLimit]]
                                                                Limit:1
                                                            ascending:NO];
    if (recordArray && [recordArray count]>0) {
        return [recordArray objectAtIndex:0];
    }else{
        return nil;
    }
    
}

//插入数据--消息列表
-(BOOL)insertDialogEntityWithMessageId:(NSString*)messageId
                               FromUid:(NSString*)fromUid
                                 ToUid:(NSString*)toUid
                               GroupId:(NSString*)groupId
                           MessageType:(MessageType)type
                         MessageStatus:(MessageStatus)sendStatus
                               Content:(NSString*)content
                                  Time:(NSDate*)time
{
    BOOL success = NO;
    
    if (messageId!=nil) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName index:messageId indexName:@"messageId" OtherCondition:[NSString stringWithFormat:@" messageType != %d and %@",MessageTypeForIgnoreRecentMessage,[self addCurrentLoginUserLimit]]];
        if (MO==nil) {//表示创建一个插入新的值
            MO =  [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:DialogEntityTableName];

            [MO setValue:messageId forKey:@"messageId"];
            [MO setValue:[self  GetLoginUserId] forKey:@"loginUid"];
        }
        
        if (fromUid != nil) {
            NSString * strfromuid =[NSString stringWithFormat:@"%@",fromUid];
            [MO setValue:strfromuid forKey:@"fromUid"];
        }
        
        if (toUid != nil) {
            NSString * strtouid = [NSString stringWithFormat:@"%@",toUid];
            [MO setValue:strtouid forKey:@"toUid"];
        }
        
        
        [MO setValue:[NSNumber numberWithInt:type] forKey:@"messageType"];
        [MO setValue:[NSNumber numberWithInt:sendStatus] forKey:@"messageSendStatus"];
        
        if (content) {
            [MO setValue:content forKey:@"contents"];
        }
        
        if (time == nil) {
            time = [NSDate date];
        }
        [MO setValue:[NSString stringWithFormat:@"%0.0lf",[time timeIntervalSince1970] ] forKey:@"time"];
        
        
        
        
        success = [[HandlerCoreDataManager shareInstance] saveContext];
        
    }
    return success;
    
    
}
-(BOOL)insertDialogEntityWithWithObject:(EMEDialogEntity*)dialogEntity
{
    return  [self  insertDialogEntityWithMessageId:dialogEntity.messageId
                                           FromUid:dialogEntity.fromUid
                                             ToUid:dialogEntity.toUid
                                           GroupId:dialogEntity.groupId
                                       MessageType:dialogEntity.type
                                 MessageStatus:dialogEntity.sendStatus
                                           Content:dialogEntity.content
                                              Time:dialogEntity.time];
}

//更新记录
-(BOOL)updateDialogEntityWithMessageId:(NSString*)messageId
                               FromUid:(NSString*)fromUid
                                 ToUid:(NSString*)toUid
                               GroupId:(NSString*)groupId
                           MessageType:(MessageType)type
                     MessageStatus:(MessageStatus)sendStatus
                               Content:(NSString*)content
                                  Time:(NSDate*)time
{
    return  [self  insertDialogEntityWithMessageId:messageId
                                           FromUid:fromUid
                                             ToUid:toUid
                                           GroupId:groupId
                                       MessageType:type
                                 MessageStatus:sendStatus
                                           Content:content
                                              Time:time];
    
}
-(BOOL)updateDialogEntity:(EMEDialogEntity*)dialogEntity
{
    return  [self  updateDialogEntityWithMessageId:dialogEntity.messageId
                                           FromUid:dialogEntity.fromUid
                                             ToUid:dialogEntity.toUid
                                           GroupId:dialogEntity.groupId
                                       MessageType:dialogEntity.type
                                 MessageStatus:dialogEntity.sendStatus
                                           Content:dialogEntity.content
                                              Time:dialogEntity.time];
}


//删除--聊天记录

-(BOOL)removeAllDialogEntitiesWithCondition:(NSString*)condition
{
    //去除最近联系人记录
     BOOL success = NO;
    NSArray* historysArray =   [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName
                                                                                   condition:[NSString stringWithFormat:@" messageType != %d and %@",MessageTypeForIgnoreRecentMessage,condition]
                                                                                   sortByKey:nil
                                                                                       limit:0
                                                                                   ascending:NO];
    if (historysArray != nil && [historysArray count] > 0) {
        for (NSManagedObject* MO in historysArray) {
            [[HandlerCoreDataManager shareInstance] deleteNotSaveWithObject:MO];
        }
        success = [[HandlerCoreDataManager shareInstance] saveContext];
    }
    return success;
}



-(BOOL)removeAllDialogEntitiesWithOnlyLoginUser:(BOOL)isOnlyLoginUser;
{
    return [self removeAllDialogEntitiesWithCondition:(isOnlyLoginUser ? [self addCurrentLoginUserLimit] : nil)];
    
}



-(BOOL)removeAllDialogEntitiesWithStatusTypes:(MessageStatusUnit)statusTypesUnit WithToUidOrGroupId:(NSString*)toUidOrGroupId  isGroup:(BOOL)isGroup
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    NSInteger backUnit = statusTypesUnit;
    NSInteger one = 1UL;
    while (backUnit != 0) {
        [condtion  appendFormat:@" messageSendStatus = %ld ",statusTypesUnit&one];
        backUnit = backUnit>>1;
        one = one << 1;
        if (backUnit != 0) {
            [condtion appendFormat:@" or "];
        }
    }
    [condtion  setString:[NSString stringWithFormat:@" (%@) and %@ ",condtion,[self addCurrentLoginUserLimit]]];
    if (isGroup) {
        [condtion appendFormat:@" and groupId ='%@'",toUidOrGroupId];
        
    }else{
        [condtion appendFormat:@" and (toUid ='%@' || fromUid = '%@')  and  groupId = '%@' ",toUidOrGroupId,toUidOrGroupId,[StringUtils getEmptyUUID]];
     }
    

    
    return [self removeAllDialogEntitiesWithCondition:condtion];
}

-(BOOL)removeDialogEntityWithMessageId:(NSString*)messageId
{
    NSMutableString* condtion = [NSMutableString  stringWithFormat:@"messageId =='%@' and %@ ",messageId,[self addCurrentLoginUserLimit]];
    
    return [self removeAllDialogEntitiesWithCondition:condtion];
    
}



//查询联系人
-(NSArray*)getAllRecentContactsWithloginUid:(NSString*)loginUid
{
    NSArray* recentloginUidArray = [self selectRecentContactsWithCondition:[NSString stringWithFormat:@"loginUid == '%@'",loginUid]];
    if (recentloginUidArray && [recentloginUidArray count] >0) {
        return [recentloginUidArray objectAtIndex:0];
    }else{
        return nil;
    }
    return [self selectRecentContactsWithCondition:[self addCurrentLoginUserLimit]];
}

//获取指定的一个联系人记录 junyi.zhu debug
-(EMERecentContactsEntity*)getRecentContactWithContactUid:(NSString*)contactUid
{
    NSArray* recentContactsArray = [self selectRecentContactsWithCondition:[NSString stringWithFormat:@"contactUid == '%@' and %@",contactUid,[self addCurrentLoginUserLimit]] Limit:1];
    if (recentContactsArray && [recentContactsArray count] >0) {
        return [recentContactsArray objectAtIndex:0];
    }else{
        return nil;
    }

}

//插入数据--最近联系人 --junyi.zhu debug
-(BOOL)insertRecentContactsEntityWithNoMessageWithContactUid:(NSString*)contactUid
                              ContactFromSource:(NSString*)fromSource
                                ContactNickName:(NSString*)nickName
                                 ContactHeadUrl:(NSString*)headUrl
                                      MessageId:(NSString*)messageId
                                        FromUid:(NSString*)fromUid
                                          ToUid:(NSString*)toUid
                                        GroupId:(NSString*)groupId
                                    MessageType:(MessageType)type
                                  MessageStatus:(MessageStatus)sendStatus
                                        Content:(NSString*)content
                                           Time:(NSDate*)time
{
    BOOL isSuccess = NO;
    
    
    //自动判断获取最近联系人Id
    if (!contactUid) {
        NSString * strloginuid =[NSString stringWithFormat:@"%@",[UserManager shareInstance].user.userId];
        fromUid =[NSString stringWithFormat:@"%@",fromUid];
        toUid = [NSString stringWithFormat:@"%@",toUid];
        //表示是收到一条消息
        if (![fromUid isEqualToString:strloginuid]) {
            contactUid = fromUid;
        }else{
            contactUid = toUid;
        }
    }
    
    //统计未读消息
    NSInteger unReadCount = 0;
    
    //    //表示是自己发送的消息，自己发送的消息，进行计数
    //    if ([CurrentUserID isEqualToString:fromUid]) {
    //
    //    }
    //    //表示正在聊天，所以计数器为0
    if ([[UserManager shareInstance] isOnDialogVCWithUserId:contactUid]) {
        unReadCount = 0;
    }
    
    
    
    if (contactUid) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:RecentContactEntityTableName index:contactUid indexName:@"contactUid" OtherCondition:[self addCurrentLoginUserLimit]];
        
        if (MO==nil) {//表示创建一个插入新的值
            MO =  [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:RecentContactEntityTableName];
            [MO setValue:contactUid forKey:@"contactUid"];
            
            
            [MO setValue:[self GetLoginUserId] forKey:@"loginUid"];
        }
        
        //表示未读消息，需要添加上之前未读消息

            unReadCount = [[MO valueForKey:@"unReadMessagesCount"] integerValue];

        
        //        [MO setValue:[NSNumber numberWithInt:unReadCount] forKey:@"unReadMessagesCount"];
        [MO setValue:[NSNumber numberWithLong:unReadCount] forKey:@"unReadMessagesCount"];
        
        
        
        if (fromSource) {
            [MO setValue:fromSource forKey:@"fromSource"];
        }
        
        if (nickName) {
            [MO setValue:nickName forKey:@"contactNickName"];
        }
        
        if (headUrl) {
            [MO setValue:headUrl forKey:@"contactHeadUrl"];
        }
        
        //最后一条消息
        if (messageId) {
            [MO setValue:messageId forKey:@"messageId"];
        }
        
        if (fromUid != nil) {
            [MO setValue:fromUid forKey:@"fromUid"];
        }
        
        if (toUid != nil) {
            [MO setValue:toUid forKey:@"toUid"];
        }
        
        if (groupId !=nil) {
            [MO setValue:groupId forKey:@"groupId"];
        }
        
        //内容，区分语音
        if (content) {
            [MO setValue:(type == MessageTypeForSoundFragment ? @"[语音]" : content) forKey:@"contents"];
        }
        
        
        //注意这里是用来区分是否是聊天消息的
        [MO setValue:[NSNumber numberWithInt:MessageTypeForIgnoreRecentMessage] forKey:@"messageType"];
        
        [MO setValue:[NSNumber numberWithInt:sendStatus] forKey:@"messageSendStatus"];
        
        
        
        if (time != nil) {
//            time = [NSDate date];
            [MO setValue:[NSString stringWithFormat:@"%0.0lf",[time timeIntervalSince1970] ] forKey:@"time"];
        }
        
        isSuccess = [[HandlerCoreDataManager shareInstance] saveContext];
        
    }
    
    return isSuccess;
}


//插入数据--最近联系人 --junyi.zhu debug
-(BOOL)insertRecentContactsEntityWithContactUid:(NSString*)contactUid
                              ContactFromSource:(NSString*)fromSource
                                ContactNickName:(NSString*)nickName
                                 ContactHeadUrl:(NSString*)headUrl
                                      MessageId:(NSString*)messageId
                                        FromUid:(NSString*)fromUid
                                          ToUid:(NSString*)toUid
                                        GroupId:(NSString*)groupId
                                    MessageType:(MessageType)type
                                  MessageStatus:(MessageStatus)sendStatus
                                        Content:(NSString*)content
                                           Time:(NSDate*)time
{
    BOOL isSuccess = NO;
    
    
//自动判断获取最近联系人Id
    if (!contactUid) {
         NSString * strloginuid =[NSString stringWithFormat:@"%@",[UserManager shareInstance].user.userId];
        fromUid =[NSString stringWithFormat:@"%@",fromUid];
        toUid = [NSString stringWithFormat:@"%@",toUid];
        //表示是收到一条消息
        if (![fromUid isEqualToString:strloginuid]) {
            contactUid = fromUid;
        }else{
            contactUid = toUid;
        }
    }
    
    //统计未读消息
    NSInteger unReadCount = 1;
    
//    //表示是自己发送的消息，自己发送的消息，进行计数
//    if ([CurrentUserID isEqualToString:fromUid]) {
//        
//    }
//    //表示正在聊天，所以计数器为0
    if ([[UserManager shareInstance] isOnDialogVCWithUserId:contactUid]) {
        unReadCount = 0;
    }
    
    
    
    if (contactUid) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:RecentContactEntityTableName index:contactUid indexName:@"contactUid" OtherCondition:[self addCurrentLoginUserLimit]];
        
        if (MO==nil) {//表示创建一个插入新的值
             MO =  [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:RecentContactEntityTableName];
            [MO setValue:contactUid forKey:@"contactUid"];
           
         
            [MO setValue:[self GetLoginUserId] forKey:@"loginUid"];
        }
        
        //表示未读消息，需要添加上之前未读消息
        if (unReadCount != 0) {
            unReadCount += [[MO valueForKey:@"unReadMessagesCount"] integerValue];
         }
        
//        [MO setValue:[NSNumber numberWithInt:unReadCount] forKey:@"unReadMessagesCount"];
        [MO setValue:[NSNumber numberWithLong:unReadCount] forKey:@"unReadMessagesCount"];

        
        
        if (fromSource) {
            [MO setValue:fromSource forKey:@"fromSource"];
        }
        
        if (nickName) {
            [MO setValue:nickName forKey:@"contactNickName"];
        }
        
        if (headUrl) {
            [MO setValue:headUrl forKey:@"contactHeadUrl"];
        }
        
        //最后一条消息
        if (messageId) {
            [MO setValue:messageId forKey:@"messageId"];
        }
        
        if (fromUid != nil) {
            [MO setValue:fromUid forKey:@"fromUid"];
        }
        
        if (toUid != nil) {
            [MO setValue:toUid forKey:@"toUid"];
        }
        
        if (groupId !=nil) {
            [MO setValue:groupId forKey:@"groupId"];
        }
        
        //内容，区分语音
        if (content) {
            [MO setValue:(type == MessageTypeForSoundFragment ? @"[语音]" : content) forKey:@"contents"];
        }
        
        
        //注意这里是用来区分是否是聊天消息的
        [MO setValue:[NSNumber numberWithInt:MessageTypeForIgnoreRecentMessage] forKey:@"messageType"];
        
        [MO setValue:[NSNumber numberWithInt:sendStatus] forKey:@"messageSendStatus"];
        
     
        
        if (time == nil) {
            time = [NSDate date];
        }
        [MO setValue:[NSString stringWithFormat:@"%0.0lf",[time timeIntervalSince1970] ] forKey:@"time"];
        
        isSuccess = [[HandlerCoreDataManager shareInstance] saveContext];
        
    }
 
    return isSuccess;
}



-(BOOL)insertRecentContactsEntityWithContactUid:(NSString*)contactUid
                              ContactFromSource:(NSString*)fromSource
                                ContactNickName:(NSString*)nickName
                                 ContactHeadUrl:(NSString*)headUrl
                                   DialogEntity:(EMEDialogEntity*)dialogEntity
{
    return  [self insertRecentContactsEntityWithContactUid:contactUid
                                         ContactFromSource:fromSource
                                           ContactNickName:nickName
                                            ContactHeadUrl:headUrl
                                                 MessageId:dialogEntity ?  dialogEntity.messageId : nil
                                                   FromUid:dialogEntity ?  dialogEntity.fromUid : nil
                                                     ToUid:dialogEntity ?  dialogEntity.toUid : nil
                                                   GroupId:dialogEntity ?  dialogEntity.groupId : nil
                                               MessageType:dialogEntity ?  dialogEntity.type : MessageTypeForSystemMessage
                                             MessageStatus:dialogEntity ?  dialogEntity.sendStatus : MessageStatusForSendSuccess
                                                   Content:dialogEntity ?  dialogEntity.content : nil
                                                      Time:dialogEntity ?  dialogEntity.time : nil];
}



-(BOOL)insertRecentContactsEntityWithoutMessageWithContactUid:(NSString*)contactUid
                              ContactFromSource:(NSString*)fromSource
                                ContactNickName:(NSString*)nickName
                                 ContactHeadUrl:(NSString*)headUrl
                                   DialogEntity:(EMEDialogEntity*)dialogEntity
{
    return  [self insertRecentContactsEntityWithNoMessageWithContactUid:contactUid
                                         ContactFromSource:fromSource
                                           ContactNickName:nickName
                                            ContactHeadUrl:headUrl
                                                 MessageId:dialogEntity ?  dialogEntity.messageId : nil
                                                   FromUid:dialogEntity ?  dialogEntity.fromUid : nil
                                                     ToUid:dialogEntity ?  dialogEntity.toUid : nil
                                                   GroupId:dialogEntity ?  dialogEntity.groupId : nil
                                               MessageType:dialogEntity ?  dialogEntity.type : MessageTypeForSystemMessage
                                             MessageStatus:dialogEntity ?  dialogEntity.sendStatus : MessageStatusForSendSuccess
                                                   Content:dialogEntity ?  dialogEntity.content : nil
                                                      Time:dialogEntity ?  dialogEntity.time : nil];
}





-(BOOL)insertRecentContactsEntityWithObject:(EMERecentContactsEntity *)recentContactsEntity
{
  return  [self insertRecentContactsEntityWithContactUid:recentContactsEntity.contactUid
                                 ContactFromSource:recentContactsEntity.fromSource
                                   ContactNickName:recentContactsEntity.contactNickName
                                    ContactHeadUrl:recentContactsEntity.contactHeadUrl
                                         MessageId:recentContactsEntity.messageId
                                           FromUid:recentContactsEntity.fromUid
                                             ToUid:recentContactsEntity.toUid
                                           GroupId:recentContactsEntity.groupId
                                       MessageType:recentContactsEntity.type
                                     MessageStatus:recentContactsEntity.sendStatus
                                           Content:recentContactsEntity.content
                                              Time:recentContactsEntity.time];

}

//更新数据
-(BOOL)updateRecentContactsEntityWithContactUid:(NSString*)contactUid
                              ContactFromSource:(NSString*)fromSource
                                ContactNickName:(NSString*)nickName
                                 ContactHeadUrl:(NSString*)headUrl
                                   DialogEntity:(EMEDialogEntity*)dialogEntity
{
return  [self insertRecentContactsEntityWithContactUid:contactUid
                                     ContactFromSource:fromSource
                                       ContactNickName:nickName
                                        ContactHeadUrl:headUrl
                                          DialogEntity:dialogEntity];
}

-(BOOL)updateRecentContactsEntityWithObject:(EMERecentContactsEntity *)recentContactsEntity
{
    return [self insertRecentContactsEntityWithObject:recentContactsEntity];
}

//清空未读消息
-(BOOL)clearRecentContactsEntityUnreadMessagesCountWithContactUid:(NSString*)contactUid
{
    BOOL isSuccess = NO;
    if (contactUid) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:RecentContactEntityTableName index:contactUid indexName:@"contactUid" OtherCondition:[self addCurrentLoginUserLimit]];
        if (MO) {
        //先减去统计的总数
            [[UserManager shareInstance] removeNoticeCountWithCount:[[MO valueForKey:@"unReadMessagesCount"] intValue]];
            
            
            [MO setValue:[NSNumber numberWithInt:0] forKey:@"unReadMessagesCount"];
            isSuccess =  [[HandlerCoreDataManager shareInstance] saveContext];
        }else{
            NIF_ALLINFO(@"不存在的记录,说明数据记录有问题");
        }
    }
    return isSuccess;
}

//删除联系人数据


-(BOOL)removeRecentContactsEntityWithCondition:(NSString*)condition
{
    BOOL success = NO;
    NSArray* historysArray =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:RecentContactEntityTableName
                                                                                  condition:condition
                                                                                  sortByKey:nil];
    if (historysArray != nil && [historysArray count] > 0) {
        for (NSManagedObject* MO in historysArray) {
            [[HandlerCoreDataManager shareInstance] deleteNotSaveWithObject:MO];
        }
        success = [[HandlerCoreDataManager shareInstance] saveContext];
    }
    return success;
}

-(BOOL)removeAllRecentContacts
{
    return [self removeRecentContactsEntityWithCondition:[self addCurrentLoginUserLimit]];
}

-(BOOL)removeRecentContactsWithContactUid:(NSString*)contactUid
{
    return [self removeRecentContactsEntityWithCondition:[NSString stringWithFormat:@"contactUid == '%@' and %@",contactUid,[self addCurrentLoginUserLimit]]];
}

@end
