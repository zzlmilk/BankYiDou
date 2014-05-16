//
//  ChangeAttentionObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-24.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface ChangeAttentionObj : SuperPostObj
@property (nonatomic,strong) NSString *customerId;
@property (nonatomic,strong) NSString *attentionType;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
