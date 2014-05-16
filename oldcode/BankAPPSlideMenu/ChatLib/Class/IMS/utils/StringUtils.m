//
//  StringUtils.m
//  ims
//
//  Created by Tony Ju on 10/16/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import "StringUtils.h"
#import "EMEChatConfManager.h"
@implementation StringUtils

+(NSString *) getEmptyUUID {
    return @"0000000000000000000000000000000";//junyi   uid
}

+(NSString*) getFixedUUId {
    
    return ChatCurrentUserChatID;

 }

+(NSString *) getUUID {
    NSUUID *uuid = [[NSUUID alloc] init];
    
    return [uuid UUIDString];
}

//+(NSString *) getUUID {
//    NSString *uuid = [[NSString alloc] init];
////    NSString * struid = message.uid;
//    NSString * sUid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    return @"1111";
//}

@end
