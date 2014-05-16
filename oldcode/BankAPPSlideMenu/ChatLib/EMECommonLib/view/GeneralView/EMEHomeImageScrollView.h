//
//  EMEHomeImageScrollView.h
//  EMECommonLib
//
//  Created by ZhuJianyin on 14-3-4.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridView.h"
#import "EMECustomCell.h"
@protocol EMEImageScrollViewECDelegate;

@interface EMEHomeImageScrollView : UIView<DTGridViewDelegate,DTGridViewDataSource>

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data showPageControl:(BOOL)pageControl;
- (id)initWithFrame:(CGRect)frame data:(NSArray *)data showPageControl:(BOOL)pageControl withBorderImage:(UIImageView*)borderImageView;

@property(nonatomic,assign)id<EMEImageScrollViewECDelegate>scrollDelegate;

@end

@protocol EMEImageScrollViewECDelegate <NSObject>
@optional

-(void)epViewDidSelectedIdnex:(NSInteger)index;

-(void)epViewDidScrolltoIndex:(NSInteger)index;

@end
