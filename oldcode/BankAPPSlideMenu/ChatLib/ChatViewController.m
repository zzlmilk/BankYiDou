
//
//  EMEChatViewController.m
//  EMEChat
//
//  Created by Sean Li on 3/6/14.
//  Copyright (c) 2014 junyi.zhu All rights reserved.
//

#import "ChatViewController.h"
#import "EMELPDialogVC.h"
#import "EMEChatConfManager.h"
#import "ChatViewCell.h"
#import "ClientListViewController.h"
#import "ListCustomersVIPWithRemarkPostObj.h"
#import "ListCustomersVIPWithRemarkTask.h"
#import "ChatViewCell.h"
#import "EMELPDialogVC.h"
#import "NSObject+CoreDataExchange.h"
#define SplitTimeSpan 1*60
#import "EMEDialogEntity.h"
#import "EMERecentContactsEntity.h"
#import "BaseViewController.h"
#import "UpdateMessagesStatuPostObj.h"
#import "UpdateMessagesStatuTask.h"


@interface ChatViewController (){
    NSMutableArray *aryList;
    NSString * struseruid;
//    NSString * strType;
    NSString *stringUrl;
    NSString *stringName;
    EMELPDialogVC *lpDialogVC;

}
@property(nonatomic,strong)UIButton *evChatButton;
@end

@implementation ChatViewController
@synthesize struserId,socketList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        aryList = [[NSMutableArray alloc]initWithCapacity:10];
          }
    return self;
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

- (void)customNavigationTitle
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"留 言";
    self.navigationItem.titleView = titleLabel;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UserManager shareInstance] addUserStatusWithUserStatus:UserCurrentStatusForMessageTableView];

    //发送通知-滑动手势-panGestureEnabled=YES
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifPanGestureEnabled object:nil];
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self HandleResponseWithNotic:nil];
    [[DockView sharedDockView] resetLabelunread];
}


