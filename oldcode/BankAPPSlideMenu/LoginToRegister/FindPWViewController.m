//
//  FindPWViewController.m
//  BankAPP
//
//  Created by kevin on 14-2-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "FindPWViewController.h"
#import "SetNewPWViewController.h"
#import "sendSMSPTask.h"
#import "sendSMSPostObj.h"
#import "MBProgressHUD.h"

@interface FindPWViewController ()

@end

@implementation FindPWViewController
@synthesize usePhoneNum;


-(IBAction)closeClick:(id)sende
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)nextbutton:(id)sender
{
    if (usePhoneNum.text.length!=11) {
        [Utility alert:@"请填写11位手机号码"];
        return;
    }
    sendSMSPostObj *postData = [[sendSMSPostObj alloc] init];
    postData.mobile = self.usePhoneNum.text;
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    
    sendSMSPTask *task = [[sendSMSPTask alloc] initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)didTaskStarted:(Task *)aTask
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([aTask isKindOfClass:[sendSMSPTask class]]) {
        
        NSDictionary *sendSMSDict = aTask.responseDict;
        NSArray *info = [sendSMSDict objectForKey:@"info"];
        NSDictionary *result = [info objectAtIndex:0];
        NSLog(@"%@",result);
        NSString * code = [sendSMSDict objectForKey:@"code"];
        if ([code isEqualToString:@"9999"]) {
            [Utility alert:@"验证码发送失败，请点击重新发送"];
            return;
        }
        else if ([code isEqualToString:@"9003"]) {
            [Utility alert:@"手机号码格式错误"];
            return;
        }
        else if ([code isEqualToString:@"9007"]) {
            [Utility alert:@"短信验证码下发次数超限"];
            return;
        }
        else if ([code isEqualToString:@"3001"]) {
            [Utility alert:@"验证码入库失败，将影响用户验证，建议重发验证码"];
            return;
        }
        else if([code isEqualToString:@"0000"]){
        SetNewPWViewController *spsVC = [[SetNewPWViewController alloc] initWithNibName:@"SetNewPWViewController" bundle:nil];
        spsVC.strmobile = self.usePhoneNum.text;
        [self presentViewController:spsVC animated:NO completion:nil];  //7.0用法
        }
    }
}

-(IBAction)hideKeyboardAction:(id)sender
{
    [self.usePhoneNum resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:18];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"找回密码";
    self.navItem.titleView = t;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
