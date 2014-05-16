//
//  ImageUtils.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-12.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

+ (NSString*)getImageUrl:(NSString *)imageString;

+ (void)setImageWithURL:(NSString *)imagePath withImageView:(UIImageView *)iv;

//根据UIImageView等比缩放(---还没用)
+ (void)setImageRect:(NSDictionary *)sizeDict withImageView:(UIImageView *)iv;

//根据屏幕宽度确定图片大小(---还没用)
+ (void)setImageMaximumRect:(NSDictionary *)sizeDict withImageView:(UIImageView *)iv;


@end
