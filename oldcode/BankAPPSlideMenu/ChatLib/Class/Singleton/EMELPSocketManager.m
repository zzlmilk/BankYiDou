//
//  EMELPSocketManager.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-19.
//  Copyright (c) 2013年 YXW. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EMELPSocketManager.h"
#import "NSObject+CoreDataExchange.h"
#import "NSObject+Message_Dialog.h"

#import "PathUtils.h"
#import "StringUtils.h"

#import "MessageCodec.h"
#import "objc/runtime.h"
#import "ChatViewController.h"
#import "EMELPFamily.h"

//#import "EMEViewController.h"
//#import "EMELPFamilyHttpRquestManager.h"
//#import "RecorderManager.h"
//#import "EMELPVoiceVC.h"

//#import "AppDelegate.h"

static NSString*  AlertInfoKey = @"AlertInfoKey";

typedef  enum SocketAlertTag{
    EMELPSocketManagerTagForOtherPlaceLoginAlert = 100,
    EMELPSocketManagerTagForInviteTalkAlert,
    EMELPSocketManagerTagForStopTalkAlert,
    EMELPSocketManagerTagForExceptionTalkAlert,
    EMELPSocketManagerTagForGetAMessageAlert,

    EMELPSocketManagerTagForAddFriendRequest, //收到一个加好友请求
    EMELPSocketManagerTagForRejectFriendRequest, //收到一个拒绝成为好友请求
    EMELPSocketManagerTagForRemoveFriendRequest, //收到一个被删除请求好友请求
    
    EMELPSocketManagerTagForGroupMemberQuiteGroupRequest, //收到群成员退出消息请求
    EMELPSocketManagerTagForExceptionTalkBusy,

} EMELPSocketManagerTag;

static EMELPSocketManager*  s_socketManager = nil;

@interface EMELPSocketManager ()<MessageHandlerDelegate,UIAlertViewDelegate>

@end

@implementation EMELPSocketManager

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _socketConn.delegate = nil;
}

-(id)init
{
    self = [super init];
    if (self) {
        _socketConn = [SocketConn shareInstanceWithMessageHandlerDelegate:self];
        //socket 连接状态处理
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(socketConnectStatusChanged:)
                                                     name:ChatSocketConnectStatusNotice
                                                   object:nil];
        _socketMessage = [[Message alloc] init];
    }
    return self;
}

+(EMELPSocketManager*)shareInstance
{
    @synchronized(self){
        
        if (s_socketManager == nil) {
            s_socketManager =  [[self alloc] init];
        }
    }
    
     return s_socketManager;
}


+(void)destroyInstance
{
    if (nil != s_socketManager) {
    
        [s_socketManager checkVoiceStatusAndAutoStopVoice];
        
        //不能留在实时对讲页面
//        EMEAppDelegate* appDelegate = (EMEAppDelegate*)[UIApplication sharedApplication].delegate;
//        if ([[appDelegate visibleViewController] isKindOfClass:[EMELPVoiceVC class]]) {
//            [((UIViewController*)[appDelegate visibleViewController]).navigationController  popViewControllerAnimated:NO];
//        }
        [s_socketManager stopSocketConnect];
        s_socketManager = nil;
    }
}




#pragma mark - define
-(void)checkVoiceStatusAndAutoStopVoice
{
//    /*
//     * 编写实时对讲后台运行 或者退出程序时兼容
//     */
//    if ([[UserManager shareInstance] isOnUserStatusWithUserStatus:UserCurrentStatusForVoice] && [UserManager shareInstance].userContactUserId) { //正在实时对讲
//        [[UserManager shareInstance] removeUserStatusWithUserStatus:UserCurrentStatusForVoice];
//
//        [[RecorderManager sharedManager] stopRecording];
//        [s_socketManager  endFriendTalkWithLoginUserId:CurrentUserIsLogin
//                                          friendUserId:[UserManager shareInstance].userContactUserId];
//        
//        sleep(1);
//    }
}

/*!
 *@abstract 判断是否正在录音
 @discusssion 如果没有在录音，则自动进行清理动作
 */
-(BOOL)isOnRecording
{
//    if ([RecorderManager sharedManager].isRecording) {
//        return YES;
//    }else{
//        [[UserManager shareInstance] removeUserStatusWithUserStatus:UserCurrentStatusForVoice];
        return NO;
//    }
}

#pragma mark 操作网络连接

/*!
 *@abstract 获取socket 的连接状态
 */
-(BOOL)isSocketConnect
{
   return  [self.socketConn isConnected];
}
/*!
 *@abstract    开始建立socekt 连接
 *@discussion  这里，如果socket已经建立连接，系统不会再次去连接，而是直接任务建立已经建立了
 */
-(BOOL)startSocketConnect
{
    
  return  [self.socketConn connect];
}
/*!
 *@abstract 停止socket 连接
 *@discussion 不建议手动调用改方法，   因为断开socket 连接的时候networkDog 会自动去尝试连接，并自动登录
 */
-(void)stopSocketConnect
{
    [self.socketConn disconnect];
}

