//
//  EMEChatConfManager.h
//  EMEChat
//
//  Created by Sean Li on 3/7/14.
//  Copyright (c) 2014 junyi.zhu All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  登录注册
 */
extern NSString *ChatCurrentUserChatID; //默认登录用户UID
extern NSString *ChatLoginSuccessNotice ;
extern NSString *ChatLoginOutNotice;

/**
 *  服务器连接相关
 */
extern NSString *ChatServerHost;
extern NSInteger ChatServerPort;

/**
 *  网络相关
 */
extern NSString *ChatSocketConnectStatusNotice ;
extern NSString *ChatSocketRequestSlowNotice;
extern NSString *ChatSocketRequestNeedRegisterNotice ;

/**
 *  聊天消息内容相关
 */
extern NSString *ChatSocketRequestResponseNoticeForFriendRelation ;
extern NSString *ChatSocketRequestResponseNoticeForDailog ;
extern NSString *ChatSocketRequestResponseNoticeForList ;
extern NSString *ChatSocketRequestResponseNoticeForMessage ;//junyi.zhu debug 

/**
 *  设置配置的值
 *
 *  @return 配置对应key的值
 */
typedef  NSString* (^ConfValueBlock)(NSString* key);

 

@interface EMEChatConfManager : NSObject



+(instancetype)sharedManager;
+(void)destroyInstance;


#pragma - mark   聊天服务器信息设置

/**
 *  注册聊天服务器信息
 *
 *  @param serverHost 聊天服务器地址设置
 *  @param serverPort 聊天服务器端口号
 */
+(void)registerChatServerHost:(NSString*)serverHost ChatServerPort:(NSInteger)serverPort;



#pragma - mark  当前用户聊天信息设置
/**
 *  注册当前用户聊天ID
 *
 *  @param currentUserChatIdBlock 用户聊天IdBlock
 *  @discussion 这里是使用bolck 是因为，用户的聊天ID 可能会发生变化，比如切换用户登录，或者后登录等
 */
-(void)registerCurrentUserChatId:(ConfValueBlock)currentUserChatIdBlock;

/**
 *  用户登录或者注销，发送的消息通知名字
 *
 *  @param LoginSuccessNoticeName 登录成功通知名字
 *  @param LogoutNoticeName       注销通知名字
 */
+(void)registerLoginSuccessNoticeKeyName:(NSString*)LoginSuccessNoticeName   logOutNoticeValue:(NSString*)LogoutNoticeName;

@end
