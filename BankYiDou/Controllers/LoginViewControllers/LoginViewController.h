//
//  LoginViewController.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-14.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    
}


@property (strong,nonatomic)   UIImageView * imageView;
@property (strong,nonatomic)   UITextField * usePhoneText;
@property (strong,nonatomic)   UITextField * passWordText;

- (IBAction)loginButton_TouchUpInside:(id)sender;

@end