/*!
 *@abstract 重新建立socket 连接
 *@discussion 不建议调用该方法， 因为断线的时候会自动netwathDog 会自动的去重新连接，并且尝试重新登录
 */
-(void)reStartSocketConnect
{
    if ([self isSocketConnect]) {
        [self stopSocketConnect];
    }
    
    [self startSocketConnect];
}

#pragma mark - 网络连接维续

/*!
 *@abstract 自动连接socket
 *@discussion  自动连接socket，是通过判断用户信息是否存在，如果存在则自动连接socket 并使用socket 自动注册(connect 方法中已经包含了自动注册聊天服务器)，
 注意： 1. 登录完成之后需要通知Socket自动连接,
 2. 注销的时候，也需通知socket断开socket 连接
 
 使用场景： 登录、注册、背景切换道前台、以及网络变化的时候调用
 */
-(BOOL)autoConnectSocket
{
    BOOL isSuccess = NO;
    if ([[UserManager shareInstance] can_auto_login]) {
        if (![self isSocketConnect]) {
            isSuccess = [self startSocketConnect];
            
        }else{
            isSuccess = YES;
        }
    }
    return isSuccess;
}

/*
 @abstract   注册道Socket服务器端
 @discussion 当建立好Socket连接的时候需要向服务端提交身份信息进行一次注册
 */
-(void)registerToSocketServer
{
    if ([[UserManager shareInstance] can_auto_login]) {
        if (![self isSocketConnect]) {
            [self startSocketConnect];
        }else{
            [self.socketConn registration];
        }
        
    }
    
}

#pragma -  消息发送接口

-(void)sendMessage:(Message*)message
{
    BOOL isSocketConn = NO;
    if (![self isSocketConnect]) {
        if ([self startSocketConnect]) {
            isSocketConn = YES;
        }
    }else{
        isSocketConn = YES;
    }
    
    if (isSocketConn) {
        message.direction = MSG_DIRECTION_CLIENT_TO_SERVER;

//            message.to = targetId;

        
        [self.socketConn sendMessage:[MessageCodec encode:(message == nil ? self.socketMessage : message ) :0]];
    }
    
}

