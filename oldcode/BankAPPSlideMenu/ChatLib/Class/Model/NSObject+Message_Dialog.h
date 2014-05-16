//
//  NSObject+Message_Dialog.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-20.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "EMEDialogEntity.h"
@interface NSObject (Message_Dialog)
-(Message*)messageTransformWithDialogEntity:(EMEDialogEntity*)dialogEntity;
-(EMEDialogEntity*)DialogEntityTransformWithMessage:(Message*)message;

@end
