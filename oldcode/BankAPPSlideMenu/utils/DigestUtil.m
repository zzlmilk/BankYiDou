//
//  DigestUtil.m
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import "DigestUtil.h"
#define CHUNK_SIZE  (10 * 1024)
@implementation DigestUtil

+(NSString*)md5File:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        @autoreleasepool {
            NSData* fileData = [handle readDataOfLength: CHUNK_SIZE ];
            CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
            if( [fileData length] == 0 ) done = YES;
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}


+(unsigned char *)sha1File:(NSFileHandle *)fileHandler length:(CC_LONG)len messageDigest:(unsigned char *)md {
    CC_SHA1_CTX ctx;
    CC_SHA1_Init(&ctx);
    
    CC_LONG num = 0;
    
    while (len > 0) {
        @autoreleasepool {
        
            CC_LONG numToRead = len < CHUNK_SIZE ? len : CHUNK_SIZE;
            NSData * data = [fileHandler readDataOfLength:numToRead];
            if (data == nil) {
                NSLog(@"sha1 error! read no data");
                return nil;
            }
            num = [data length];
            if (num != numToRead) {
                NSLog(@"sha1 error! it should read %d, but only read %d", numToRead, num);
                return nil;
            }
            
            CC_SHA1_Update(&ctx, [data bytes], num);
            
            len -= num;
        
        }
    }
    
    CC_SHA1_Final(md, &ctx);
    return md;
}

+ (NSString *)md5ForString:(NSString *)string {
    const char *cStr = [string UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    
}

@end
