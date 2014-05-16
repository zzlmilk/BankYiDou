//
//  PhoneUtil.m
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//


#import "PhoneUtil.h"

//getMacAddress
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//---------------------------------

@implementation PhoneUtil

//手机别名
+ (NSString *)getName
{
    return [[UIDevice currentDevice] name];
}

//手机号
+ (NSString *)getMobile
{
    //该方法未实现
    return @"";
}

//设备号
+ (NSString *)getUuid
{
    return [self getMacAddress];
}

//获取设备类型
+ (NSString *)getDeviceType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    /*
     Possible values:
     "iPhone1,1" = iPhone 1G
     "iPhone1,2" = iPhone 3G
     "iPhone2,1" = iPhone 3GS
     "iPhone3,1" = iPhone 4G
     "iPod1,1"   = iPod touch 1G
     "iPod2,1"   = iPod touch 2G
     "iPod3,1"   = iPod touch 3G
     "iPod4,1"   = iPod touch 4G
     "iPod1,1"   = iPad
     "i386"      = simulate
     */
    NSString *platform = [NSString stringWithUTF8String:machine];
    
    free(machine);
    
    return platform;
}

//操作系统的版本
+ (NSString *)getOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//获取屏幕尺寸
+ (CGSize)getScreenSize
{
    return [[UIScreen mainScreen]bounds].size;
}

//获取屏幕分辨率
+ (CGSize)getScreenResolution
{
    CGFloat screenScale = [UIScreen mainScreen].scale;//分辨率宽高与编程时的宽高比例
    CGSize screenSize = [self getScreenSize];
    CGSize size = CGSizeMake(screenSize.width * screenScale, screenSize.height * screenScale);
    return size;
}

//获取Token（用于Push Message）
+ (NSString *)getToken
{
    //该方法未实现
    return @"";
}

+ (NSString *)getMacAddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}


//获取MAC地址
//+ (NSString *)getMacAddress
//{
//    
//}




//+ (NSString *)deviceId
//{
//    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
//        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    } else {
//              UIDevice *myDevice = [UIDevice currentDevice];
//        NSString *deviceUDID = myDevice.uniqueIdentifier;
//        return deviceUDID;
//    }
//    
//    
//}

@end
