//
//  App.m
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "App.h"

@interface App ()

@end

@implementation App
@synthesize jwviewManager = _jwviewManager;
@synthesize cfg=_cfg;


static App *_instance = nil;
+ (App *)sharedInstance
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[App alloc] init];
        }
    }
    
    return _instance;
}
-(void)test
{
    
}

- (id) init {
    if ((self = [super init])) {
        [self test];
    }
    
    return self;
}

- (Config *)cfg {
    if (_cfg == nil) {
        _cfg = [Config sharedInstance];
    }
    return _cfg;
}


//- (PictureData *)pictureData
//{
//    if (_pictureData == nil) {
//        _pictureData = [[PictureData alloc] initWithCoreData:self.coreData];
//    }
//    return _pictureData;
//}
//
//-(VoteData *)voteData
//{
//    if (_voteData == nil) {
//        _voteData = [[VoteData alloc]initWithCoreData:self.coreData];
//    }
//    return _voteData;
//}

+(Boolean) isEmptyOrNull:(NSString *) str {
    if (!str) {
        // null object
        return true;
    } else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return true;
        } else {
            // is neither empty nor null
            return false;
        }
    }
}
@end
