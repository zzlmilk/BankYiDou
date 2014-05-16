//
//  ListMaterialInfoForPageObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-3.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ListMaterialInfoForPageObj.h"
#define ktoken @"token"
#define kuid   @"uid"
#define kpageSize @"pageSize"
#define kclassId  @"classId"
#define kplateId  @"plateId"
#define kdataType @"dataType"
#define kordertype @"orderType"
#define ksearch @"search"
#define kcurPage @"curPage"
@implementation ListMaterialInfoForPageObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:ktoken];
    [key addObject:kuid];
    [key addObject:kpageSize];
    [key addObject:kclassId];
    [key addObject:kplateId];
    [key addObject:kdataType];
    [key addObject:kordertype];

    [key addObject:ksearch];
    [key addObject:kcurPage];
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.token];
    [key addObject:self.uid];
    [key addObject:self.pageSize];
    [key addObject:self.classId];
    [key addObject:self.plateId];
    [key addObject:self.dataType];
    [key addObject:self.orderType];
    [key addObject:self.search];
    [key addObject:self.curPage];

    return key;
}

@end
