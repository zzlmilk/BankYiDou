//
//  RegisterPostObj.h
//  BankAPP
//
//  Created by kevin on 14-3-4.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface LoadingPostObj : SuperPostObj

/*
 name	手机的别名 (Itunes/91WAP显示的 如 XXX's IPhone)
 mobile	当前手机里的号码
 uuid	uuid 设备号 (必填不能为空,全球唯一号)
 devicetype	设备种类 string 类型如"Iphone4s" "Iphone5" "IPAD"
 osversion	操作系统的版本
 height	屏幕高度
 width	屏幕宽度
 horizontalpixels	水平像素
 verticalpixels	垂直像素
 token	用于向 Apple Service 发PUSH MESSAGE
 */

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *horizontalpixels;
@property (nonatomic, strong) NSString *verticalpixels;
@property (nonatomic, strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;


@end
