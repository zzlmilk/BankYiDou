        //
//  EMELPDialogVC.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

typedef enum {
    BubbleTypeForDefualt =0,//默认值
    BubbleTypeForSystemMessage// 系统消息
} BubbleType;



#import "EMELPDialogVC.h"
#import "EMEDialogEntity.h"
#import "EMELPMessageCell.h"
//#import "EMELPVoiceVC.h"
#import "TouchTableView.h"
#import "StringUtils.h"
#import "NSObject+Message_Dialog.h"
//#import "EMELPFamilyHttpRquestManager.h"
#import "NSObject+CoreDataExchange.h"
#import "AudioManager.h"
#import "AudioManagerDelegate.h"
#import "EMELPSocketManager.h"
#import <AVFoundation/AVFoundation.h>
#import "PathUtils.h"
#import "NetWorkWatchDogManager.h"
#import "SVPullToRefresh.h"
#import "EMEButton.h"
#import "EMEFactroyManger.h"
#define SplitTimeSpan 1*60
#import "UserManager.h"
#import "ClientVIpDetailVC.h"
#import "DockView.h"

typedef enum {
    LPDialogVCTagForSoundButton = 210,
    LPDialogVCTagForVoiceButton,
    LPDialogVCTagForSwithButton,
    LPDialogVCTagForSendButton,
    LPDialogVCTagForHintsButton
} LPDialogVCTag;

static NSString* AudioRecordTempFileName = @"AudioRecordTempFileName";


@interface EMELPDialogVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EMELPMessageCellDelegate,UITableViewTouchDelegate,AudioManagerDelegate>
{
    BOOL _isGroupDialog;
    AudioManager *_audioManager;
    BOOL isCanRecord;//是否可以录音
    BOOL _isShow;
    BOOL _isPreHidden;
}


@property(nonatomic,strong)UIView* contentPanelView;//正文内容面板，除了导航栏的面板

@property(nonatomic,strong)TouchTableView* mytableView;
@property(nonatomic,strong)NSMutableArray* data_array;


@property(nonatomic,strong)UIView *buttom_view;


@property(nonatomic,strong)UITextView *inputTextView;
@property(nonatomic,strong)EMEButton *soundButton;//录音按钮

@property(nonatomic,strong)EMEButton *voiceButton; //语音对话
@property(nonatomic,strong)EMEButton *swithButton; //切换 录音 还是 文本
@property(nonatomic,strong)EMEButton *sendButton;  //发送按钮
@property(nonatomic,strong)EMEButton *keyboardButton;  //键盘按钮 junyi.zhu debug

@property(nonatomic,strong)UIView *hintsView;
@property(nonatomic,strong)UILabel *hintsLabel;



@end

@implementation EMELPDialogVC

@synthesize theuserid;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _mytableView.delegate = nil; _mytableView.dataSource = nil;
//    [[EMELPFamilyHttpRquestManager shareInstance] clearDelegate:self.class];
    _audioManager.delegate = nil;
    
    
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

- (void)rightBtnClicked:(id)sender
{
    //进入客户信息页面
    NSLog(@"...进入客户信息页面");
    ClientVIpDetailVC *cVipvc = [[ClientVIpDetailVC alloc]initWithNibName:@"ClientVIpDetailVC" bundle:nil];
    cVipvc.strUserId = self.familyMember.userId;
    [self.navigationController pushViewController:cVipvc animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

-(void)setAttributeFamilyMember:(EMELPFamily*)family Group:(EMELPGroup*)group
{
    if (family) {
        self.familyMember = family;
        _isGroupDialog = NO;
    }else{
        _isGroupDialog = YES;
        self.group = group;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isPreHidden = [DockView sharedDockView].hidden;
    if ([DockView sharedDockView].hidden == NO) {
        [DockView sharedDockView].hidden = YES;
    }
    
    [self customNavLeftButton];
    self.title = self.familyMember.userNickname;
    
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleResponseWithNotic:) name:ChatSocketRequestResponseNoticeForDailog object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleResponseWithNoticStopVoice:) name:SocketRequestResponseNoticeForVoiceStop object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleResponseWithNoticExceptionVoice:) name:SocketRequestResponseNoticeForVoiceException object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleResponseWithNoticFriendNotOnlineVoice:) name:SocketRequestResponseNoticeForFriendNotOnline object:nil];
    
    _audioManager = [AudioManager getInstance:[NSString stringWithFormat:@"%@.aac",AudioRecordTempFileName]
                         audioManagerDelegate:self];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *userType = [mySettingData objectForKey:@"userType"];
    if ([userType isEqualToString:@"1"]) {
        [self customNavRightButton];
    }
    //检查网络
    [self checkNetWorkStatus];
    
    [self initData];
    [self initView];
       
    
    //清除新消息条数记录
//    [self clearRecentContactsEntityUnreadMessagesCountWithContactUid:_isGroupDialog ? self.group.groupId : self.familyMember.userId];
    [self clearRecentContactsEntityUnreadMessagesCountWithContactUid: self.familyMember.userId];

    
    //    //加载更多和更新
    __weak EMELPDialogVC *weakSelf = self;
         //下拉刷新
    [self.mytableView addPullToRefreshWithActionHandler:^{
        if (![weakSelf getMoreHistoryMessageRecord]) {
            [weakSelf.mytableView.pullToRefreshView setTitle:@"没有更多了" forState:SVPullToRefreshStateAll];
            
         }else{
             [weakSelf.mytableView reloadData];
        }
        [weakSelf performSelector:@selector(hiddenPullToRefreshAnimated) withObject:nil afterDelay:2];
     }];
    
    [self.mytableView.pullToRefreshView setTitle:@"下拉加载更多" forState:SVPullToRefreshStateTriggered];
    [self.mytableView.pullToRefreshView setTitle:@"正在加载..." forState:SVPullToRefreshStateLoading];
    [self.mytableView.pullToRefreshView setTitle:@"处理完毕..." forState:SVPullToRefreshStateStopped];
    
}

