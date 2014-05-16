//
//  ChangePassWordVController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChangePassWordVController.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonHMAC.h> //MD5加密

@interface ChangePassWordVController ()
{
    NSString *strOldPw;
    NSString *strTurePw;
}
@end

@implementation ChangePassWordVController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customNavLeftButton];
        [self customNavigationTitle];
    }
    return self;
}

- (void)customNavigationTitle
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"密码修改";
    self.navigationItem.titleView = titleLabel;
}

- (void)customNavLeftButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 25);
    [btn setImage:[UIImage imageNamed:@"fanhui11.png"] forState:UIControlStateNormal];
    btn.tag = 10004;
    [btn addTarget:self action:@selector(LeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)LeftBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //发送通知取消滑动手势
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifNotpanGestureEnabled object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - Network
- (void)requestList {
    UpdatePwdByOldPwdPostObj *postData = [[UpdatePwdByOldPwdPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.oldpwd = strOldPw;
    postData.password = strTurePw;
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    UpdatePwdByOldPwdTask *task = [[UpdatePwdByOldPwdTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([aTask isKindOfClass:[UpdatePwdByOldPwdTask class]]){
        NSDictionary * updataDict = aTask.responseDict;
        NSString *code = [updataDict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *ary = [updataDict objectForKey:@"info"];
            NSArray *aryData = [ary objectAtIndex:0];
            NSLog(@"aryData......%@",aryData);
        }
        else if([code isEqualToString:@"9999"]) {
            [Utility alert:@"密码修改失败"];
            return;
        }
        else if([code isEqualToString:@"9998"]) {
            [Utility alert:@"登录信息验证失败"];
            return;
        }
        else if([code isEqualToString:@"9001"]) {
            [Utility alert:@"用户不存在"];
            return;
        }
        else if([code isEqualToString:@"9006"]) {
            [Utility alert:@"旧密码输入错误"];
            return;
        }
        else if([code isEqualToString:@"9018"]) {
            [Utility alert:@"新密码格式错误"];
            return;
        }
    }
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.fieldtruePWord) {
        [textField resignFirstResponder];
    }
    else if(textField == self.fieldNewPWord) {
        [textField resignFirstResponder];
    }
    else if(textField == self.fieldOldPWord) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 120 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
    else
    {
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (id)sender;
    if (btn.tag == 0) {//提交，发送请求
        if ([self.fieldNewPWord.text isEqualToString:self.fieldtruePWord.text]&&self.fieldNewPWord.text.length != 0 && self.fieldtruePWord.text != 0) {
            strOldPw = [self getMd5_32Bit_String:self.fieldOldPWord.text];
            strTurePw = [self getMd5_32Bit_String:self.fieldtruePWord.text];
            [self requestList];
        }
        else
        {
            UIAlertView *alertv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码为空或两次密码输入的不同" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertv show];
        }
    }
    else if (btn.tag == 1){//点空白键盘消失
        [self.fieldNewPWord resignFirstResponder];
        [self.fieldOldPWord resignFirstResponder];
        [self.fieldtruePWord resignFirstResponder];
    }
}
@end
