//
//  UIViewController+REXSideMenu.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-29.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "UIViewController+REXSideMenu.h"
#import "REXSIdeMenu.h"

@implementation UIViewController (REXSideMenu)

-(REXSIdeMenu *)sideMenuViewController{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[REXSIdeMenu class]]) {
            return (REXSIdeMenu *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}



#pragma mark -
#pragma mark IB Action  methods
-(IBAction)presentLeftMenuViewController:(id)sender{
    [self.sideMenuViewController presentLeftMenuViewController];
}



@end
