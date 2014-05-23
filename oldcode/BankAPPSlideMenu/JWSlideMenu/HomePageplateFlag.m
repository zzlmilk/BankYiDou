//
//  FirstViewController.m
//  JWSlideMenu
//
//  Created by Jeremie Weldin on 11/15/11.
//  Copyright (c) 2011 Jeremie Weldin. All rights reserved.
//

#import "HomePageplateFlag.h"
#import "UIViewController+JDSideMenu.h"
#import "NavViewController.h"
#import "FirstCell.h"
#import "MBProgressHUD.h"
#import "ImageUtils.h"
#import "UIImageView+WebCache.h"
#import "FirstDetailViewController.h"
#import "VipDetailViewController.h"

#import "PrivilegeVIPplateFlag.h"

#import "ClientListViewController.h"
#import "MoreViewController.h"
#import "MyCollectionViewController.h"
#define PAGESIZE @"9"


#import "EMELPDialogVC.h"
#import "ChatViewController.h"


#import "FVIPViewController.h"
#import "CatchConsultantInfoPostObj.h"
#import "CatchConsultantInfoTask.h"
#import "ZeroViewController.h"



@implementation HomePageplateFlag
{
    NSString *ConsultantUid;
    NSString *ConsultantName;
    NSString *Consultanturl;
}
@synthesize strMaxTime = _strMaxTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customNavigationTitle];
        [self customNavLeftButton];
        aryRequstData = [[NSArray alloc]init];
        aryList = [[NSMutableArray alloc]initWithCapacity:10];
        
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
    titleLabel.text = @"首 页";
    self.navigationItem.titleView = titleLabel;
}

- (void)customNavLeftButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:@"登录首页-头部-LEFT-ICONS.png"] forState:UIControlStateNormal];
    btn.tag = 10004;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strcatchType = [mySettingData objectForKey:@"catchType"];
//    if ([strcatchType isEqualToString:@"1"]) {
//        NSLog(@"11111111111111");
//        ZeroViewController * zVC= [[ZeroViewController alloc]initWithNibName:@"ZeroViewController" bundle:nil];
//        [self presentViewController:zVC animated:NO completion:nil];
//    }
    JDSideOpenOrNot = YES;
    //发送通知-滑动手势-panGestureEnabled=YES
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifPanGestureEnabled object:nil];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.

    //tableviewcell的分割线的偏移
