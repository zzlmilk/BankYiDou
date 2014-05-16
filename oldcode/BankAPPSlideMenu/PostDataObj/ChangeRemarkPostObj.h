//
//  ChangeRemarkPostObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-25.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface ChangeRemarkPostObj : SuperPostObj
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
