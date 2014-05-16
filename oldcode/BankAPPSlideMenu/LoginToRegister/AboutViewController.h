//
//  aboutViewController.h
//  BankAPP
//
//  Created by kevin on 14-2-24.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "BaseVC.h"

@interface AboutViewController : BaseVC

@property (strong,nonatomic) IBOutlet UILabel *lbl_content;
@property (strong,nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong,nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong,nonatomic) IBOutlet UILabel *lbl_contentHidden;
//@property (strong,nonatomic) IBOutlet UIImageView *aboutImageView;
-(IBAction)closeClick:(id)sende;

@end
