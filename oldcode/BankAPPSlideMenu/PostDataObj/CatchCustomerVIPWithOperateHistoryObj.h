//
//  catchCustomerVIPWithOperateHistoryObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface CatchCustomerVIPWithOperateHistoryObj : SuperPostObj
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *curPage;
@property (nonatomic,strong) NSString *pageSize;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
