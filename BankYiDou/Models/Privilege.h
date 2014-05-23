//
//  Privilege.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-19.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Privilege : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString  *privilegeImageUrl;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;



+ (NSURLSessionDataTask *)privilegePostsParameters:(NSMutableDictionary *)parameters WithBlock:(void (^)(NSArray *privileges, NSError *error))block;


@end
