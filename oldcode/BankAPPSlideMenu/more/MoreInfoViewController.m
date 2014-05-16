//
//  MoreInfoViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "MoreInfoViewController.h"

@interface MoreInfoViewController ()
{
    NSString *strType;
}
@end

@implementation MoreInfoViewController

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
    titleLabel.text = @"更多信息";
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
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    strType = @"0";
    
    self.btnSina.selected = YES;
    [self.btnSina setImage:[UIImage imageNamed:@"单选按钮-a"] forState:UIControlStateNormal];
    [self.btnSina setImage:[UIImage imageNamed:@"单选按钮-hover"] forState:UIControlStateSelected];
    [self.btnSina addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnT.selected = NO;
    [self.btnT setImage:[UIImage imageNamed:@"单选按钮-a"] forState:UIControlStateNormal];
    [self.btnT setImage:[UIImage imageNamed:@"单选按钮-hover"] forState:UIControlStateSelected];
    [self.btnT addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)buttonClick:(id)sender
{
    NSLog(@"进来了，不错");
    UIButton *btn = (id)sender;
    if (btn.tag == 0000) {
        strType = @"0";
        self.btnSina.selected = YES;
        self.btnT.selected = NO;
    }else if (btn.tag == 1111){
        strType = @"1";
        self.btnSina.selected = NO;
        self.btnT.selected = YES;
    }
}


#pragma mark - Network
- (void)requestList {
    ChangeUserOtherInfoPostObj *postData = [[ChangeUserOtherInfoPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    if (self.qqNum.text == nil) {
        self.qqNum.text = @"";
    }
    if (self.weixinNum.text == nil) {
        self.weixinNum.text = @"";
    }
    if (self.weiboNum.text == nil) {
        self.weiboNum.text = @"";
    }
    
    postData.qqCode = self.qqNum.text;
    postData.wechatCode = self.weixinNum.text;
    postData.blogType = strType;//0 新浪 1 腾讯
    postData.blogCode = self.weiboNum.text;
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    ChangeUserOtherInfoTask *task = [[ChangeUserOtherInfoTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([aTask isKindOfClass:[ChangeUserOtherInfoTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            [Utility alert:@"用户其他信息修改成功"];
        }else if ([code isEqualToString:@"9998"]){
        
        }else if ([code isEqualToString:@"9019"]){
            [Utility alert:@"微博类型错误"];
        }else{
            [Utility alert:@"用户其他信息修改失败"];
        }
    }
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.qqNum) {
        [textField resignFirstResponder];
    }
    else if(textField == self.weixinNum) {
        [textField resignFirstResponder];
    }
    else if(textField == self.weiboNum) {
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
    if (btn.tag == 101) {
        [self requestList];
    }
    else if (btn.tag == 102){
        [self.qqNum resignFirstResponder];
        [self.weiboNum resignFirstResponder];
        [self.weixinNum resignFirstResponder];
    }
}
@end
