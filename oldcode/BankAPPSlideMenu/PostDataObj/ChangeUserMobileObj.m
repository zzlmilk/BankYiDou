//
//  ChangeUserMobileObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChangeUserMobileObj.h"
#define kpassword  @"password"
#define kmobile  @"mobile"
#define kvercode @"vercode"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation ChangeUserMobileObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:kpassword];
    [key addObject:kmobile];
    [key addObject:kvercode];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.password];
    [key addObject:self.mobile];
    [key addObject:self.vercode];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end
