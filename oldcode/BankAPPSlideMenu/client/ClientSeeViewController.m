//
//  ClientSeeViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ClientSeeViewController.h"
#import "ClientSeeCell.h"
#import "MBProgressHUD.h"
#import "ManageListVController.h"

#import "VipDetailViewController.h"
#import "FirstDetailViewController.h"

#import "EMEDialogEntity.h"
#import "EMERecentContactsEntity.h"
#import "UserManager.h"
#import "ChatViewController.h"
#import "NSObject+CoreDataExchange.h"

#import "ClientVIpDetailVC.h"

@interface ClientSeeViewController ()
{
    NSArray *aryList;
    NSString *ContactUid;
    NSString *ContactNickName;
    NSString *ContactHeadUrl;
    NSString *FromSource;
    ChatViewController * chatVC ;
}
@end

@implementation ClientSeeViewController
@synthesize stringUserId,stringName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    titleLabel.text = stringName;
    self.navigationItem.titleView = titleLabel;
}

- (void)customNavLeftButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 25);
    [btn setImage:[UIImage imageNamed:@"fanhui11"] forState:UIControlStateNormal];
    btn.tag = 10004;
    [btn addTarget:self action:@selector(LeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)customNavRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:@"icon_btm_client"] forState:UIControlStateNormal];
    btn.tag = 10005;
    [btn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)LeftBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender
{
    //进入客户信息页面
    NSLog(@"...进入客户信息页面");
    ClientVIpDetailVC *cVipvc = [[ClientVIpDetailVC alloc]initWithNibName:@"ClientVIpDetailVC" bundle:nil];
    cVipvc.strUserId = ContactUid;
    [self.navigationController pushViewController:cVipvc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customNavRightButton];
    [self customNavigationTitle];
    [self customNavLeftButton];

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
    
    [self requestList];
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

#pragma - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClientSeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientSeeCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    
    long long num = [[dict objectForKey:@"lastTime"]longLongValue];
    cell.lblTime.text = [self changeTime:num];
    
    NSDictionary *dic = [dict objectForKey:@"materialInfo"];
    cell.lblTitle.text = [dic objectForKey:@"title"];
    [cell.imageRight setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@small",[dic objectForKey:@"pictureurl"]]] placeholderImage:[UIImage imageNamed:@"icon-gear"]];
    NSString *strPraise = [dict objectForKey:@"praiseFlag"];
    if ([strPraise isEqualToString:@"0"]) {
        cell.lblZan.text = @"未赞";
    }
    else if ([strPraise isEqualToString:@"1"]){
        cell.lblZan.text = @"已赞";
    }
    NSString *strCollect = [dict objectForKey:@"collectFlag"];
    if ([strCollect isEqualToString:@"0"]) {
        cell.lblCollect.text = @"未收藏";
    }
    else if ([strCollect isEqualToString:@"1"]){
        cell.lblCollect.text = @"已收藏";
    }
    return cell;
}
/***
 *0：普通素材（咨询类型）
 *1：活动类型素材
 *2：VIP特权类型素材
 *3：理财产品类型素材
 *4：信贷类型素材
 *5：黄金类型素材
 *
 ***/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    NSDictionary *dic = [dict objectForKey:@"materialInfo"];
    NSString *stringTemplet = [dic objectForKey:@"templet"];
    NSString *stringMaterialId = [dic objectForKey:@"materialId"];
    if ([stringTemplet isEqualToString:@"0"]) {
        
    }
    else if ([stringTemplet isEqualToString:@"1"])
    {
        
    }
    else if ([stringTemplet isEqualToString:@"2"])
    {
        VipDetailViewController *vipVC = [[VipDetailViewController alloc]initWithNibName:@"VipDetailViewController" bundle:nil];
        vipVC.strIndex = @"1333";
        vipVC.strMaterialId = stringMaterialId;
        vipVC.dictList = dict;
        [self.navigationController pushViewController:vipVC animated:YES];
    }
    else if ([stringTemplet isEqualToString:@"3"])
    {
        FirstDetailViewController *firstvc = [[FirstDetailViewController alloc]initWithNibName:@"FirstDetailViewController" bundle:nil];
        firstvc.strMaterialId = stringMaterialId;
        firstvc.strIndex = @"1333";
        firstvc.dictAll = dict;
        [self.navigationController pushViewController:firstvc animated:YES];
    }
    else if ([stringTemplet isEqualToString:@"4"])
    {
        
    }
    else if ([stringTemplet isEqualToString:@"5"])
    {
        
    }
    
    
//    VipDetailViewController *vipVC = [[VipDetailViewController alloc]initWithNibName:@"VipDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:vipVC animated:YES];

    
//    ManageListVController *manageVC = [[ManageListVController alloc]initWithNibName:@"ManageListVController" bundle:nil];
//    [self.navigationController pushViewController:manageVC animated:NO];
}

#pragma mark - Network
- (void)requestList {
    CatchCustomerVIPWithOperateHistoryObj *postData = [[CatchCustomerVIPWithOperateHistoryObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    postData.uid = struid;
    postData.token = strtoken;
    postData.userId = stringUserId;//传空就是整个列表；不是空，就是搜索关键字
    postData.curPage = @"1";//当前页面从“1”开始
    postData.pageSize = @"5";
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    CatchCustomerVIPWithOperateHistoryTask *task = [[CatchCustomerVIPWithOperateHistoryTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[CatchCustomerVIPWithOperateHistoryTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *ary = [dict objectForKey:@"info"];
            NSDictionary *dic = [ary objectAtIndex:0];
            aryList = [dic objectForKey:@"materialUserList"];
            
            ContactUid = [dic objectForKey:@"userId"];//传值用到，改得时候注意
            ContactNickName =[ dic objectForKey:@"realName"];
            ContactHeadUrl = [NSURL URLWithString:[dic objectForKey:@"pictureurl"]];
            
            //设置头像
            [self.imagePerson setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pictureurl"]] placeholderImage:[UIImage imageNamed:@"1305774588258"]];
            [self.tablelist reloadData];
        }else if ([code isEqualToString:@"9998"]){
        
        }else if ([code isEqualToString:@"9009"]||[code isEqualToString:@"9017"]){
            [Utility alert:@"用户无权访问"];
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

- (IBAction)btnClicked:(id)sender {
    NSLog(@"发起会话聊天");

    EMELPDialogVC *lpDialogVC = [[EMELPDialogVC alloc] init];
    EMELPFamily *lpFamliy = [[EMELPFamily alloc] init];
    [lpFamliy setAttributeWithUserId:ContactUid
                            UserName:ContactNickName
                        UserNickName:ContactNickName
                         UserHeadURL:[NSString stringWithFormat:@"%@", ContactHeadUrl]
                             UserSex:UserSexTypeForFemale
                         UserAddress:nil
                       UserSignature:nil
                        UserTeamName:nil
                        UserIndustry:nil
                         UserJobName:nil
                    UserRegisterDate:nil
                      UserAlbumArray:nil
                            isOnline:YES
                          FriendType:FriendTypeForFriend];
    [lpDialogVC setAttributeFamilyMember:lpFamliy
                                   Group:nil];
    [self.navigationController pushViewController:lpDialogVC animated:YES];
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

@end
