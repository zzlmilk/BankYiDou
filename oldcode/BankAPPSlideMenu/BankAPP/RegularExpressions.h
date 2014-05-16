//
//  RegularExpressions.h
//  T_E_F
//
//  Created by 贺 寅杰 on 13-3-24.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularExpressions : NSObject
+(BOOL)judgmentMobile:(NSString *)mobile;
+(BOOL)judgmentPassword:(NSString *)password;
+(BOOL)judgmentNumber:(NSString *)integer andSize:(int) IntegerSize;
@end
