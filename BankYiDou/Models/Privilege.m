//
//  Privilege.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-19.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "Privilege.h"
#import "BankAppAPIClient.h"

@implementation Privilege

+(NSURLSessionDataTask *)privilegePostsWithBlock:(void (^)(NSArray *, NSError *))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"pageSize" forKey:@"9"];
        [dic setObject:@"uid" forKey:@"76"];
        [dic setObject:@"token" forKey:@"M5m2R602u1o4K3n7K0p7V1v5K0n441T0N2MkppIKhGQNj79wywYmEPDEFiGcxUaZ"];
    
    
    return [[BankAppAPIClient sharedClient]POST:@"/data/ds/mi/listMaterialInfo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
       
    }];
}
@end
