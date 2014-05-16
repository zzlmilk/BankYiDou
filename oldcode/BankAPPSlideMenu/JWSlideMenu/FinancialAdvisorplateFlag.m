//
//  EightViewController.m
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "FinancialAdvisorplateFlag.h"
#import "CatchConsultantInfoPostObj.h"
#import "CatchConsultantInfoTask.h"
#import "MBProgressHUD.h"
#import "ChangeInvestmentViewController.h"
#import "ChangeRemarkViewController.h"
#import "ClientListViewController.h"
#import "ChatViewController.h"
#import "PrivilegeVIPplateFlag.h"

@interface FinancialAdvisorplateFlag ()
{
    NSDictionary *catchConsultantDict;
}
@end

@implementation FinancialAdvisorplateFlag
@synthesize investmentImage,investmentName,theText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customNavigationTitle];
        [self customNavLeftButton];
        [self requestCatchConsultant];

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
    titleLabel.text = @"我的理财顾问";
    self.navigationItem.titleView = titleLabel;
}


- (void)customNavLeftButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:@"登录首页-头部-LEFT-ICONS.png"] forState:UIControlStateNormal];
    btn.tag = 10004;
    [btn addTarget:self action:@selector(LeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)LeftBtnClicked:(id)sender
{
    if (JDSideOpenOrNot) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifOpenJDSide object:nil];
        JDSideOpenOrNot = NO;
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifCloseJDSide object:nil];
        JDSideOpenOrNot = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     *下边这段代码消除tableview上边的一段空白
     */
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    JDSideOpenOrNot = YES;
    //发送通知-滑动手势-panGestureEnabled=YES
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifPanGestureEnabled object:nil];

}

- (void)addClearView
{
    clearView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    clearView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, clearView.frame.size.height- 230+75, clearView.frame.size.width, 30);
    btn.tag = 10001;
    [btn setBackgroundColor:[UIColor darkGrayColor]];
    [btn setTitle:@"手机 : 12312341234" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, clearView.frame.size.height- 230+30+75, clearView.frame.size.width, 30);
    btn1.tag = 10002;
    [btn1 setBackgroundColor:[UIColor darkGrayColor]];
    [btn1 setTitle:@"手机 : 12312341234" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, clearView.frame.size.height - 230+30+30+30+45, clearView.frame.size.width,30);
    btn2.tag = 10003;
    [btn2 setBackgroundColor:[UIColor darkGrayColor]];
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn2];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeInvestment:(UIButton *)sender {
    ChangeInvestmentViewController *changeInVC = [[ChangeInvestmentViewController alloc]initWithNibName:@"ChangeInvestmentViewController" bundle:nil];
    changeInVC.delegate =self;
     [self.navigationController pushViewController:changeInVC animated:YES];
}
- (IBAction)changeRemark:(UIButton *)sender {
    ChangeRemarkViewController *changeReVC = [[ChangeRemarkViewController alloc]initWithNibName:@"ChangeRemarkViewController" bundle:nil];
    changeReVC.delegate = self;
    changeReVC.strRemark = self.theText.text;
    [self.navigationController pushViewController:changeReVC animated:YES];
}

- (void)changeLabelText:(NSString *)text{
    self.theText.text =text;

}

- (void)changeInvestmentID: (NSDictionary *)Investmentdict{
    catchConsultantDict = Investmentdict;
    NSString * dispName = [catchConsultantDict objectForKey:@"realName"];
    investmentName.text = dispName;
    NSString *strurl = [catchConsultantDict objectForKey:@"pictureurl"];
    [investmentImage setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"1305774588258.png"]];
}

-(void)requestCatchConsultant
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    CatchConsultantInfoPostObj *postData = [[CatchConsultantInfoPostObj alloc] init];
    postData.token = strtoken;
    postData.uid = struid;
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    CatchConsultantInfoTask *task = [[CatchConsultantInfoTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - Task Delegate
- (void)didTaskStarted:(Task *)aTask
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[CatchConsultantInfoTask class] ]){
        catchConsultantDict = aTask.responseDict;
        NSArray * array = [catchConsultantDict objectForKey:@"info"];
        NSDictionary * result = [array objectAtIndex:0];
        NSString * dispName = [result objectForKey:@"realName"];
        investmentName.text = dispName;
        NSString *strurl = [result objectForKey:@"pictureurl"];
        [investmentImage setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"1305774588258.png"]];
        NSDictionary * dict = [result objectForKey:@"userRemark"];
        NSString *theRemark = [dict objectForKey:@"remark"];
        NSLog(@"备注=================%@",theRemark);
        theText.text = theRemark;
        NSString * userId =[dict objectForKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
        }
}
@end
