//
//  VerificationCodePostObj.m
//  Association
//
//  Created by appleUser on 13-5-21.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "VerificationCodePostObj.h"
#define KMobile             @"mobile"

@implementation VerificationCodePostObj

- (NSDictionary *)getPostDict
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    
    [dataDict setValue:self.mobile forKey:KMobile];
    
    NSDictionary *postDict = [super getPostDict:dataDict];
    
    return postDict;
}

@end
