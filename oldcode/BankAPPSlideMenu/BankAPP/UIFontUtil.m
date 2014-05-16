//
//  UIFontUtil.m
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "UIFontUtil.h"

@implementation UIFontUtil

+ (UIFont *)getNavTitleFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:18];
    return font;
}

+ (UIFont *)getListTitleFont
{
    UIFont *font = [UIFont systemFontOfSize:19];
    return font;
}

+ (UIFont *)getListContentFont
{
    UIFont *font = [UIFont systemFontOfSize:12];
    return font;
}

+ (UIFont *)getListTimeFont
{
    UIFont *font = [UIFont systemFontOfSize:12];
    return font;
}

@end
