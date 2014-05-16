//
//  ClientListViewController.m
//  copy
//
//  Created by kevin on 14-3-25.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ClientListViewController.h"
#import "ClientListCell.h"
#import "ClientSeeViewController.h"
#import "MBProgressHUD.h"
/*
 *1.0 是否关注还没有改
 *
 *2.0 下拉刷新还没有做
 *
 *
 *
 ***/
@interface ClientListViewController ()
{
    NSMutableArray *aryBtnClicked;
    NSMutableArray *aryList;//整个表数据
    NSString *strSearch;
    NSString *strCustomerId;
    NSString *strAttention;
}
@end

@implementation ClientListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customNavigationTitle];
        [self customNavLeftButton];
        aryBtnClicked = [[NSMutableArray alloc]initWithCapacity:10];
        aryList = [[NSMutableArray alloc]initWithCapacity:10];
        strSearch = @"";//传空就是整个列表；不是空，就是搜索关键字
        [self requestList];
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
    titleLabel.text = @"客 户";
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
    //发送通知-滑动手势-panGestureEnabled=NO
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifNotpanGestureEnabled object:nil];
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
    
    /// 添加下拉刷新视图
    if (self._refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tablelist.bounds.size.height, self.view.frame.size.width, self.tablelist.bounds.size.height)];
		view.delegate = self;
		[self.tablelist addSubview:view];
		self._refreshHeaderView = view;
	}
	[self._refreshHeaderView refreshLastUpdatedDate];
    
    //隐藏掉table没有信息的cell
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 1111;
    self.tablelist.tableFooterView = view;
}

#pragma table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientListCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    NSString *stringName = [dict objectForKey:@"realName"];
    NSString *stringRemark = [dict objectForKey:@"remark"];
    cell.lblName.text = stringName;
    cell.lblInfo.text = stringRemark;
    [cell.imagePerson setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@small",[dict objectForKey:@"pictureurl"]]] placeholderImage:[UIImage imageNamed:@"1305774588258"]];
    
    NSDictionary *dic = [dict objectForKey:@"userRemark"];
    NSString *string = [dic objectForKey:@"isAttention"];
    NSLog(@"%@",string);
    
    //    NSString *str = [aryBtnClicked objectAtIndex:indexPath.row];
    if ([string isEqualToString:@"1"]) {
        cell.btnCareOrNot.selected = YES;
    }
    else
    {
        cell.btnCareOrNot.selected = NO;
    }
    cell.btnCareOrNot.tag = 3333;
    cell.btnCareOrNot.frame = CGRectMake(250, 5, 40, 40);
    [cell.btnCareOrNot setImage:[UIImage imageNamed:@"客户列表-空-心"] forState:UIControlStateNormal];
    [cell.btnCareOrNot setImage:[UIImage imageNamed:@"客户列表-实-心"] forState:UIControlStateSelected];
    [cell.btnCareOrNot addTarget:self action:@selector(btnDeleteTapped: event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"bbbb ...%d",indexPath.row);
    NSDictionary *dic = [aryList objectAtIndex:indexPath.row];
    ClientSeeViewController *clientSVC = [[ClientSeeViewController alloc]initWithNibName:@"ClientSeeViewController" bundle:nil];
    clientSVC.stringUserId = [dic objectForKey:@"userId"];
    clientSVC.stringName = [dic objectForKey:@"realName"];
    [self.navigationController pushViewController:clientSVC animated:NO];
}

- (void)btnDeleteTapped:(UIButton *)sender event:(UIEvent *)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint touchPosition = [touch locationInView:self.tablelist];
    NSIndexPath *indexPath = [self.tablelist indexPathForRowAtPoint:touchPosition];
    NSLog(@"aaaa  ..%d",indexPath.row);
    strCustomerId = [[aryList objectAtIndex:indexPath.row]objectForKey:@"userId"];
    
    UIButton *btn = (UIButton *)sender;
    NSString *string;
    if (btn.selected == YES) {
        string = @"0";
        btn.selected = NO;
        strAttention = string;
    }
    else
    {
        string = @"1";
        btn.selected = YES;
        strAttention = string;
    }
    [self requestAttentionOrNot];
    [aryBtnClicked replaceObjectAtIndex:indexPath.row withObject:string];
    NSLog(@"%@",aryBtnClicked);
}

#pragma mark - Network
- (void)requestList {
    ListCustomersVIPWithRemarkPostObj *postData = [[ListCustomersVIPWithRemarkPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    postData.uid = struid;
    postData.token = strtoken;
    postData.search = strSearch;//传空就是整个列表；不是空，就是搜索关键字
    postData.curPage = @"1";//当前页面从“1”开始
    postData.pageSize = @"5";
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    ListCustomersVIPWithRemarkTask *task = [[ListCustomersVIPWithRemarkTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
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
    postData.customerId = strCustomerId;//客户Id
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
    
    if ([aTask isKindOfClass:[ListCustomersVIPWithRemarkTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSArray *ary = [dict objectForKey:@"info"];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            aryList = [ary objectAtIndex:0];
            for (int i = 0; i < aryList.count; i ++) {
                NSDictionary *d = [aryList objectAtIndex:i];
                NSDictionary *ddd = [d objectForKey:@"userRemark"];
                NSString *str;
                if (ddd == nil) {
                    str = @"0";
                }
                else
                {
                    str = [ddd objectForKey:@"isAttention"];
                }
                [aryBtnClicked addObject:str];
            }
            [self.tablelist reloadData];
        }else if ([code isEqualToString:@"9998"]){
        
        }else if ([code isEqualToString:@"9009"]){
            [Utility alert:@"无权访问"];
        }
        else{
            [Utility alert:@"用户操作数据失败"];
        }
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

#pragma - search bar delegate
//UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBr setShowsCancelButton:YES animated:YES];
    return YES;
}

//取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBr resignFirstResponder];
    [self.searchBr setShowsCancelButton:NO animated:NO];
}

//键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBr resignFirstResponder];
    NSLog(@"键盘中，搜索按钮被按下，执行的方法");
    strSearch = searchBar.text;
    [self requestList];
}
// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"....搜索内容变化时，执行该方法。");
    if ([searchText isEqualToString:@""]) {
        NSLog(@"如果为空，就刷新列表，回到搜索前");
        strSearch = @"";
        [self requestList];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"搜索输入完");
}

#pragma mark --下拉刷新
#pragma mark - Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    refresh = YES;
    [self requestList];
    
	self._reloading = YES;
}

//更新完成调用这个方法 刷新表视图数据
- (void)doneLoadingTableViewData{
    
	//  model should call this when its done loading
	self._reloading= NO;
    //    [self.tableviewlist reloadData];
	[self._refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tablelist];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end