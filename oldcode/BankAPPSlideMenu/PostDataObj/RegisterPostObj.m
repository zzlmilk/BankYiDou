//
//  SuperPostObj+loginPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-3.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "RegisterPostObj.h"

#define Kmobile         @"mobile"
#define Kname           @"name"
#define Kvercode        @"vercode"  //验证码
#define Kinvitation     @"invitation" //邀请码
#define Kpassword       @"password"
@implementation RegisterPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Kmobile];
    [key addObject:Kname];
    [key addObject:Kvercode];
    [key addObject:Kinvitation];
    [key addObject:Kpassword];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.mobile];
    [key addObject:self.name];
    [key addObject:self.vercode];
    [key addObject:self.invitation];
    [key addObject:self.password];
    
    return key;
}
@end
