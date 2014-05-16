//
//  UpdatePwdByOldPwd.h
//  BankAPP
//
//  Created by kevin on 14-3-13.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface UpdatePwdByVercodePostObj : SuperPostObj

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *vercode;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
