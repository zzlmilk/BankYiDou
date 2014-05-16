//
//  LoadingPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-4.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "LoadingPostObj.h"

#define Kmobile         @"mobile"
#define Kname           @"name"
#define Kvercode        @"vercode"  //验证码
#define Kinvitation     @"invitation" //邀请码
@implementation LoadingPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Kmobile];
    [key addObject:Kname];
        
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.mobile];
    [key addObject:self.name];
    
    return key;
}

@end
