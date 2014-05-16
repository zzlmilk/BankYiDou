//
//  ChangeAttentionObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-24.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChangeAttentionObj.h"
#define kcustomerId  @"customerId"
#define kattentionType  @"attentionType"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation ChangeAttentionObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:kcustomerId];
    [key addObject:kattentionType];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.customerId];
    [key addObject:self.attentionType];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end
