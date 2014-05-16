//
//  UrlucrecordUserStatusLogPostObj.m
//  BankAPP
//
//  Created by kevin on 14-4-28.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "UrlucrecordUserStatusLogPostObj.h"

#define KclientInfo     @"clientInfo"
#define KactionType     @"actionType"
#define KdeviceInfo     @"deviceInfo"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation UrlucrecordUserStatusLogPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:KclientInfo];
    [key addObject:KactionType];
    [key addObject:KdeviceInfo];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:self.clientInfo];
    [key addObject:self.actionType];
    [key addObject:self.deviceInfo];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end