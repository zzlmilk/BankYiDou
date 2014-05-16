//
//  Second2ViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-14.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "PrivilegeVIPdetail.h"
#import "VipTwoCell.h"
/*
 *与首页key相同
 *参数有不同
 */
#import "MaterialInfosPostObj.h"
#import "MaterialInfosTask.h"
#import "MBProgressHUD.h"

#import "ImageUtils.h"
#import "UIImageView+WebCache.h"

#import "VipDetailViewController.h"
@interface PrivilegeVIPdetail ()    
{
    NSString *strDifferentId;
}
@end

@implementation PrivilegeVIPdetail
@synthesize strClassId,strPlateId;
@synthesize strMaxTime = _strMaxTime;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customNavigationTitle];
        [self customNavLeftButton];
        aryList = [[NSMutableArray alloc]initWithCapacity:10];
        strDifferentId = @"0";
        self.strMaxTime = @"";
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
    titleLabel.text = @"VIP特权";
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
    
    /*
     *下边这段代码消除tableview上边的一段空白
     */
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    /// 添加下拉刷新视图
    if (self._refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableList.bounds.size.height, self.view.frame.size.width, self.tableList.bounds.size.height)];
		view.delegate = self;
		[self.tableList addSubview:view];
		self._refreshHeaderView = view;
	}
	[self._refreshHeaderView refreshLastUpdatedDate];
    
    ///上拉加载更多
    if (_refreshFootView == nil) {
		_refreshFootView = [[EGORefreshTableFootView alloc] initWithFrame: CGRectMake(0.0f, self.tableList.contentSize.height, 320, 650)];
		_refreshFootView.delegate = self;
		[self.tableList addSubview:_refreshFootView];
        //		_refreshFootView.hidden = YES;
	}
    
    //隐藏掉table没有信息的cell
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 1111;
    self.tableList.tableFooterView = view;

    
    [self addBasicView];
    [self requestList];
}
- (void)addBasicView
{
    btnLocal = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocal.frame = CGRectMake(30+10, 10, 120, 25);
    [btnLocal setTitle:@"本地" forState:UIControlStateSelected];
    [btnLocal setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnLocal setTitle:@"本地" forState:UIControlStateNormal];
    [btnLocal setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnLocal.tag = 11111;
    btnLocal.selected = YES;
    [btnLocal setBackgroundImage:[UIImage imageNamed:@"vipthree"] forState:UIControlStateSelected];
    [btnLocal setBackgroundImage:[UIImage imageNamed:@"viptwo"] forState:UIControlStateNormal];
    [btnLocal addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLocal];
    btnCountry = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCountry.frame = CGRectMake(150+10, 10, 120, 25);
    [btnCountry setTitle:@"全国" forState:UIControlStateSelected];
    [btnCountry setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnCountry setTitle:@"全国" forState:UIControlStateNormal];
    [btnCountry setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCountry.tag = 22222;
    btnCountry.selected = NO;
    [btnCountry setBackgroundImage:[UIImage imageNamed:@"vipone"] forState:UIControlStateSelected];
    [btnCountry setBackgroundImage:[UIImage imageNamed:@"vipfour"] forState:UIControlStateNormal];
    [btnCountry addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCountry];
}

- (void)btnClicked:(UIButton *)button
{
    UIButton *btn = (UIButton *)button;
    
    if (aryList != nil) {
        [aryList removeAllObjects];
    }
    
    if (btn.tag == 11111) {
        NSLog(@"本地");
        if (btnLocal.selected == YES) {
//            btnLocal.selected = NO;
//            btnCountry.selected = YES;
        }
        else
        {
            btnLocal.selected = YES;
            btnCountry.selected = NO;
        }
        self.strMaxTime = @"";
        strDifferentId = @"1";
        [self requestList];
        [self.tableList reloadData];
    }
    else if (btn.tag == 22222)
    {
        NSLog(@"全国");
        
        if (btnCountry.selected == NO) {
            btnCountry.selected = YES;
            btnLocal.selected = NO;
        }
        else
        {
//            btnCountry.selected = NO;
//            btnLocal.selected = YES;
        }
        self.strMaxTime = @"";
        strDifferentId = @"2";
        [self requestList];
        [self.tableList reloadData];
    }
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VipTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VipTwoCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    cell.lblone.text = [dict objectForKey:@"title"];
    cell.lbltwo.text = [[dict objectForKey:@"promissoryShop"]objectForKey:@"address"];
    NSString *strurl = [NSString stringWithFormat:@"%@small",[dict objectForKey:@"pictureurl"]];
    [cell.imageOne setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"icon-gear.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    
    VipDetailViewController *vipdevc = [[VipDetailViewController alloc]initWithNibName:@"VipDetailViewController" bundle:nil];
    vipdevc.dictList = dict;
    vipdevc.strIndex = @"1222";
    vipdevc.strMaterialId = [dict objectForKey:@"materialId"];
    [self.navigationController pushViewController:vipdevc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self modifyMoreFrame];
}

-(void) modifyMoreFrame{
    
	_refreshFootView.frame = CGRectMake(0.0f, self.tableList.contentSize.height, 320, 650);
}


#pragma mark - Network
- (void)requestList {
    MaterialInfosPostObj *postData = [[MaterialInfosPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.plateId = strPlateId;
    postData.classId = strClassId;
    postData.minTime = @"";
    postData.maxTime = self.strMaxTime;//获取后边5条数据
    postData.pageSize = @"5";
    postData.uid = struid;
    postData.token = strtoken;
    
    postData.plateFlag = @"2";
    postData.templet = @"2";
    postData.scale = strDifferentId;
    postData.orderBy = @"";
    postData.orderType = @"";
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    MaterialInfosTask *task = [[MaterialInfosTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSDictionary *dict = aTask.responseDict;
    NSLog(@"dict == %@",dict);
    NSArray *ary = [dict objectForKey:@"info"];
    NSArray *aryData = [ary objectAtIndex:0];
    
    NSDictionary *dic = [aryData lastObject];
    self.strMaxTime = [dic objectForKey:@"verifyTime"];
    
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

    
    [self.tableList reloadData];
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
	[self._refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableList];
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
    
	[_refreshFootView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableList];
    
    [self.tableList reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
