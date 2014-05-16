//
//  RecordUserStatusLogObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-18.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"
//15 
@interface RecordUserStatusLogObj : SuperPostObj
@property (nonatomic,strong) NSString *operateType;
@property (nonatomic,strong) NSString *operateValue;
@property (nonatomic,strong) NSString *operateTime;

@property (nonatomic, strong) NSString *materialId;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