/*!
@abstract 发送语音
@discussion 注意audioName 不能包含文件后缀, 并且Message.content 字段为nil
@param  audioMessage  message消息，注意content属性被忽略
@param   audioName   录音存储的临时文件名字，不是路径，并且不包含后缀
*/
-(BOOL)sendAudioMessage:(Message*)audioMessage AudioName:(NSString*)audioName
{
    NSString* path= [[PathUtils getAudioDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",audioName]];
    NIF_ALLINFO(@"path :%@",path);
    if (path && [[NSFileManager defaultManager] isReadableFileAtPath:path]) {
        
        NSMutableData *audioData  = [NSMutableData dataWithContentsOfFile:path];
        if (!audioData  ||  [audioData length] < 10) {
            NIF_ALLINFO("语音留言太短了");
            return NO;
        }
        Message* message = audioMessage;
//        message.commandId = COMMAND_SEND_P2P_MESSAGE;
        message.direction = MSG_DIRECTION_CLIENT_TO_SERVER;
        message.type =  MSG_TYPE_VOICE;
        message.contents  = audioData;
        message.error =  ERROR_UNKNOWN;
        message.status =  MSG_STATUS_SENDING;
        NSMutableData* data = [MessageCodec encode :message :0];

        [self.socketConn  sendMessage:data];
        
        return YES;
    } else {
        NIF_ALLINFO(@"file does not exist. :%@",path);
        return NO;
    }

}

#pragma mark - Socket 接口

-(Message*)addFriendRequestWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId
                                   Content:(NSString*)content
{
    Message* temp_message = [[Message alloc] init];
    [temp_message setAttributesWithMsgId:nil
                                    FromUserId:loginUserId
                                      ToUserId:friendUserId
                                Contents:content ? [content dataUsingEncoding:NSUTF8StringEncoding] : nil
                                   CommandType:COMMAND_SEND_ADD_FRIEND_REQUEST
                                   MessageType:MSG_TYPE_TEXT
                                 MessageStatus:MSG_STATUS_UNKNOWN
                              MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
                                     ErrorType:ERROR_UNKNOWN
                                     EventDate:[NSDate date]];
    [self sendMessage:temp_message ];
    return temp_message;
}

-(Message*)logoutRequestWithLoginUserId:(NSString*)loginUserId
{

    Message* temp_message = [[Message alloc] init];
    [temp_message setAttributesWithMsgId:nil
                              FromUserId:loginUserId
                                ToUserId:nil
                                Contents:nil
                             CommandType:COMMAND_DISCONNECT
                             MessageType:MSG_TYPE_TEXT
                           MessageStatus:MSG_STATUS_UNKNOWN
                        MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
                               ErrorType:ERROR_UNKNOWN
                               EventDate:[NSDate date]];
    [self sendMessage:temp_message ];
    return temp_message;
}

#pragma mark - 实时对讲
/*
 @abstract 邀请朋友进行实时对讲通话
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)inviteFriendTalkWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId
{
    Message* temp_message = [[Message alloc] init];
    [temp_message setAttributesWithMsgId:nil
                              FromUserId:loginUserId
                                ToUserId:friendUserId
                                Contents:nil
                             CommandType:COMMAND_INVITE_TALK
                             MessageType:MSG_TYPE_TEXT
                           MessageStatus:MSG_STATUS_UNKNOWN
                        MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
                               ErrorType:ERROR_UNKNOWN
                               EventDate:[NSDate date]];
    [self sendMessage:temp_message];
    return temp_message;

}

/*
 @abstract 同意进行实时对讲通话
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)acceptFriendTalkWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId
{
    Message* temp_message = [[Message alloc] init];
    [temp_message setAttributesWithMsgId:nil
                              FromUserId:loginUserId
                                ToUserId:friendUserId
                                Contents:nil
                             CommandType:COMMAND_ACCEPT_TALK
                             MessageType:MSG_TYPE_TEXT
                           MessageStatus:MSG_STATUS_UNKNOWN
                        MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
                               ErrorType:ERROR_UNKNOWN
                               EventDate:[NSDate date]];
    [self sendMessage:temp_message];
    return temp_message;
}
/*
 @abstract 拒绝
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)rejectFriendTalkWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId
{
    Message* temp_message = [[Message alloc] init];
    [temp_message setAttributesWithMsgId:nil
                              FromUserId:loginUserId
                                ToUserId:friendUserId
                                Contents:nil
                             CommandType:COMMAND_REJECT_TALK
                             MessageType:MSG_TYPE_TEXT
                           MessageStatus:MSG_STATUS_UNKNOWN
                        MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
                               ErrorType:ERROR_UNKNOWN
                               EventDate:[NSDate date]];
    [self sendMessage:temp_message ];
    return temp_message;
}
///*
// @abstract 开始实时对讲通话
// @param loginUserId  登录用户ID
// @param friendUserId 邀请的好友id
// @result Message   放回整个Message 请求对象
// */
//-(Message*)startFriendTalkWithLoginUserId:(NSString*)loginUserId
//                             friendUserId:(NSString*)friendUserId
//{
//    Message* temp_message = [[Message alloc] init];
//    [temp_message setAttributesWithMsgId:nil
//                              FromUserId:loginUserId
//                                ToUserId:friendUserId
//                               ToGroupId:nil
//                                Contents:nil
//                             CommandType:COMMAND_TALK_START
//                             MessageType:MSG_TYPE_TEXT
//                           MessageStatus:MSG_STATUS_UNKNOWN
//                        MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
//                               ErrorType:ERROR_UNKNOWN
//                               EventDate:[NSDate date]];
//    [self sendMessage:temp_message];
//    return temp_message;
//}

/*
 @abstract 结束实时对讲通话
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)endFriendTalkWithLoginUserId:(NSString*)loginUserId
                           friendUserId:(NSString*)friendUserId
{
    Message* temp_message = [[Message alloc] init];
    [temp_message setAttributesWithMsgId:nil
                              FromUserId:loginUserId
                                ToUserId:friendUserId
                                Contents:nil
                             CommandType:COMMAND_TALK_END
                             MessageType:MSG_TYPE_TEXT
                           MessageStatus:MSG_STATUS_UNKNOWN
                        MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
                               ErrorType:ERROR_UNKNOWN
                               EventDate:[NSDate date]];
    [self sendMessage:temp_message ];
    return temp_message;
}
/*
 @abstract  实时对讲通话异常
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)exceptionFriendTalkWithLoginUserId:(NSString*)loginUserId
                                 friendUserId:(NSString*)friendUserId
{
    Message* temp_message = [[Message alloc] init];
    [temp_message setAttributesWithMsgId:nil
                              FromUserId:loginUserId
                                ToUserId:friendUserId
                                Contents:nil
                             CommandType:COMMAND_TALK_EXCEPTION
                             MessageType:MSG_TYPE_TEXT
                           MessageStatus:MSG_STATUS_UNKNOWN
                        MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
                               ErrorType:ERROR_UNKNOWN
                               EventDate:[NSDate date]];
    [self sendMessage:temp_message ];
    return temp_message;
}
/*
 @abstract  正在实时对讲中
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)busyInFriendTalkWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId
{
    Message* temp_message = [[Message alloc] init];
    [temp_message setAttributesWithMsgId:nil
                              FromUserId:loginUserId
                                ToUserId:friendUserId
                                Contents:nil
                             CommandType:COMMAND_TALK_BUSY
                             MessageType:MSG_TYPE_TEXT
                           MessageStatus:MSG_STATUS_UNKNOWN
                        MessageDirection:MSG_DIRECTION_CLIENT_TO_SERVER
                               ErrorType:ERROR_UNKNOWN
                               EventDate:[NSDate date]];
    [self sendMessage:temp_message ];
    return temp_message;

}
#pragma mark socket状态处理， 主要是处理连接成功、连接断开

//SocketStatus  = SocketStatusForConnectSuccess | SocketStatusForConnectCloseOrFail
-(void)socketConnectStatusChanged:(NSNotification*)notification
{
    NSDictionary* socketStatusDic = [notification object];
    SocketStatus socketConnectStatus = SocketStatusForConnectSuccess;
    if (socketStatusDic != nil) {
        socketConnectStatus = [[socketStatusDic objectForKey:@"SocketStatus"]  integerValue];
    }else{
        NIF_ALLINFO(@"socket 连接状态通知错误");
    }
    
//#warning 如果socket 连接失败,这里需要断开实时对讲语音
    if (socketConnectStatus == SocketStatusForConnectCloseOrFail) {
//        [[RecorderManager sharedManager] stopRecording];
    }

}

#pragma mark - MessageHandlerDelegate
- (void) addReceivedMessage: (Message *) message
{
    /**
     * 1  socket 连接相关的。比如心跳、注册链接、Socket连接异常等
     */
    if (message.uid==nil) {
        return;
    }
    
    message.uid = [NSString stringWithFormat:@"%@123",message.uid];
    
    if (message.commandId >= COMMAND_REGISTRATION && message.commandId < COMMAND_SEND_P2P_MESSAGE) {
        [self handleSocketConnectInfoWithMessage:message];
        return;
    }
 
    /**
     *2. 聊天消息、语音留言
     */
    else if (message.commandId >= COMMAND_SEND_P2P_MESSAGE  &&  message.commandId < COMMAND_GET_GROUP_LIST){
        [self handleDialogMessageWithMessage:message];
    }
    
    /**
     *4. 添加好友，退出群组等好友处理相关接口
     */
//    else if(message.commandId >= COMMAND_GET_GROUP_LIST && message.commandId < COMMAND_INVITE_TALK){
//        [self handleFriendRelationInterfaceMessageWithMessage:message];
//    }
//    
    /**
     *5. 实时对讲接口
     */
//    else if(message.commandId >= COMMAND_INVITE_TALK && message.commandId < 0x5000){
//        [self handleAudioMessageWithMessage:message];
//    }

    /**
     *6. 未知接口类型
     */
    else{
        NIF_ALLINFO(@"未能正常处理消息：%@",message);
    }
  
}

#pragma mark - 收到消息具体处理

-(void)handleSocketConnectInfoWithMessage:(Message*)message
{
    /**
     1.0 心跳包
         注意: 心跳是没有内容的数据，所以 message toId 和  groupId 都为空值
     */
    if (message.commandId == COMMAND_HEART_BEAT) {
        NIF_ALLINFO(@"收到心跳响应,如果注册信息失效的话,服务端会自动重新注册 :%@",message);
 
//        if (message.error == ERROR_USER_NOT_ONLINE) {
//            [self.socketConn registration];//表示自己未注册
//            }
        return;
    }
    
    //1.1 异常登录
    else if (message.commandId == COMMAND_DUPLICATE_REGISTRATION) {
        NIF_ALLINFO(@"收到异常登录消息，用户需要重新登录, 并清理密码, 发送loginOutNotice 会自停止网络狗程序 ");
 
        [UserManager shareInstance].user.userPassword = nil;
        [[UserManager shareInstance] update_to_disk];
    
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatLoginOutNotice object:nil];
        
        [self stopSocketConnect];

    
        UIAlertView* alertView = [CommonUtils AlertWithTitle:@"提示" Msg:@"账号已经在其他地方登录，请重新登录！" Delegate:self];
        alertView.tag = EMELPSocketManagerTagForOtherPlaceLoginAlert;
        
    }else{
        NIF_ALLINFO(@"忽略的socket 连接响应");
    }
    
}


