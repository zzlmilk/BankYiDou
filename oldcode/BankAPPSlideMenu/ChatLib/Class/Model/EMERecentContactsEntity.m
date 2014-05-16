//
//  EMERecentContactsEntity.m
//  EMEAPP
//
//  Created by Sean Li on 13-12-17.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMERecentContactsEntity.h"

@implementation EMERecentContactsEntity

-(id)init
{
    self = [super init];
    if (self) {
        self.unReadMessagesCount = 0;
    }
   return  self;
}

-(void)setAttributeWithContactUid:(NSString *)contactUid
                       FromSource:(NSString *)fromSource
                  ContactNickName:(NSString *)contactNickName
                   ContactHeadUrl:(NSString *)contactHeadUrl
{
    if (contactUid) {
        self.contactUid = contactUid;
    }
    if (contactHeadUrl) {
        self.contactHeadUrl = contactHeadUrl;
    }
    if (contactNickName) {
        self.contactNickName = contactNickName;
    }
    if (fromSource) {
        self.fromSource = fromSource;
    }
}


-(void)addNewUnReadMessagesCount
{
    self.unReadMessagesCount ++;
}

-(NSString*)description
{
    NSMutableString* description  = [NSMutableString stringWithString:[super description]];
    [description appendFormat:@"  contactUid :%@",self.contactUid];
    [description appendFormat:@"  fromSource :%@",self.fromSource];
    [description appendFormat:@"  contactNickName :%@",self.contactNickName];
    [description appendFormat:@"  contactHeadUrl :%@",self.contactHeadUrl];
    [description appendFormat:@"  unReadMessageCount :%ld",(long)self.unReadMessagesCount];

    return description;
}
@end
