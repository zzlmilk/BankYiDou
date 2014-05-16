//
//  LogUtil.m
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import "LogUtil.h"

@implementation LogUtil

+(void)errorLog:(NSString *)log function:(NSString *)function {
    NSLog(@"!!!Error: %@ %@", function, log);
}

@end
