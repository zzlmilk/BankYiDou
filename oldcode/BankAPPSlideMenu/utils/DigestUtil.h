//
//  DigestUtil.h
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface DigestUtil : NSObject

+(NSString*)md5File:(NSString*)path;
+(unsigned char *)sha1File:(NSFileHandle *)fileHandler length:(CC_LONG)len messageDigest:(unsigned char *)md;
+ (NSString *)md5ForString:(NSString *)string;
@end
