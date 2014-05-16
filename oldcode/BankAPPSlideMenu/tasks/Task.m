//
//  Task.m
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//


#import "Task.h"

@implementation Task

@synthesize delegate;
@synthesize error;


- (id)initWithDelegate:(id)aDelegate {
    self = [super init];
    if (self != nil) {
        self.delegate = aDelegate;
    }
    return self;
}


- (void) run
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didTaskStarted:)]) {
            [self.delegate didTaskStarted:self];
        }
    }
    
    [self process];
}

- (void) process
{
}

@end
