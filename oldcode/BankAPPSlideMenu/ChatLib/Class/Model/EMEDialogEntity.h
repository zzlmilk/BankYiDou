//
//  EMEDialogEntity.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-11.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    MessageTypeForSystemPushAD =0,//系统广告
    MessageTypeForSystemNotic, // 系统消息文本， 比如 好友申请成功
    MessageTypeForSystemMessage, // 系统对话信息   比如系统给发一个内容
    MessageTypeForImage,// 图片数据
    MessageTypeForMap,//地图
    MessageTypeForSoundFragment,//语音片段
    MessageTypeForVideoFragment,//视频片段
    MessageTypeForTime,//用来显示发送时间的，这里暂时等同于MessageTypeForSystemNotic
    MessageTypeForIgnoreRecentMessage //用来记录最后一天消息，在聊天信息中忽略
 } MessageType;

typedef enum {
    MessageStatusForSendSuccess = (1UL << 0),//消息已经成功发送到服务端
    MessageStatusForSending = (1UL << 1),//正在发送
    MessageStatusForSendRead = (1UL << 2),//表示发送消息,已经被对方阅读
    MessageStatusForSendFail = (1UL << 3),//发送失败
    
    MessageStatusForReceiveUnRead = (1UL << 4),//表示收到新消息未读
    MessageStatusForReceiveRead = (1UL << 5),//表示收到消息并且已经阅读
    
    MessageStatusForAll = 0b111111//表示所有组合状态
} MessageStatus;

//用来表示多种状态的组合  eg MessageSendStatusForSuccess|MessageSendStatusForSending

typedef NSInteger MessageStatusUnit;


@interface EMEDialogEntity : NSObject

@property(atomic,strong)NSString*   messageId;//表示消息Id
@property(atomic,strong)NSString*   fromUid;//谁发的信息
@property(atomic,strong)NSString*   toUid;//发给谁
@property(atomic,strong)NSString*   groupId;//存在，则表示是群消息，否则是两个人之间的对话
@property(atomic,assign)MessageType type;//用来表示数据类型， 比如1. 系统广告，2 系统消息通知等


@property(atomic,strong)NSString*  content;//这里的content 如果是地图，这包含了  geolan,geolon,msg,用逗号分割的内容
@property(atomic,assign)MessageStatus sendStatus;//表示发送的状态，比如  已发送，已经阅读，发送失败等状态
@property(atomic,strong)NSDate* time;//发送的时间，或者是从服务端获取信息的时间

-(void)setAttributeWithMessageId:(NSString*)messageId
                         FromUid:(NSString*)fromUid
                           ToUid:(NSString*)toUid
                     MessageType:(MessageType)type
               MessageStatus:(MessageStatus)sendStatus
                         Content:(NSString*)content
                            Time:(NSDate*)time;


@end
