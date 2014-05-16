//
//  Message.m
//  ims
//
//  Created by Tony Ju on 10/16/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import "Message.h"
#import "StringUtils.h"
#import "DateUtils.h"


@implementation Message

#pragma mark intialization

-(id) init {
    self = [super init];
    if (self) {
        
        _uid = [StringUtils getUUID];
    //这是自己
        _from = [StringUtils getFixedUUId];
        _to = [StringUtils getEmptyUUID];
        _contents = nil;
        _commandId = COMMAND_UNKNOWN;
        _type = MSG_TYPE_UNKNOWN;
        _error = ERROR_UNKNOWN;
        _direction = MSG_DIRECTION_UNKNOWN;
        _status = MSG_STATUS_UNKNOWN;
        
        _eventDate = [DateUtils getNow];
    }
    
    return self;
    
}
-(void)setmessage
{
    
    
}

-(void)setAttributesWithMsgId:(NSString*)msgId
                   FromUserId:(NSString*)fromUserId
                     ToUserId:(NSString*)toUserId
                     Contents:(NSString*)contents
                  CommandType:(COMMAND_TYPE)commandType
                  MessageType:(MSG_TYPE)messageType
                MessageStatus:(MSG_STATUS)messageStatus
             MessageDirection:(MSG_DIRECTION)messageDirection
                    ErrorType:(ERROR_TYPE)errorType
                    EventDate:(NSDate*)eventDate


{
    if (msgId) {
        self.uid = msgId;
    }else{
        self.uid = [StringUtils getUUID];
    }
    
    if (fromUserId) {
        self.from = fromUserId;
    }
    if (toUserId) {
        self.to  = toUserId;
    }

    if (contents) {
        self.contents = contents;
    }
   
        self.type = messageType;
    
    
        self.status = messageStatus;
    
        self.direction = messageDirection;
    
        self.error = errorType;
    
    if (eventDate) {
        self.eventDate = eventDate;
    }

}

#pragma mark -------- setter

-(void)setContents:(NSString *)contents
{
    if (contents) {
        _contents =contents;
    }
}

-(NSString*)description
{

     NSMutableString* res  = [NSMutableString  stringWithFormat:@""];
    [res appendFormat:@" messageId: %@ \n",self.uid];
    [res appendFormat:@" fromId: %@ \n",self.from];
    [res appendFormat:@" toId: %@ \n",self.to];
    [res appendFormat:@" Contents: %@ \n", self.contents];
    [res appendFormat:@" messageType: %X \n",self.type];
    [res appendFormat:@" commandType: %x \n",self.commandId];

    [res appendFormat:@" sendStatus: %x \n",self.status];
    [res appendFormat:@" messageDirection: %x \n",self.direction];

    [res appendFormat:@" errorType: %x \n",self.error];
    [res appendFormat:@" eventDate: %@ \n",self.eventDate];
    return [res description] ;
}
@end