//    self.tableviewlist.separatorInset = UIEdgeInsetsMake(0, 65, 0, 3);
    /*
     *下边这段代码消除tableview上边的一段空白
     */
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    /// 添加下拉刷新视图
    if (self._refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableviewlist.bounds.size.height, self.view.frame.size.width, self.tableviewlist.bounds.size.height)];
		view.delegate = self;
		[self.tableviewlist addSubview:view];
		self._refreshHeaderView = view;
	}
	[self._refreshHeaderView refreshLastUpdatedDate];
    
    ///上拉加载更多
    if (_refreshFootView == nil) {
		_refreshFootView = [[EGORefreshTableFootView alloc] initWithFrame: CGRectMake(0.0f, self.tableviewlist.contentSize.height, 320, 650)];
		_refreshFootView.delegate = self;
		[self.tableviewlist addSubview:_refreshFootView];
//		_refreshFootView.hidden = YES;
	}
    
    //隐藏掉table没有信息的cell
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 1111;
    self.tableviewlist.tableFooterView = view;
    
    self.strMaxTime = @"";
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
    }else if (btn.tag == 10004){
        NSLog(@"展开左侧");
        if (JDSideOpenOrNot) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotifOpenJDSide object:nil];
            JDSideOpenOrNot = NO;
        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotifCloseJDSide object:nil];
            JDSideOpenOrNot = YES;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (NSString *)changeTime:(long long)num
{
    NSString *strValue = @"";
    //发布时间
    long long value1 = num/1000;
    NSLog(@"value1...%lld",value1);
    //取当前日期
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    long long value2 = [[NSNumber numberWithDouble:time]longLongValue];
    
    long long value = value2 - value1;
    NSLog(@"value...%lld",value);
    if (value <= 0) {
        strValue = @"刚    刚";
    }else if (value < 60){
        strValue = [NSString stringWithFormat:@"%lld秒前",value];
    }else if (value <= 60*60){
        strValue = [NSString stringWithFormat:@"%lld分钟前",value/60];
    }else if (value <= 60*60*24){
        strValue = [NSString stringWithFormat:@"%lld小时前",value/(60*60)];
    }else if (value/(60*60*24)<10){
        strValue = [NSString stringWithFormat:@"%lld天前",value/(60*60*24)];
    }
    else{
        NSLog(@"年月日");
        strValue = @"11";
        NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:value1];
        NSLog(@"%@",d);
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"MM-dd"];
        strValue = [dateformatter stringFromDate:d];
    }
    NSLog(@"strValue...%@",strValue);
    return strValue;
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (aryList.count >= 5) {
//        _refreshFootView.hidden = NO;
//    }
    
    return aryList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FirstCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    cell.lblTitle.text = [dict objectForKey:@"title"];
    
    long long num1 = [[dict objectForKey:@"verifyTime"]longLongValue];
    NSString *strtime = [self changeTime:num1];
    cell.lblTime.text = strtime;
    NSLog(@" .....%@",strtime);
    
    NSString *strURL = [NSString stringWithFormat:@"%@small",[dict objectForKey:@"pictureurl"]];
//    [ImageUtils setImageWithURL:strURL withImageView:nil];
    [cell.imageImage setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"icon-gear"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击cell");
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    NSString *iii = [dict objectForKey:@"templet"];
    NSString *stringMId = [dict objectForKey:@"materialId"];
    if ([iii isEqualToString:@"0"]) {//普通素材（咨询类型）
        NSLog(@"0");
    }
    else if ([iii isEqualToString:@"1"])//活动类型素材
    {
        NSLog(@"1");
    }
    else if ([iii isEqualToString:@"2"])//VIP特权类型素材
    {
        NSLog(@"2");
        VipDetailViewController *vvc = [[VipDetailViewController alloc]initWithNibName:@"VipDetailViewController" bundle:nil];
        vvc.dictList = dict;
        vvc.strIndex = @"1111";
        vvc.strMaterialId = stringMId;
        [self.navigationController pushViewController:vvc animated:YES];
    }
    else if ([iii isEqualToString:@"3"])//理财产品类型素材
    {
        NSLog(@"3");
        FirstDetailViewController *fvc = [[FirstDetailViewController alloc]initWithNibName:@"FirstDetailViewController" bundle:nil];
        fvc.dictAll = dict;
        fvc.strIndex = @"1111";
        fvc.strMaterialId = stringMId;
        [self.navigationController pushViewController:fvc animated:YES];
    }
    else if ([iii isEqualToString:@"4"])//信贷类型素材
    {
        
    }
    else if ([iii isEqualToString:@"5"])//黄金类型素材
    {
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self modifyMoreFrame];
}

-(void) modifyMoreFrame{
    
	_refreshFootView.frame = CGRectMake(0.0f, self.tableviewlist.contentSize.height, 320, 650);
}



#pragma mark - Network
- (void)requestList {
    MaterialInfosPostObj *postData = [[MaterialInfosPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.plateId = @"";
    postData.classId = @"";
    postData.minTime = @"";
    NSLog(@".....time = %@",self.strMaxTime);
    postData.maxTime = self.strMaxTime;//获取后边的数据 verifyTime
    postData.pageSize = PAGESIZE;
    postData.uid = struid;
    postData.token = strtoken;
    
    postData.plateFlag = @"";
    postData.templet = @"";
    postData.scale = @"";
    postData.orderBy = @"";
    postData.orderType = @"";
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    MaterialInfosTask *task = [[MaterialInfosTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
     if ([aTask isKindOfClass:[MaterialInfosTask class]]){
    NSDictionary *dict = aTask.responseDict;
    NSLog(@"dict == %@",dict);
    NSArray *ary = [dict objectForKey:@"info"];
    NSArray *aryData = [ary objectAtIndex:0];
    NSLog(@"aryData......%@",aryData);
    
    NSDictionary *dic = [aryData lastObject];
    self.strMaxTime = [dic objectForKey:@"verifyTime"];
    NSLog(@"....加载更多。。。。%@",self.strMaxTime);
    NSLog(@"....content..%@",[dic objectForKey:@"content"]);
    
    if (aryData.count< 7) {
        _refreshFootView.hidden = YES;
    }
    
    if (refresh) {//下拉刷新
        NSLog(@"........下拉刷新");
        if (aryList != nil) {
            [aryList removeAllObjects];
        }
        [aryList addObjectsFromArray:aryData];
        NSLog(@"....arylist.count333333...%lu",(unsigned long)aryList.count);
        //
    }
    else
    {
        NSLog(@"....加载更多2222。。。。%@",self.strMaxTime);
        //上啦加载更多
        NSLog(@"....arylist.count1111..%d",aryList.count);
        [aryList addObjectsFromArray:aryData];
        NSLog(@".....arylist.count2222...%d",aryList.count);
    }
    NSLog(@".....time22222..%@",self.strMaxTime);
    [self.tableviewlist reloadData];
    }
}

#pragma mark --下拉刷新
#pragma mark - Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    refresh = YES;
    _refreshFootView.hidden = NO;
    self.strMaxTime = @"";
    [self requestList];
    
	self._reloading = YES;
}

 //更新完成调用这个方法 刷新表视图数据
- (void)doneLoadingTableViewData{
    
	//  model should call this when its done loading
	self._reloading= NO;
//    [self.tableviewlist reloadData];
	[self._refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableviewlist];
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
        if (_refreshFootView.hidden) {
            return;
        }
        [_refreshFootView egoRefreshScrollViewDidScroll:scrollView];
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
        if (_refreshFootView.hidden) {
            return;
        }
        [_refreshFootView egoRefreshScrollViewDidEndDragging:scrollView];
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

#pragma mark - foot
- (void)egoRefreshTableFootDidTriggerRefresh:(EGORefreshTableFootView*)view{
    
	[self reloadTableViewDataSource1];
	[self performSelector:@selector(doneLoadingTableViewData1) withObject:nil afterDelay:2.0f];
}

- (BOOL)egoRefreshTableFootDataSourceIsLoading:(EGORefreshTableFootView*)view{
	
	return self._reloading; // should return if data source model is reloading
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource1{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	//刷新数据去吧
    refresh = NO;
    
    [self requestList];
    
//    [self performSelector:@selector(nextPageListData:) withObject:sortContent];
	self._reloading = YES;
}

- (void)doneLoadingTableViewData1{
	//  model should call this when its done loading
	[self modifyMoreFrame];
	self._reloading = NO;
    
	[_refreshFootView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableviewlist];
    
    [self.tableviewlist reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
