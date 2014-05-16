//
//  LogoutPostObj.h
//  BankAPP
//
//  Created by kevin on 14-5-6.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface LogoutPostObj : SuperPostObj

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *clientInfo;
@property (nonatomic,strong) NSString *deviceInfo;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end