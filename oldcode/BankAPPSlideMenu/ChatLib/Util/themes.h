//
//  themes.h
//  EMEAPP
//
//  Created by Sean Li on 13-12-13.
//  Copyright (c) 2013年 YXW. All rights reserved.
//


@interface themes : NSObject

+(void)themesCellHeaderColorGradientWithCellView:(UIView*)view;
+(UIFont*)UIFontSizeWithEMEOfMark:(NSInteger)Mark;
+(UIColor*)UIFontColorWithEMEOfMark:(NSInteger)Mark;
+(UIColor*)UIBGColorWithEMEOfMark:(NSInteger)mark;

@end