-(void)handleDialogMessageWithMessage:(Message*)message
{
    if (message.type == MSG_TYPE_TEXT || message.type == MSG_TYPE_VOICE) {
        
        //2.1 存储道数据库
        EMEDialogEntity* dialog = [self DialogEntityTransformWithMessage:message];
        
        //如果是收到服务端响应，则需要进行数据的处理，除了语音留言需要处理响应的格式之外，其他的均不需要处理
        if (message.direction == MSG_DIRECTION_SERVER_TO_CLIENT) {
            //本地数据库中不需要响应的内容
            if ( message.type == MSG_TYPE_TEXT) {
//                dialog.content = nil;
            }
            dialog.sendStatus = MessageStatusForSendSuccess;
        }
        
        [self insertDialogEntityWithWithObject:dialog];
        [self insertRecentContactsEntityWithContactUid:nil
                                     ContactFromSource:nil
                                       ContactNickName:nil
                                        ContactHeadUrl:nil
                                          DialogEntity:dialog];
        
        //2.2 处理分发和提示
        //是否正在和对应的用户在对话, 响应也直接通知出去
        if ( message.direction == MSG_DIRECTION_SERVER_TO_CLIENT || //收到响应
            [[UserManager  shareInstance] isOnDialogVCWithUserId:message.from])//正在个人聊天界面
//            [[UserManager  shareInstance] isOnDialogVCWithUserId:message.groupId]) //正在群组聊天界面
            {
//                NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
//                NSString *userType = [mySettingData objectForKey:@"userType"];
//                ChatViewController *chatVC =[[ ChatViewController alloc]init];
//                if ([userType isEqualToString:@"1"]) {d
//                    //    if ([self.dialogEN.fromUid intValue] == [[UserManager shareInstance].user.userId intValue])
//                    if ([message.from intValue]!=[chatVC.contactuid intValue] ) {
//                        return;
//                    }
//                }
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatSocketRequestResponseNoticeForDailog object:message];
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatSocketRequestResponseNoticeForList object:message];
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatSocketRequestResponseNoticeForMessage object:message];

            NIF_ALLINFO(@"响应到对话中");
            [[UserManager  shareInstance] addNoticeCountWithMusicHints:YES SenderUID:message.from];// junyi.zhu debug
         }
            else{//统一进行数据接受处理,存储到数据库中,并进行提示
           
//            if (message.commandId == COMMAND_SEND_P2G_MESSAGE && [[UserManager shareInstance] isOffGroupMessageNoticeWithGroupId:message.groupId]) {
//                NIF_ALLINFO(@"表示群组消息已经被设置过滤");
//                return;
//            }
            }
            //表示收到一条新消息
            if (message.direction == MSG_DIRECTION_CLIENT_TO_SERVER) {
                //添加一条新消息提醒
                [[UserManager  shareInstance] addNoticeCountWithMusicHints:YES SenderUID:message.from];
            }
        
            if (![[UserManager  shareInstance] isOnUserStatusWithUserStatus:UserCurrentStatusForVoice] &&
                ![[UserManager  shareInstance] isOnUserStatusWithUserStatus:UserCurrentStatusForMessage]) {
                
                //使用时间来限制，2分钟之后才能直接提示一个
                static  NSString*  latestPointStartTimeKey = @"lastestPointStartTimeKey";
                NSDate* latestPointStartTimeDate = [[NSUserDefaults standardUserDefaults] objectForKey:latestPointStartTimeKey];
                if (latestPointStartTimeDate == nil  ||   ([[NSDate date] timeIntervalSince1970] - [latestPointStartTimeDate timeIntervalSince1970]) > 1*60) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:latestPointStartTimeKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    UIAlertView* alertView =  [CommonUtils AlertWithTitle:@"新消息"
//                                                            OkButtonTitle:@"查看"
//                                                        CancelButtonTitle:@"忽略"
//                                                                      Msg:@"你有一条新消息"
//                                                                 Delegate:self
//                                                                      Tag:EMELPSocketManagerTagForGetAMessageAlert];
//                    objc_setAssociatedObject(alertView  , &AlertInfoKey  , message, OBJC_ASSOCIATION_RETAIN);
                    
                 }


            }

        }
        
        
