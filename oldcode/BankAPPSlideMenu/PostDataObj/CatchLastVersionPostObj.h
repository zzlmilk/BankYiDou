//
//  CatchLastVersionPostObj.h
//  BankAPP
//
//  Created by kevin on 14-5-5.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface CatchLastVersionPostObj : SuperPostObj

@property (nonatomic,strong) NSString *appCode;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