-(void)HandleResponseWithNotic:(NSNotification*)notifiction
{
    [self initData];
    [socketList reloadData];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[UserManager shareInstance] removeUserStatusWithUserStatus:UserCurrentStatusForALL];
    
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark - Network
- (void)requestList {
    ListCustomersVIPWithRemarkPostObj *postData = [[ListCustomersVIPWithRemarkPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    postData.uid = struid;
    postData.token = strtoken;
    postData.search = @"";//传空就是整个列表；不是空，就是搜索关键字
    postData.curPage = @"1";//当前页面从“1”开始
    postData.pageSize = @"5";
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    ListCustomersVIPWithRemarkTask *task = [[ListCustomersVIPWithRemarkTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)requestupdateMessagesStatu
{
    UpdateMessagesStatuPostObj *postData = [[UpdateMessagesStatuPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *token = [mySettingData objectForKey:@"token"];
    NSString *uid = [mySettingData objectForKey:@"uid"];
    postData.uid = uid;
    postData.token = token;
    //已发送   已接受    已读
    postData.fromStatu = @"0";   //原状态值
    postData.toStatu =@"1";      //新状态值
    postData.userId = @"8";   //当前联系人uid
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    UpdateMessagesStatuTask *task = [[UpdateMessagesStatuTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleResponseWithNotic:) name:ChatSocketRequestResponseNoticeForList object:nil];
    [self requestList];
    [self setExtraCellLineHidden:self.socketList];

    [self customNavigationTitle];

    [self customNavLeftButton];

//    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
//    stringName = [mySettingData objectForKey:@"realName"];
//    stringUrl =[mySettingData objectForKey:@"pictureurl"];
    
    
    [[EMEChatConfManager sharedManager] registerCurrentUserChatId:^NSString *(NSString *key) {
        if ( ![[UserManager shareInstance] can_auto_login]) {
//            [UserManager shareInstance].user.userId = theuseruid;
            [UserManager shareInstance].user.userName = stringName;
//            [UserManager shareInstance].user.userPassword = stringPassWord;
            [UserManager shareInstance].user.userHeadURL = stringUrl;
        }
        return    [UserManager shareInstance].user.userId;
        
    }];
    
    [lpDialogVC checkNetWorkStatus];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


-(void)initData
{
    if (_data_array == nil) {
        _data_array = [[NSMutableArray alloc] initWithCapacity:5];
    }
    else
    {
        [_data_array removeAllObjects];
    }
    
    [self getMoreHistoryContactRecord];
}
//获取最近联系人数据 --junyi.zhu debug
-(BOOL)getMoreHistoryContactRecord
{
    BOOL success = NO;
    NSDate *historyDate = [NSDate date];
    //表示有数据，这历史数据获取，应该以第一条数据查询
    if ([self.data_array count] > 0) {
        EMERecentContactsEntity* oldestMessage = [self.data_array  objectAtIndex:0];
        historyDate = oldestMessage.time;
    }
    
    NSArray* temp_array = [self getlatestRecentContactEntiesWithLimitTime];
    
    if (temp_array) {
        success = YES;
        for (NSInteger i = 0 ; i<[temp_array count]; i++) {
            EMERecentContactsEntity* tempRecentEntity = [temp_array objectAtIndex:i];
            
            if (!(tempRecentEntity.messageId == nil)) {
                    [self.data_array addObject:tempRecentEntity];
            }
            historyDate = tempRecentEntity.time;
        }
    }
    
    NIF_ALLINFO(@"dataArray: %@ DateTime:%@",self.data_array,historyDate);
    return  success;
}

- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[ListCustomersVIPWithRemarkTask class]]) {
        
//        EMERecentContactsEntity * RecentEn =[[EMERecentContactsEntity alloc]init] ;

        NSDictionary *dict = aTask.responseDict;
        NSArray *ary = [dict objectForKey:@"info"];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
                   aryList = [ary objectAtIndex:0];
            for (int i = 0; i < aryList.count; i ++) {
                NSDictionary *dict = [aryList objectAtIndex:i];
                stringName = [dict objectForKey:@"realName"];
                stringUrl= [dict objectForKey:@"pictureurl"];
//                struseruid = [dict objectForKey:@"userId"];
            }
//            [ RecentEn setAttributeWithContactUid:nil
//                                   FromSource:nil
//                              ContactNickName:stringName
//                               ContactHeadUrl:stringUrl];

        }else if ([code isEqualToString:@"9998"]){
            [Utility alert:@"登录信息验证失败"];
        }else if ([code isEqualToString:@"9009"]){
            [Utility alert:@"无权访问"];
        }
        else if ([code isEqualToString:@"9999"]){
            [Utility alert:@"VIP客户信息列表获取失败"];
        }
    }
    else if ([aTask isKindOfClass:[UpdateMessagesStatuTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
        }
        else if ([code isEqualToString:@"9999"]){
            [Utility alert:@"修改用户消息状态失败"];
        }
        else if ([code isEqualToString:@"9998"]){
            [Utility alert:@"登录信息验证失败"];
        }
        else if ([code isEqualToString:@"9001"]){
            [Utility alert:@"用户不存在"];
        }
        else if ([code isEqualToString:@"9001"]){
            [Utility alert:@"非法状态值"];
        }
    }
}
#pragma table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data_array.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *whichSection = @"contact_table_view_cell";
	ChatViewCell *cell = (ChatViewCell*)[tableView dequeueReusableCellWithIdentifier:whichSection];
    if (cell == nil) {
        cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:whichSection];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChatViewCell" owner:self options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中CELL时，无色（不变色）

    EMERecentContactsEntity * RecentEn = [self.data_array objectAtIndex:indexPath.row];
    cell.VipName.text = RecentEn.contactNickName;
    [cell.VipImage setImageWithURL:[NSURL URLWithString:RecentEn.contactHeadUrl ] placeholderImage:[UIImage imageNamed:@"1305774588258.png"]];
    //change nsinteger to nsstring  junyi.zhu
    cell.unReadNum.text = [NSString stringWithFormat: @"%d", (int)RecentEn.unReadMessagesCount];
    int intString = [cell.unReadNum.text intValue];
    cell.socketContents.text = [NSString stringWithFormat:@"%@",RecentEn.content];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"左侧菜单-提示数.png"]];
    [cell.unReadNum setBackgroundColor:color];
    
    if (intString <=0) {
        [cell.unReadNum setHidden:YES];
    }
    else if(intString >0) {
        [cell.unReadNum setHidden:NO];
    }
    else if(intString > 100 ){
        cell.unReadNum.text =@"99+";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //清除新消息条数记录
    [self clearRecentContactsEntityUnreadMessagesCountWithContactUid:self.contactuid];

    NSLog(@"indexPath.row:%ld",(long)indexPath.row);
    EMERecentContactsEntity *dic = [self.data_array objectAtIndex:indexPath.row];
    lpDialogVC = [[EMELPDialogVC alloc] init];
    lpDialogVC.touid = dic.contactUid;
    lpDialogVC.toName = dic.contactNickName;
    lpDialogVC.tourl=dic.contactHeadUrl;
//    lpDialogVC.touid = [dic objectForKey:@"userId"];
//    lpDialogVC.toName = [dic objectForKey:@"contactNickName"];
    
//    struserId = [[_data_array objectAtIndex:indexPath.row]objectForKey:@"contactUid"];
  
//    [[NSUserDefaults standardUserDefaults] setObject:struserId forKey:@"userId"];
    EMELPFamily *lpFamliy = [[EMELPFamily alloc] init];
    [lpFamliy setAttributeWithUserId:lpDialogVC.touid
                            UserName:lpDialogVC.toName
                        UserNickName:lpDialogVC.toName
                         UserHeadURL:lpDialogVC.tourl
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
    [self.navigationController pushViewController:lpDialogVC animated:NO];
//    [self requestupdateMessagesStatu]; //修改消息状态接口
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//切换到主线程中来做更新
-(void)updateTableViewOnMainThreadWithDic:(NSDictionary*)Dic //(EMEDialogEntity*)dialogEntity isNewMessage:(BOOL)isNewMessage
{
    EMERecentContactsEntity* RecentEntity = [Dic objectForKey:@"RecentContactsEntity"];
    
    BOOL isNewMessage = [[Dic objectForKey:@"isNewMessage"] boolValue];
    
    BOOL isSameRecord = NO;
    NSInteger relaodRowIndex = [self.data_array count]+1;
    //服务端响应过来的数据 , 或者是不是同一条数据
    if ([_data_array count]>0 && !isNewMessage) {
        //倒序查询
        for (NSInteger i= [self.data_array count]-1 ; i>=0 ; i--) {
            EMERecentContactsEntity* recentEn = [self.data_array objectAtIndex:i];
            if ([recentEn.messageId  isEqualToString:RecentEntity.messageId]) {
                [recentEn setAttributeWithContactUid:recentEn.contactUid FromSource:nil ContactNickName:recentEn.contactNickName ContactHeadUrl:recentEn.contactHeadUrl];
                isSameRecord = YES;
                relaodRowIndex = i;
                break;
            }
        }
    }
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    //表示是一条新消息
    if (!isSameRecord  || isNewMessage) {
        //检查时间
        if ([self.data_array count ] > 0) {
            EMEDialogEntity* historyDialogEN  = [self.data_array lastObject];
            if ([RecentEntity.time timeIntervalSince1970] - [historyDialogEN.time  timeIntervalSince1970] > SplitTimeSpan) {
                EMEDialogEntity* timeDialogEN = [[EMEDialogEntity alloc] init];
                [timeDialogEN setAttributeWithMessageId:nil
                                                FromUid:nil
                                                  ToUid:nil
                                            MessageType:MessageTypeForSystemNotic
                                          MessageStatus:MessageStatusForSendSuccess
                                                Content:[CommonUtils DateConvertToFriendlyStringWithDate:RecentEntity.time]
                                                   Time:RecentEntity.time];
                
                [self.data_array addObject:timeDialogEN];
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:[self.data_array count]-1 inSection:0]];
                
            }
        }
        
        [_data_array addObject:RecentEntity];
        
        relaodRowIndex = [self.data_array count]-1;
    }
    
    
    
    
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:relaodRowIndex inSection:0]];
    
    
    if (isSameRecord && !isNewMessage) {
        
        [self.socketList reloadRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        
        
        [self.socketList beginUpdates];
        [self.socketList insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
        [self.socketList endUpdates];
        
    }
    
    
    [self.socketList scrollToRowAtIndexPath:[indexPathsToInsert lastObject] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
}

-(void)updateTableViewWithRecentEntity:(EMERecentContactsEntity*)RecentEntity isNewMessage:(BOOL)isNewMessage
{
    
    NSThread *currentThread = [NSThread currentThread];
    NSDictionary*  messageDic = [NSDictionary dictionaryWithObjectsAndKeys:RecentEntity,@"RecentContactsEntity",[NSNumber numberWithBool:isNewMessage],@"isNewMessage", nil];
    
    if ([currentThread isMainThread]) {
        [self updateTableViewOnMainThreadWithDic:messageDic];
    }else{
        [self performSelectorOnMainThread:@selector(updateTableViewOnMainThreadWithDic:) withObject:messageDic waitUntilDone:NO];
    }
}
@end
