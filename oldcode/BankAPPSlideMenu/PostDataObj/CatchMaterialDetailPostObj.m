//
//  CatchMaterialDetailPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CatchMaterialDetailPostObj.h"

#define KmaterialId        @"materialId"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation   CatchMaterialDetailPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:KmaterialId];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.materialId];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}
@end