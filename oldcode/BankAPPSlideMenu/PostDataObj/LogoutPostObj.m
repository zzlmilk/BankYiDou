//
//  LogoutPostObj.m
//  BankAPP
//
//  Created by kevin on 14-5-6.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "LogoutPostObj.h"

#define Kuid     @"uid"
#define Ktoken     @"token"
#define KclientInfo     @"clientInfo"
#define KdeviceInfo     @"deviceInfo"


@implementation LogoutPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    [key addObject:KclientInfo];
    [key addObject:KdeviceInfo];
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:self.uid];
    [key addObject:self.token];
    [key addObject:self.clientInfo];
    [key addObject:self.deviceInfo];
    return key;
}

@end