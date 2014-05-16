//
//  Datamanager.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-27.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//
/* plate_info         左侧请求模块
 * material_user      素材信息用户关联表
 * material_info      素材信息
 * plate_class        VIP特权一级列表信息
 * promissory_shops   VIP特权详细信息
 * financial_products 理财产品表
 * user_remark        移动端用户备注表
 * user_info          移动端用户表
 * golden          // 黄金（未用）
 * credit          // 信贷（未用）
 * activity_info   // 银行活动信息表（未用）
 **/

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface Datamanager : NSObject

//打开数据库
+(sqlite3 *)openDatabase;

//关闭数据库
+(void)closeDataBase;

+ (sqlite3 *)OpenWithDBType:(DBCenterType) dBCenterType;

@end
