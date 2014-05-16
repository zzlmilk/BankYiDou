//
//  LoginPostObj.h
//  Association
//
//  Created by appleUser on 13-5-21.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface LoginPostObj : SuperPostObj

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;


- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
