//
//  DDNetType.m
//  DDCoupon
//
//  Created by  on 12-6-5.
//  Copyright (c) 2012年 DDmap. All rights reserved.
//

#import "EMENetType.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"

@implementation EMENetType

+ (NSString *)getNetType{
    NSString *netType = @"G";
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if (netStatus == ReachableViaWiFi) {
        netType = @"WIFI";
    }else {
        NSString *version = [[UIDevice currentDevice] systemVersion];
        CGFloat versionNum = [version floatValue];
        if (versionNum>4.0) {
            CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
            CTCarrier *carrier = [netinfo subscriberCellularProvider];
            NSString *netName;
            netName = [carrier carrierName];
            if ([netName isEqualToString:@"中国联通"]) {
                netType = @"CU";
            }else if([netName isEqualToString:@"中国移动"]){
                netType = @"CM";
            }else if([netName isEqualToString:@"中国电信"]){
                netType = @"CT";
            }else {
                netType = @"G";
            }
        }
    }
    
    return netType;
}

@end
