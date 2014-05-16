//
//  ClientVIpDetailVC.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ClientVIpDetailVC.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "ClientChangeRemarkViewController.h"
@interface ClientVIpDetailVC ()
{
    NSDictionary *dicAll;
    
    NSString *strAttention;
}
@end

@implementation ClientVIpDetailVC
@synthesize strUserId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dicAll = [[NSDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavigationTitle];
    [self customNavLeftButton];
    
    /*
     *下边这段代码消除tableview上边的一段空白
     */
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //边框
    [self.textviewInfo.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [self.textviewInfo.layer setBorderWidth:1.0];
    [self.textviewInfo.layer setCornerRadius:8.0f];
    [self.textviewInfo.layer setMasksToBounds:YES];

    
    [self requestList];
}

- (void)customNavigationTitle
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"联系客户";
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


#pragma mark - Network
- (void)requestList {
    CatchCustomerVIPPostObj *postData = [[CatchCustomerVIPPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    postData.userId = self.strUserId;//后边由连天界面进来的时候传过来的id
    postData.uid = struid;
    postData.token = strtoken;
    
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    CatchCustomerVIPTask *task = [[CatchCustomerVIPTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma - mark - attention network
- (void)requestAttentionOrNot
{
    ChangeAttentionObj *postData = [[ChangeAttentionObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    postData.uid = struid;
    postData.token = strtoken;
    postData.customerId = self.strUserId;//客户Id
    postData.attentionType = strAttention;// 1:关注  0:取消关注
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    ChangeAttentionTask *task = [[ChangeAttentionTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
    
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[CatchCustomerVIPTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSLog(@"dict == %@",dict);
        NSArray *ary = [dict objectForKey:@"info"];
        dicAll = [ary lastObject];
        self.lblTitle.text = [dicAll objectForKey:@"realName"];
        [self.imagePerson setImageWithURL:[NSURL URLWithString:[dicAll objectForKey:@"pictureurl"]] placeholderImage:[UIImage imageNamed:@"1305774588258"]];
        NSString *textInfo = [[dicAll objectForKey:@"userRemark"]objectForKey:@"remark"];
        if ([textInfo isEqualToString:@""]||textInfo == nil) {
            textInfo = @"暂无备注";
        }
        self.textviewInfo.text = textInfo;
        
        NSString *string = [[dicAll objectForKey:@"userRemark"]objectForKey:@"isAttention"];
        
        [self.btnCareOrNot setImage:[UIImage imageNamed:@"客户列表-空-心"] forState:UIControlStateNormal];
        [self.btnCareOrNot setImage:[UIImage imageNamed:@"客户列表-实-心"] forState:UIControlStateSelected];
        if ([string isEqualToString:@"1"]) {
            self.btnCareOrNot.selected = YES;
        }
        else
        {
            self.btnCareOrNot.selected = NO;
        }
        self.btnCareOrNot.tag = 3333;

    }
    else if ([aTask isKindOfClass:[ChangeAttentionTask class]]){
        NSDictionary *dict = aTask.responseDict;
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            [Utility alert:@"用户操作成功"];
        }else if ([code isEqualToString:@"9998"]){
            
        }else if ([code isEqualToString:@"9009"]||[code isEqualToString:@"9017"]){
            [Utility alert:@"用户无权访问"];
        }else{
            [Utility alert:@"用户操作失败"];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (id)sender;
    if (btn.tag == 0) {
        ClientChangeRemarkViewController *clientCRVC = [[ClientChangeRemarkViewController alloc]initWithNibName:@"ClientChangeRemarkViewController" bundle:nil];
        clientCRVC.delegate = self;
        clientCRVC.stringUserId = self.strUserId;
        clientCRVC.strTextRemark = self.textviewInfo.text;
        [self.navigationController pushViewController:clientCRVC animated:YES];
    }
    else if (btn.tag == 3333){
        if (self.btnCareOrNot.selected == YES) {
            strAttention = @"0";
            self.btnCareOrNot.selected = NO;
        }
        else if (self.btnCareOrNot.selected == NO){
            strAttention = @"1";
            self.btnCareOrNot.selected = YES;
        }
        [self requestAttentionOrNot];
    }
}

#pragma mark - text view delegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (void)changeTextInfo:(NSString *)str
{
    self.textviewInfo.text = str;
}

@end
