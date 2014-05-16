//
//  themes.m
//  EMEAPP
//
//  Created by Sean Li on 13-12-13.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "themes.h"
#import "EMEConstants.h"
#import "EMEConfigManager.h"
@interface themes ()

@end

@implementation themes

+(void)themesCellHeaderColorGradientWithCellView:(UIView*)view{

    if (view == nil) {
        return;
    }
    
    CAGradientLayer *gradientLayer = (CAGradientLayer*)view.layer;//[[CAGradientLayer alloc] init];
    
// Set the colors for the gradient layer.
static NSMutableArray *colors = nil;
if (colors == nil) {
    colors = [[NSMutableArray alloc] initWithCapacity:3];
    UIColor *color = nil;
    color = UIColorFromRGB(0xF9EFE8);
    [colors addObject:(id)[color CGColor]];
    color =UIColorFromRGB(0xF5ECE6);
    [colors addObject:(id)[color CGColor]];
    color = UIColorFromRGB(0xEEE5DB);
    [colors addObject:(id)[color CGColor]];
}
    
    if ([colors count] == 3) {
    
        [gradientLayer setColors:colors];
        [gradientLayer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
        
//        for (id tempGradientLayer in [view.layer sublayers]) {
//            if ([tempGradientLayer isKindOfClass:[CAGradientLayer class]]) {
//                [tempGradientLayer removeFromSuperlayer];
//            }
//        }
//        [view.layer addSublayer:gradientLayer];
    }

}

+(UIFont*)UIFontSizeWithEMEOfMark:(NSInteger)Mark
{
    NSString *evFontSizeMark  = [NSString stringWithFormat:@"font_size%02d",Mark];
     return UIFontFromString(evFontSizeMark);
}

+(UIColor*)UIFontColorWithEMEOfMark:(NSInteger)Mark
{
    NSString *evFontColorMark =  [NSString stringWithFormat:@"font_color%02d",Mark];;
    return UIColorFromString(evFontColorMark);

}

+(UIColor*)UIBGColorWithEMEOfMark:(NSInteger)mark
{
    NSString *evBGColorMark =  [NSString stringWithFormat:@"bg_color%02d",mark];;
    return UIColorFromString(evBGColorMark);

}

@end
