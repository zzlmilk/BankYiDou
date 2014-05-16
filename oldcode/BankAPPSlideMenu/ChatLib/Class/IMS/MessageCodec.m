//
//  MessageCodec.m
//  ims
//
//  Created by Tony Ju on 10/16/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import "MessageCodec.h"
#import "NSString+base64.h"
#import "NSDataUtils.h"
#import "ChatViewController.h"

@implementation MessageCodec
@synthesize stringuid;


+(void)decodeToArray:(NSData *)data  withBolck:(DecodeSuccessBlock)decodeSuccessBlock
{
    
    NSMutableArray *strArray = [[NSMutableArray alloc]init];
    
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (![[newStr  substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"["]) {
        newStr = [NSString stringWithFormat:@"[%@]",newStr];
    }
    
    
    newStr = [newStr stringByReplacingOccurrencesOfString:@"}{" withString:@"},{"];
    
    strArray = [newStr JSONValue];
    
    for (NSDictionary* dic in strArray) {
        Message* message = [[Message alloc] init];
        
//        NSError  *error;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dic);
        NSString * type = [dic objectForKey:@"type"];
        if ([type isEqualToString:@"MESSAGE"]) {//文本消息
            NSLog(@" 新消息。。。。。。。。。");
        }
        if ([type isEqualToString:@"DISCONNECT"]) {//断开连接
            return;
        }
        if ([type isEqualToString:@"MESSAGE_CONFIRM"]) {//确认消息发送到服务器
            
        }
        NSString *strcontent = [dic objectForKey:@"content"];
        NSLog(@"%@",strcontent);
        NSString *strsendtime = [dic objectForKey:@"sendTime"];
        NSLog(@"%@",strsendtime);
        NSString *strmid = [dic objectForKey:@"mid"];
        NSLog(@"%@",strmid);
        
        
        //    {"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0},{"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0},{"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0}{"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0}
        
        message.uid = [dic objectForKey:@"mid"];
        message.from = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sendUser"]];
        message.to = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveUser"]];
        message.theuid = [UserManager shareInstance].user.userId;
        message.contents = [dic objectForKey:@"content"];
        message.eventDate = [NSDate date];
        //    message.eventDate = [dic objectForKey:@"sendTime"];
        message.commandId = COMMAND_SEND_P2P_MESSAGE;
        message.type = MSG_TYPE_TEXT;
        message.direction = MSG_DIRECTION_SERVER_TO_CLIENT;
        message.status = MSG_STATUS_READ;
        
        if (decodeSuccessBlock) {
            decodeSuccessBlock(message);
        }
        NSLog(@"接收返回的消息。。。。。%@",message);

    }
    
    
    
    
    //表示还有消息,递归解析
    /*
     int messageLenth =  CFSwapInt32BigToHost(*(int*)([[data subdataWithRange:NSMakeRange(0, 4)] bytes]));
     int leaveDataLenth = (int)[data length] - messageLenth;
     if (leaveDataLenth > 0) {
     NSData* leaveData  = [data subdataWithRange:NSMakeRange(messageLenth, leaveDataLenth)];
     return [self.class decode:leaveData withBolck:decodeSuccessBlock];
     }
     */
    
}

+(Message *)decode:(NSData *)data  withBolck:(DecodeSuccessBlock)decodeSuccessBlock
{
    
    Message* message = [[Message alloc] init];
    
    NSError  *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",dic);
    NSString *strcontent = [dic objectForKey:@"content"];
    NSLog(@"%@",strcontent);
    NSString *strsendtime = [dic objectForKey:@"sendTime"];
    NSLog(@"%@",strsendtime);
    NSString *strmid = [dic objectForKey:@"mid"];
    NSLog(@"%@",strmid);


    //    {"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0},{"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0},{"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0}{"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0}

    message.uid = [dic objectForKey:@"mid"];
    message.from = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sendUser"]];
    message.to = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveUser"]];
    message.theuid = [UserManager shareInstance].user.userId;
    message.contents = [dic objectForKey:@"content"];
    message.eventDate = [NSDate date];
//    message.eventDate = [dic objectForKey:@"sendTime"];
    message.commandId = COMMAND_SEND_P2P_MESSAGE;
    message.type = MSG_TYPE_TEXT;
    message.direction = MSG_DIRECTION_SERVER_TO_CLIENT;
    message.status = MSG_STATUS_READ;

    if (decodeSuccessBlock) {
        decodeSuccessBlock(message);
    }
    
    NSLog(@"接收返回的消息。。。。。%@",message);

    //表示还有消息,递归解析
    /*
    int messageLenth =  CFSwapInt32BigToHost(*(int*)([[data subdataWithRange:NSMakeRange(0, 4)] bytes]));
    int leaveDataLenth = (int)[data length] - messageLenth;
    if (leaveDataLenth > 0) {
        NSData* leaveData  = [data subdataWithRange:NSMakeRange(messageLenth, leaveDataLenth)];
        return [self.class decode:leaveData withBolck:decodeSuccessBlock];
    }
    */
    
    return message;
}

+ (NSData *) encodeRegister:(Message *)message  :(int)capacity {
    capacity = capacity + 168;
    NSMutableData* result = [[NSMutableData alloc] init];

    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString* theuseruid = [mySettingData objectForKey:@"uid"];
    
    NSNumber *  numuid = [NSNumber numberWithFloat:[theuseruid floatValue]];
    NSDictionary * dict2 = [NSDictionary dictionaryWithObjectsAndKeys:strtoken,@"token",numuid,@"sendUser",@"IOS_VIP",@"appCode",@"REGIST",@"type",nil];
    NSError *ror;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict2
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&ror];
    
    [result appendData:jsonData];
    return result;

}