-(void)hiddenPullToRefreshAnimated
{
    [self.mytableView.pullToRefreshView stopAnimating];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self sendRequestFriendInfo];
    
    
    //记录聊天状态记录
    [UserManager shareInstance].userContactUserId = [NSString stringWithFormat:@"%@",self.familyMember.userId];
    
    [[UserManager shareInstance] addUserStatusWithUserStatus:UserCurrentStatusForMessage];

    //会重新加载一次头部提示显示
    NIF_ALLINFO(@"如果处于实时对讲中，则需要显示提示");
    [self.mytableView reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self.mytableView.pullToRefreshView startAnimating];
//    [self performSelector:@selector(hiddenPullToRefreshAnimated) withObject:nil afterDelay:0.2];

    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UserManager shareInstance] removeUserStatusWithUserStatus:UserCurrentStatusForMessage];

    [DockView sharedDockView].hidden = _isPreHidden;
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    
    if (_data_array == nil) {
       _data_array = [[NSMutableArray alloc] initWithCapacity:5];
        
//        for (NSInteger i = 0; i<40; i++) {
//            MessageType   type =   [NSString getRandomNumber:1 to:2];
//            EMEDialogEntity* dialogEntity = [[EMEDialogEntity alloc] init];
//            NSString* contentStr = nil;
//            if (type == MessageTypeForMap) {
//                contentStr = @"22.531263202092,114.007975459121";
//            }else if(type == MessageTypeForSystemMessage){
//                contentStr =[NSString stringWithFormat:@"类型《%d》，求救信息这是系统消息",type] ;
//            }else if(type == MessageTypeForSystemNotic){
//                contentStr = [NSString stringWithFormat:@"09-29 21:44"];
//            }else if(type == MessageTypeForSystemPushAD){
//                contentStr = [NSString stringWithFormat:@"类型《%d》，大甩卖了大甩卖了",type];
//            }else{
//               contentStr = @"这是一个测试";
//            }
//            
//            [dialogEntity setAttributeWithUid:[NSString stringWithFormat:@"UID_%ld",(long)i]
//                                  MessageType:type
//                            MessageSendStatus:MessageSendStatusForSuccess
//                                      Content:contentStr
//                                         Time:[NSDate dateWithTimeIntervalSinceNow:-50*i]];
//            [_data_array addObject:dialogEntity];
//        }
//        NIF_INFO(@"%@",_data_array);
    }
    
    //获取数据
    [self getMoreHistoryMessageRecord];
    
//    [NSObject testCoreDataHandleFunction];
}

