//
//  RegularExpressions.m
//  T_E_F
//
//  Created by 贺 寅杰 on 13-3-24.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "RegularExpressions.h"

@implementation RegularExpressions

//手机号格式的正则表达式
+(BOOL)judgmentMobile:(NSString *)mobile{
    
    NSString * regexMobile = @"(^[1][3-8]+\\d{9})";
    NSPredicate * predMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexMobile];
    BOOL isMatchMobile = [predMobile evaluateWithObject:mobile];
    return isMatchMobile;
}

//正则表达式，密码格式（范围a－z,A-Z,0-9）
+(BOOL)judgmentPassword:(NSString *)password{
    NSString * regexPassword = @"(\\w{4,16})";
    NSPredicate * predPassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPassword];
    BOOL isMatchPassword = [predPassword evaluateWithObject:password];
    return isMatchPassword;
}

//判断参数是否为数字,size,为需要判断的长度
+(BOOL)judgmentNumber:(NSString *)integer andSize:(int) IntegerSize{
    NSString * regexPassword1 = @"^\\d{";
//    NSLog(@" ns :  %@",[regexPassword1 stringByAppendingFormat:@"%@}$", [[NSString alloc]initWithFormat:@"%d",IntegerSize]]);
    NSPredicate * predPassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [regexPassword1 stringByAppendingFormat:@"%@}$", [[NSString alloc]initWithFormat:@"%d",IntegerSize]]];
    BOOL isMatchPassword=FALSE;
    @try {
        isMatchPassword = [predPassword evaluateWithObject:integer];
    } @catch (NSException *exception) {
        NSLog(@"judgmentNumber main: Caught %@: %@", [exception name], [exception reason]);
    } @finally {
    }
    return isMatchPassword;
}
@end
