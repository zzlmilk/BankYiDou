//
//  EMELPSocketHeartBeat.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-26.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMELPSocketHeartBeat.h"
#import "EMELPSocketManager.h"
#import "StringUtils.h"
#import "UserManager.h"

//#import "EMELPFamilyHttpRquestManager.h"

@interface EMELPSocketHeartBeat()
{
  NSTimer           *_heartTimer;               // 心跳包timer
}

@end

@implementation EMELPSocketHeartBeat
static EMELPSocketHeartBeat*  s_heartBeat  = nil;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//如果注册了通知的话。
}

+(EMELPSocketHeartBeat*)shareInstance
{
    @synchronized(self){
        
        if (s_heartBeat == nil) {
            s_heartBeat =  [[self alloc] init];
            __weak   EMELPSocketHeartBeat* weakSelf = (EMELPSocketHeartBeat*)s_heartBeat;
            
            [[NSNotificationCenter  defaultCenter] addObserver:weakSelf selector:@selector(HandleResponseForLoginWithNotic:) name:ChatLoginSuccessNotice object:nil];
            [[NSNotificationCenter  defaultCenter] addObserver:weakSelf selector:@selector(HandleResponseForLogoutWithNotic:) name:ChatLoginOutNotice object:nil];
        }
    }
    return s_heartBeat;
}

+(void)destroyInstance
{
    [s_heartBeat stopHeartBeat];
    s_heartBeat = nil;
}

-(void)HandleResponseForLoginWithNotic:(NSNotification*)notifiction
{
    
    //表示登录成功 需要开始心跳包
    [self startHeartBeat];
    NIF_ALLINFO(@"登录成功开始心跳包");
 
}


-(void)HandleResponseForLogoutWithNotic:(NSNotification*)notifiction
{
    NIF_ALLINFO(@"退出登录成功，停止心跳");
    //不论任何情况下收到退出登录的消息，都应该认识是退出登录
    [self stopHeartBeat];
    
}

/**
 *@method 发送心跳包请求
 */

-(void)sendSockeRequestForHeartBeat
{
//#warning 这是用来测试心跳连接时间的
    NIF_ALLINFO(@"发送心跳");
    if ([[UserManager shareInstance] can_auto_login]) {
        Message* message = [[Message alloc] init];
        message.from = [UserManager shareInstance].user.userId;
        message.to = [StringUtils getEmptyUUID];
        message.commandId = COMMAND_HEART_BEAT;
        message.type = MSG_TYPE_TEXT;
        message.contents =  [@"heartBeat" dataUsingEncoding:NSUTF8StringEncoding];
        [[EMELPSocketManager shareInstance] sendMessage:message ];
    }
}


/**
 *@method 开始心跳包
 */

-(void)startHeartBeat
{
    // 启动发送心跳包timer
    [self stopHeartBeat];//先停止，再发送
    
    if ([[UserManager shareInstance] can_auto_login]) {
        //手动发送一次心跳
        [self sendSockeRequestForHeartBeat];
        
        [self performSelector:@selector(getOfflineMessages) withObject:nil afterDelay:5];
    _heartTimer = [NSTimer scheduledTimerWithTimeInterval:SendHeartBeatNSTimeInterval
                                                   target:self
                                                 selector:@selector(sendSockeRequestForHeartBeat)
                                                 userInfo:nil
                                                  repeats:YES];
    }

    
}



/**
 *@method 停止心跳包
 */
-(void)stopHeartBeat
{
    // 停止发送心跳包timer
    if (nil != _heartTimer) {
        // 如果心跳包timer已经启动，销毁已经启动的timer
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
    
}

-(void)getOfflineMessages
{
    NIF_ALLINFO(@"拉取离线消息");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//     [[EMELPFamilyHttpRquestManager shareInstance] getOfflineMessages];
//    });

}


@end
