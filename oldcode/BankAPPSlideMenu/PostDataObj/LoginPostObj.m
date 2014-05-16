//
//  LoginPostObj.m
//  Association
//
//  Created by appleUser on 13-5-21.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "LoginPostObj.h"

#define Kmobile        @"mobile"
#define Kpassword         @"password"

@implementation LoginPostObj


- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Kmobile];
    [key addObject:Kpassword];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.mobile];
    [key addObject:self.password];
    
    return key;
}


@end
