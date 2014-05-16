//
//  CheckTokenPostObj.m
//  BankAPP
//
//  Created by kevin on 14-5-6.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CheckTokenPostObj.h"

#define Kuid     @"uid"
#define Ktoken     @"token"


@implementation CheckTokenPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end