//
//  HttpRequest.m
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import "HttpRequest.h"
#import "ASIHTTPRequest.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HttpUtil.h"
#import "NSString+Utils.h"
#import "App.h"
#import "DigestUtil.h"


#define POST_GET_TIMEOUT 20.0f

@implementation HttpRequest
@synthesize delegate;

- (id)initWithDelegate:(id<HttpRequestDelegate>)aDelegate {
    if ((self = [super init])) {
        self.delegate = aDelegate;
    }
    return self;
}

- (void)requestPostAryKey:(NSArray *)aryKey withAryValue:(NSArray *)aryValue withURL:(NSString *)url
{
#if KAvailable_NSLog
    NSLog(@"url: %@, thread:%@", url, [NSThread currentThread]);
#endif
    if (aryValue && aryValue.count > 0)
    {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Content-Type" value:@"text/javascript"];
        [request addRequestHeader:@"Content-Type" value:@"text/plain"];
        [request addRequestHeader:@"Content-Type" value:@"text/json"];
        
        for (int i = 0; i <aryValue.count; i++) {
            
            NSString *strvalue = [aryValue objectAtIndex:i];
            NSString *strkey = [aryKey objectAtIndex:i];
            [request setPostValue:strvalue forKey:strkey];
        }
        [request startAsynchronous];
    }
    
}



-(void)requestPost:(NSMutableDictionary *)param withURL:(NSString *)url
{
//    Config *cfg = [App sharedInstance].cfg;
//    NSString *associationId = cfg.associationId;
//    [param setObject:associationId forKey:@"associationId"];
#if KAvailable_NSLog
    NSLog(@"url: %@, thread:%@", url, [NSThread currentThread]);
#endif
    if (param && param.count > 0)
    {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Content-Type" value:@"text/javascript"];
        [request addRequestHeader:@"Content-Type" value:@"text/plain"];
        [request addRequestHeader:@"Content-Type" value:@"text/json"];//        NSLog(@"request parameters: %@", param);
//        for (NSString *key in param.allKeys)
//        {
//            id value = [param valueForKey:key];
//            if ([value isKindOfClass:[NSString class]]) {
//                [request addPostValue:[NSString stringWithUTF8String:[value UTF8String]] forKey:key];
//            }
//        }
        
//        NSString *jsonString = [param JSONRepresentation];
#if KAvailable_NSLog
        NSLog(@"json representation:\n%@", jsonString);
#endif
//        [request appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostValue:@"13011111000" forKey:@"mobile"];
        [request setPostValue:@"e00cf25ad42683b3df678c61f42c6bda" forKey:@"password"];
        
//        [request setTimeOutSeconds:POST_GET_TIMEOUT];
//        [request setResponseEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
    }
}

-(void)requestPostwithURL:(NSString *)url
{
#if KAvailable_NSLog
    NSLog(@"url: %@, thread:%@", url, [NSThread currentThread]);
#endif
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addRequestHeader:@"content-type" value:@"application/json"];
    [request setTimeOutSeconds:POST_GET_TIMEOUT];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request startAsynchronous];
}



- (NSDictionary *)requestPostSynchronous:(NSDictionary *)param withURL:(NSString *)url
{
    if (param && param.count > 0) {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request addRequestHeader:@"content-type" value:@"application/json"];
        
        NSString *jsonString = [param JSONRepresentation];
        
        [request appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setTimeOutSeconds:POST_GET_TIMEOUT];
        [request setResponseEncoding:NSUTF8StringEncoding];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        id response = [request responseString];
        BOOL succeed = NO;
        
        if (!error) {
            response = [request responseString];
            succeed = YES;
        }
        else {
            response = nil;
            succeed = NO;
        }        
        
        NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
        [responseDict setObject:response forKey:@"responseString"];
        [responseDict setObject:[NSNumber numberWithBool:succeed] forKey:@"succeed"];
        return responseDict;
    }
    return nil;
}

-(void)requestGet:(NSMutableDictionary *)param withURL:(NSString *)url
{
    Config *cfg = [App sharedInstance].cfg;
    NSString *associationId = cfg.associationId;
    [param setObject:associationId forKey:@"associationId"];
    
//    [self requestGet:param withURL:url isCached:NO];
}


#pragma mark-
#pragma mark ASIHttpRequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString * response = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
#if KAvailable_NSLog
    NSDictionary *dict = [response JSONValue];
    NSLog(@"responsString: %@ \n json:%@",response, dict);
#endif
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:response forKey:@"userInForMation"];
    
    if (delegate) {
        if ([delegate respondsToSelector:@selector(requestFinished:)]) {
            [delegate requestFinished:(ASIHTTPRequest*)response];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
#if KAvailable_NSLog
    NSLog(@"response %@", request.error);
#endif
    if (delegate) {
        if ([delegate respondsToSelector:@selector(requestFailed:)]) {
            [delegate requestFailed:(ASIHTTPRequest*)request.error];
        }
    }

}


@end
