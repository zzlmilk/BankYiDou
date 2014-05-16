//
//  AnalyseResponseUtil.h
//  Association
//
//  Created by Chen Bing on 13-5-30.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyseResponseUtil : NSObject

@property (strong, nonatomic) NSDictionary *responseDict;

- (id)initWithResponseDict:(NSDictionary *)response;

//- (BOOL)isSucceed;
//- (NSString *)getErrMessage;
- (id)getResponseData;

@end
