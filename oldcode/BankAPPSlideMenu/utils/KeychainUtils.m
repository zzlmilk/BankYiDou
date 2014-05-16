//
//  KeychainUtils.m
//  Association
//
//  Created by Chen Bing on 13-6-14.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "KeychainUtils.h"
#import "KeychainItemWrapper.h"


@implementation KeychainUtils

+ (NSNumber *)getMemberID
{
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:KUserInfoKey accessGroup:nil];
    NSNumber *memberid = [keyChain objectForKey:(__bridge id)kSecValueData];
    
    if ([memberid isKindOfClass:[NSNull class]]||0 == [memberid intValue]) {
        memberid = [NSNumber numberWithInt:0];
    }
    memberid = [UserInfoUtil getUserMemberID];
    return memberid;
}

+ (NSNumber *)getDeviceID
{
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:KUserInfoKey accessGroup:nil];
    NSNumber *deviceid = [keyChain objectForKey:(__bridge id)kSecAttrAccount];
    if ([deviceid isKindOfClass:[NSNull class]]||0 == [deviceid intValue]) {
        deviceid = [NSNumber numberWithInt:0];
    }
    deviceid = [UserInfoUtil getUserDeviceID];
    return deviceid;
}

@end
