//
//  RegisterTask.h
//  BankAPP
//
//  Created by kevin on 14-3-5.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
@interface LoadingTask : Task
@property (strong, nonatomic) HttpRequest *request;
@property (strong, nonatomic) NSArray *aryKey;
@property (strong, nonatomic) NSArray *aryValue;

- (id)initWithpostAryKey:(NSArray *)ary1 withAryValue:(NSArray *)ary2 withDelegate:(id)delegate;
@end