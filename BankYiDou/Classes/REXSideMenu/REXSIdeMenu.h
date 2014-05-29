//
//  REXSIdeMenu.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-23.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol REXSIdeMenuDelegate;

@interface REXSIdeMenu : UIViewController

@property (nonatomic,strong)UIViewController *contentViewController;
@property(nonatomic,strong)UIViewController *leftMenuViewController;
@property (nonatomic,strong)UIViewController *rightMenuViewController;

@property (weak,nonatomic)id<REXSIdeMenuDelegate>delegate;

@property (assign,nonatomic)  NSTimeInterval animationDuration;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (assign, readwrite, nonatomic) BOOL scaleMenuView;
@property (assign, readwrite, nonatomic) CGFloat contentViewInPortraitOffsetCenterX;




@property (assign, readwrite, nonatomic) CGAffineTransform menuViewControllerTransformation;




- (id)initWithContentViewController:(UIViewController *)contentViewController
             leftMenuViewController:(UIViewController *)leftMenuViewController
            rightMenuViewController:(UIViewController *)rightMenuViewController;


- (void)presentLeftMenuViewController;
- (void)presentRightMenuViewController;
- (void)hideMenuViewController;


@end
