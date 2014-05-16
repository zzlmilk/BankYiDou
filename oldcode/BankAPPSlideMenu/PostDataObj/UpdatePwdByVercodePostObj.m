//
//  UpdatePwdByOldPwd.m
//  BankAPP
//
//  Created by kevin on 14-3-13.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "UpdatePwdByVercodePostObj.h"

#define Kmobile        @"mobile"
#define Kpassword      @"password"
#define Kvercode       @"vercode"

@implementation  UpdatePwdByVercodePostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Kmobile];
    [key addObject:Kpassword];
    [key addObject:Kvercode];
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.mobile];
    [key addObject:self.password];
    [key addObject:self.vercode];
    return key;
}
@end
