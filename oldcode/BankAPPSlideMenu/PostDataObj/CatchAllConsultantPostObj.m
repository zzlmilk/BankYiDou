//
//  CatchAllConsultantPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CatchAllConsultantPostObj.h"

#define Ksearch         @"search"
#define KpageSize       @"pageSize"
#define KlastConsultantId            @"lastConsultantId"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation  CatchAllConsultantPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Ksearch];
    [key addObject:KpageSize];
    [key addObject:KlastConsultantId];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.search];
    [key addObject:self.pageSize];
    [key addObject:self.lastConsultantId];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}
@end

