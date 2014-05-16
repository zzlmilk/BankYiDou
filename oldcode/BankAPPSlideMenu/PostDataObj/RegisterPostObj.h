//
//  SuperPostObj+loginPostObj.h
//  BankAPP
//
//  Created by kevin on 14-3-3.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface RegisterPostObj : SuperPostObj

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *vercode;  //验证码
@property (nonatomic, strong) NSString *invitation; //邀请码
@property (nonatomic, strong) NSString *password;

- (NSArray *)aryKey;
- (NSArray *)aryValue;


@end