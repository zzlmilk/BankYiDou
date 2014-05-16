//
//  FindPWViewController.h
//  BankAPP
//
//  Created by kevin on 14-2-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface FindPWViewController : BaseVC <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usePhoneNum;
@property (strong,nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong,nonatomic) IBOutlet UINavigationItem *navItem;

-(IBAction)closeClick:(id)sende;
-(IBAction)nextbutton:(id)sender;
-(IBAction)hideKeyboardAction:(id)sender;
@end
