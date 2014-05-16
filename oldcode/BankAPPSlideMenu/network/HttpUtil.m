//
//  HttpUtil.m
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import "HttpUtil.h"
#import "AppDelegate.h"
#import "NSString+Utils.h"


static NSString* const kQuerySeperator = @"?";
static NSString* const kParamSeperator = @"&";

@implementation HttpUtil

+(NSString *)buildGetURL:(NSString*)urlString WithParameters:(NSDictionary *)parameters
{
    NSMutableString *urlGETRequest = [NSMutableString stringWithString:urlString];
    if (![urlGETRequest hasSuffix:kQuerySeperator]) {
        [urlGETRequest appendString:kQuerySeperator];
    }
    
    for (NSString* key in parameters.allKeys)
    {
//        [urlGETRequest appendFormat:@"%@=%@&",key, [[parameters valueForKey:key] URLEncodedString]];
        [urlGETRequest appendFormat:@"%@=%@&",key, [parameters valueForKey:key]];
    }
    if ([urlGETRequest hasSuffix:kParamSeperator])
    {
        [urlGETRequest deleteCharactersInRange:NSMakeRange(urlGETRequest.length -1, 1)];
    }
    return urlGETRequest;
}

@end
