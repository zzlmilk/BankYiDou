//
//  FouthViewController.m
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ExclusiveMoneyplateFlag.h"
#import "FourCell.h"
#import "FirstDetailViewController.h"

/*
 *与首页key相同
 *参数有不同
 */
#import "MaterialInfosPostObj.h"
#import "MaterialInfosTask.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "EMELPDialogVC.h"
#import "ChatViewController.h"
#import "ClientListViewController.h"
#import "PrivilegeVIPplateFlag.h"

#import "FVIPViewController.h"
@interface ExclusiveMoneyplateFlag ()
{
    UIView *clearview;//加一个透明的层
    UIScrollView *scrolview;
    
    NSMutableArray *aryDif;
    NSString *datatype;
    
    NSString *stringPage;
    NSInteger intPage;
    
    NSString *stringClassId;
}
@end

@implementation ExclusiveMoneyplateFlag
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customNavigationTitle];
        [self customNavLeftButton];
        [self rightButton];
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
    titleLabel.text = @"尊享理财";
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
    NSLog(@"展开左侧");
    if (JDSideOpenOrNot) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifOpenJDSide object:nil];
        JDSideOpenOrNot = NO;
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifCloseJDSide object:nil];
        JDSideOpenOrNot = YES;
    }
}


- (void)rightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"尊享理财-Right.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnRightClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
}

- (void)btnRightClicked:(UIButton*)button
{
    NSLog(@"右边按钮");
    
    if (openOrNot == NO) {
        clearview = [[UIView alloc]init];
        clearview.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-self.navigationController.navigationBar.frame.origin.y-self.navigationController.navigationBar.frame.size.height);
        clearview.backgroundColor = [UIColor clearColor];
        [self.view addSubview:clearview];
        
        scrolview = [[UIScrollView alloc]init];
        scrolview.frame = CGRectMake(0, 0, 320, 88);
        scrolview.contentSize = CGSizeMake(320, 88);
        scrolview.backgroundColor = [UIColor blackColor];
        [clearview addSubview:scrolview];
        
        [self addButtons:scrolview];
        openOrNot = YES;
    }
    else
    {
        [clearview removeFromSuperview];
        openOrNot = NO;
    }
}

