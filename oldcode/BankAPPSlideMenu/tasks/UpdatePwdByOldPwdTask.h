//
//  UpdatePwdByOldPwdTask.h
//  BankAPP
//
//  Created by kevin on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
@interface  UpdatePwdByOldPwdTask: Task
@property (strong, nonatomic) HttpRequest *request;
@property (strong, nonatomic) NSArray *aryKey;
@property (strong, nonatomic) NSArray *aryValue;

- (id)initWithpostAryKey:(NSArray *)ary1 withAryValue:(NSArray *)ary2 withDelegate:(id)delegate;

@end
