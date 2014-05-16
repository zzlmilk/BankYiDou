//
//  JDSideMenu.h
//  StatusBarTest
//
//  Created by Markus Emrich on 11/11/13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DockView.h"

@interface JDSideMenu : UIViewController <UIGestureRecognizerDelegate,DockViewDelegate>{
    UIView *clearView;
    
}

@property (nonatomic, readonly) UIViewController *contentController;
@property (nonatomic, readonly) UIViewController *menuController;

@property (nonatomic, readonly) UIViewController *rootController;

@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) BOOL tapGestureEnabled;
@property (nonatomic, assign) BOOL panGestureEnabled;

- (id)initWithContentController:(UIViewController*)contentController
                 menuController:(UIViewController*)menuController
                 rootController:(UIViewController*)rootController;

- (void)setContentController:(UIViewController*)contentController
                     animted:(BOOL)animated;
- (void)setContentController:(UIViewController*)contentController rootController:(UIViewController*)rootController
                     animted:(BOOL)animated;

// show / hide manually
- (void)showMenuAnimated:(BOOL)animated;
- (void)hideMenuAnimated:(BOOL)animated;
- (BOOL)isMenuVisible;

// background
- (void)setBackgroundImage:(UIImage*)image;

@end
