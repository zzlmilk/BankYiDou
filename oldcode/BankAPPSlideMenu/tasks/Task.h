//
//  Task.h
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "HttpRequest.h"

@interface Task : NSObject <HttpRequestDelegate> {

}

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSDictionary *responseDict;

@property (nonatomic, strong) NSString *dataString;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *serverTime;


- (id)initWithDelegate:(id)aDelegate;
- (void) run;
- (void) process;
@end



@protocol TaskDelegate<NSObject>
- (void)didTaskStarted:(Task *)aTask;
- (void)didTaskFinished:(Task *)aTask;
@end
