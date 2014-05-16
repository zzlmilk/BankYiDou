//
//  SetNewPWViewController.h
//  BankAPP
//
//  Created by kevin on 14-2-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"



@interface SetNewPWViewController : BaseVC <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *extVerificationCode2;
@property (strong, nonatomic) IBOutlet UITextField *setnewPassWord;

@property (strong, nonatomic) IBOutlet UITextField *setnewPassWord2;
@property (strong, nonatomic) IBOutlet UILabel *phoneNum2;

@property (strong,nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong,nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong,nonatomic) NSString * strmobile;


-(IBAction)closeClick:(id)sende;
-(IBAction)onClickbUTTON:(id)sender;
-(IBAction)hideKeyboardAction:(id)sender;

@end