-(NSString *)trimStringValue:(NSString *)sender{
    if([sender isKindOfClass:[NSNull class]] || !sender){
        return @"";
        
    }else{
        return sender;
    }
}



+ (NSData *) encode:(Message *)message  :(int)capacity {
    capacity = capacity + 168;
    NSMutableData* result = [[NSMutableData alloc] init];
    NSString* contents = message.contents;
    
    NSString * struid = message.uid;
//    NSString * sUid = [struid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString * midstring = [ struid stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    [result appendData:[NSDataUtils convertIntToNSData:capacity]];
//    NSData* uid  = [message.uid dataUsingEncoding:NSUTF8StringEncoding];
//    [result appendData:uid];
    NSLog(@"dffff%@",midstring);
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *stringuid = [mySettingData objectForKey:@"uid"];
    NSNumber *  numuid = [NSNumber numberWithFloat:[stringuid floatValue]];
    NSString *strType = [mySettingData objectForKey:@"userType"];
    NSString * userConsultant = [mySettingData objectForKey:@"userConsultant"];
    if ([strType isEqualToString:@"1"]) {
        stringuid = message.to;
        
        NSLog(@"%@",stringuid);
    }
    else
    {
        stringuid =userConsultant;
    }
    
    NSNumber * str222 =[NSNumber numberWithFloat:[stringuid floatValue]];
    NSString* newStr = contents;//[[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];

    if (contents != nil) {
        capacity = capacity + (int)[contents length];
        
    }
//    NSDictionary * dict =[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"sendUser",@"IOS_VIP",@"appCode",newStr,@"content",@"MESSAGE",@"type",nil];
      NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"IOS_VIP",@"appCode",newStr,@"content", midstring,@"mid",str222,@"receiveUser",numuid,@"sendUser",@"MESSAGE",@"type",nil];
//    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"IOS_VIP",@"appCode",newStr,@"content",@"",@"mid",@"","sendTime",str222,@"receiveUser",ustring,"sendUser",@"MESSAGE",@"type",nil];
//   model.AppDetailId = [[CommonMethods getInstance] trimStringValue:[dataArr valueForKey:@"app_id"]];
  
//格式1：    {"appCode":"ANDROID_VIP","content":"u4t5W721g2C6D2X1z1H2Q2w3p0d4O1K0m2JOLFXwBepPYlEiqTLju35FSnsJKpH5","sendUser":1,"type":"REGIST","unReadNum":0}
//格式2：
//    {"appCode":"ANDROID_VIP","content":"理财师","messageStatus":"SEND","mid":"7d0acc04570148e0a072524131872514","receiveUser":17,"sendTime":1395459142527,"sendUser":4,"type":"MESSAGE","unReadNum":0}

//    NSString * dict1 = @"{\"content\":newStr,\"messageId\":4,\"receiveUser\":6,\"sendUser\":\"6\",\"type\":\"MESSAGE\"}";

//    NSString* str = [NSString stringWithFormat:@"%@", dict];
//
    
//    NSData* strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *ror;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&ror];
    
//    NSString *string = [[NSString alloc]initWithData:strData encoding:NSUTF8StringEncoding];
    [result appendData:jsonData];
    
    
    
    if (contents != nil) {
//        [result appendData:contents];
    }
    
    return result;
}


@end