-(void)initView
{
    CGRect  frame = [self efGetContentFrame];
    _contentPanelView = [[UIView alloc] init];
    self.contentPanelView.backgroundColor  = [UIColor clearColor];
    self.contentPanelView.frame =frame;
 
    [self.view addSubview:self.contentPanelView];
    
    frame.origin.y = 0;
    frame.size.height -= 52;
    
//    if (EME_SYSTEMVERSION7) {
//        frame.origin.y += -20;
//        frame.size.height += 20;
//    }
    
    self.mytableView.frame = frame;
    [self.contentPanelView addSubview:self.mytableView];
    
    
    //buttom view
    frame.origin.y = frame.size.height+frame.origin.y;
    frame.size.height = 52;
//    self.buttom_view.frame = frame;
    if (!IS_IPHONE5) {
        self.buttom_view.frame =CGRectMake(0,365, 320, 52);
    }
    else{
        self.buttom_view.frame =CGRectMake(0,453, 320, 52);
    }
    [self.contentPanelView addSubview:self.buttom_view];
    
    CGFloat spaceing = 6.0; //间距
    //添加底边的子视图
    //添加图片button
    frame.size = CGSizeMake(39, 34);
    frame.origin.y = (self.buttom_view.frame.size.height - frame.size.height) / 2.0;
    frame.origin.x = spaceing;
    _swithButton = [EMEFactroyManger createEMEbuttonWithTitile:nil
                                                         Frame:frame
                                                      FontSize:14
                                               BackgroundColor:[UIColor clearColor]
                                                         Image:[UIImage imageNamed:@"lp07_macrophone_icon"]
                                                     TextColor:[UIColor  whiteColor]
                                                        Action:@selector(buttonClick:)
                                                        Target:self
                                                     ButtonTag:LPDialogVCTagForSwithButton];
    
    [_swithButton setBackgroundImgeWithNormalImageName:@"g_button_bg01"
                                   HighlightedImageName:@"g_button_bg02"];
//    [self.buttom_view addSubview:self.swithButton];//junyi.zhu debug语音
    _keyboardButton = [EMEFactroyManger createEMEbuttonWithTitile:nil
                                                            Frame:frame FontSize:14
                                                  BackgroundColor:[UIColor clearColor]
                                                            Image:[UIImage imageNamed:@"lp07_keyboard_icon"]
                                                        TextColor:[UIColor whiteColor]
                                                           Action:@selector(buttonOnclock:)
                                                           Target:self ButtonTag:LPDialogVCTagForSwithButton];
    [_keyboardButton setBackgroundImgeWithNormalImageName:@"g_button_bg01"
                                     HighlightedImageName:@"g_button_bg02"];
    [self.buttom_view addSubview:self.keyboardButton];
//#warning 注意群组不支持语音
//    if (!_isGroupDialog) {
//    //语音对话按钮
//    frame.origin.x += frame.size.width + spaceing;
//    _voiceButton =  [EMEFactroyManger createEMEbuttonWithTitile:nil
//                                                          Frame:frame
//                                                       FontSize:14
//                                                BackgroundColor:[UIColor clearColor]
//                                                          Image:[UIImage imageNamed:@"lp07_duijiang_icon"]
//                                                      TextColor:[UIColor  whiteColor]
//                                                         Action:@selector(buttonClick:)
//                                                         Target:self
//                                                      ButtonTag:LPDialogVCTagForVoiceButton];
//    [_voiceButton setBackgroundImgeWithNormalImageName:@"g_button_bg01"
//                                  HighlightedImageName:@"g_button_bg02"];
//    [_buttom_view addSubview:self.voiceButton];
//    }


    ////////////////////////////////////////  注意：  录音图标的宽度是   发送按钮宽度、文字输入框宽度、一个间距的总和
   //录音Button
    frame.origin.x += frame.size.width + spaceing;
    frame.size.width = 320 - frame.origin.x - spaceing;
    
    _soundButton = [EMEFactroyManger createEMEbuttonWithTitile:@"按住说话"
                                                         Frame:frame
                                                      FontSize:14
                                               BackgroundColor:[UIColor clearColor]
                                                         Image:nil
                                                     TextColor:[UIColor  whiteColor]
                                                        Action:nil
                                                        Target:nil
                                                     ButtonTag:LPDialogVCTagForSoundButton];
    
    [_soundButton  addTarget:self action:@selector(buttonClickDown:) forControlEvents:UIControlEventTouchDown];
    [_soundButton  addTarget:self action:@selector(buttonClickUP:) forControlEvents:UIControlEventTouchUpInside];
    
    [_soundButton setBackgroundImgeWithNormalImageName:@"g_button_bg01"
                                  HighlightedImageName:@"g_button_bg02"];
    self.soundButton.frame = frame;
    [_buttom_view addSubview:self.soundButton];
    self.soundButton.hidden = YES;
    
    
    
    ////////////////////////////////////////
    //发送按钮
    frame.size.width =  50.0;
frame.origin.x = 320 - frame.size.width -  spaceing;
    
    _sendButton  = [EMEFactroyManger createEMEbuttonWithTitile:@"发送"
                                                         Frame:frame
                                                      FontSize:14
                                               BackgroundColor:[UIColor clearColor]
                                                         Image:nil
                                                     TextColor:[UIColor  whiteColor]
                                                        Action:@selector(buttonClick:)
                                                        Target:self
                                                     ButtonTag:LPDialogVCTagForSendButton];
    [_sendButton setBackgroundImgeWithNormalImageName:@"g_button_bg01"
                                 HighlightedImageName:@"g_button_bg02"];
    [_buttom_view addSubview:self.sendButton];
    
    
    
    //输入框
    frame.size.width =   _soundButton.frame.size.width  - _sendButton.frame.size.width - spaceing  ;
    frame.origin.x = _soundButton.frame.origin.x;
    
    self.inputTextView = [[UITextView alloc]initWithFrame:frame];

    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.layer.cornerRadius = 3.0;
    self.inputTextView.font = [UIFont systemFontOfSize:14.0];
    self.inputTextView.returnKeyType = UIReturnKeySend;
    self.inputTextView.delegate = self;

    [_buttom_view addSubview:self.inputTextView];

    if ([self.data_array count] > 0) {
        [self.mytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.data_array count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];

    }
    
    
    
    
    //提示
    frame.size = CGSizeMake(320, 50.0+10.0);
    frame.origin = CGPointMake(0.0, 0.0);
    self.hintsView.frame = frame;
    
    frame.size.height -= 10.0;
    UIImageView* hintsBackGroundImageView = [[UIImageView alloc] init];
    hintsBackGroundImageView.frame = frame;
    hintsBackGroundImageView.backgroundColor = UIColorFromRGB(0xE2DBD5);
    hintsBackGroundImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    hintsBackGroundImageView.layer.shadowOpacity = 0.3;
    hintsBackGroundImageView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    [self.hintsView addSubview:hintsBackGroundImageView];
    
    //提示 - 手机信号图标
    frame.size = CGSizeMake(15, 25);
    frame.origin.x = 16.0;
    frame.origin.y =  (self.hintsView.frame.size.height - frame.size.height)/2.0;
    
    UIImageView*  mobileImageView = [[UIImageView alloc] init];
    mobileImageView.backgroundColor = [UIColor clearColor];
    mobileImageView.frame = frame;
    mobileImageView.image = [UIImage imageNamed:@"lp07_duijiang_icon"];
    [self.hintsView addSubview:mobileImageView];
    
    //提示 - 提示可变内容
    frame.size = CGSizeMake(115, 21);
    frame.origin.y = 6.0;
    frame.origin.x = (320 - frame.size.width ) /2.0;
    self.hintsLabel.frame = frame;
    self.hintsLabel.layer.cornerRadius = frame.size.height/ 2.0;
    self.hintsLabel.text = @"正在实时对讲";
    [self.hintsView addSubview:self.hintsLabel];
    
    //提示  - 友好描述
    frame = self.hintsView.frame;
    frame.size.height  =  14;
    frame.origin.y = self.hintsLabel.frame.origin.y + self.hintsLabel.frame.size.height + 5.0;
    UILabel* friendlyDescriptionLabel  = [[UILabel alloc] init];
    friendlyDescriptionLabel.text = @"轻触此处回到实时对讲";
    friendlyDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    friendlyDescriptionLabel.frame = frame;
    friendlyDescriptionLabel.backgroundColor = [UIColor clearColor];
    friendlyDescriptionLabel.font = [UIFont boldSystemFontOfSize:11];
    friendlyDescriptionLabel.textColor = UIColorFromRGB(0xA79E98);
    [self.hintsView addSubview:friendlyDescriptionLabel];
    
    
    //提示  -  示意剪头
    frame.size = CGSizeMake(19, 19);
    frame.origin.x = 320 - frame.size.width - mobileImageView.frame.origin.x;
    frame.origin.y =  (self.hintsView.frame.size.height - frame.size.height)/2.0;
    UIImageView* arrowImageView = [[UIImageView alloc] init];
    arrowImageView.backgroundColor = [UIColor clearColor];
    arrowImageView.image = [UIImage imageNamed:@"g_arrow_right"];
    arrowImageView.frame = frame;
    arrowImageView.layer.cornerRadius = frame.size.width/2.0;
    [self.hintsView addSubview:arrowImageView];
    
    
    //提示 - 点击Button
 
    UIButton* hintsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hintsButton.frame = hintsBackGroundImageView.frame;
    hintsButton.backgroundColor = [UIColor clearColor];
    hintsButton.tag = LPDialogVCTagForHintsButton;
    [hintsButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.hintsView addSubview:hintsButton];

}

