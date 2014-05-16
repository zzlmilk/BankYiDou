//
//  ChangeMobileNumVController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChangeMobileNumVController.h"
#import <CommonCrypto/CommonHMAC.h> //MD5加密

@interface ChangeMobileNumVController ()

@end

@implementation ChangeMobileNumVController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customNavigationTitle];
        [self customNavLeftButton];
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
    titleLabel.text = @"手机号码修改";
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
    ChangeUserMobileObj *postData = [[ChangeUserMobileObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.password = [self getMd5_32Bit_String:self.fieldNewPWord.text];
    postData.mobile = self.fieldNewMobile.text;
    postData.vercode = self.fieldVercode.text;
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    ChangeUsermobile *task = [[ChangeUsermobile alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)sendSMS
{
    sendSMSPostObj *postData = [[sendSMSPostObj alloc] init];
    
    postData.mobile = self.fieldNewMobile.text;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    sendSMSPTask  *task = [[sendSMSPTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];

}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([aTask isKindOfClass:[ChangeUsermobile class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            [Utility alert:@"用户手机号码修改成功"];
        }else if ([code isEqualToString:@"9998"]){
            
        }else if ([code isEqualToString:@"9002"]){
            [Utility alert:@"新手机号码已被占用"];
        }else if ([code isEqualToString:@"9003"]){
            [Utility alert:@"手机号码格式错误"];
        }else if ([code isEqualToString:@"9005"]){
            [Utility alert:@"手机号码格式错误"];
        }else if ([code isEqualToString:@"9006"]){
            [Utility alert:@"旧密码输入错误"];
        }else{
            [Utility alert:@"用户手机号码修改失败"];
        }
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

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.fieldVercode) {
        [textField resignFirstResponder];
    }
    else if(textField == self.fieldNewPWord) {
        [textField resignFirstResponder];
    }
    else if(textField == self.fieldNewMobile) {
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (id)sender;
    if (btn.tag == 111) {//发送验证码(*****缺少对手机号码的判断**)
        if (self.fieldNewPWord.text.length!=11) {
            [Utility alert:@"请填写11位旧手机号码"];
            return;
        }
        if (self.fieldNewMobile.text.length!=11) {
            [Utility alert:@"请填写11位新手机号码"];
            return;
        }
        [self sendSMS];
    }
    else if (btn.tag == 222)//提交
    {
        [self requestList];
    }
    else if (btn.tag == 333)//点击空白区域，隐藏键盘
    {
        [self.fieldNewMobile resignFirstResponder];
        [self.fieldNewPWord resignFirstResponder];
        [self.fieldVercode resignFirstResponder];
    }
}
@end
