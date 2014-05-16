//
//  catchCustomerVIPWithOperateHistoryObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CatchCustomerVIPWithOperateHistoryObj.h"
#define kuserId  @"userId"
#define kcurPage  @"curPage"
#define kpageSize  @"pageSize"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation CatchCustomerVIPWithOperateHistoryObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:kuserId];
    [key addObject:kcurPage];
    [key addObject:kpageSize];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.userId];
    [key addObject:self.curPage];
    [key addObject:self.pageSize];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end
