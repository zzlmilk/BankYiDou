//
//  DialogEntity.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-11.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEDialogEntity.h"

@implementation EMEDialogEntity


-(void)setAttributeWithMessageId:(NSString*)messageId
                         FromUid:(NSString*)fromUid
                           ToUid:(NSString*)toUid
                     MessageType:(MessageType)type
               MessageStatus:(MessageStatus)sendStatus
                         Content:(NSString*)content
                            Time:(NSDate*)time

{
    self.messageId = messageId;
    self.fromUid = fromUid;
    self.toUid = toUid;
    self.type = type;
    self.sendStatus = sendStatus;
    if (content) {
        self.content = content;
    }
    self.time = time;
}


-(NSString*)description
{
    NSMutableString* description  = [NSMutableString stringWithString:[super description]];
    [description  appendFormat:@" messageId = %@   ",self.messageId];
    [description  appendFormat:@" fromUid = %@   ",self.fromUid];
    [description  appendFormat:@" toUid = %@    ",self.toUid];
    [description appendFormat:@"  type = %d  ",self.type];
    [description appendFormat:@"  sendStatus = %d  ",self.sendStatus];
    [description appendFormat:@"  time = %@  ",self.time];
    [description appendFormat:@"  content = %@",self.content];

    return description;
}
@end
