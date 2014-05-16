//
//  LoginViewController.h
//  BankVip2
//
//  Created by kevin on 14-2-16.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageplateFlag.h"
#import "LoginTask.h"




@interface LoginViewController : UIViewController <TaskDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) IBOutlet  UIImageView * imageView;
@property (strong,nonatomic) IBOutlet  UITextField * usePhoneText;
@property (strong,nonatomic) IBOutlet  UITextField * passWordText;

@property (strong,nonatomic) UIViewController *menuController;
@property (strong,nonatomic) NSString *thetoken;
@property (strong,nonatomic) NSString *theuid;
@property (strong,nonatomic) NSString *thelastTime;
@property (strong,nonatomic) NSString *theuserType;

-(IBAction)loginAction:(id)sender;
-(IBAction)Register:(id)sender;
-(IBAction)findBack:(id)sender;

- (IBAction)hideKeyboardAction:(id)sender;


@end
