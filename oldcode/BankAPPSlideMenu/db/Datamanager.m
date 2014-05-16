//
//  Datamanager.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-27.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "Datamanager.h"
#define kDataBasePath @"dataBase.sqlite"
#define kDBasePath @"dBase.sqlite"
static sqlite3 *db = nil;

@implementation Datamanager

+(sqlite3 *)openDatabase
{
    //判断数据库是否打开，返回数据库指针
    if (db) {
        return db;
    }
    //从沙河中取得sql文件
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [documentPath objectAtIndex:0];
    NSString *sqlPath = [filePath stringByAppendingPathComponent:kDataBasePath];
    NSLog(@"路径是...%@",sqlPath);
    //开始数据库并设置它的指针
    if (sqlite3_open([sqlPath UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    return db;
}

+(void)closeDataBase
{
    if (db) {
        sqlite3_close(db);
        db = nil;
    }
}

+ (sqlite3 *)OpenWithDBType:(DBCenterType)dBCenterType
{
    if (db) {
        return db;
    }else{
//        NSString *sqliteName = @"";
        NSString *sqliteString = @"";
        NSString *sqliteTitle = @"";
        switch (dBCenterType) {
            case DBCenterType_material_user://素材信息用户关联表 12个字段
            {
//                sqliteName = @"material_user.sqlite";
                sqliteTitle = @"material_user";
                sqliteString = @"create table if not exists material_user(id integer primary key autoincrement,user_id text,material_id text,read_flag text,praise_flag text,collect_flag text,join_flag text,read_times text,first_time text,last_time text,praise_time text,collect_time text,join_time text);";
                break;
            }
            case DBCenterType_material_info://素材信息 33个字段
            {
//                sqliteName = @"material_info.sqlite";
                sqliteTitle = @"material_info";
                sqliteString = @"create table if not exists material_info(id integer primary key autoincrement,user_id text,material_id text,plate_id text,class_id text,material_type text,title text,content text,picture text,video text,recommend_flag text,verify_user text,verify_status text,refuse_reasion text,status text,publish_site text,publish_user text,publish_time text,insert_user text,insert_time text,update_user text,update_time text,eduo_id text,publish text,video_real_name text,video_size text,pictureurl text,templet text,showPicture text,searchkey text,more_info text,verify_time text,delete_user text,delete_time text);";
                break;
            }
            case DBCenterType_plate_class://VIP特权、尊享理财一级列表信息  12个字段
            {
//                sqliteName = @"plate_class.sqlite";
                sqliteTitle = @"plate_class";
                sqliteString = @"create table if not exists plate_class(id integer primary key autoincrement,user_id text,class_id text,plate_id text,class_name text,disp_name text,class_sort text,used_flag text,insert_user text,insert_time text,update_user text,update_time text,eduo_id text);";
                break;
            }
            case DBCenterType_promissory_shops://VIP特权详细信息 9个字段
            {
//                sqliteName = @"promissory_shops.sqlite";
                sqliteTitle = @"promissory_shops";
                sqliteString = @"create table if not exists promissory_shops(id integer primary key autoincrement,id text,material_id text,scale text,product_code text,address text,longitude text,sale_type text,sale_descript text,telephone text);";
                break;
            }
            case DBCenterType_financial_products:
                //理财产品表 比服务器多了2个字段ext_risk_level，ext_product_ser   20
            {
//                sqliteName = @"financial_products.sqlite";
                sqliteTitle = @"financial_products";
                sqliteString = @"create table if not exists financial_products(id integer primary key autoincrement,id text,material_id text,product_ser text,product_code text,risk_level text,subscribe_start text,subscribe_end text,value_date_from text,value_date_to text,product_struct text,expected_rite text,min_amount text,manager_rite text,receipt_time text,asset_manager text,detail_file text,file_name text,file_size text,ext_risk_level text,ext_product_ser text);";
                break;
            }
            case DBCenterType_user_remark://移动端用户备注表  8
            {
//                sqliteName = @"user_remark.sqlite";
                sqliteTitle = @"user_remark";
                sqliteString = @"create table if not exists user_remark(id integer primary key autoincrement,remark_id text,user_id text,remark text,insert_user text,insert_time text,update_user text,update_time text,is_attention text);";
                break;
            }
            case DBCenterType_user_info://移动端用户表   32
            {
//                sqliteName = @"user_info.sqlite";
                sqliteTitle = @"user_info";
                sqliteString = @"create table if not exists user_info(id integer primary key autoincrement,user_id text,login_name text,real_name text,disp_name text,vip_number text,password text,user_consultant text,user_type text,user_photo text,user_status text,verify_code text,expires_time text,verify_times text,verify_time text,email text,mobile text,telephone text,qq_code text,wechat_code text,blog_type text,blog_code text,remark text,insert_user text,insert_time text,update_user text,update_time text,user_changes text,user_direct1 text,user_direct2 text,user_direct3 text,pictureurl text,invention text);";
                break;
            }
            case DBCenterType_plate_info://左侧请求模块
            {
//                sqliteName = @"plate_info.sqlite";
                sqliteTitle = @"plate_info";
                sqliteString = @"create table if not exists plate_info(id integer primary key autoincrement,plate_id text,plate_name text,disp_name text,plate_sort text,back_color text,back_ground text,verify_flag text,used_flag text,plate_url text,insert_user text,insert_time text,update_user text,update_time text,plate_flag text,eduo_id text,eduo_close text,back_ground_url text);";
                break;
            }
            case DBCenterType_golden://黄金
            {
                break;
            }
            case DBCenterType_credit://信贷
            {
                break;
            }
            case DBCenterType_activity_info://银行活动信息表
            {
                break;
            }
                
            default:
                break;
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths objectAtIndex:0];
        NSString *path = [filePath stringByAppendingPathComponent:kDBasePath];
        NSLog(@"sql2....path...%@",path);
        int openSqliteResult = sqlite3_open([path UTF8String], &db);
        if (openSqliteResult == SQLITE_OK) {
            NSLog(@"数据库打开成功");
        }
        else
        {
            NSLog(@"数据库打开失败");
        }
        char *error = NULL;
        int resultCreate = sqlite3_exec(db, [sqliteString UTF8String], NULL, NULL, &error);
        if (resultCreate == SQLITE_OK) {
            NSLog(@"数据库创建成功");
        }
        return db;
    }
}

@end
