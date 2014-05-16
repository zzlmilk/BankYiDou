//
//  MaterialInfosPostObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-10.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface MaterialInfosPostObj : SuperPostObj

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *pageSize;
@property (nonatomic, strong) NSString  *classId;//模块子分类Id
@property (nonatomic, strong) NSString * plateId;//银行模块Id ，，为空则为首页
@property (nonatomic, strong) NSString *minTime;
@property (nonatomic, strong) NSString *maxTime;
@property (nonatomic, strong) NSString *plateFlag;
@property (nonatomic, strong) NSString *templet;
@property (nonatomic, strong) NSString *scale;
@property (nonatomic, strong) NSString *orderBy;
@property (nonatomic, strong) NSString *orderType;

- (NSArray *)aryKey;
- (NSArray *)aryValue;


@end
