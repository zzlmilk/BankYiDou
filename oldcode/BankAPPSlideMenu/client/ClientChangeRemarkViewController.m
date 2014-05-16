//
//  ClientChangeRemarkViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-25.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ClientChangeRemarkViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ClientChangeRemarkViewController ()

@end

@implementation ClientChangeRemarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self changeNavigationTitle];
        [self changeNavLeftButton];
        [self changeNavRightButton];
    }
    return self;
}

- (void)changeNavigationTitle
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"添加/修改备注";
    self.navigationItem.titleView = titleLabel;
}

- (void)changeNavLeftButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 25);
    [btn setImage:[UIImage imageNamed:@"fanhui11.png"] forState:UIControlStateNormal];
    btn.tag = 10004;
    [btn addTarget:self action:@selector(LeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)changeNavRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(RightBtnClickede:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)LeftBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RightBtnClickede:(id)sender
{
    [self requestList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     *下边这段代码消除tableview上边的一段空白
     */
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //边框
    [self.textviewRemark.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [self.textviewRemark.layer setBorderWidth:1.0];
    [self.textviewRemark.layer setCornerRadius:8.0f];
    [self.textviewRemark.layer setMasksToBounds:YES];
    
    self.textviewRemark.text = self.strTextRemark;
}


#pragma mark - Network
- (void)requestList {
    ChangeRemarkPostObj *postData = [[ChangeRemarkPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.userId = self.stringUserId;
    postData.remark = self.textviewRemark.text;
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    ChangeRemarkTask *task = [[ChangeRemarkTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([aTask isKindOfClass:[ChangeRemarkTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSString *strCode = [dict objectForKey:@"code"];
        NSString *strMsg = [dict objectForKey:@"msg"];
        if ([strCode isEqualToString:@"0000"]) {
            //修改成功
            [self.delegate changeTextInfo:self.textviewRemark.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([strCode isEqualToString:@"9998"]){
            
        }else if ([strCode isEqualToString:@"9017"]){
            [Utility alert:@"用户无权访问"];
        }else{
            [Utility alert:@"用户操作失败"];
        }

    }
}
#pragma mark - text view delegate
//不知道未什么现实不出来（郁闷）
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [self.textviewRemark setInputAccessoryView:topView];
}

- (void)dismissKeyBoard
{
    [self.textviewRemark resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
