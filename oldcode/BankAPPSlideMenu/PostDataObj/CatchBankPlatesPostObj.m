//
//  CatchBankPlatesPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-7.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CatchBankPlatesPostObj.h"

#define Ktoken         @"token"
#define KlastTime      @"lastTime"
#define Kuid           @"uid"

@implementation CatchBankPlatesPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Ktoken];
    [key addObject:KlastTime];
    [key addObject:Kuid];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];

    [key addObject:self.token];
    [key addObject:self.lastTime];
    [key addObject:self.uid];
    return key;
}

@end
