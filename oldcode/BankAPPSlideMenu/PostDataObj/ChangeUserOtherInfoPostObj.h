//
//  ChangeUserOtherInfoPostObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface ChangeUserOtherInfoPostObj : SuperPostObj
@property (nonatomic,strong) NSString *qqCode;
@property (nonatomic,strong) NSString *wechatCode;
@property (nonatomic,strong) NSString *blogType;
@property (nonatomic,strong) NSString *blogCode;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
