//
//  UpdateMessagesStatuPostObj.h
//  BankAPP
//
//  Created by kevin on 14-5-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface UpdateMessagesStatuPostObj : SuperPostObj

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *fromStatu;
@property (nonatomic,strong) NSString *toStatu;
@property (nonatomic,strong) NSString *userId;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