#pragma mark - define

-(void)updateView
{
    self.title = ( _familyMember != nil ? self.familyMember.userNickname : self.group.groupName );
    [self.mytableView reloadData];
}

//获取消息数据 --junyi.zhu debug
-(BOOL)getMoreHistoryMessageRecord
{
    BOOL success = NO;
    NSDate *historyDate = [NSDate date];
    //表示有数据，这历史数据获取，应该以第一条数据查询
    if ([self.data_array count] > 0) {
        EMEDialogEntity* oldestMessage = [self.data_array  objectAtIndex:0];
         historyDate = oldestMessage.time;
    }
    
    NSArray* temp_array = [self getlatestDialogEntitiesWithLimitTime:historyDate
                                                  LimitRecordsNumber:10
                                                  WithToUidOrGroupId:(_isGroupDialog ? self.group.groupId : self.familyMember.userId)
                                                             isGroup:_isGroupDialog];
    if (temp_array) {
        
        success = YES;
        
        
        for (NSInteger i = 0 ; i<[temp_array count]; i++) {
            EMEDialogEntity* tempDialogEntity = [temp_array objectAtIndex:i];
                       
            [self.data_array insertObject:tempDialogEntity atIndex:0];
            
            if ([historyDate timeIntervalSince1970] - [tempDialogEntity.time  timeIntervalSince1970] > SplitTimeSpan) {
                EMEDialogEntity* timeDialogEN = [[EMEDialogEntity alloc] init];
                [timeDialogEN setAttributeWithMessageId:nil
                                                FromUid:nil
                                                  ToUid:nil
                                            MessageType:MessageTypeForSystemNotic
                                          MessageStatus:MessageStatusForSendSuccess
                                                Content:[CommonUtils DateConvertToFriendlyStringWithDate:tempDialogEntity.time]
                                                   Time:tempDialogEntity.time];
                
                [self.data_array insertObject:timeDialogEN atIndex:0];
                
            }
            historyDate = tempDialogEntity.time;

        }
      
    }
    
    NIF_ALLINFO(@"dataArray: %@ DateTime:%@",self.data_array,historyDate);
    return  success;
}




-(void)sendRequestFriendInfo
{
//    if (!_isGroupDialog) {//如果不是群消息的话，并且个人对个人的聊天中个人信息不全，则需要自动去获取一次个人信息
//        if ( !self.familyMember.userHeadURL  || !self.familyMember.userNickname ) {
//            sleep(0.3);
//            [EMELPFamilyHttpRquestManager shareInstance].delegate = self;
//            [[EMELPFamilyHttpRquestManager shareInstance] getFriendInfoWithLoginUserId:[UserManager shareInstance].user.userId
//                                                                          FriendUserId:self.familyMember.userId];
//        }
//    }else{
//        if (!self.group.groupHeadURL || !self.group.groupName || !self.group.groupMembersIDArray || [self.group.groupMembersIDArray count]==0 ) {
//            sleep(0.5);
//            [EMELPFamilyHttpRquestManager  shareInstance].delegate = self;
//            [[EMELPFamilyHttpRquestManager shareInstance] getGroupInfoWithGroupId:self.group.groupId];
//        }
//    
//    }
}




-(void)sendText
{
    
    if ([_inputTextView.text isEqualToString:@""]||_inputTextView.text==nil) {
        return;
    }
    if (![self checkNetWorkStatus]) {
        return;
    }
    
    // [self.inputTextView resignFirstResponder];
    
    EMEDialogEntity* dialogEntity = [[EMEDialogEntity alloc] init];
    
    [dialogEntity setAttributeWithMessageId:[StringUtils getUUID]
                                    FromUid:[NSString stringWithFormat:@"%@",[UserManager shareInstance].user.userId]
//                                      ToUid:[NSString stringWithFormat:@"%@",[UserManager shareInstance].user.userId]
                                      ToUid:[NSString stringWithFormat:@"%@",self.familyMember.userId]
                                MessageType:MessageTypeForSystemMessage
                              MessageStatus:MessageStatusForSending
                                    Content:self.inputTextView.text
                                       Time:[NSDate date]];
    //存到数据库
    [self insertDialogEntityWithWithObject:dialogEntity];

    [self insertRecentContactsEntityWithContactUid:[NSString stringWithFormat:@"%@",self.familyMember.userId]
                                 ContactFromSource: @"来自LP家族"
                                   ContactNickName:self.familyMember.userNickname
                                    ContactHeadUrl:self.familyMember.userHeadURL
                                      DialogEntity:dialogEntity];

    
    
    [self updateTableViewWithDialogEntity:dialogEntity isNewMessage:YES];
    
    Message* message = [self messageTransformWithDialogEntity:dialogEntity];
    message.commandId = _isGroupDialog ? COMMAND_SEND_P2G_MESSAGE : COMMAND_SEND_P2P_MESSAGE ;
    
    [[EMELPSocketManager shareInstance] sendMessage:message ];
    
    //消息通知
//   [CommonUtils localNotificationSendWithBody:@"body" SoundName:nil Info:nil];
    
    NIF_INFO(@"message: %@",[self messageTransformWithDialogEntity:dialogEntity]);
    //清理数据
     self.inputTextView.text = @"";
}

