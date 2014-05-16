//
//  NSObject+Message_Dialog.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-20.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "NSObject+Message_Dialog.h"
#import "Message.h"
#import "EMEDialogEntity.h"

@implementation NSObject (Message_Dialog)

-(Message*)messageTransformWithDialogEntity:(EMEDialogEntity*)dialogEntity
{
    if (dialogEntity == nil) {
        return  nil;
    }
    
    
    MSG_TYPE msgType = MSG_TYPE_UNKNOWN ;
 
    switch (dialogEntity.type) {
        case MessageTypeForSystemMessage:
            msgType = MSG_TYPE_TEXT;
            break;
        case MessageTypeForSoundFragment:
            msgType = MSG_TYPE_VOICE;
            break;
        default:
            break;
    }
    
    MSG_STATUS msgStatus = MSG_STATUS_UNKNOWN;
    switch (dialogEntity.sendStatus) {
        case MessageStatusForSendFail:
            msgStatus = MSG_STATUS_FAILED;
            break;
        case MessageStatusForSendRead:
            msgStatus = MSG_STATUS_READ;
            break;
        case MessageStatusForSending:
            msgStatus = MSG_STATUS_SENDING;
            break;
        case MessageStatusForSendSuccess:
            msgStatus = MSG_STATUS_DELIVERED;
            break;
         default:
            break;
    }
    
    
    MSG_DIRECTION msgDirction = MSG_DIRECTION_UNKNOWN;
    
     if (dialogEntity.fromUid && ChatCurrentUserChatID) {
    
    if ([dialogEntity.fromUid  isEqualToString:ChatCurrentUserChatID]) {
        msgDirction =MSG_DIRECTION_CLIENT_TO_SERVER;
    }else{
        msgDirction =MSG_DIRECTION_SERVER_TO_CLIENT;
    }
        
    }else{
        NIF_INFO(@"用户未登录");
        return nil;
    }

    
    Message* message = [[Message alloc] init];
    [message setAttributesWithMsgId:dialogEntity.messageId
                         FromUserId:dialogEntity.fromUid
                           ToUserId:dialogEntity.toUid
                           Contents:dialogEntity.content
                        CommandType:COMMAND_SEND_P2P_MESSAGE
                        MessageType:msgType
                      MessageStatus:msgStatus
                   MessageDirection:msgDirction
                          ErrorType:ERROR_UNKNOWN
                          EventDate:dialogEntity.time];
    return message;

}


-(EMEDialogEntity*)DialogEntityTransformWithMessage:(Message*)message
{
   
    if (message == nil) {
        return  nil;
    }
    
    MessageType massageType = MessageTypeForSystemMessage;
    
    switch (message.type) {
        case MSG_TYPE_TEXT :
            massageType = MessageTypeForSystemMessage;
            break;
        case MSG_TYPE_VOICE :
            massageType = MessageTypeForSoundFragment;
            break;
        default:
            break;
    }
    
    MessageStatus messageStatus = MessageStatusForSendSuccess;
    switch (message.status) {
        case MSG_STATUS_FAILED:
            messageStatus = MessageStatusForSendFail;
            break;
        case MSG_STATUS_READ:
            messageStatus = MessageStatusForSendRead;
            break;
        case MSG_STATUS_SENDING:
            messageStatus = MessageStatusForSending ;
            break;
        case MSG_STATUS_DELIVERED:
            messageStatus = MessageStatusForSendSuccess ;
            break;
        default:
            break;
    }
    
    
    EMEDialogEntity* dialogEntity = [[EMEDialogEntity alloc] init];
    [dialogEntity setAttributeWithMessageId:message.uid
                                    FromUid:message.from
                                      ToUid:message.to
                                MessageType:massageType
                          MessageStatus:messageStatus
                                    Content:message.contents
                                       Time:message.eventDate];
    NIF_ALLINFO(@" contents:%@ 转换结果：%@",message.contents,dialogEntity);
    return dialogEntity;
}

@end