- (void)addButtons:(UIScrollView *)sview
{
    for (int i=0; i < aryRequstData.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5+i*(60+20), 15, 50, 50);
        btn.tag = 888+i;
        [btn setTitle:[[aryRequstData objectAtIndex:i] objectForKey:@"className"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"尊享理财-LIST-TAB-BG"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(Addbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [sview addSubview:btn];
    }
    
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame = CGRectMake(5+(60+20)*(aryRequstData.count-1)+60+20+5, 15, 50, 50);
    aBtn.tag = 1000;
    [aBtn setTitle:@"全部" forState:UIControlStateNormal];
    [aBtn setBackgroundImage:[UIImage imageNamed:@"尊享理财-LIST-TAB-BG"] forState:UIControlStateNormal];
    [aBtn addTarget:self action:@selector(Addbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [sview addSubview:aBtn];
}

- (void)Addbtnclicked:(UIButton*)button
{
    [clearview removeFromSuperview];
    if (aryList != nil) {
        [aryList removeAllObjects];
    }
    UIButton *btn = (UIButton *)button;
    if (btn.tag == 1000) {
        stringClassId = @"";
    }
    else
    {
        NSInteger iii = button.tag-888;
        stringClassId = [[aryRequstData objectAtIndex:iii]objectForKey:@"classId"];
    }
    [self requestList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    JDSideOpenOrNot = YES;
    //发送通知-滑动手势-panGestureEnabled=YES
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifPanGestureEnabled object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //***********开始的时候是隐藏的
    openOrNot = NO;
    // Do any additional setup after loading the view from its nib.
/*
 *下边这段代码消除tableview上边的一段空白
 */
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    

    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, 320, self.view.frame.size.height-170) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    /// 添加下拉刷新视图
    if (self._refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - table.bounds.size.height, self.view.frame.size.width, table.bounds.size.height)];
		view.delegate = self;
		[table addSubview:view];
		self._refreshHeaderView = view;
	}
	[self._refreshHeaderView refreshLastUpdatedDate];
    
    ///上拉加载更多
    if (_refreshFootView == nil) {
		_refreshFootView = [[EGORefreshTableFootView alloc] initWithFrame: CGRectMake(0.0f, table.contentSize.height, 320, 650)];
		_refreshFootView.delegate = self;
		[table addSubview:_refreshFootView];
        //		_refreshFootView.hidden = YES;
	}
    //隐藏掉table没有信息的cell
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 1111;
    table.tableFooterView = view;
    
    btnEarning = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEarning.frame = CGRectMake(30+10, 10, 120, 25);
    btnEarning.selected = YES;
    [btnEarning setTitle:@"预期收益" forState:UIControlStateSelected];
    [btnEarning setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnEarning setTitle:@"预期收益" forState:UIControlStateNormal];
    [btnEarning setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnEarning.titleLabel.font = [UIFont systemFontOfSize:14];
    btnEarning.tag = 11111;
    [btnEarning setBackgroundImage:[UIImage imageNamed:@"vipthree"] forState:UIControlStateSelected];
    [btnEarning setBackgroundImage:[UIImage imageNamed:@"viptwo"] forState:UIControlStateNormal];
    [btnEarning addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEarning];
    btnTime = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTime.frame = CGRectMake(150+10, 10, 120, 25);
    btnTime.tag = 22222;
    btnTime.selected = NO;
    [btnTime setTitle:@"剩余时间" forState:UIControlStateSelected];
    [btnTime setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnTime setTitle:@"剩余时间" forState:UIControlStateNormal];
    [btnTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnTime.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnTime setBackgroundImage:[UIImage imageNamed:@"vipone"] forState:UIControlStateSelected];
    [btnTime setBackgroundImage:[UIImage imageNamed:@"vipfour"] forState:UIControlStateNormal];
    [btnTime addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTime];
    
    intPage = 1;
    stringPage = @"1";
    datatype = @"FP2";
    stringClassId = @"";
    [self requestList];
    
//    [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(newthread) userInfo:nil repeats:NO];
    [self requestList22];
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
    [btn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, clearView.frame.size.height- 230+30+75, clearView.frame.size.width, 30);
    btn1.tag = 10002;
    [btn1 setBackgroundColor:[UIColor darkGrayColor]];
    [btn1 setTitle:@"手机 : 12312341234" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, clearView.frame.size.height - 230+30+30+30+45, clearView.frame.size.width,30);
    btn2.tag = 10003;
    [btn2 setBackgroundColor:[UIColor darkGrayColor]];
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn2];
    
}

- (void)bottomBtnClicked:(id)sender
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


- (void)btnClicked:(UIButton *)button
{
    UIButton *btn = (UIButton*)button;
    
    _refreshFootView.hidden = NO;
    if (aryList != nil) {
        [aryList removeAllObjects];
    }
    
    if (btn.tag == 11111)
    {
        NSLog(@"预期收益");
        if (btnEarning.selected == YES)
        {
            NSLog(@"预期收益选中中，不可以再点击");
        }
        else
        {
            btnEarning.selected = YES;
            btnTime.selected = NO;
        }
        stringPage = @"1";
        datatype = @"FP2";
        [self requestList];
    }
    else if (btn.tag == 22222)
    {
        NSLog(@"剩余时间");
        if (btnTime.selected == NO) {
            btnTime.selected = YES;
            btnEarning.selected = NO;
        }
        else
        {
            NSLog(@"剩余时间选中中，不可以再点击");
        }
        stringPage = @"1";
        datatype = @"FP3";
        [self requestList];
    }
    [table reloadData];
}


#pragma mark - Network
- (void)requestList {
    ListMaterialInfoForPageObj *postData = [[ListMaterialInfoForPageObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.plateId = @"1";//选择模块的时候传过来的
    postData.classId = stringClassId;//开始为@“” ，模块分类的时候传参数(右上角按钮)
    postData.pageSize = @"10";
    postData.uid = struid;
    postData.token = strtoken;
    postData.orderType = @"1";//1 降序 0 升序(预留)
    postData.dataType = datatype;//时间FP3 ，收益率FP2
    postData.search = @"";
    postData.curPage = stringPage;//分页 +1
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    ListMaterialInfoForPageTask *task = [[ListMaterialInfoForPageTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - Network
- (void)requestList22 {
    listPlateClassObj *postData = [[listPlateClassObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.plateId = @"1";
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    listPlateClassTask *task = [[listPlateClassTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}


#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];

    
    if ([aTask isKindOfClass:[ListMaterialInfoForPageTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *ary = [dict objectForKey:@"info"];
            NSArray *aryData = [ary objectAtIndex:0];
            
            //    NSDictionary *dic = [[ary objectAtIndex:0]lastObject];
            //    self.strMaxTime = [dic objectForKey:@"verifyTime"];
            //    NSLog(@"....加载更多。。。。%@",self.strMaxTime);
            
            if (aryData.count< 7) {
                _refreshFootView.hidden = YES;
            }
            
            if (refresh) {//下拉刷新
                NSLog(@"........下拉刷新");
                if (aryList != nil) {
                    [aryList removeAllObjects];
                }
                [aryList addObjectsFromArray:aryData];
                NSLog(@"....arylist.count333333...%d",aryList.count);
                //
            }
            else
            {
                [aryList addObjectsFromArray:aryData];
            }
            [table reloadData];
        }else if ([code isEqualToString:@"9998"]){
            
        }else{
            [Utility alert:@"用户操作数据失败"];
        }
    }
    else if ([aTask isKindOfClass:[listPlateClassTask class]])
    {
        NSDictionary *dict= aTask.responseDict;
        NSLog(@"分类是。。。。。%@",dict);
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *ary = [dict objectForKey:@"info"];
            aryRequstData = [ary objectAtIndex:0];
        }else if ([code isEqualToString:@"9998"]){
            
        }else{
            [Utility alert:@"接收分类数据失败"];
        }
        
    }
}

#pragma mark - 认购时间剩余

- (NSString *)timeSubscribeStartTime:(long long)aStartTime withEndTime:(long long)aEndTime
{
    //取当前日期
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    long long value1 = [[NSNumber numberWithDouble:time]longLongValue];
    
    long long startTime = aStartTime/1000;
    long long endTime = aEndTime/1000;
    
    NSString *string= @"";
    
    if (startTime > value1) {
        NSLog(@"未开始");
        string = @"未开始";
    }
    else if (endTime <= value1){
        NSLog(@"已结束");
        string = @"已结束";
    }
    else
    {
        long long time = endTime - value1;
        string = [NSString stringWithFormat:@"%lld天",time/(60*60*24)];
    }
    
    return string;
}

#pragma mark - 期限
- (NSString *)valueFromTime:(long long)fromeT withToTime:(long long)ToT
{
    long long aFromT = fromeT/1000;
    long long aToT = ToT/1000;
    long long aQX = aToT - aFromT;
    NSString *string = [NSString stringWithFormat:@"%lld天",aQX/(60*60*24)];
    return string;
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FourCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    cell.lblTitle.text = [dict objectForKey:@"title"];
    NSString *strExp = [[[dict objectForKey:@"financialProduct"]objectForKey:@"expectedRite"]stringValue];
    cell.lbl_expectedrite.text = [NSString stringWithFormat:@"%@%%",strExp];
    NSString *strExtRiskLevel = [[dict objectForKey:@"financialProduct"]objectForKey:@"extRiskLevel"];
    if ([strExtRiskLevel isEqualToString:@""]||strExtRiskLevel == nil) {
        strExtRiskLevel = @"无";
    }
    cell.lblrisk.text = strExtRiskLevel;
    NSString *strURL = [NSString stringWithFormat:@"%@small",[dict objectForKey:@"pictureurl"]];
    [cell.imageimage setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"icon-gear.png"]];
    
    long long startT = [[[dict objectForKey:@"financialProduct"]objectForKey:@"subscribeStart"]longLongValue];
    long long endT = [[[dict objectForKey:@"financialProduct"]objectForKey:@"subscribeEnd"]longLongValue];
    NSString *stringT = [self timeSubscribeStartTime:startT withEndTime:endT];
    cell.lbl_thelasttime.text = stringT;
    
    long long ft = [[[dict objectForKey:@"financialProduct"]objectForKey:@"valueDateFrom"]longLongValue];
    long long tt = [[[dict objectForKey:@"financialProduct"]objectForKey:@"valueDateTo"]longLongValue];
    NSString *strTT = [self valueFromTime:ft withToTime:tt];
    cell.lbl_qixian.text = strTT;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [aryList objectAtIndex:indexPath.row];
    NSString *string = [dic objectForKey:@"materialId"];
    FirstDetailViewController *first = [[FirstDetailViewController alloc]initWithNibName:@"FirstDetailViewController" bundle:nil];
    first.strMaterialId = string;
    first.strIndex = @"1222";
    first.dictAll = dic;//将详细信息传过去，后边只是调用日志接口
    [self.navigationController pushViewController:first animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self modifyMoreFrame];
}

-(void) modifyMoreFrame{
    
	_refreshFootView.frame = CGRectMake(0.0f, table.contentSize.height, 320, 650);
}


#pragma mark --下拉刷新
#pragma mark - Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    refresh = YES;
    stringPage = @"1";
    _refreshFootView.hidden = NO;
    [self requestList];
    
	self._reloading = YES;
}

//更新完成调用这个方法 刷新表视图数据
- (void)doneLoadingTableViewData{
    
	//  model should call this when its done loading
	self._reloading= NO;
    //    [self.tableviewlist reloadData];
	[self._refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:table];
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
    intPage ++;
    stringPage = [NSString stringWithFormat:@"%d",intPage];
    [self requestList];
    
    //    [self performSelector:@selector(nextPageListData:) withObject:sortContent];
	self._reloading = YES;
}

- (void)doneLoadingTableViewData1{
	//  model should call this when its done loading
	[self modifyMoreFrame];
	self._reloading = NO;
    
	[_refreshFootView egoRefreshScrollViewDataSourceDidFinishedLoading:table];
    
    [table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
