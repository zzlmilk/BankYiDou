//
//  ChangeInvestmentViewController.m
//  BankAPP
//
//  Created by kevin on 14-3-17.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChangeInvestmentViewController.h"
#import "CatchAllConsultantTask.h"
#import "CatchAllConsultantPostObj.h"
#import "MBProgressHUD.h"
#import "SetConsultantIdForVIPPostObj.h"
#import "SetConsultantIdForVIPTask.h"
#import "HomePageplateFlag.h"
#import "ChangeInvestmentCell.h"

@interface ChangeInvestmentViewController (){
    NSString *consultantId;
}
@end

@implementation ChangeInvestmentViewController
@synthesize listtable,arydict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arylist = [[NSArray alloc]init];
        [self requestChangeIn];
    }
    [self changeNavigationTitle];
    [self changeNavLeftButton];
    return self;
}
- (void)changeNavigationTitle
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"修改理财顾问";
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

-(void)requestChangeIn
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    NSString *struserId =[mySettingData objectForKey:@"userId"];
    CatchAllConsultantPostObj *postData = [[CatchAllConsultantPostObj alloc] init];
    
    postData.search =@"";
    postData.pageSize = @"5";
    postData.uid =struid;
    postData.token =strtoken;
    
    if ( struserId==nil) {
        postData.lastConsultantId = @"";
    }
    else{
        postData.lastConsultantId = struserId;
    }
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    CatchAllConsultantTask *task = [[CatchAllConsultantTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    /// 添加下拉刷新视图
    if (self._refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.listtable.bounds.size.height, self.view.frame.size.width, self.listtable.bounds.size.height)];
		view.delegate = self;
		[self.listtable addSubview:view];
		self._refreshHeaderView = view;
	}
	[self._refreshHeaderView refreshLastUpdatedDate];
    
    [self setExtraCellLineHidden:self.listtable];//清除多余分割线

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //发送通知取消滑动手势
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifNotpanGestureEnabled object:nil];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}   
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arylist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *whichSection = @"cell";
	ChangeInvestmentCell *cell = (ChangeInvestmentCell*)[tableView dequeueReusableCellWithIdentifier:whichSection];
    if (cell == nil) {
        cell = [[ChangeInvestmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:whichSection];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChangeInvestmentCell" owner:self options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    
    
    NSDictionary *dict = [arylist objectAtIndex:indexPath.row];
   
    cell.LableTitle.text = [dict objectForKey:@"realName"];
    
    NSString *strurl = [dict objectForKey:@"pictureurl"];
    [cell.HeadImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@small",strurl]] placeholderImage:[UIImage imageNamed:@"1305774588258"]];

//    [cell.HeadImage setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"1305774588258.png"]];
//    cell.HeadImage.contentMode = UIViewContentModeScaleAspectFit;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    arydict = [arylist objectAtIndex:indexPath.row];
    NSString *str = [arydict objectForKey:@"realName"];
    consultantId=[arydict objectForKey:@"userId"];
    NSString * title = [[NSString alloc]initWithFormat:@"你确定要选择%@为理财顾问吗？",str];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"更改"message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
    [self requestChangeRemark];
    
    }
}

#pragma mark - Task Delegate
- (void)didTaskStarted:(Task *)aTask
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[CatchAllConsultantTask class]]){
        NSDictionary * catchInDict = aTask.responseDict;
        NSString *code = [catchInDict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray * array =[catchInDict objectForKey:@"info"];
            arylist = [array objectAtIndex:0];
            [self.listtable reloadData];
        }
        else if([code isEqualToString:@"9999"]) {
            [Utility alert:@"理财顾问信息检索失败"];
            return;
        }
        else if([code isEqualToString:@"9998"]) {
            [Utility alert:@"登录信息验证失败"];
            return;
        }
        else if([code isEqualToString:@"9010"]) {
            [Utility alert:@"VIP功能，理财顾问无权访问"];
            return;
        }
    }
    else if ([aTask isKindOfClass:[SetConsultantIdForVIPTask class]]){
        NSDictionary *setConsult = aTask.responseDict;
        NSArray * array =[setConsult objectForKey:@"info"];
        NSLog(@"%@",array);
        NSDictionary *result = [array objectAtIndex:0];
        NSLog(@"%@",result);
        NSString *code = [setConsult objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            [Utility alert:@"理财顾问设置成功"];
            [self.delegate changeInvestmentID: arydict];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if([code isEqualToString:@"9999"]) {
            [Utility alert:@"理财顾问设置失败"];
            return;
        }
        else if([code isEqualToString:@"9998"]) {
            [Utility alert:@"登录信息验证失败，请重新登陆"];
            return;
        }
        else if([code isEqualToString:@"9001"]) {
            [Utility alert:@"找不到可用用户"];
            return;
        }
        else if([code isEqualToString:@"9009"]) {
            [Utility alert:@"VIP用户无权限修改理财顾问"];
            return;
        }
        else if([code isEqualToString:@"9010"]) {
            [Utility alert:@"VIP功能，理财顾问无权限使用"];
            return;
        }
        else if([code isEqualToString:@"9012"]) {
            [Utility alert:@"找不到指定理财顾问"];
            return;
        }
    }
}

#pragma mark - Network Request
- (void)requestChangeRemark
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
//    NSString *strconsultId= [mySettingData objectForKey:@"userConsultant"];
    SetConsultantIdForVIPPostObj *postData = [[SetConsultantIdForVIPPostObj alloc] init];
    
    postData.consultantId = consultantId;
    postData.uid = struid;
    postData.token = strtoken;
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    SetConsultantIdForVIPTask *task = [[SetConsultantIdForVIPTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark --下拉刷新
#pragma mark - Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    refresh = YES;
    [self requestChangeIn];
    
	self._reloading = YES;
}

//更新完成调用这个方法 刷新表视图数据
- (void)doneLoadingTableViewData{
    
	//  model should call this when its done loading
	self._reloading= NO;
    //    [self.tableviewlist reloadData];
	[self._refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.listtable];
}

#pragma mark - UIScrollViewdelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    point = scrollView.contentOffset;
}

//下拉刷新开始更新数据
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint pt = scrollView.contentOffset;
    if (point.y < pt.y) {//向上提加载更多
    }
    else
    {
        [self._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint pt = scrollView.contentOffset;
    if (point.y < pt.y) {
    }
    else
    {
        [self._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark - EGO_HeaderDelegate method
//
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return __reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view

{
    return [NSDate date];
}

@end
