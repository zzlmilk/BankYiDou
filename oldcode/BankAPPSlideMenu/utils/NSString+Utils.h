//
//  NSString+Utils.h
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncodingAddition)
- (NSString*)URLDecodedString;
- (NSString*)URLEncodedString;

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString;
- (BOOL)isEqualToOneOfStrings:(NSArray *)aStringArray withCaseInsensitive:(BOOL)caseInsensitive;

+ (BOOL)isNilOrEmpty:(NSString *)aStr;
+(BOOL)isNotBlank:(NSString*)str;
+(BOOL)isWhitespaceAndNewlines:(NSString *)str;
+ (NSString *)stringFromBytes:(long long)aBytes;
@end