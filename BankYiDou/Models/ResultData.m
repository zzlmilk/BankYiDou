//
//  ResultData.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-23.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "ResultData.h"

@implementation ResultData

-(instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    _code = [attributes objectForKey:@"code"];
    _message = [attributes objectForKey:@"msg"]; 
    _time  = [attributes objectForKey:@"time"];
    _uid = [attributes objectForKey:@"uid"];
    _token = [attributes objectForKey:@"token"];
    
    
    NSArray * array  = (NSArray *)[attributes objectForKey:@"info"] ;
    _info = [array objectAtIndex:0];
    
    
    return self;
    
}





@end