//    }
    else if(message.type == MSG_TYPE_AUDIO_STREAM){
        NIF_ALLINFO(@"收到语音响应消息");
//
//        //表示对方语音异常
//        if (message.error != ERROR_SUCCESS) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceException object:nil userInfo:nil];
//        }
//        
//        if (message.contents != nil && message.direction == MSG_DIRECTION_CLIENT_TO_SERVER) {
//            NIF_ALLINFO(@"收到语音流,需要直接播放");
//            [[RecorderManager sharedManager] addReceivedMessage:message];
//        }else if(message.direction == MSG_DIRECTION_SERVER_TO_CLIENT){
//            NIF_ALLINFO(@"收到语音响应");
//        }else{
            NIF_ALLINFO(@"收到无效的语音包");
//        }
        
    }
            else
        {
        NIF_ALLINFO(@"不能正确解析的消息类型");
        
    }

}

/*!
 * @abstract 处理
 */
//-(void)handleFriendRelationInterfaceMessageWithMessage:(Message*)message
//{
//    BOOL isNeedNoticeForFriendRelation = YES;
//    
//    if (message.direction == MSG_DIRECTION_SERVER_TO_CLIENT) {
//        NIF_ALLINFO(@"收到响应");
//        isNeedNoticeForFriendRelation = YES;
//
//    }else if (message.direction == MSG_DIRECTION_CLIENT_TO_SERVER){
//        [[NSNotificationCenter defaultCenter] postNotificationName:ChatSocketRequestResponseNoticeForFriendRelation object:message];
//        switch (message.commandId) {
//            case COMMAND_GET_GROUP_LIST:
//            {
//                NIF_ALLINFO(@"获取好友");
//                break;
//            }
//            case COMMAND_SEND_GROUP_INVITATION:
//            {
//                NIF_ALLINFO(@"被邀请加入群组好友");
//                NSString* hints = nil;
//                if (message.contents) {
//                    hints = [[NSString alloc] initWithData:message.contents encoding:NSUTF8StringEncoding];
//                }else{
//                    hints = @"你被邀请加入了一个群组";
//                }
//                
////                [CommonUtils showHintsWithContent:hints];
//
//                break;
//            }
//            case COMMAND_QUIT_GROUP:
//            {
//                NIF_ALLINFO(@"退出群组");
//                NSString* hints = nil;
//                if (message.contents) {
//                    hints = [[NSString alloc] initWithData:message.contents encoding:NSUTF8StringEncoding];
//                }else{
//                  hints = @"有人退出了群组";
//                }
////                [CommonUtils showHintsWithContent:hints];
//                
////                //表示你被踢出了群组,直接清理历史记录
////                if ([message.to isEqualToString:CurrentUserChatID]) {
////                    [self removeRecentContactsWithContactUid:message.groupId];
////                }
//                
//                break;
//            }
//            case COMMAND_GET_FIENDS_LIST:
//            {
//                NIF_ALLINFO(@"获取好友列表");
//                
//                break;
//            }
//            case COMMAND_SEND_ADD_FRIEND_REQUEST:
//            {
//                NIF_ALLINFO(@"加好友请求");
//              UIAlertView* alertView =  [CommonUtils AlertWithTitle:@"加好友请求"
//                              OkButtonTitle:@"同意加为好友"
//                          CancelButtonTitle:@"拒绝"
//                                        Msg:[[NSString alloc] initWithData:message.contents encoding:NSUTF8StringEncoding]
//                                   Delegate:self
//                                        Tag:EMELPSocketManagerTagForAddFriendRequest];
//                if (alertView) {
//                    objc_setAssociatedObject(alertView  , &AlertInfoKey  , message, OBJC_ASSOCIATION_RETAIN);
//                }
//                break;
//            }
//            case COMMAND_HANDLE_ADD_FRIEND_REQUEST:
//            {
//                NIF_ALLINFO(@"同意加好友请求");
//              
//                NSString* hints = nil;
//                if (message.contents) {
//                    hints = [[NSString alloc] initWithData:message.contents encoding:NSUTF8StringEncoding];
//                }else{
//                    hints = @"恭喜！你的好友申请已被接受。";
//                }
////                [CommonUtils showHintsWithContent:hints];
//                break;
//            }
//            case COMMAND_DELETE_FRIEND:
//            {
//                NIF_ALLINFO(@"删除好友");
//                
//                NSString* hints = nil;
//                if (message.contents) {
//                    hints = [[NSString alloc] initWithData:message.contents encoding:NSUTF8StringEncoding];
//                }else{
//                    hints = @"真遗憾！你的一个好友跟你解除了好友关系。";
//                }
////                [CommonUtils showHintsWithContent:hints];
//                
//                
//                break;
//            }
//            case COMMAND_BLOCK_FRIEND:
//            {
//                NIF_ALLINFO(@"加黑名单好友");
//                NSString* hints = nil;
//                if (message.contents) {
//                    hints = [[NSString alloc] initWithData:message.contents encoding:NSUTF8StringEncoding];
//                }else{
//                    hints = @"真遗憾！你被一个好友拉入了黑名单。";
//                }
////                [CommonUtils showHintsWithContent:hints];
//                break;
//            }
//            default:
//                break;
//        }
//        
//    }else{
//        NIF_ALLINFO(@"没法处理相关消息，请检查 message.direction :%d",message.direction);
//    }
//    
//    //处理通知
//    if ( isNeedNoticeForFriendRelation) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ChatSocketRequestResponseNoticeForFriendRelation object:message];
//    }
//}
/*!
 
 */
