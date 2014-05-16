//
//  Message.h
//  ims
//
//  Created by Tony Ju on 10/16/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface Message : NSObject

@property (atomic, strong) NSString *unReadNum;  //未读条数
@property (atomic, strong) NSString *uid; //消息id
@property (atomic, strong) NSString *from; //发送者的id
@property (atomic, strong) NSString *to;   //接受者的用户id
//@property (atomic, strong) NSString *groupId; //群组id，如果群组id 为000 是，则表示需要个人对个人，否则表示个人对群组
@property (atomic, strong) NSString *theuid; //用户uid
@property (atomic, strong) NSString *thetoken;  //用户token
@property (nonatomic, strong) NSString* contents; //发送的内容
@property (atomic, assign) COMMAND_TYPE commandId;
@property (atomic, assign) MSG_TYPE  type;
@property (atomic, assign) MSG_STATUS status;
@property (atomic, assign) MSG_DIRECTION direction;
@property (atomic, assign) ERROR_TYPE error;

@property (atomic, strong) NSDate *eventDate;

-(void)setContents:(NSString *)contents;
-(void)setmessage;
- (id)init;
-(void)setAttributesWithMsgId:(NSString*)msgId            
                   FromUserId:(NSString*)fromUserId
                     ToUserId:(NSString*)toUserId
                     Contents:(NSString*)contents
                  CommandType:(COMMAND_TYPE)commandType
                  MessageType:(MSG_TYPE)messageType
                MessageStatus:(MSG_STATUS)messageStatus
             MessageDirection:(MSG_DIRECTION)messageDirection
                    ErrorType:(ERROR_TYPE)errorType
                    EventDate:(NSDate*)eventDate;

@end
