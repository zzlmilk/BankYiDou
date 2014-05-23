//
//  User.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-23.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultData.h"

@interface User : ResultData
{}
@property (nonatomic,strong)NSString *displayName;
@property (nonatomic,strong)NSString *insertTime;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *pictureurl;
@property(nonatomic,strong) NSString *realName;
/*
 updateTime = 1400485732201;
 updateUser = 42;
 userConsultant = 2;
 userStatus = 2;
 userType = 0;
 vipNumber = 430477932;
 */


@property (nonatomic,strong) NSString *userId;





+ (NSURLSessionDataTask *)userPostsParameters:(NSMutableDictionary *)parameters WithBlock:(void (^)(User *user, NSError *error))block;
@end