-(BOOL)checkNetWorkStatus
{
    if (![NetWorkWatchDogManager  isConnectNetWork]) {
        [CommonUtils AlertWithMsg:@"网络连接失败，请检查你的网络。"];
        return NO;
    }else if (![[EMELPSocketManager shareInstance]  isSocketConnect]){
       [[EMELPSocketManager shareInstance]  reStartSocketConnect];//断开连接之后，系统会自动重新尝试连接
        [self.view addHUDActivityViewWithHintsText:@"正在连接服务端..." hideAfterDelay:1.5];
         return NO;
    }else{
        return YES;
    }
}


-(void)sendAudio{

    if (![self checkNetWorkStatus]) {
        return;
    }
    
    EMEDialogEntity* dialogEntity = [[EMEDialogEntity alloc] init];
    
    [dialogEntity setAttributeWithMessageId:[StringUtils getUUID]
                                    FromUid:[UserManager shareInstance].user.userId
                                      ToUid:(_isGroupDialog ? [StringUtils getEmptyUUID] : self.familyMember.userId)
                                MessageType:MessageTypeForSoundFragment
                              MessageStatus:MessageStatusForSending
                                    Content:nil
                                       Time:[NSDate date]];
    
    NIF_ALLINFO(@"AudioRecordTempFileName :%@",AudioRecordTempFileName);
    
    Message* message = [self messageTransformWithDialogEntity:dialogEntity];
    message.commandId = _isGroupDialog ? COMMAND_SEND_P2G_MESSAGE : COMMAND_SEND_P2P_MESSAGE ;
    
     BOOL isHaveFile = [[EMELPSocketManager shareInstance] sendAudioMessage:message
                                               AudioName:@"AudioRecordTempFileName"];
    if (isHaveFile) {
        [self updateTableViewWithDialogEntity:dialogEntity isNewMessage:YES];
    }else{
        [self.view addHUDActivityViewWithHintsText:@"录音太短" hideAfterDelay:1.5];
      }

}
-(void)buttonOnclock:(UIButton*)button{
    
    if ([self.inputTextView isFirstResponder]) {
        _isShow = YES;
    }
    else
    {
        _isShow = NO;
    }
    
    if (!_isShow) {
        [self.inputTextView becomeFirstResponder];
        _isShow = YES;
    }
    else{
        [self.inputTextView resignFirstResponder];
        _isShow = NO;
    }
}


-(void)buttonClickDown:(UIButton*)button
{
    NIF_ALLINFO(@"开始说话");
    //开始录音
    if (button.tag == LPDialogVCTagForSoundButton) {
      isCanRecord = [_audioManager startRecord];
    }
    
}
-(void)buttonClickUP:(UIButton*)button
{
    NIF_ALLINFO(@"结束说话");

    //结束录音并发送
    if (button.tag == LPDialogVCTagForSoundButton) {
        if (isCanRecord) {
            [_audioManager stopRecord];
        }
        //当处理好录音的时候，自动发送录音
//        [self sendAudio];
    }
}

/**
 * button tag 规则
 * 1.  500+ 表示 选择其中的一个对话内容
 */
-(void)buttonClick:(UIButton*)button
{
    
    NIF_INFO(@"button click");

    if (button.tag>= 500) {//表示，点击到图片或者地图登信息
        NIF_INFO(@"选中内容");
    }else if(button.tag > 0){
        LPDialogVCTag ButtonTag = (LPDialogVCTag)button.tag;
        switch (ButtonTag) {
            case LPDialogVCTagForSendButton:
            {
                NIF_INFO(@"sendButton click :%@",self.inputTextView.text);
                [self sendText];
                break;
            }
                case LPDialogVCTagForSoundButton:
            {
               
                NIF_INFO(@"点击了录音");

                break;
            }
                case LPDialogVCTagForVoiceButton:
            {
                NIF_INFO(@"点击了语音聊天");
             
                [self gotoVoicVC];

                break;
            }
                case LPDialogVCTagForSwithButton:
            {
                NIF_INFO(@"点击了切换");

                _soundButton.hidden = !_soundButton.hidden;
                _sendButton.hidden = !_sendButton.hidden;
                _inputTextView.hidden = !_inputTextView.hidden;
                if (!_inputTextView.hidden) {
                    [self.inputTextView becomeFirstResponder];
                    [_swithButton  setImageWithImageName:@"lp07_macrophone_icon"];
                }else{
                    [self.inputTextView resignFirstResponder];
                    [_swithButton  setImageWithImageName:@"lp07_keyboard_icon"];
                }
                break;
            }
                case LPDialogVCTagForHintsButton:
            {
                NIF_INFO(@"点击回到聊天页面");
                [self gotoVoicVC];
                break;
            }
            default:
                break;
        }
        
    }
}


-(void)gotoVoicVC
{
    if (![self checkNetWorkStatus]) {
        return;
    }
    
    [_audioManager stopPlayOnline];
    
//    EMELPVoiceVC* voiceVC = [[EMELPVoiceVC alloc] init];
//    [voiceVC setAttrbuteWithLPFamily:self.familyMember];
//    //如果处于实时对讲状态，则不需要再次发送邀请
//    voiceVC.isAccessTalk = [[UserManager shareInstance] isOnUserStatusWithUserStatus:UserCurrentStatusForVoice];
//    voiceVC.isRecording = [[UserManager shareInstance] isOnUserStatusWithUserStatus:UserCurrentStatusForVoice];
//    [self.navigationController pushViewController:voiceVC animated:YES];

}



-(EMELPFamily*)getGroupMemeberFamilyWithUserId:(NSString*)userId
{
    for (EMELPFamily* tempLPF in self.group.groupMembersIDArray) {
        if ([tempLPF.userId  isEqualToString:userId]) {
            return tempLPF;
        }
    }
    return nil;
}


