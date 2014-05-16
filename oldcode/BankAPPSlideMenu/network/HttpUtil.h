//
//  HttpUtil.h
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUtil : NSObject

+(NSString *)buildGetURL:(NSString*)urlString WithParameters:(NSDictionary *)parameters;
@end
