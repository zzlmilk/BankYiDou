//
//  DialogUtil.h
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DialogUtil : NSObject

+ (void)showMessage:(NSString *)msg;
+ (void)showMessage:(NSString *)msg title:(NSString *)title;
@end