//-(void)handleAudioMessageWithMessage:(Message*)message
//{
//    NIF_ALLINFO(@"实时对讲无法响应");
//    if (message.error != ERROR_SUCCESS) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceException object:nil userInfo:nil];
//    }
//    
//    if (message.direction == MSG_DIRECTION_SERVER_TO_CLIENT) {
//        if ([message.from  isEqualToString:CurrentUserChatID]) {
//            switch (message.commandId) {
//                case COMMAND_INVITE_TALK:
//                {
//                    //4.0  邀请实时对讲要求响应，这是如果是好友未在线，则直接提示好友不在线
//                    NIF_ALLINFO(@"发送语音聊天邀请成功");
//                    switch (message.error) {
//                        case ERROR_NOT_CONNECTED:
//                        {
//                            NIF_ALLINFO(@"不能连接");
//                            break;
//                        }
//                        case ERROR_USER_NOT_ONLINE:
//                            NIF_ALLINFO(@"用户不在线");
//                            [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForFriendNotOnline object:nil];
//                            break;
//                        case ERROR_UNKNOWN:
//                            NIF_ALLINFO(@"未知错误");
//                            break;
//                        default:
//                            break;
//                    }
//                    break;
//                }
//                case COMMAND_ACCEPT_TALK:
//                {
//                    NIF_ALLINFO(@"接受语音聊天成功，需要开始对讲");
//                    [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStart object:message];
//                    [RecorderManager sharedManager].isPreparePlayingVoiceData = YES;
//                    [RecorderManager sharedManager].isTalking = YES;
//                    break;
//                }
//                case COMMAND_REJECT_TALK:
//                {
//                    NIF_ALLINFO(@"拒绝好友实时对讲");
//                }
////                case COMMAND_TALK_START: //注意  talk start 命令字已经取消
////                {
////                    NIF_ALLINFO(@"需要启动实时对讲，收到开始语音聊天，如果自己还未开启，则开启");
////                    [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStart object:message];
////
////                    break;
////                }
//                case COMMAND_TALK_END:
//                case COMMAND_TALK_EXCEPTION:
//                {
//                    [RecorderManager sharedManager].isPreparePlayingVoiceData = NO;
//                    [[RecorderManager sharedManager] stopRecording];
//                    NIF_ALLINFO(@"忽略响应回来的异常和结束");
//                    break;
//                }
//                case COMMAND_TALK_BUSY:
//                {
//                    NIF_ALLINFO(@"正在实时对讲，表示不能同时和多个人实时对讲");
//                    break;
//                
//                }
//                default:
//                    break;
//            }//end switch
//        }else{
//            NIF_ALLINFO(@"无法正确处理解析请求,请检查消息fromId:%@  currentUserId:%@",message.from,CurrentUserID);
//        }
//        
//    }else if(message.direction == MSG_DIRECTION_CLIENT_TO_SERVER) {
//        
//        if ([message.to  isEqualToString:CurrentUserID] ) {
//            
//            switch (message.commandId) {
//                case COMMAND_INVITE_TALK:  //4.1  收到实时对讲邀请
//                    
//                {
//                    NIF_ALLINFO(@"收到一个实时对讲要求");
//                    if(![RecorderManager sharedManager].isTalking){
//                    UIAlertView* alertView =  [CommonUtils AlertWithTitle:@"语音对话"
//                                                            OkButtonTitle:@"接受"
//                                                        CancelButtonTitle:@"拒绝"
//                                                                      Msg:@"你好友邀请你进行语音通话"
//                                                                 Delegate:self
//                                                                      Tag:EMELPSocketManagerTagForInviteTalkAlert];
//                    objc_setAssociatedObject(alertView  , &AlertInfoKey  , message, OBJC_ASSOCIATION_RETAIN);
//                    }else{
//                        NIF_ALLINFO(@"正在实时对讲");
//                        [self busyInFriendTalkWithLoginUserId:CurrentUserID
//                                                 friendUserId:message.from];
//                    }
//                    break;
//                }
//                case COMMAND_ACCEPT_TALK://4.2 收到同意实时对讲邀请
//                {
//                    NIF_ALLINFO(@"收到一个同意");
//                    [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStart object:message];
//                    break;
//                }
//                case COMMAND_REJECT_TALK:
//                {
//                    [self stopVoiceTalkAndChangedStatus];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStop object:message];
//
//                    UIAlertView* alertView =  [CommonUtils AlertWithTitle:@"提示" Msg:@"对方拒绝实时对讲" Delegate:self];
//                    alertView.tag = EMELPSocketManagerTagForStopTalkAlert;
//                    objc_setAssociatedObject(alertView  , &AlertInfoKey  , message, OBJC_ASSOCIATION_RETAIN);
//
//                    break;
//                }
////                case COMMAND_TALK_START:////4.2 收到同意实时对讲邀请
////                {
////                    NIF_ALLINFO(@"需要启动实时对讲，如果未启动的话");
////                    [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStart object:message];
////                    
////                    break;
////                }
//                case COMMAND_TALK_END:
//                {
//                    NIF_ALLINFO(@"收到实时对讲结束");
//
//                    [self stopVoiceTalkAndChangedStatus];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStop object:message];
//
//                    UIAlertView* alertView =  [CommonUtils AlertWithTitle:@"提示" Msg:@"实时对讲结束" Delegate:self];
//                    alertView.tag = EMELPSocketManagerTagForStopTalkAlert;
//                    objc_setAssociatedObject(alertView  , &AlertInfoKey  , message, OBJC_ASSOCIATION_RETAIN);
//
//                    break;
//                }
//                case COMMAND_TALK_EXCEPTION:
//                {
//                    NIF_ALLINFO(@"收到实时对讲异常");
//                    
//                    [self stopVoiceTalkAndChangedStatus];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStop object:message];
//
//                    if ([[UserManager shareInstance] isVisibleVCWithViewControllerClass:[EMELPVoiceVC class]]) {
//
//                    UIAlertView* alertView =  [CommonUtils AlertWithTitle:@"提示" Msg:@"实时对讲异常" Delegate:self];
//                    alertView.tag = EMELPSocketManagerTagForExceptionTalkAlert;
//                    objc_setAssociatedObject(alertView  , &AlertInfoKey  , message, OBJC_ASSOCIATION_RETAIN);
//                        
//                    }else{
//                    
//                    //判断是否邀请还在显示
//                        UIAlertView* alertView = [CommonUtils AlertIsExist];
//                        if (alertView && alertView.tag == EMELPSocketManagerTagForInviteTalkAlert) {
//                            [CommonUtils AlertViewClear];
//                        }
//                    }
//                    break;
//                }
//                case COMMAND_TALK_BUSY:
//                {
//                    NIF_ALLINFO(@"对方正在实时对讲");
//                    [self stopVoiceTalkAndChangedStatus];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStop object:message];
//                    
//                    if ([[UserManager shareInstance] isVisibleVCWithViewControllerClass:[EMELPVoiceVC class]]) {
//                    [CommonUtils AlertWithTitle:@"提示" Msg:@"你的好友正在实时对讲，请稍后再试。"];
//                    }
//
//                     break;
//                }
//                default:
//                    break;
//            } //end switch
//        }else{
//            NIF_ALLINFO(@"无法正确处理解析请求,请检查消息fromId:%@  currentUserId:%@",message.from,CurrentUserID);
//        }
//        
//    }else{
//        
//        NIF_ALLINFO(@"无法判断是响应，还是收到一个新的消息，请检查Message  direction :%d",message.direction);
//    }
    

