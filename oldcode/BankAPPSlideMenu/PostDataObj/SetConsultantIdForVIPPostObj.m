//
//  SetConsultantIdForVIPPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SetConsultantIdForVIPPostObj.h"

#define KconsultantId         @"consultantId"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation   SetConsultantIdForVIPPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:KconsultantId];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];

    [key addObject:self.consultantId];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}
@end

