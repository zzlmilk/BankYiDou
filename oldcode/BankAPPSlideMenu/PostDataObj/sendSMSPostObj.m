//
//  sendSMSPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-6.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "sendSMSPostObj.h"

#define Kmobile         @"mobile"


@implementation sendSMSPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Kmobile];
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.mobile];
    return key;
}
@end
