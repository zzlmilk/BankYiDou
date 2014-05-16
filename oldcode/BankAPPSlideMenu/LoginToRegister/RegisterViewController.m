//
//  loginViewController.m
//  BankVip2
//
//  Created by kevin on 14-2-18.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//


#import "RegisterViewController.h"
#import "PasswordViewController.h"
#import "AboutViewController.h"
#import "MBProgressHUD.h"
#import "sendSMSPTask.h"
#import "sendSMSPostObj.h"
#import "RegistCheckTask.h"
#import "RegistCheckPostObj.h"

typedef enum
{
    VertifyNameAndPhone = 0,
    VertifyCode
} VertifyMode;

@interface RegisterViewController ()
{
    NSTimer *myTimer;
    int i;
}
@property  BOOL isAgree;
@property (strong, nonatomic) NSString *requestedPhoneNum;
@end

@implementation RegisterViewController
@synthesize btnNext,btnVertify,textName,textPhone,textVerificationCode,textInviteCode,theCatchType,secondLabel,InviteImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@",theCatchType);
    if ([theCatchType isEqualToString:@"3"]) {
        [textInviteCode setHidden:true];
        InviteImg.hidden = YES;
    }
    else if([theCatchType isEqualToString:@"1"]) {
        textInviteCode.hidden =YES;
        InviteImg.hidden = YES;
    }
    textInviteCode.text=@"";
    _isAgree =YES;
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:18];
    t.backgroundColor= [UIColor clearColor];
    t.textColor=[UIColor whiteColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"新用户注册";
    self.navItem.titleView = t;

    textVerificationCode.tag =2;
    textInviteCode.tag =1;
    
    self.btnVertify.enabled=YES;
    myTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    i = 60;
    [self->myTimer setFireDate:[NSDate distantFuture]];

}

-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [self->myTimer setFireDate:[NSDate distantFuture]];
}
-(void)timerMethod{
    NSLog(@" come on timer: %d",i);
    if (i>0) {
        i=i-1;
        NSString *b = [[NSString alloc]initWithFormat:@"（%d",i];
        self.secondLabel.text=[b stringByAppendingString:@"秒后可重发验证码）"];
    }else{
        [myTimer setFireDate:[NSDate distantFuture]];
        i=60;
        self.secondLabel.text=@"";
        self.btnVertify.enabled=YES;
    }
}
- (IBAction)hideKeyboardAction:(id)sender {
    [self.textName resignFirstResponder];
    [self.textPhone resignFirstResponder];
    [self.textVerificationCode resignFirstResponder];
    [self.textInviteCode resignFirstResponder];
  }

//发送验证码 连续3次则24小时不能再发
- (IBAction)getVerificationCodeAction:(id)sender {
    [self hideKeyboardAction:nil];
    
    BOOL notNull = [self vertifyEmpty:VertifyNameAndPhone];
    
      if (notNull) {
          if ([self.requestedPhoneNum isEqualToString:self.textPhone.text]) {
            return;
        }
        else {
            self.requestedPhoneNum = self.textPhone.text;
            double timer = 60;//获取验证码的时间间隔是1分钟！
            [self performSelector:@selector(setBtnEnable) withObject:nil afterDelay:timer];
            self.btnVertify.enabled=NO;
            myTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
                [self requestVerificationCode];
//                [DialogUtil showMessage:NSLocalizedString(@"超出验证码发送次数", nil)];//junyi debug
       }
   }
    
}

