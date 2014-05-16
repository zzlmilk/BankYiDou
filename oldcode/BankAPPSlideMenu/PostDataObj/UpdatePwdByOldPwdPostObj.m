//
//  UpdatePwdByOldPwdPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "UpdatePwdByOldPwdPostObj.h"

#define Koldpwd         @"oldpwd"
#define Kpassword       @"password"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation  UpdatePwdByOldPwdPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Koldpwd];
    [key addObject:Kpassword];
    [key addObject:Kuid];
    [key addObject:Ktoken];

    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.oldpwd];
    [key addObject:self.password];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}
@end
