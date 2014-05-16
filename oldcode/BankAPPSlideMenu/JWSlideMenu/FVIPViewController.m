//
//  FVIPViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "FVIPViewController.h"
#import "VipOneCell.h"
#import "MBProgressHUD.h"
#import "PrivilegeVIPdetail.h"
#import "PrivilegeVIPplateFlag.h"
#import "EMELPDialogVC.h"
#import "ChatViewController.h"
#import "ClientListViewController.h"
@interface FVIPViewController ()

@end

@implementation FVIPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customNavigationTitle];
        [self customNavLeftButton];
        aryList = [[NSArray alloc]init];
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
    titleLabel.text = @"特权VIP";
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
    NSLog(@"展开左侧");
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    //隐藏掉table没有信息的cell
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 1111;
    self.vipTableList.tableFooterView = view;
    [self requestList];
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

- (void)btnClicked:(id)sender
{
    UIButton *btn = (id)sender;
    if (btn.tag == 10001) {
        NSLog(@"打电话功能未实现");
    }
    else if (btn.tag == 10002){
        NSLog(@"打电话功能未实现");
    }else if (btn.tag == 10003){
        [clearView removeFromSuperview];
    }
}


#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VipOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VipOneCell" owner:self options:nil]lastObject];
    }
    
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = [dict objectForKey:@"className"];
    
    NSDictionary *dic = [dict objectForKey:@"firstMaterialInfo"];
    NSDictionary *dic2 = [dic objectForKey:@"promissoryShop"];
    cell.lblDetailTitle.text = [dic2 objectForKey:@"saleDescript"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    
    PrivilegeVIPdetail *second2 = [[PrivilegeVIPdetail alloc]initWithNibName:@"PrivilegeVIPdetail" bundle:nil];
    second2.strPlateId = [dict objectForKey:@"plateId"];
    second2.strClassId = [dict objectForKey:@"classId"];
    [self.navigationController pushViewController:second2 animated:YES];
}

#pragma mark - Network
- (void)requestList {
    listPlateClassObj *postData = [[listPlateClassObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.plateId = @"2";
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    listPlateClassTask *task = [[listPlateClassTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[listPlateClassTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *ary = [dict objectForKey:@"info"];
            aryList = [ary objectAtIndex:0];
            [self.vipTableList reloadData];
        }else if ([code isEqualToString:@"9998"]){
        
        }else{
            [Utility alert:@"用户操作数据失败"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
