//
//  VerificationCodeTask.m
//  Association
//
//  Created by appleUser on 13-5-21.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "VerificationCodeTask.h"

@implementation VerificationCodeTask

- (id)initWithPostDict:(NSDictionary *)postDict withDelegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.postDict = postDict;
    }
    
    return self;
}

- (void)process
{
    @try {
        NSString *url = [[App sharedInstance].cfg urlGetCode];
        self.request = [[HttpRequest alloc] initWithDelegate:self];
        [self.request requestPost:self.postDict withURL:url];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception);
    }
    @finally {
        
    }
}

#pragma mark - http delegate
- (void)requestFinished:(NSString *)response
{    
    
    NSDictionary *res = [response JSONValue];
    
    NSArray *array  = [res objectForKey:@"info"];
    
    NSDictionary *result = [array objectAtIndex:0];
    
    NSString* code = [result objectForKey:@"code"];
    
    BOOL succeed = [code isEqualToString:@"0000"];
    
    if (!succeed) {
        [self requestFailed:[NSError errorWithDomain:@"association" code:[[result objectForKey:@"errnum"] intValue] userInfo:result]];
        return;
    }
    
    self.dataString = [result objectForKey:@"data"];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didTaskFinished:)]) {
            
            self.responseDict = [response JSONValue];
            
            [self.delegate didTaskFinished:self];
        }
    }
}

- (void)requestFailed:(NSError *)theError
{
    self.error = theError;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didTaskFinished:)]) {
            self.responseDict = theError.userInfo;
            [self.delegate didTaskFinished:self];
        }
    }
}

@end