//切换到主线程中来做更新
-(void)updateTableViewOnMainThreadWithDic:(NSDictionary*)Dic //(EMEDialogEntity*)dialogEntity isNewMessage:(BOOL)isNewMessage
{
    EMEDialogEntity* dialogEntity = [Dic objectForKey:@"dialogEntity"];
    BOOL isNewMessage = [[Dic objectForKey:@"isNewMessage"] boolValue];
    
    BOOL isSameRecord = NO;
    NSInteger relaodRowIndex = [self.data_array count]-1;
    //服务端响应过来的数据 , 或者是不是同一条数据
    if ([_data_array count]>0 && !isNewMessage) {
        //倒序查询
        for (NSInteger i= [self.data_array count]-1 ; i>=0 ; i--) {
            EMEDialogEntity* dialogEn = [self.data_array objectAtIndex:i];
            if ([dialogEn.messageId  isEqualToString:dialogEntity.messageId]) {
                [dialogEn setAttributeWithMessageId:dialogEn.messageId
                                            FromUid:dialogEn.fromUid
                                              ToUid:dialogEn.toUid
                                        MessageType:dialogEn.type
                                      MessageStatus:dialogEntity.sendStatus
                                            Content:dialogEntity.type == MessageTypeForSoundFragment ? dialogEntity.content : dialogEn.content
                                               Time:dialogEntity.time];
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
            if ([dialogEntity.time timeIntervalSince1970] - [historyDialogEN.time  timeIntervalSince1970] > SplitTimeSpan) {
                EMEDialogEntity* timeDialogEN = [[EMEDialogEntity alloc] init];
                [timeDialogEN setAttributeWithMessageId:nil
                                                FromUid:nil
                                                  ToUid:nil
                                            MessageType:MessageTypeForSystemNotic
                                          MessageStatus:MessageStatusForSendSuccess
                                                Content:[CommonUtils DateConvertToFriendlyStringWithDate:dialogEntity.time]
                                                   Time:dialogEntity.time];
                
                [self.data_array addObject:timeDialogEN];
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:[self.data_array count]-1 inSection:0]];
                
            }
        }
        
        [_data_array addObject:dialogEntity];
        
        relaodRowIndex = [self.data_array count]-1;
    }
    
    
    
    
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:relaodRowIndex inSection:0]];
    
    
    if (isSameRecord && !isNewMessage) {
        
        [self.mytableView reloadRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        
        
        [self.mytableView beginUpdates];
        [self.mytableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
        [self.mytableView endUpdates];
        
    }
    
    
    [self.mytableView scrollToRowAtIndexPath:[indexPathsToInsert lastObject] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
}

-(void)updateTableViewWithDialogEntity:(EMEDialogEntity*)dialogEntity isNewMessage:(BOOL)isNewMessage
{
    
    NSThread *currentThread = [NSThread currentThread];
    NSDictionary*  messageDic = [NSDictionary dictionaryWithObjectsAndKeys:dialogEntity,@"dialogEntity",[NSNumber numberWithBool:isNewMessage],@"isNewMessage", nil];
    
    if ([currentThread isMainThread]) {
        [self updateTableViewOnMainThreadWithDic:messageDic];
    }else{
        [self performSelectorOnMainThread:@selector(updateTableViewOnMainThreadWithDic:) withObject:messageDic waitUntilDone:NO];
    }
    
    
}

-(void)removeVoiceStatusAndUpdateView
{
    [[UserManager shareInstance] removeUserStatusWithUserStatus:UserCurrentStatusForVoice];
    [self.mytableView reloadData];
}


 
#pragma mark - 触摸事件

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputTextView resignFirstResponder];
}


#pragma mark - socekt  发送状态

-(void)HandleResponseWithNotic:(NSNotification*)notifiction
{
    Message* responseMessage = (Message*)notifiction.object;
    
    if ((responseMessage.commandId == COMMAND_SEND_P2G_MESSAGE && !_isGroupDialog) ||
        (responseMessage.commandId == COMMAND_SEND_P2P_MESSAGE && _isGroupDialog)
        ) {
        NIF_ALLINFO(@"当前消息类型不对应，即群组消息，对应个人对话中， 或者是个人消息，对应道群组消息中 :%@",responseMessage);
        return ;
    }
    if ([self.familyMember.userId intValue] != [responseMessage.from intValue]) {//junyi.zhu debug 判断
        return;
    }
    
    
    if (responseMessage.direction == MSG_DIRECTION_SERVER_TO_CLIENT) {
        responseMessage.status = MSG_STATUS_DELIVERED;
    }
    
    
    NIF_ALLINFO(@"responseMessage:%@",responseMessage);
    [self updateTableViewWithDialogEntity:[self DialogEntityTransformWithMessage:responseMessage] isNewMessage:NO];

}



-(void)HandleResponseWithNoticStopVoice:(NSNotification*)notifiction
{
    [self removeVoiceStatusAndUpdateView];
    
}
-(void)HandleResponseWithNoticExceptionVoice:(NSNotification*)notifiction
{
    [self removeVoiceStatusAndUpdateView];

}

