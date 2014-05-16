//
//  SetNewPWViewController.m
//  BankAPP
//
//  Created by kevin on 14-2-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SetNewPWViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "UpdatePwdByVercodePostObj.h"
#import "updatePwdByVercodeTask.h"
#import <CommonCrypto/CommonHMAC.h> //MD5加密

@interface SetNewPWViewController ()

@end

@implementation SetNewPWViewController
@synthesize setnewPassWord,setnewPassWord2,phoneNum2,extVerificationCode2;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)onClickbUTTON:(id)sender
{
    [setnewPassWord resignFirstResponder];
    [setnewPassWord2 resignFirstResponder];
    if (![self.setnewPassWord.text isEqualToString:self.setnewPassWord2.text]){
        setnewPassWord.text=@"";
        setnewPassWord2.text=@"";
        NSLog(@"密码更改不成功");
        return;
    }
    else{
    UpdatePwdByVercodePostObj *postData = [[UpdatePwdByVercodePostObj alloc] init];
    postData.mobile = _strmobile;
    postData.vercode = extVerificationCode2.text;
    postData.password = [self getMd5_32Bit_String:self.setnewPassWord.text];
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    
    updatePwdByVercodeTask *task = [[updatePwdByVercodeTask alloc] initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
    }
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

-(IBAction)closeClick:(id)sende
{
     [self dismissViewControllerAnimated:NO completion:nil];
}


-(IBAction)hideKeyboardAction:(id)sender
{
    [setnewPassWord resignFirstResponder];
    [setnewPassWord2 resignFirstResponder];
}

- (void)didTaskStarted:(Task *)aTask
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([aTask isKindOfClass:[updatePwdByVercodeTask class]]) {
        NSDictionary * UpdatePwbDict = aTask.responseDict;
        NSString *code = [UpdatePwbDict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]){
            [Utility alert:@"密码设置成功"];
        LoginViewController * LOVC =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:LOVC animated:NO completion:nil];  //7.0用法
        }
        else if([code isEqualToString:@"9999"]) {
            [Utility alert:@"密码设置失败"];
            return;
        }
        else if([code isEqualToString:@"9001"]) {
            [Utility alert:@"用户不存在"];
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
        else if([code isEqualToString:@"9018"]) {
            [Utility alert:@"新密码格式错误"];
            return;
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    phoneNum2.text =_strmobile;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:_strmobile];
    [String1 replaceCharactersInRange:NSMakeRange(4, 5) withString:@"*****"];
    phoneNum2.text =String1;
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:17];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"设置新密码";
    self.navItem.titleView = t;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始编辑输入框的时候，软键盘出现，执行此事件
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
//    
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [UIView commitAnimations];
//}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

////输入框编辑完成以后，将视图恢复到原始状态
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}

@end
