//
//  MessageCodec.h
//  ims
//
//  Created by Tony Ju on 10/16/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageCodec : NSObject


typedef void (^DecodeSuccessBlock)(Message* newMessage);

@property (strong,nonatomic) NSString *stringuid;
+(void)decodeToArray:(NSData *)data  withBolck:(DecodeSuccessBlock)decodeSuccessBlock;

+(Message *)decode:(NSData *)data  withBolck:(DecodeSuccessBlock)decodeSuccessBlock;
+(NSMutableData *) encode:(Message *)message  :(int)capacity;
+(NSMutableData *) encodeRegister:(Message *)message  :(int)capacity;


@end
