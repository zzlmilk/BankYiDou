//
//  CatchConsultantInfoPostObj.h
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface CatchConsultantInfoPostObj : SuperPostObj

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;


- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
