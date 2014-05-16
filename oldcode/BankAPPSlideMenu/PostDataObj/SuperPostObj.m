//
//  SuperPostObj.m
//  Association
//
//  Created by Mac 10.8 on 13-5-22.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

#define KData       @"code"
#define KAppimei    @"appimei"
#define KApptel     @"apptel"
#define KDeviceID   @"deviceid"

@implementation SuperPostObj

- (NSDictionary *)getPostDict:(NSDictionary *)dataDict
{
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] initWithDictionary:dataDict];
    
//    [postDict setValue:dataDict forKey:KData];

    
    
    return postDict;
}

- (NSDictionary *)getPostDictWithData:(NSString *)dataStr
{
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] initWithDictionary:[self getDict]];
    
//    [postDict setValue:dataStr forKey:KData];
    
    return postDict;
}

- (NSMutableDictionary *)getDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
//    NSNumber *deviceid = [UserInfoUtil getUserDeviceID];
    
//    [dict setValue:@"0000000000000000" forKey:KAppimei];
//    [dict setValue:@"13901234567" forKey:KApptel];
//    [dict setValue:deviceid forKey:KDeviceID];
    
    return dict;
}

@end
