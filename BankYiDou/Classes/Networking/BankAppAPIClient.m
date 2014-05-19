//
//  BankAppAPIClient.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-16.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "BankAppAPIClient.h"

@implementation BankAppAPIClient

static NSString * const APIBaseURLString = @"http://117.79.93.103/";




+ (instancetype)sharedClient {
    static BankAppAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BankAppAPIClient alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
