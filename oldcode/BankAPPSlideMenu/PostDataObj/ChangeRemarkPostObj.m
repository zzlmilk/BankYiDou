//
//  ChangeRemarkPostObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-25.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChangeRemarkPostObj.h"
#define kuserId @"userId"
#define kremark @"remark"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation ChangeRemarkPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:kuserId];
    [key addObject:kremark];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:self.userId];
    [key addObject:self.remark];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end
