//
//  VerificationCodeTask.h
//  Association
//
//  Created by appleUser on 13-5-21.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "Task.h"

@interface VerificationCodeTask : Task

@property (strong, nonatomic) HttpRequest *request;
@property (strong, nonatomic) NSDictionary *postDict;

- (id)initWithPostDict:(NSDictionary *)postDict withDelegate:(id)delegate;

@end
