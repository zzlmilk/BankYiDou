//
//  EMELPSocketManager.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-19.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketConn.h"


@interface EMELPSocketManager : NSObject
@property (nonatomic,strong)Message *socketMessage;
@property (nonatomic,strong)SocketConn* socketConn;


+(EMELPSocketManager*)shareInstance;//共享实例
+(void)destroyInstance;//销毁实例

#pragma mark - define
/*!
 *@abstract 检查实时对讲
 @discusssion 在离开聊天页面的时候都需要重新写
 */
-(void)checkVoiceStatusAndAutoStopVoice;
/*!
 *@abstract 判断是否正在录音
 @discusssion 如果没有在录音，则自动进行清理动作
 */
-(BOOL)isOnRecording;

#pragma mark 操作网络连接

/*!
 *@abstract 获取socket 的连接状态
 */
-(BOOL)isSocketConnect;
/*!
 *@abstract    开始建立socekt 连接
 *@discussion  这里，如果socket已经建立连接，系统不会再次去连接，而是直接任务建立已经建立了
 */
-(BOOL)startSocketConnect;
/*!
 *@abstract 停止socket 连接
 *@discussion 不建议手动调用改方法，   因为断开socket 连接的时候networkDog 会自动去尝试连接，并自动登录
 */
-(void)stopSocketConnect;

/*!
 *@abstract 重新建立socket 连接
 *@discussion 不建议调用该方法， 因为断线的时候会自动netwathDog 会自动的去重新连接，并且尝试重新登录
 */
-(void)reStartSocketConnect;

#pragma mark - 网络连接维续
/*!
 *@abstract 自动连接socket
 *@discussion  自动连接socket，是通过判断用户信息是否存在，如果存在则自动连接socket 并使用socket 自动注册，
 注意： 1. 登录完成之后需要通知Socket自动连接,
 2. 注销的时候，也需通知socket断开socket 连接
 使用场景： 登录、注册、背景切换道前台、以及网络变化的时候调用
 */
-(BOOL)autoConnectSocket;
/*
 @abstract   注册道Socket服务器端
 @discussion 当建立好Socket连接的时候需要向服务端提交身份信息进行一次注册
 */
-(void)registerToSocketServer;

#pragma mark - 收到一条消息
/*
 *@abstract 收到消息代理实现， 提供直接调用方式
 */
- (void)addReceivedMessage:(Message *)message;

#pragma -  消息发送接口

-(void)sendMessage:(Message*)message  ;


/*!
 @abstract 发送语音
 @discussion 注意audioName 不能包含文件后缀, 并且Message.content 字段为nil
 @param  audioMessage  message消息，注意content属性被忽略
 @param   audioName   录音存储的临时文件名字，不是路径，并且不包含后缀
 @result  是否存在音频文件
 */
-(BOOL)sendAudioMessage:(Message*)audioMessage AudioName:(NSString*)audioName;
#pragma mark - Socket 接口


/*
 @abstract 申请好友
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @param  content    邀请说明内容
 @result Message   返回整个Message 请求对象
 */
-(Message*)addFriendRequestWithLoginUserId:(NSString*)loginUserId
                               friendUserId:(NSString*)friendUserId
                                    Content:(NSString*)content;
/*
 @abstract 退出登录
 @param loginUserId  登录用户ID
 @result Message   返回整个Message 请求对象
 */
-(Message*)logoutRequestWithLoginUserId:(NSString*)loginUserId;


#pragma mark - 实时对讲
/*
 @abstract 邀请朋友进行实时对讲通话
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)inviteFriendTalkWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId;

/*
 @abstract 同意进行实时对讲通话
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)acceptFriendTalkWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId;
/*
 @abstract 拒绝
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)rejectFriendTalkWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId;

///*
// @abstract 开始实时对讲通话
// @param loginUserId  登录用户ID
// @param friendUserId 邀请的好友id
// @result Message   放回整个Message 请求对象
// */
//-(Message*)startFriendTalkWithLoginUserId:(NSString*)loginUserId
//                              friendUserId:(NSString*)friendUserId;
/*
 @abstract 结束实时对讲通话
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)endFriendTalkWithLoginUserId:(NSString*)loginUserId
                           friendUserId:(NSString*)friendUserId;
/*
 @abstract  实时对讲通话异常
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)exceptionFriendTalkWithLoginUserId:(NSString*)loginUserId
                           friendUserId:(NSString*)friendUserId;
/*
 @abstract  正在实时对讲中
 @param loginUserId  登录用户ID
 @param friendUserId 邀请的好友id
 @result Message   放回整个Message 请求对象
 */
-(Message*)busyInFriendTalkWithLoginUserId:(NSString*)loginUserId
                              friendUserId:(NSString*)friendUserId;
//-(void)testSocketSendData;

@end
