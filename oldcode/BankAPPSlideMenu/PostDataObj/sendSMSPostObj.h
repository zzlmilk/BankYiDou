//
//  sendSMSPostObj.h
//  BankAPP
//
//  Created by kevin on 14-3-6.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface sendSMSPostObj : SuperPostObj

@property (nonatomic, strong) NSString *mobile;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end

