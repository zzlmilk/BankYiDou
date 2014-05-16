//
//  UIFontUtil.m
//  Association
//
//  Created by Chen Bing on 13-7-27.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
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
