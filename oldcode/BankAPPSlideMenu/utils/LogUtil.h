//
//  LogUtil.h
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogUtil : NSObject


+(void)errorLog:(NSString*)log function:(NSString *)function;
//#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#ifdef DEBUG
#define DLog(...) do { } while (0)

#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)

#define ELog(...) [LogUtil errorLog:[NSString stringWithFormat:__VA_ARGS__]function:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] ]



@end