//}


//-(void)stopVoiceTalkAndChangedStatus
//{
////    [RecorderManager sharedManager].isPreparePlayingVoiceData = NO;
////    [[RecorderManager sharedManager] stopRecording];
////    //移除语音对话
////    [[UserManager shareInstance] removeUserStatusWithUserStatus:UserCurrentStatusForVoice];
//    
//
//}

#pragma mark -    UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    EMELPSocketManagerTag  tag = (EMELPSocketManagerTag)alertView.tag;
//    
//    switch (tag) {
//        case EMELPSocketManagerTagForInviteTalkAlert:
//        {
//            Message* message =     objc_getAssociatedObject(alertView, &AlertInfoKey);
//            NIF_ALLINFO(@"收到邀请");
//            if (buttonIndex == 1) {
//                NIF_ALLINFO(@"同意语音对话邀请，（注意：需要等待录音和播放设备结束了 才发送同意）");
//            
//                
//                [[UserManager shareInstance] gotoPageWithCalssVCName:@"EMELPVoiceVC"
//                                                         AttributeId:message.from
//                                                   OtherAttrbiuteDic:nil];
//                
//            }else if(buttonIndex == 0){
//                NIF_ALLINFO(@"拒绝语音对话邀请");
//                [self  rejectFriendTalkWithLoginUserId:CurrentUserChatID friendUserId:message.from];
//            }
//            break;
//        }
//        case EMELPSocketManagerTagForExceptionTalkAlert:
//        {
//            NIF_ALLINFO(@"实时对讲异常");
//            [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceException object:nil userInfo:nil];
//           //需要处理好友邀请弹出对话框
//            
//        }
//        case EMELPSocketManagerTagForStopTalkAlert:
//        {
//            NIF_ALLINFO(@"实时对讲停止");
//            [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForVoiceStop object:nil userInfo:nil];
//            break;
//        }
            
