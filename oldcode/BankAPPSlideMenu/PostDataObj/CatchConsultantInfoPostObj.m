//
//  CatchConsultantInfoPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CatchConsultantInfoPostObj.h"

#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation  CatchConsultantInfoPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}
@end

