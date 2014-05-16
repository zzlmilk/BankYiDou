//
//  ChangeUserMobileObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface ChangeUserMobileObj : SuperPostObj
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *vercode;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
