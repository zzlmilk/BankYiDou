//
//  EMEImageScrollViewEC.h
//  UiComponentDemo
//
//  Created by junyi.zhu on 14-2-25.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DTGridView.h" 
#import "EMECustomCell.h"
@protocol EMEImageScrollViewECDelegate;

@interface EMENewsHomeImageScrollView : UIView <DTGridViewDelegate,DTGridViewDataSource>

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data showPageControl:(BOOL)pageControl;
- (id)initWithFrame:(CGRect)frame data:(NSArray *)data showPageControl:(BOOL)pageControl withBorderImage:(UIImageView*)borderImageView;

@property(nonatomic,assign)id<EMEImageScrollViewECDelegate>scrollDelegate;

@end

@protocol EMEImageScrollViewECDelegate <NSObject>
@optional

-(void)epViewDidSelectedIdnex:(NSInteger)index;

-(void)epViewDidScrolltoIndex:(NSInteger)index;
@end








