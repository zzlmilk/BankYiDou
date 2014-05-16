//
//  KMacros.h
//  Association
//
//  Created by Mac 10.8 on 13-5-22.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#ifndef Association_KMacros_h
#define Association_KMacros_h

#define KDeveloping 1   //1：开发、测试，0：发布安装包
#define KAvailable_NSLog 0 //1：NLog可用，0：不可用

#define KUserInfoKey @"AssociationUserInfo"  //保存设备ID和会员ID的Key

//#define KDownImagePath @"http://njcj2020.xicp.net:8181/Image?filename=" //下载图片的路径
//#define KDownImagePath @"http://192.168.5.8:8282/Image?filename=" //下载图片的路径
#define KDownImagePath @"http://njcj2020.xicp.net:8181/Image?filename=" //下载图片的路径


#define CLUBID @"35"

#define POST_GET_TIMEOUT 20.0f

typedef enum
{
    Blocker = 0,
    Creator = 1,
    Member = 2
}RoleType;

#define KUserInfoFile @"userInfo.plist"
#define KDeviceID @"deviceid"
#define KMemberID @"memberid"

//Utils
#import "UIFontUtil.h"

//Common UI
#import "ShadeView.h"

#endif
