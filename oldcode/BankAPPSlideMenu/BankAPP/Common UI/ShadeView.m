//
//  ShadeView.m
//  Association
//
//  Created by Chen Bing on 13-7-27.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "ShadeView.h"

@implementation ShadeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setShade];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setShade
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    CALayer *layer = self.layer;
    layer.masksToBounds = NO;//为YES，阴影就会无效
    [layer insertSublayer:gradient atIndex:0];
    self.alpha = 0.75;
}

@end
