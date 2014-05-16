//
//  ListCustomersVIPWithRemarkPostObj.m
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ListCustomersVIPWithRemarkPostObj.h"

#define Ksearch         @"search"
#define KcurPage        @"curPage"
#define KpageSize       @"pageSize"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation  ListCustomersVIPWithRemarkPostObj

- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:Ksearch];
    [key addObject:KcurPage];
    [key addObject:KpageSize];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    [key addObject:self.search];
    [key addObject:self.curPage];
    [key addObject:self.pageSize];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}
@end
