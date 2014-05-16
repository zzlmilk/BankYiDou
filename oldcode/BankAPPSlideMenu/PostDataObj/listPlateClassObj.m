//
//  listPlateClassObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-14.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "listPlateClassObj.h"
#define ktoken        @"token"
#define kuid          @"uid"
#define kplateId      @"plateId"

@implementation listPlateClassObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:ktoken];
    [key addObject:kuid];
    [key addObject:kplateId];
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.token];
    [key addObject:self.uid];
    [key addObject:self.plateId];
    return key;
}

@end
