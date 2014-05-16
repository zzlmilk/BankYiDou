//
//  RecordUserStatusLogObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-18.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "RecordUserStatusLogObj.h"
#define koperateTime  @"operateTime"
#define koperateValue  @"operateValue"
#define koperateType   @"operateType"
#define KmaterialId       @"materialId"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation RecordUserStatusLogObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:KmaterialId];
    
    [key addObject:koperateType];
    [key addObject:koperateValue];
    [key addObject:koperateTime];
    
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.materialId];
    
    [key addObject:self.operateType];
    [key addObject:self.operateValue];
    [key addObject:self.operateTime];
    
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end
