//
//  KeychainUtils.h
//  Association
//
//  Created by Chen Bing on 13-6-14.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainUtils : NSObject

+ (NSNumber *)getMemberID;
+ (NSNumber *)getDeviceID;

@end
