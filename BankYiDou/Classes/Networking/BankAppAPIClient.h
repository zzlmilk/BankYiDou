//
//  BankAppAPIClient.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-16.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface BankAppAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;


@end
