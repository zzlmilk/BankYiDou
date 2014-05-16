//
//  UrlucrecordUserStatusLogPostObj.h
//  BankAPP
//
//  Created by kevin on 14-4-28.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface UrlucrecordUserStatusLogPostObj : SuperPostObj
@property (nonatomic,strong) NSString *clientInfo;
@property (nonatomic,strong) NSString *actionType;
@property (nonatomic,strong) NSString *deviceInfo;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end