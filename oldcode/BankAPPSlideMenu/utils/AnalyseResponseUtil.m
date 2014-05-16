//
//  AnalyseResponseUtil.m
//  Association
//
//  Created by Chen Bing on 13-5-30.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "AnalyseResponseUtil.h"

#define KSucceed @"succeed"
#define KInfo @"info"
#define KCode @"code"


@implementation AnalyseResponseUtil

- (id)initWithResponseDict:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        self.responseDict = response;
    }
    return self;
}

//- (BOOL)isSucceed
//{
//    BOOL succeed = [[self.responseDict valueForKey:@"code"] boolValue];
//    return succeed;
//}

//- (NSString *)getErrMessage
//{
//    NSString *msg;
//    if (self.responseDict) {
//        msg = [self.responseDict objectForKey:KCode];
//        if ([msg isEqualToString:@"9999"]) {
//            msg = @"失败";
//        }
//        else if ([msg isEqualToString:@"9003"])
//        {
//            msg = @"手机号码格式错误";
//        }
//    }
//    
//    else {
//        msg = NSLocalizedString(@"RequestFailed", nil);
//    }    
//    return msg;
//}

- (id)getResponseData
{
    id data = [self.responseDict objectForKey:KInfo];
    return data;
}

@end
