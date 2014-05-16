//
//  LoginTask.m
//  Association
//
//  Created by jinke on 3/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import "LoginTask.h"
#import "App.h"
#import "NSObject+SBJson.h"
@implementation LoginTask

@synthesize request;

- (id)initWithPostDict:(NSDictionary *)postDict withDelegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
    }
    
    return self;
}

- (id)initWithpostAryKey:(NSArray *)ary1 withAryValue:(NSArray *)ary2 withDelegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.aryKey = ary1;
        self.aryValue = ary2;
    }
    return self;
}


- (void)process {
    @try {        
        NSString *url = [[App sharedInstance].cfg urlLogin];
        self.request = [[HttpRequest alloc] initWithDelegate:self];
        [self.request requestPostAryKey:self.aryKey withAryValue:self.aryValue withURL:url];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception);
    }
    @finally {
        
    }
    
}

#pragma mark - http delegate
- (void)requestFinished:(NSString *)response {
    
    NSDictionary *result = [response JSONValue];
    
//    NSArray *array  = [result objectForKey:@"info"];
//    
//    NSDictionary *result2 = [array objectAtIndex:0];
//    NSString * dispName = [result2 objectForKey:@"dispName"];
//    NSLog(@"%@",dispName);
    
    
//    NSString * token = [result objectForKey:@"token"];
    NSString* code = [result objectForKey:@"code"];
//    NSLog(@"%@",token);
    BOOL succeed = [code isEqualToString:@"0000"];
    
    if (!succeed) {
        [self requestFailed:[NSError errorWithDomain:@"bank" code:[[result objectForKey:@"code"] intValue] userInfo:result]];
        return;
    }
    
    self.dataString = [result objectForKey:@"code"];
    
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
