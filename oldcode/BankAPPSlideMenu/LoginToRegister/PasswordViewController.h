//
//  passwordViewController.h
//  BankVip2
//
//  Created by kevin on 14-2-18.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface PasswordViewController : BaseVC <UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet  UITextField *passwordText;
@property (nonatomic,strong) IBOutlet  UITextField *confirmPasswordText;
@property (strong,nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong,nonatomic) IBOutlet UINavigationItem *navItem;

@property (nonatomic, strong) NSString *strMobile;
@property (nonatomic, strong) NSString *strname;
@property (nonatomic, strong) NSString *strvercode;
@property (nonatomic, strong) NSString *strinvitation;

- (IBAction)hideKeyboardAction:(id)sender;
- (IBAction)closeClick:(id)sende;

- (IBAction)btnAction:(BOOL)isOpen sender:(id)sender;
@end
