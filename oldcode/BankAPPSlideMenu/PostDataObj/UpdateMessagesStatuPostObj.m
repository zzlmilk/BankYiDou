//
//  UpdateMessagesStatuPostObj.m
//  BankAPP
//
//  Created by kevin on 14-5-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "UpdateMessagesStatuPostObj.h"


#define Kuid         @"uid"
#define Ktoken       @"token"
#define KfromStatu   @"fromStatu"
#define KtoStatu     @"toStatu"
#define KuserId      @"userId"


@implementation UpdateMessagesStatuPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    [key addObject:KfromStatu];
    [key addObject:KtoStatu];
    [key addObject:KuserId];

    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:self.uid];
    [key addObject:self.token];
    [key addObject:self.fromStatu];
    [key addObject:self.toStatu];
    [key addObject:self.userId];

    return key;
}

@end