//
//  User.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-23.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "User.h"
#import "BankAppAPIClient.h"


@implementation User

-(instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }

    

    _displayName = [self.info objectForKey:@"dispName"];
    _userId = [self.info objectForKey:@"userId"];
    _pictureurl = [self.info objectForKey:@"pictureurl"];
    
    
    
    return self;
    
}


+(NSURLSessionDataTask*)userPostsParameters:(NSMutableDictionary *)parameters WithBlock:(void (^)(User *, NSError *))block{
  return   [[BankAppAPIClient sharedClient]POST:@"data/ds/uc/login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
      
      
      User *u = [[User alloc]initWithAttributes:responseObject];
      block(u,nil);
     
      
      
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
@end