- (void)requestVerificationCode
{
    sendSMSPostObj *postData = [[sendSMSPostObj alloc] init];
    postData.mobile = self.textPhone.text;
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    
    sendSMSPTask *task = [[sendSMSPTask alloc] initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)setBtnEnable
{
    self.requestedPhoneNum = @"";
}

#pragma mark - Custom Method
- (BOOL)vertifyEmpty:(VertifyMode)mode
{
    if ([self.textName.text isEqualToString:@""]) {
        [DialogUtil showMessage:NSLocalizedString(@"姓名不能为空", nil)];
        return NO;
    }
    if ([self.textPhone.text isEqualToString:@""]) {
        [DialogUtil showMessage:NSLocalizedString(@"手机号码不能为空", nil)];
        return NO;
    }
    
    switch (mode) {
        case VertifyCode:
        {
            if ([self.textVerificationCode.text isEqualToString:@""]) {
                [DialogUtil showMessage:NSLocalizedString(@"验证码不能为空", nil)];
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

-(IBAction)closeClick:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (IBAction)clickBtnAgree:(id)sender {

    UIButton *btn = (UIButton *)sender;
    if (!btn.selected) {
        [btn setImage:[UIImage imageNamed:@"空复选框.png"] forState:UIControlStateNormal];
        _isAgree = NO;
    }else{
       
        [btn setImage:[UIImage imageNamed:@"复选框.png"] forState:UIControlStateNormal];
        _isAgree = YES;
    }
    btn.selected = !btn.selected;

}

-(void)requestRegistCheck
{
    RegistCheckPostObj *postData = [[RegistCheckPostObj alloc] init];
    postData.mobile = self.textPhone.text;
    postData.name = self.textName.text;
    postData.vercode =self.textVerificationCode.text;
    postData.invitation =@"";
    if ([theCatchType isEqualToString:@"2"])  {
        postData.invitation =self.textInviteCode.text;
    }
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    
    RegistCheckTask *task = [[RegistCheckTask alloc] initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];

}

-(void)checkPhoneExists
{
//    CheckPhoneExistsPostObj *postData = [[CheckPhoneExistsPostObj alloc] init];
//    postData.mobile = self.textPhone.text;
    
}

- (IBAction)nextAction:(id)sender
{
    if (!_isAgree) {
        [Utility alert:@"请先阅读使用条款！"];
        return;
    }
    
    if (textName.text.length ==0) {
        [Utility alert:@"姓名不能为空，请重新输入！"];
        return;
    }
    if (textPhone.text.length!=11) {
        [Utility alert:@"请填写11位手机号码！"];
        return;
    }
    if (textVerificationCode.text.length ==0 ) {
         [Utility alert:@"注册码不能为空，请重新输入！"];
         return;
    }
    if ([theCatchType isEqualToString:@"2"]) {
        if (textVerificationCode.text.length ==0 ) {
            [Utility alert:@"邀请码不能为空，请重新输入！"];
            return;}
    }
    /*  暂时不用这个功能，后面的自带   junyi.zhu debug   4.11
    if ([theCatchType isEqualToString:@"3"]) {
        [self checkPhoneExists];
    }*/
    
    BOOL notNull = [self vertifyEmpty:VertifyCode];
    
    if (notNull) {
        [self requestRegistCheck];
    }

}

#pragma mark - Task Delegate
- (void)didTaskStarted:(Task *)aTask
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
     if ([aTask isKindOfClass:[RegistCheckTask class]]) {
         NSDictionary *registCheckDict = aTask.responseDict;
         NSArray * info = [registCheckDict objectForKey:@"info"];
         NSDictionary *result = [info objectAtIndex:0];
         NSString *userId = [result objectForKey:@"userId"];
         NSLog(@"%@",userId);
         NSString *code = [registCheckDict objectForKey:@"code"];
         NSString *token = [registCheckDict objectForKey:@"token"];
         NSLog(@"%@",token);
         if ([code isEqualToString:@"0000"]) {
             PasswordViewController *psVC = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController" bundle:nil];
             psVC.strMobile = self.textPhone.text;
              psVC.strname = self.textName.text;
              psVC.strvercode =self.textVerificationCode.text;
             psVC.strinvitation =self.textInviteCode.text;
             [self presentViewController:psVC animated:NO completion:nil];  //7.0用法
           }
          else if ([code isEqualToString:@"9999"]) {
              [Utility alert:@"验证失败"];
              return;
          }
         else if ([code isEqualToString:@"9002"]) {
             [Utility alert:@"手机已被注册"];
             return;
         }
         else if ([code isEqualToString:@"9003"]) {
             [Utility alert:@"手机号码格式错误"];
             return;
         }
         else if ([code isEqualToString:@"9005"]) {
             [Utility alert:@"验证码格式错误"];
             return;
         }
         else if ([code isEqualToString:@"9008"]) {
             [Utility alert:@"邀请码错误"];
             return;
        }
         else if ([code isEqualToString:@"9014"]) {
             [Utility alert:@"银行已关闭"];
             return;
         }
         else if ([code isEqualToString:@"1001"]) {
             [Utility alert:@"姓名不能为空"];
             return;
         }
         else if ([code isEqualToString:@"1002"]) {
             [Utility alert:@"用户信息不存在"];
             return;
         }
         else if ([code isEqualToString:@"1003"]) {
             [Utility alert:@"银行VIP会员数超过限额"];
             return;
         }
    }
    else if ([aTask isKindOfClass:[sendSMSPTask class]]) {
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

    }
}

-(IBAction)reedAction:(id)sender
{
    AboutViewController *aboutVC = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    [self presentViewController:aboutVC animated:NO completion:nil];
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

//输入框编辑完成以后，将视图恢复到原始状态
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}


@end
