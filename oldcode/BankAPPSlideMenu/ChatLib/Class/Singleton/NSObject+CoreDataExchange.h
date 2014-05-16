//
//  NSObject+CoreDataExchange.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-19.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "EMEDialogEntity.h"
#import "EMERecentContactsEntity.h"

@interface NSObject (CoreDataExchange)
#pragma mark - 获取当前登陆账号Uid
-(NSString*)GetLoginUserId;


#pragma mark - 历史聊天数据操作方法
//注历msgId作为索引值存放的
//查询
-(NSArray*)getAllDialogEntitiesWithStatusTypes:(MessageStatusUnit)statusTypesUnit
                            WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                       isGroup:(BOOL)isGroup;

//查询指定内容
-(NSArray*)getAllDialogEntitiesWithStatusTypes:(MessageStatusUnit)statusTypesUnit
                            WithToUidOrGroupId:(NSString *)toUidOrGroupId
                                       isGroup:(BOOL)isGroup
                                 SearchContent:(NSString*)searchContent;

//获取最新的消息,根据时间查询之前的十条记录
-(NSArray*)getlatestDialogEntitiesWithLimitTime:(NSDate*)LimitTime
                             LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                             WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                        isGroup:(BOOL)isGroup;


-(NSArray*)getlatestRecentContactEntiesWithLimitTime:(NSDate*)LimitTime
                                  LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                                  WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                             isGroup:(BOOL)isGroup;

//获取指定的一条消息记录
-(EMEDialogEntity*)getDialogEntityWithMessageId:(NSString*)messageId;


//插入消息数据
-(BOOL)insertDialogEntityWithMessageId:(NSString*)messageId
                               FromUid:(NSString*)fromUid
                                 ToUid:(NSString*)toUid
                               GroupId:(NSString*)groupId
                           MessageType:(MessageType)type
                         MessageStatus:(MessageStatus)sendStatus
                               Content:(NSString*)content
                                  Time:(NSDate*)time;
-(BOOL)insertDialogEntityWithWithObject:(EMEDialogEntity*)dialogEntity;


//更新记录
-(BOOL)updateDialogEntityWithMessageId:(NSString*)messageId
                               FromUid:(NSString*)fromUid
                                 ToUid:(NSString*)toUid
                               GroupId:(NSString*)groupId
                           MessageType:(MessageType)type
                         MessageStatus:(MessageStatus)sendStatus
                               Content:(NSString*)content
                                  Time:(NSDate*)time;
-(BOOL)updateDialogEntity:(EMEDialogEntity*)dialogEntity;


//删除
-(BOOL)removeAllDialogEntitiesWithOnlyLoginUser:(BOOL)isOnlyLoginUser;

-(BOOL)removeAllDialogEntitiesWithStatusTypes:(MessageStatusUnit)statusTypesUnit
                           WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                      isGroup:(BOOL)isGroup;

-(BOOL)removeDialogEntityWithMessageId:(NSString*)messageId;


-(NSArray*)getlatestRecentContactEntiesWithLimitTime;

#pragma mark -  最近联系人操作方法
//查询
-(NSArray*)getAllRecentContactsWithloginUid:(NSString*)loginUid;
-(EMERecentContactsEntity*)getRecentContactWithContactUid:(NSString*)contactUid;

//插入联系人数据
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
                                           Time:(NSDate*)time;

-(BOOL)insertRecentContactsEntityWithContactUid:(NSString*)contactUid
                              ContactFromSource:(NSString*)fromSource
                                ContactNickName:(NSString*)nickName
                                 ContactHeadUrl:(NSString*)headUrl
                                   DialogEntity:(EMEDialogEntity*)dialogEntity;




-(BOOL)insertRecentContactsEntityWithoutMessageWithContactUid:(NSString*)contactUid
                                            ContactFromSource:(NSString*)fromSource
                                              ContactNickName:(NSString*)nickName
                                               ContactHeadUrl:(NSString*)headUrl
                                                 DialogEntity:(EMEDialogEntity*)dialogEntity;





-(BOOL)insertRecentContactsEntityWithObject:(EMERecentContactsEntity *)recentContactsEntity;

//更新数据
-(BOOL)updateRecentContactsEntityWithContactUid:(NSString*)contactUid
                              ContactFromSource:(NSString*)fromSource
                                ContactNickName:(NSString*)nickName
                                 ContactHeadUrl:(NSString*)headUrl
                                   DialogEntity:(EMEDialogEntity*)dialogEntity;

-(BOOL)updateRecentContactsEntityWithObject:(EMERecentContactsEntity *)recentContactsEntity;

//清空未读消息
-(BOOL)clearRecentContactsEntityUnreadMessagesCountWithContactUid:(NSString*)contactUid;

//删除数据
-(BOOL)removeAllRecentContacts;
-(BOOL)removeRecentContactsWithContactUid:(NSString*)contactUid;

@end
