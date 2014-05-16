//
//  PhoneUtil.h
//  Association
//
//  Created by jinke on 03/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface PhoneUtil : NSObject

//手机别名
+ (NSString *)getName;
//手机号
+ (NSString *)getMobile;
//设备号
+ (NSString *)getUuid;
//获取设备类型
+ (NSString *)getDeviceType;
//获取设备操作系统版本号
+ (NSString *)getOSVersion;
//获取屏幕尺寸
+ (CGSize)getScreenSize;
//获取屏幕分辨率
+ (CGSize)getScreenResolution;
//获取Token（用于Push Message）
+ (NSString *)getToken;
////获取MAC地址
//+ (NSString *)getMacAddress;
//
//
////未使用这个方法
//+ (NSString *) deviceId;

@end
