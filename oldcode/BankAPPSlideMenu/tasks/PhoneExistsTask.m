//
//  PhoneExistsTask.m
//  BankAPP
//
//  Created by kevin on 14-3-4.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "PhoneExistsTask.h"
#import "App.h"
#import "NSObject+SBJson.h"
@implementation PhoneExistsTask

@synthesize request;

- (id)initWithPostDict:(NSDictionary *)postDict withDelegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.postDict = postDict;
    }
    
    return self;
}

- (void)process {
    @try {
        NSString *url = [[App sharedInstance].cfg urlcheckPhoneExists];
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
- (void)requestFinished:(NSString *)response {
    
    NSDictionary *result = [response JSONValue];
    
    NSString* code = [result objectForKey:@"code"];
    
    BOOL succeed = [code isEqualToString:@"9002"];
    
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
