//
//  HttpRequest.h
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//
//  sdsdsdsd
#import <Foundation/Foundation.h>

@protocol HttpRequestDelegate <NSObject>
@optional
- (void)requestFinished:(NSString *)response;
- (void)requestFailed:(NSError *)theError;

@end
@interface HttpRequest : NSObject
@property (strong, nonatomic) id delegate;

- (id)initWithDelegate:(id<HttpRequestDelegate>)aDelegate;

- (void)requestPostAryKey:(NSArray *)aryKey withAryValue:(NSArray *)aryValue withURL:(NSString *)url;

-(void)requestPost:(NSDictionary *)param withURL:(NSString *)url;

-(void)requestPostwithURL:(NSString *)url;//junyi.zhu 2014.03.09

-(void)requestGet:(NSDictionary *)param withURL:(NSString *)url;
//-(void)requestGet:(NSDictionary *)param withURL:(NSString *)url isCached:(BOOL)isCached;

- (NSDictionary *)requestPostSynchronous:(NSDictionary *)param withURL:(NSString *)url;
@end
