//
//  UserInfoUtil.h
//  Association
//
//  Created by Chen Bing on 13-7-16.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoUtil : NSObject

+ (void)logoutUserInfo;

+ (NSNumber *)getUserDeviceID;
+ (void)setUserDeviceID:(id)data;

+ (NSNumber *)getUserMemberID;
+ (void)setUserMemberID:(id)data;

@end
