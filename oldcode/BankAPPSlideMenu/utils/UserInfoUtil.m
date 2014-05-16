//
//  UserInfoUtil.m
//  Association
//
//  Created by Chen Bing on 13-7-16.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "UserInfoUtil.h"

@implementation UserInfoUtil

+ (void)logoutUserInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getUserInfo]];
    [dict setObject:@"0" forKey:KDeviceID];
    [dict setObject:@"0" forKey:KMemberID];
    
    [self setUserInfo:dict];
}

+ (NSNumber *)getUserDeviceID
{
    NSDictionary *dict = [self getUserInfo];
    NSNumber *deviceid = [dict objectForKey:KDeviceID];
    if ([deviceid isKindOfClass:[NSNull class]] || 0 == [deviceid intValue]) {
        deviceid = [NSNumber numberWithInt:0];
    }
    return deviceid;
}

+ (void)setUserDeviceID:(id)data
{
    NSNumber *deviceid = [data objectForKey:@"data"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getUserInfo]];
    
    [dict setObject:deviceid forKey:KDeviceID];
    
    [self setUserInfo:dict];
}

+ (NSNumber *)getUserMemberID
{
    NSDictionary *dict = [self getUserInfo];
    NSNumber *memberid = [dict objectForKey:KMemberID];
    if ([memberid isKindOfClass:[NSNull class]] || 0 == [memberid intValue]) {
        memberid = [NSNumber numberWithInt:0];
    }
    return memberid;
}

+ (void)setUserMemberID:(id)data
{
    NSNumber *memberid = [data objectForKey:@"data"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getUserInfo]];
    
    [dict setObject:memberid forKey:KMemberID];
    
    [self setUserInfo:dict];
}

+ (NSDictionary *)getUserInfo
{
    NSString *plistPath = [self getUserInfoFilePath];
    NSDictionary *userInfo = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if (!userInfo) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"0" forKey:KDeviceID];
        [dict setObject:@"0" forKey:KMemberID];
    }
    
    return userInfo;
}

+ (BOOL)setUserInfo:(NSMutableDictionary *)userInfoDict
{
    NSString *plistPath = [self getUserInfoFilePath];
    
    return [userInfoDict writeToFile:plistPath atomically:YES];
}

+ (NSString *)getUserInfoFilePath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:KUserInfoFile];
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
    }
    return plistPath;
}

@end
