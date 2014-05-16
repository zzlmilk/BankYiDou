//
//  EMEChatConfManager.m
//  EMEChat
//
//  Created by Sean Li on 3/7/14.
//  Copyright (c) 2014 junyi.zhu All rights reserved.
//

#import "EMEChatConfManager.h"


/**
 *  登录注册
 */
 NSString *ChatCurrentUserChatID; //默认登录用户UID
 NSString *ChatLoginSuccessNotice = @"ChatLoginSuccessNotice";
 NSString *ChatLoginOutNotice = @"ChatLoginOutNotice";
/**
 *  服务器连接相关
 */
 NSString *ChatServerHost ;
 NSInteger ChatServerPort ;


/**
 *  网络相关
 */
 NSString *ChatSocketConnectStatusNotice = @"ChatSocketConnectStatusNotice";
 NSString *ChatSocketRequestSlowNotice = @"ChatSocketRequestSlowNotice";
 NSString *ChatSocketRequestNeedRegisterNotice = @"ChatSocketRequestNeedRegisterNotice";

/**
 *  聊天消息内容相关
 */
 NSString *ChatSocketRequestResponseNoticeForFriendRelation = @"ChatSocketRequestResponseNoticeForFriendRelation";
 NSString *ChatSocketRequestResponseNoticeForDailog = @"ChatSocketRequestResponseNoticeForDailog";
 NSString *ChatSocketRequestResponseNoticeForList = @"ChatSocketRequestResponseNoticeForList";
 NSString *ChatSocketRequestResponseNoticeForMessage = @"ChatSocketRequestResponseNoticeForMessage";


@interface EMEChatConfManager()

@property (nonatomic,copy) ConfValueBlock evConfValueBlock;
@end

@implementation EMEChatConfManager

static EMEChatConfManager *s_chatConfManager = nil;

+(instancetype)sharedManager
{
  
        @synchronized(self){
            
            if (!s_chatConfManager) {
                s_chatConfManager =  [[self alloc] init];
            }
        }
        
        return s_chatConfManager;
 

}
+(void)destroyInstance
{
    if (!s_chatConfManager) {
        s_chatConfManager = nil;//释放内存
    }

}



#pragma - mark   聊天服务器信息设置

/**
 *  注册聊天服务器信息
 *
 *  @param serverHost 聊天服务器地址设置
 *  @param serverPort 聊天服务器端口号
 */
+(void)registerChatServerHost:(NSString*)serverHost ChatServerPort:(NSInteger)serverPort
{
    if (serverHost) {
        ChatServerHost = serverHost;
    }else{
        NIF_ERROR(@"请设置正确的聊天服务器地址，不能为空");
    }
    
    if (serverPort > 0 && serverPort < 65535) {
        ChatServerPort = serverPort;
    }else{
        NIF_ERROR(@"请设置正确的聊天服务器端口 ：servePort 端口取值在 0 ～ 65535 之间");

    }

}



#pragma - mark  当前用户聊天信息设置
/**
 *  注册当前用户聊天ID
 *
 *  @param currentUserChatIdBlock 用户聊天IdBlock
 *  @discussion 这里是使用bolck 是因为，用户的聊天ID 可能会发生变化，比如切换用户登录，或者后登录等
 */
-(void)registerCurrentUserChatId:(ConfValueBlock)currentUserChatIdBlock
{
    if (currentUserChatIdBlock) {
        self.evConfValueBlock = currentUserChatIdBlock;
        ChatCurrentUserChatID = self.evConfValueBlock(@"ChatCurrentUserChatID");
    }else{
        NIF_ERROR(@"请设置当前聊天用户Block");
    }
}


/**
 *  用户登录或者注销，发送的消息通知名字
 *
 *  @param LoginSuccessNoticeName 登录成功通知名字
 *  @param LogoutNoticeName       注销通知名字
 */
+(void)registerLoginSuccessNoticeKeyName:(NSString*)LoginSuccessNoticeName   logOutNoticeValue:(NSString*)LogoutNoticeName
{
    if (LoginSuccessNoticeName) {
        ChatLoginSuccessNotice = LoginSuccessNoticeName;
    }else{
        NIF_ERROR(@"需要设置聊天登录成功后发出来的通知名字");
    }
    if (LogoutNoticeName) {
        ChatLoginOutNotice = LogoutNoticeName;
    }else{
        NIF_ERROR(@"需要设置用户注销后发出来的通知名字");
    }
}

@end
