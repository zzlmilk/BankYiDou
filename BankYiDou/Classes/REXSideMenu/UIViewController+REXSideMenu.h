//
//  UIViewController+REXSideMenu.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-29.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REXSIdeMenu;

@interface UIViewController (REXSideMenu)
@property(nonatomic,strong,readonly)REXSIdeMenu *sideMenuViewController;


-(IBAction)presentLeftMenuViewController:(id)sender;

@end
