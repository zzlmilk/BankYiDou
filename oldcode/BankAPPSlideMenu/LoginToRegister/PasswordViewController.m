//
//  passwordViewController.m
//  BankVip2
//
//  Created by kevin on 14-2-18.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "PasswordViewController.h"
#import "HomePageplateFlag.h"
#import "LoginViewController.h"
#import "PasswordViewController.h"
#import "RegisterTask.h"
#import "RegisterPostObj.h"
#import "RegisterViewController.h"
#import <CommonCrypto/CommonHMAC.h> //MD5加密
#import "MBProgressHUD.h"


@interface PasswordViewController ()
{
RegisterViewController * registerViewController;
}
@end

@implementation PasswordViewController
@synthesize passwordText,confirmPasswordText,strMobile,strinvitation,strname,strvercode;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)hideKeyboardAction:(id)sender
{
    [self.passwordText resignFirstResponder];
    [self.confirmPasswordText resignFirstResponder];

}

-(IBAction)btnAction:(BOOL)isOpen sender:(id)sender
{
    if ([self.passwordText.text  isEqual: @""]||[self.confirmPasswordText.text isEqual:@""] ) {
        [Utility alert:@"密码不能为空，请重新输入"];
        return;
    }
     if (![self.confirmPasswordText.text isEqualToString:self.passwordText.text])
        {
            [Utility alert:@"两次密码不一致，请重新输入"];
            self.confirmPasswordText.text = @"";
        }
       else
       {
           [self regist];
       }
    
}

- (IBAction)closeClick:(id)sende
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

- (void)regist
{
    RegisterPostObj *postData = [[RegisterPostObj alloc] init];
    postData.mobile = strMobile;
    postData.name =strname;

    postData.vercode = strvercode;
    
    postData.invitation = strinvitation;
    postData.password = [self getMd5_32Bit_String:self.passwordText.text];
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    
    RegisterTask *task = [[RegisterTask alloc] initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:18];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"设置登录密码";
    self.navItem.titleView = t;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Task Delegate
- (void)didTaskStarted:(Task *)aTask
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
        if ([aTask isKindOfClass:[RegisterTask class] ]){
                NSDictionary * registDict = aTask.responseDict;
//                NSArray * array =[registDict objectForKey:@"info"];
//                NSDictionary *result = [array objectAtIndex:0];
                NSString *uid = [registDict objectForKey:@"uid"];
                NSLog(@"%@",uid);
                NSString *code = [registDict objectForKey:@"code"];
                NSString *token = [registDict objectForKey:@"token"];
                NSLog(@"%@",token);
                if ([code isEqualToString:@"0000"]){
                    [Utility alert:@"注册成功"];
                    LoginViewController * bVC =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                    
                    [self presentViewController:bVC animated:NO completion:nil];
                }
                else if([code isEqualToString:@"9999"]) {
                    [Utility alert:@"注册失败"];
                    return;
                }
                else if([code isEqualToString:@"9002"]) {
                    [Utility alert:@"用户手机已被注册"];
                    return;
                }
                else if([code isEqualToString:@"9003"]) {
                    [Utility alert:@"手机号码格式错误"];
                    return;
                }
                else if([code isEqualToString:@"9005"]) {
                    [Utility alert:@"验证码错误"];
                    return;
                }
                else if([code isEqualToString:@"9006"]) {
                    [Utility alert:@"密码格式错误！密码格式为（字母加数字）"];
                     return;
                }
                else if([code isEqualToString:@"9008"]) {
                    [Utility alert:@"邀请码错误"];
                    return;
                }
                else if([code isEqualToString:@"9014"]) {
                    [Utility alert:@"银行已关闭"];
                    return;
                }
                else if([code isEqualToString:@"1001"]) {
                    [Utility alert:@"姓名不能为空"];
                    return;
                }
                else if([code isEqualToString:@"1002"]) {
                    [Utility alert:@"关闭注册模式，用户信息不存在"];
                    return;
                }
                else if([code isEqualToString:@"1003"]) {
                    [Utility alert:@"银银行VIP会员数超过限额"];
                    return;
                }

        }
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
