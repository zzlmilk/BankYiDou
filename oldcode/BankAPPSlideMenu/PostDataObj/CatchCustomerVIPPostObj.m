//
//  CatchCustomerVIP.m
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CatchCustomerVIPPostObj.h"

#define KuserId        @"userId"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation   CatchCustomerVIPPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:KuserId];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.userId];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}
@end
