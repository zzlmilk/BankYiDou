//
//  DialogUtil.m
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import "DialogUtil.h"

@implementation DialogUtil

+ (void)showMessage:(NSString *)msg title:(NSString *)title {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil, nil];
    [av show];
}

+ (void)showMessage:(NSString *)msg {
    if (msg.length == 0 || [msg isEqualToString:@""]) {
        msg = @"网络不太给力哦亲!";
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil, nil];
    [av show];

}
@end
