//
//  CatchBankPlatesTask.h
//  BankAPP
//
//  Created by kevin on 14-3-7.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
@interface CatchBankPlatesTask : Task
@property (strong, nonatomic) HttpRequest *request;
@property (strong, nonatomic) NSArray *aryKey;
@property (strong, nonatomic) NSArray *aryValue;

- (id)initWithpostAryKey:(NSArray *)ary1 withAryValue:(NSArray *)ary2 withDelegate:(id)delegate;
@end
