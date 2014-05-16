//
//  CatchBankPlatesTask.m
//  BankAPP
//
//  Created by kevin on 14-3-7.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "CatchBankPlatesTask.h"
#import "App.h"
#import "NSObject+SBJson.h"
@implementation CatchBankPlatesTask

@synthesize request;

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
        NSString *url = [[App sharedInstance].cfg urlcatchBankPlates];
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
    
    NSString* code = [result objectForKey:@"code"];
    
    BOOL succeed = [code isEqualToString:@"0000"];
    
    if (!succeed) {
        [self requestFailed:[NSError errorWithDomain:@"bank" code:[[result objectForKey:@"code"] intValue] userInfo:result]];
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