//        case EMELPSocketManagerTagForOtherPlaceLoginAlert:
//        {
//         
//            NIF_ALLINFO(@"异地登录,需要进行用户信息的清理");
////#warning 异地登录需要处理
////            [[EMEAppDelegate visibleViewController].navigationController popToRootViewControllerAnimated:NO];
//            break;
//        }
//        
//        case EMELPSocketManagerTagForGetAMessageAlert:
//        {
//         
//            Message* message =  objc_getAssociatedObject(alertView, &AlertInfoKey);
//            BOOL isGroup = (message.commandId == COMMAND_SEND_P2G_MESSAGE) ? YES : NO;
//            
//            
//             
//            NIF_ALLINFO(@"收到一条新消息");
//            if (buttonIndex == 1) {
//                NIF_ALLINFO(@"去查看信息");
//                    [[UserManager shareInstance] gotoPageWithCalssVCName:@"EMELPDialogVC"
//                                                             AttributeId:isGroup ? message.groupId : message.from
//                                                       OtherAttrbiuteDic:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isGroup] forKey:@"isGroup"]];
//
//            }else if(buttonIndex == 0){
//                NIF_ALLINFO(@"取消");
//                
//            }
//            break;
//        }
//            
//       case EMELPSocketManagerTagForAddFriendRequest:
//        {
//            Message* message =  objc_getAssociatedObject(alertView, &AlertInfoKey);
//
//            if (buttonIndex == 0) {
//                NIF_ALLINFO(@"拒绝好友申请");
//
//                //需要刷新好友列表
//                [[NSNotificationCenter defaultCenter] postNotificationName:SocketRequestResponseNoticeForRefreshFriendTable object:message];
//                
//            }else{
//                NIF_ALLINFO(@"同意好友申请");
//                [[EMELPFamilyHttpRquestManager shareInstance] agreeBecomeFriendWithLoginUserId:CurrentUserID
//                                                                                  FriendUserId:message.from];
//            }
//            
//            break;
//           
//        }
//            
//        default:
//            break;
//    }
//  }
//
//}


-(void)testSocketSendData
{
 
    
}
@end