-(void)HandleResponseWithNoticFriendNotOnlineVoice:(NSNotification*)notifiction
{
    [self removeVoiceStatusAndUpdateView];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMEDialogEntity* dialogEn = [self.data_array objectAtIndex:indexPath.row];
    return [EMELPMessageCell getNeedHeightWithDialogEn:dialogEn];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data_array count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *whichSection = @"message_table_view_cell";
	EMELPMessageCell *cell = (EMELPMessageCell*)[tableView dequeueReusableCellWithIdentifier:whichSection];
    if (cell == nil) {
        cell = [[EMELPMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:whichSection];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    

    
    EMEDialogEntity* dialogEn = [self.data_array objectAtIndex:indexPath.row];
    EMELPFamily* tempLPF = (_isGroupDialog? [self getGroupMemeberFamilyWithUserId:dialogEn.fromUid] : self.familyMember );
    
  
    
    [cell setAttributeWithDialogEntity:dialogEn
                              Delegate:self
                      SelfHeadImageURL:[UserManager shareInstance].user.userHeadURL
                    FirendHeadImageURL:tempLPF.userHeadURL];
    
    return cell;
    
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[UserManager shareInstance] isOnUserStatusWithUserStatus:UserCurrentStatusForVoice]) {
        return self.hintsView.frame.size.height;
    }else{
        return 10.0 ;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[UserManager shareInstance] isOnUserStatusWithUserStatus:UserCurrentStatusForVoice]) {
        return self.hintsView;
    }else{
        UIView* temp_view = [[UIView alloc] init];
        temp_view.backgroundColor = [UIColor clearColor];
        return temp_view;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* temp_view = [[UIView alloc] init];
    temp_view.backgroundColor = [UIColor clearColor];
    return temp_view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIF_INFO(@"cell selected：%ld",(long)indexPath.row);
    //    [self handleSelecedWithIndex:indexPath.row];
    
}

#pragma mark  - EMELPMessageCellDelegate


