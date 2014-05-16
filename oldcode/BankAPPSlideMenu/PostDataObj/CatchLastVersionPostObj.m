//
//  CatchLastVersionPostObj.m
//  BankAPP
//
//  Created by kevin on 14-5-5.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CatchLastVersionPostObj.h"

#define KappCode     @"appCode"

@implementation CatchLastVersionPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:KappCode];
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:self.appCode];
    return key;
}

@end