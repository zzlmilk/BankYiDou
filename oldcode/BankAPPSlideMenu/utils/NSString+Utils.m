//
//  NSString+Utils.m
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import "NSString+Utils.h"

#define ONE_KB 1024.0
#define ONE_MB (ONE_KB * ONE_KB)
#define ONE_GB (ONE_KB * ONE_MB)


@implementation NSString (URLEncodingAddition)
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    (CFStringRef)self,
                                                                                    NULL,
                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                    kCFStringEncodingUTF8));
    
	return result;
}

- (NSString*)URLDecodedString
{
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self,
                                                                                                    CFSTR(""),
                                                                                                    kCFStringEncodingUTF8));
	return result;
}

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString {
    return ([self caseInsensitiveCompare:aString] == NSOrderedSame);
}

- (BOOL)isEqualToOneOfStrings:(NSArray *)aStringArray withCaseInsensitive:(BOOL)caseInsensitive {
    NSUInteger count = [aStringArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *str = (NSString *)[aStringArray objectAtIndex:i];
        if (caseInsensitive) {
            if ([self isEqualToStringCaseInsensitive:str]) {
                return YES;
            }
        }
        else {
            if ([self isEqualToString:str]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)isNilOrEmpty:(NSString *)aStr {
    if (aStr == nil) {
        return YES;
    }
    return ([aStr length] == 0);
}

+(BOOL)isWhitespaceAndNewlines:(NSString *)str
{
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < str.length; ++i) {
        unichar c = [str characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isNotBlank:(NSString*)str
{
    if (str) {
        if (str.length > 0 && ![self isWhitespaceAndNewlines:str]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)stringFromBytes:(long long)aBytes {
    if (aBytes < 0) {
        return @"Invalid File Size";
    }
    else if (aBytes >= ONE_GB) {
        return [NSString stringWithFormat:@"%.2f GB", aBytes/ONE_GB];
    }
    else if (aBytes >= ONE_MB) {
        return [NSString stringWithFormat:@"%.2f MB", aBytes/ONE_MB];
    }
    else if (aBytes >= ONE_KB) {
        return [NSString stringWithFormat:@"%.2f KB", aBytes/ONE_KB];
    }
    else {
        return [NSString stringWithFormat:@"%lld B", aBytes];
    }
}



@end
