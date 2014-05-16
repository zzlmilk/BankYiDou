//
//  ChangeRemarkViewController.m
//  BankAPP
//
//  Created by kevin on 14-3-17.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChangeRemarkViewController.h"
#import "ChangeRemarkPostObj.h"
#import "ChangeRemarkTask.h"


@interface ChangeRemarkViewController ()

@end

@implementation ChangeRemarkViewController
@synthesize remarkText,strRemark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self changeNavLeftButton];
    [self changeNavigationTitle];
    return self;
}

- (void)changeNavigationTitle
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
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

- (void)LeftBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addView];
    remarkText.text=strRemark;
    /*
     *下边这段代码消除tableview上边的一段空白
     */
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    remarkText.layer.borderWidth =1.0;
    remarkText.layer.cornerRadius =5.0;
    remarkText.showsVerticalScrollIndicator = YES;
    remarkText.showsHorizontalScrollIndicator = YES;
//    remarkText.autoresizingMask = UIViewAutoresizingFlexibleHeight;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //发送通知取消滑动手势
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifNotpanGestureEnabled object:nil];
}
- (IBAction)back:(id)sender {
    [remarkText resignFirstResponder];
}


- (void) addView
{
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 40, 40);
    saveButton.backgroundColor = [UIColor clearColor];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = item;
    saveButton.titleLabel.textColor = [UIColor whiteColor];

}

- (void)buttonClicked
{
    [self requestList];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network
- (void)requestList {
    ChangeRemarkPostObj *postData = [[ChangeRemarkPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    NSString *userConsultant=[mySettingData objectForKey:   @"userConsultant"];
    
    postData.userId =userConsultant;
    postData.remark = self.remarkText.text;
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
        if ([strCode isEqualToString:@"0000"]) {
            //修改成功
            [self.delegate changeLabelText:remarkText.text];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if ([strCode isEqualToString:@"9998"]){
        
        }else if ([strCode isEqualToString:@"9017"]){
            [Utility alert:@"用户无权访问"];
        }else{
            [Utility alert:@"用户操作失败"];
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
