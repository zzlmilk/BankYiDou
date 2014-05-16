//
//  ListMaterialInfoForPageObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-3.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface ListMaterialInfoForPageObj : SuperPostObj

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *pageSize;
@property (nonatomic, strong) NSString  *classId;//模块子分类Id
@property (nonatomic, strong) NSString * plateId;//银行模块Id ，，为空则为首页
@property (nonatomic, strong) NSString *dataType;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *search;
@property (nonatomic, strong) NSString *curPage;

- (NSArray *)aryKey;
- (NSArray *)aryValue;


@end
