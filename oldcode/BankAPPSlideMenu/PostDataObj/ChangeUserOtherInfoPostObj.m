//
//  ChangeUserOtherInfoPostObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChangeUserOtherInfoPostObj.h"
#define kqqCode  @"qqCode"
#define kwechatCode  @"wechatCode"
#define kblogType @"blogType"
#define kblogCode @"blogCode"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation ChangeUserOtherInfoPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:kqqCode];
    [key addObject:kwechatCode];
    [key addObject:kblogType];
    [key addObject:kblogCode];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.qqCode];
    [key addObject:self.wechatCode];
    [key addObject:self.blogType];
    [key addObject:self.blogCode];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end
