//
//  RegisterViewController.h
//  BankVip2
//
//  Created by kevin on 14-2-18.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"


@interface RegisterViewController : BaseVC< UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *InviteImg;
@property (strong, nonatomic) NSString * theCatchType;//注册方式
@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textPhone;
@property (strong, nonatomic) IBOutlet UITextField *textVerificationCode;//验证码
@property (strong, nonatomic) IBOutlet UITextField *textInviteCode;//邀请码
@property (strong, nonatomic) IBOutlet UIButton *btnVertify;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton * btnreed;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIButton *btnAgree;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;

- (IBAction)closeClick:(id)sender;
- (IBAction)hideKeyboardAction:(id)sender;
- (IBAction)getVerificationCodeAction:(id)sender;//获取验证码
- (IBAction)nextAction:(id)sender;

-(IBAction)reedAction:(id)sender;
@end
