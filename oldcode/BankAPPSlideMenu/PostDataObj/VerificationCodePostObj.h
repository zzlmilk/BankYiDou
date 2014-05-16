//
//  VerificationCodePostObj.h
//  Association
//
//  Created by appleUser on 13-5-21.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface VerificationCodePostObj : SuperPostObj

@property (nonatomic, strong) NSString *mobile;
 
- (NSDictionary *)getPostDict;

@end
