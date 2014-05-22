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

-(instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    
  
    self.title = [attributes objectForKey:@"title"];
    
    long long verifyTimeLong = [[attributes objectForKey:@"verifyTime"]longLongValue];
    NSString *verifyTime = [self changeTime:verifyTimeLong];
    self.time =verifyTime;
    
    self.privilegeImageUrl = [attributes objectForKey:@"pictureurl"];
    
    
    
    return self;
    
}



+(NSURLSessionDataTask *)privilegePostsWithBlock:(void (^)(NSArray *, NSError *))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // [dic setObject:@"pageSize" forKey:@"9"];
    
    
        [dic setObject:@"75" forKey:@"uid"];
        [dic setObject:@"Z6F484C8s4w095G7p1U5Z1n5v0U4u190t2i3A7wgiXs7l2VQA6EgynZ0G0oAw0Ei" forKey:@"token"];
    
    
    
    return [[BankAppAPIClient sharedClient]POST:@"data/ds/mi/listMaterialInfo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSArray *ary = [responseObject objectForKey:@"info"];
        NSArray *aryData = [ary objectAtIndex:0];
       
                
        NSMutableArray *privileges = [NSMutableArray array];
        for (int i =0 ; i<aryData.count; i++) {
            Privilege *p = [[Privilege alloc]initWithAttributes:[aryData objectAtIndex:i]];
            [privileges addObject:p];
        }
        
        block(privileges,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);       
    }];
}


#pragma mark -- Private
- (NSString *)changeTime:(long long)num
{
    NSString *strValue = @"";
    //发布时间
    long long value1 = num/1000;
    //取当前日期
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    long long value2 = [[NSNumber numberWithDouble:time]longLongValue];
    
    long long value = value2 - value1;
    if (value <= 0) {
        strValue = @"刚    刚";
    }else if (value < 60){
        strValue = [NSString stringWithFormat:@"%lld秒前",value];
    }else if (value <= 60*60){
        strValue = [NSString stringWithFormat:@"%lld分钟前",value/60];
    }else if (value <= 60*60*24){
        strValue = [NSString stringWithFormat:@"%lld小时前",value/(60*60)];
    }else if (value/(60*60*24)<10){
        strValue = [NSString stringWithFormat:@"%lld天前",value/(60*60*24)];
    }
    else{
        strValue = @"11";
        NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:value1];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"MM-dd"];
        strValue = [dateformatter stringFromDate:d];
    }
    return strValue;
}
@end