-(void)EMELPMessageCellHeaderClick:(EMELPMessageCell*)messageCell
{
    NIF_INFO(@"点击了头像");
}
-(void)EMELPMessageCellContentClick:(EMELPMessageCell *)messageCell
{
    NIF_INFO(@"点击了内容:%@",messageCell.dialogEN.content);
    if (messageCell.dialogEN.type == MessageTypeForSoundFragment) {
//        messageCell.isCanClickContent = NO;
        [_audioManager playOnlineAudio:messageCell.dialogEN.content AudioCacheName:messageCell.dialogEN.messageId];
    }
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NIF_INFO(@"%lf",textView.contentOffset.y);
    if ([@"\n" isEqualToString:text] == YES) {
        NIF_INFO(@"键盘中的发送按钮");
        [self sendText];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [textView setNeedsDisplay];//重新自动布局
}


#pragma mark - 键盘显示，消失通知 ／／未完成
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyBoardBounds= [[userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [self viewToUp:-keyBoardBounds.size.height];
    NIF_INFO(@"userinfo:%@",userInfo);
    NIF_INFO(@"%@",self.view);
    
}
-(void)keyboardWillHidden:(NSNotification *)notification
{
    [self ViewToDown];
    NIF_INFO(@" %@",self.view);
    //    NSTimeInterval animationTime = [[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
}

#pragma mark -   UITableViewTouchDelegate

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event
{
    if (self.inputTextView.isFirstResponder) {
        [self.inputTextView resignFirstResponder];
        [self ViewToDown];
    }

}

#pragma mark - 解决键盘输入挡住输入框问题

-(void)viewToUp:(CGFloat)VIEW_UP{
	
    [self updateContenPanelViewUp:VIEW_UP];


	NSTimeInterval animationDuration = 0.30f;
	[UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
	[UIView setAnimationDuration:animationDuration];
 
    
//	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
    
		CGRect rect = CGRectMake(0.0f,VIEW_UP,self.contentPanelView.frame.size.width,self.contentPanelView.frame.size.height);
 		self.contentPanelView.frame = rect;
    
		[UIView commitAnimations];
    
//	}else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
//		CGRect rect = CGRectMake(0.0f,VIEW_UP*1.1,width,height);
//        self.view.frame = rect;
//		[UIView commitAnimations];
//	}
	
}

-(void)updateContenPanelViewUp:(CGFloat)viewUp
{

    __weak EMELPDialogVC* weakSelf = (EMELPDialogVC *)self;
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        NIF_ALLINFO(@"不执行任何动画");

        
    } completion:^(BOOL finished) {
   
        CGRect frame = weakSelf.mytableView.frame ;
        frame.size.height =  (weakSelf.contentPanelView.frame.size.height  - weakSelf.buttom_view.frame.size.height) + viewUp;
        frame.origin.y = -viewUp;
    
        
        weakSelf.mytableView.frame = frame;
        
        if ([weakSelf.data_array count] > 0) {
            [weakSelf.mytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.data_array count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    
    }];

   
 
    
}

-(void)ViewToDown{
    

    
	NSTimeInterval animationDuration = 0.30f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
    
    
	CGRect rect = CGRectMake(0.0f, 0.0, self.contentPanelView.frame.size.width, self.contentPanelView.frame.size.height);
	self.contentPanelView.frame = rect;
    
 
    [UIView commitAnimations];
    
    [self updateContenPanelViewUp:0.0];

    
}

//#pragma mark - EMEBaseDataManagerDelegate
//
//- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection;
//{
//    NIF_ALLINFO(@"响应:%@",dic);
//    if ([[dic objectForKey:@"status"] integerValue] == 0) {
//        
//         if (!dic ||  ![dic isKindOfClass:[NSDictionary class]] || [dic count]<=0) {
//            NIF_ERROR(@"数据返回错误");
//            return;
//        }
//        NSDictionary* contentDic = [dic objectForKey:@"content"];
//        if (!contentDic || ![dic isKindOfClass:[NSDictionary class]]  || [contentDic count]<=0) {
//            NIF_ERROR(@"数据返回错误");
//            return;
//        }
//    
//    
//    if (connection.connectionTag == LPFamilyHttpRquestTagForGetFriendInfo) {
//        
//        
//#warning 需要获取头像信息
////            NIF_INFO(@"%@",[CommonUtils StringConvertToDateWithString:[contentDic objectForKey:@"createtime"] DateFormatter:@"yyyy年MM月dd日"]);
//            [self.familyMember setAttributeWithUserId:[contentDic objectForKey:@"userid"]
//                                             UserName:[contentDic objectForKey:@"loginid"]
//                                         UserNickName:[contentDic objectForKey:@"name"]
//                                          UserHeadURL:[contentDic objectForKey:@"imgpath"]
//                                              UserSex:(UserSexType)[[contentDic objectForKey:@"sex"] integerValue]
//                                          UserAddress:[contentDic objectForKey:@"area"]
//                                        UserSignature:[contentDic objectForKey:@"label"]
//                                         UserTeamName:[contentDic objectForKey:@"team"]
//                                         UserIndustry:[contentDic objectForKey:@"job"]
//                                          UserJobName:[contentDic objectForKey:@"title"]
//                                     UserRegisterDate:nil //[CommonUtils StringConvertToDateWithString:[contentDic objectForKey:@"createtime"] DateFormatter:@"yyyy年MM月dd日"]
//                                       UserAlbumArray:nil
//                                             isOnline:NO
//                                           FriendType:(FriendType)[[contentDic objectForKey:@"type"] integerValue]];
//            
//            [self updateView];
//        }else if(connection.connectionTag == LPFamilyHttpRquestTagForGetGroupInfo){
//            
//            [self.group.groupMembersIDArray removeAllObjects];
//            
//            NSArray* tempArray = [dic valueForKeyPath:@"content.items"];
//            if (!tempArray) {
//                return;
//            }
//            for (NSDictionary* tempDic in tempArray) {
//                EMELPFamily* LPF = [[EMELPFamily alloc] init];
//                [LPF setAttributeWithUserId:[tempDic objectForKey:@"userid"]
//                                   UserName:nil
//                               UserNickName:[tempDic objectForKey:@"username"]
//                                UserHeadURL:[tempDic objectForKey:@"imgpath"]
//                                    UserSex:UserSexTypeForNone
//                                UserAddress:nil
//                              UserSignature:nil
//                               UserTeamName:nil
//                               UserIndustry:nil
//                                UserJobName:nil
//                           UserRegisterDate:nil
//                             UserAlbumArray:nil
//                                   isOnline:NO
//                                 FriendType:FriendTypeForOther];
//                [self.group.groupMembersIDArray addObject:LPF];
//            }
//            self.group.groupName =  [dic valueForKeyPath:@"content.name"];
//            self.group.groupInfo =  [dic valueForKeyPath:@"content.label"];
//            
//            self.titleLabel.text = self.group.groupName;
//            
//            [self updateView];
//
//    }
//    }else{
//    
//        NIF_ALLINFO(@"数据响应错误");
//    }
//
//}
//- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
//{
//
//}
//

//#pragma mark　－ Nav Back 重写
//-(void)homeBtnHandle
//{
//    BOOL isBackLPFamily = NO;
//    if (self.needPopToViewControllerClass) {
//        for (UIViewController* tempVC in [self.navigationController viewControllers]) {
//            if ([tempVC isKindOfClass:self.needPopToViewControllerClass]) {
//                
//                isBackLPFamily = YES;
//                [self.navigationController popToViewController:tempVC animated:YES];
//                break;
//            }
//        }
//    }
//    
//    if (!isBackLPFamily) {
//        [super homeBtnHandle];
//    }
//  
//    
//    
//}

#pragma mark - AudioManagerDelegate
-(void) onRecorderFinished {
    [self sendAudio];
    NIF_ALLINFO(@"onRecordVoiceFinished...");
}

 -(void) onRecorderErrorWithErrorInfo:(NSDictionary*)errorInfo
{
//    [CommonUtils AlertWithMsg:@"录音失败，请重试"];
}


-(void) startPlaying
{
    NIF_ALLINFO(@"开始播放语音留言");
}
-(void) onPlayFinished
{
    NIF_ALLINFO(@"语音留言播放结束");

}
-(void) onPlayErrorWithErrorInfo:(NSDictionary*)errorInfo
{
    NIF_ALLINFO(@"语音留言播放出错");
    [CommonUtils AlertWithMsg:@"语音播放出错，请重试"];

}





#pragma mark - getter

-(UITableView*)mytableView
{
    if (nil == _mytableView) {
        _mytableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0.0,50.0,480,340) style:UITableViewStylePlain];
        _mytableView.delegate=self;
        _mytableView.dataSource=self;
        _mytableView.touchDelegate = self;
        _mytableView.scrollEnabled=YES;
        _mytableView.backgroundColor = [UIColor clearColor];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mytableView;
}

-(UIView*)buttom_view
{
    if (nil == _buttom_view) {
        _buttom_view = [[UIView alloc] init];
        _buttom_view.backgroundColor = UIColorFromRGB(0xE1DCD6);
        _buttom_view.layer.shadowColor = [[UIColor blackColor] CGColor];
        _buttom_view.layer.shadowOpacity = 0.3;
        _buttom_view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    }
    return _buttom_view;
}

//-(UITextView*)inputTextView
//{
//    if (nil == _inputTextView) {
//        _inputTextView = [[UITextView alloc] init];
//        _inputTextView.layer.masksToBounds = YES;
//        _inputTextView.layer.cornerRadius = 3.0;
//        _inputTextView.font = [UIFont systemFontOfSize:14.0];
//        _inputTextView.returnKeyType = UIReturnKeySend;
//        _inputTextView.delegate = self;
//    }
//    return  _inputTextView;
//}
//[alertProgress dismissWithClickedButtonIndex:0 animated:YES];

-(UIView*)hintsView
{
    if (nil == _hintsView) {
        _hintsView = [[UIView alloc] init];
        _hintsView.backgroundColor = [UIColor clearColor];
    }
    return _hintsView;
}

-(UILabel*)hintsLabel
{
    if (nil == _hintsLabel) {
        _hintsLabel = [[UILabel alloc] init];
        _hintsLabel.backgroundColor = UIColorFromRGB(0xC6BFB9);
        _hintsLabel.textColor = [UIColor whiteColor];
        _hintsLabel.font = [UIFont boldSystemFontOfSize:12];
        _hintsLabel.textAlignment = NSTextAlignmentCenter;
     }
    return _hintsLabel;
}
@end
