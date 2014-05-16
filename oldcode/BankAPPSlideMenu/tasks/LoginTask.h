//
//  LoginTask.h
//  Association
//
//  Created by jinke on 3/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
@interface LoginTask : Task
@property (strong, nonatomic) HttpRequest *request;
@property (strong, nonatomic) NSArray *aryKey;
@property (strong, nonatomic) NSArray *aryValue;

- (id)initWithpostAryKey:(NSArray *)ary1 withAryValue:(NSArray *)ary2 withDelegate:(id)delegate;

@end
