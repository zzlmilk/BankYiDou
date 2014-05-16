//
//  ImageUtils.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-12.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+ (NSString *)getImageUrl:(NSString *)imageString
{
    if ([imageString isKindOfClass:[NSNull class]] || [imageString isEqualToString:@""]) {
        return @"";
    }
    
    NSError *error = nil;
    NSString *search = @"/";
    imageString = [imageString substringWithRange:NSMakeRange(1, imageString.length - 1)];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:search options:NSRegularExpressionCaseInsensitive error:&error];
    NSMutableString *str = [[NSMutableString alloc] initWithString:imageString];
    imageString = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:@"%5C"];
    imageString = [NSString stringWithFormat:@"%@%@", KDownImagePath, imageString];
    //    NSLog(@"图片path = %@",imageString);
    return imageString;//[[NSMutableString alloc] initWithString:imageString];
}

+ (void)setImageWithURL:(NSString *)imagePath withImageView:(UIImageView *)iv
{
    NSString *placeholderPath = [[NSBundle mainBundle] pathForResource:@"icon-gear" ofType:@"png"];
    if ([imagePath isKindOfClass:[NSNull class]]) {
        imagePath = @"";
    }
    else {
        imagePath = [ImageUtils getImageUrl:imagePath];
    }
    //    NSLog(@"imagePath = %@",imagePath);
    UIImage *placeholderImg = [[UIImage alloc] initWithContentsOfFile:placeholderPath];
    [iv setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:placeholderImg];
}

//根据UIImageView等比缩放
+ (void)setImageRect:(NSDictionary *)sizeDict withImageView:(UIImageView *)iv
{
    CGFloat width = [[sizeDict objectForKey:@"w"] floatValue];
    CGFloat height = [[sizeDict objectForKey:@"h"] floatValue];
    if (0 != width && 0 != height) {
        CGRect imageRect = iv.frame;
        CGSize imageSize = imageRect.size;
        CGFloat originalScale = width / height;
//        CGFloat currentScale = imageSize.width / imageSize.height;
        /*
         if (originalScale >= currentScale) {
         //按照宽度来缩放
         imageSize.height = imageSize.width / originalScale;
         }
         else {
         //按照高度来缩放
         imageSize.width = imageSize.height * originalScale;
         }
         //*/
        
        //*
        //按照宽度来缩放
        imageSize.height = imageSize.width / originalScale;
        //*/
        
        imageRect.size = imageSize;
        [iv setFrame:imageRect];
    }
    
}

//根据屏幕宽度确定图片大小
+ (void)setImageMaximumRect:(NSDictionary *)sizeDict withImageView:(UIImageView *)iv
{
    CGFloat width = [[sizeDict objectForKey:@"w"] floatValue];
    CGFloat height = [[sizeDict objectForKey:@"h"] floatValue];
    if (0 != width && 0 != height) {
        CGRect imageRect = iv.frame;
        CGSize imageSize = imageRect.size;
        CGFloat scale = imageSize.width / width;
        imageSize.height = height * scale;
        imageRect.size = imageSize;
        [iv setFrame:imageRect];
    }
}


@end
