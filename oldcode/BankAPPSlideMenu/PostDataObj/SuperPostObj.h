//
//  SuperPostObj.h
//  Association
//
//  Created by Mac 10.8 on 13-5-22.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KeychainUtils.h"

@interface SuperPostObj : NSObject

- (NSDictionary *)getPostDict:(NSDictionary *)dataDict;
- (NSMutableDictionary *)getDict;


- (NSDictionary *)getPostDictWithData:(NSString *)dataStr;

//- (NSDictionary *)getPostDict:(NSDictionary *)dataDict withDeviceID:(NSString *)deviceID;

@end
