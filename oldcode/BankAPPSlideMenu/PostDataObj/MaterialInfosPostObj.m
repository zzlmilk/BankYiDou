//
//  MaterialInfosPostObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-10.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "MaterialInfosPostObj.h"

#define ktoken @"token"
#define kuid   @"uid"
#define kpageSize @"pageSize"
#define kclassId  @"classId"
#define kplateId  @"plateId"
#define kminTime  @"minTime"
#define kmaxTime  @"maxTime"
#define kplateFlag @"plateFlag"
#define ktemplet @"templet"
#define kscale @"scale"
#define korderBy @"orderBy"
#define kordertype @"ordertype"

@implementation MaterialInfosPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:kplateId];
    [key addObject:kclassId];
    [key addObject:kminTime];
    [key addObject:kmaxTime];
    [key addObject:kpageSize];
    [key addObject:kuid];
    [key addObject:ktoken];
    
    [key addObject:kplateFlag];
    [key addObject:ktemplet];
    [key addObject:kscale];
    [key addObject:korderBy];
    [key addObject:kordertype];
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.plateId];
    [key addObject:self.classId];
    [key addObject:self.minTime];
    [key addObject:self.maxTime];
    [key addObject:self.pageSize];
    [key addObject:self.uid];
    [key addObject:self.token];
    
    [key addObject:self.plateFlag];
    [key addObject:self.templet];
    [key addObject:self.scale];
    [key addObject:self.orderBy];
    [key addObject:self.orderType];
    
    return key;
}
@end
