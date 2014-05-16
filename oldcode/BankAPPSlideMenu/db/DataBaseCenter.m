//
//  DataBaseCenter.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-27.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "DataBaseCenter.h"


static DataBaseCenter *databaseCenter;
static sqlite3 *dataBase;

@implementation DataBaseCenter
@synthesize ID;
@synthesize materialId;
@synthesize title;
@synthesize moduleName;
@synthesize imageURL;

+(DataBaseCenter *)share
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        databaseCenter = [[self alloc] init];
    });
    return databaseCenter;
}

//取表名字
- (NSString *)getDBListName:(DBCenterType)dBCenterType
{
    NSString *dbTypeString;//库表名字
    switch (dBCenterType) {
        case DBCenterType_material_user:
        {
            dbTypeString = @"material_user";
            break;
        }case DBCenterType_material_info:
        {
            dbTypeString = @"material_info";
            break;
        }case DBCenterType_plate_class:
        {
            dbTypeString = @"plate_class";
            break;
        }case DBCenterType_promissory_shops:
        {
            dbTypeString = @"promissory_shops";
            break;
        }case DBCenterType_financial_products:
        {
            dbTypeString = @"financial_products";
            break;
        }case DBCenterType_user_remark:
        {
            dbTypeString = @"user_remark";
            break;
        }case DBCenterType_user_info:
        {
            dbTypeString = @"user_info";
            break;
        }case DBCenterType_plate_info:
        {
            dbTypeString = @"plate_info";
            break;
        }
        default:
            break;
    }
    return dbTypeString;
}

- (BOOL)saveDataWithType:(DBCenterType)dBCenterType AndData:(Content *)acontent
{
    NSString *dbTypeString = [self getDBListName:dBCenterType];//取到库表的名字
    BOOL _state;
    
    dataBase = [Datamanager OpenWithDBType:dBCenterType];//打开数据库
    sqlite3_stmt *stmt;
    NSString *insertSql = nil;
    if (dBCenterType == DBCenterType_material_user) {
        NSString *user_id = acontent.user_id;
        NSString *material_id = acontent.material_id;
        NSString *read_flag = acontent.read_flag;
        NSString *praise_flag = acontent.praise_flag;
        NSString *collect_flag = acontent.collect_flag;
        NSString *join_flag = acontent.join_flag;
        NSString *read_times = acontent.read_times;
        NSString *first_time = acontent.first_time;
        NSString *last_time = acontent.last_time;
        NSString *praise_time = acontent.praise_time;
        NSString *collect_time = acontent.collect_time;
        NSString *join_time = acontent.join_time;
        insertSql = [NSString stringWithFormat:@"insert into %@ (user_id,material_id,read_flag,praise_flag,collect_flag,join_flag,read_times,first_time,last_time,praise_time,collect_time,join_time)values(?,?,?,?,?,?,?,?,?,?,?,?)",dbTypeString];
        sqlite3_prepare_v2(dataBase, [insertSql UTF8String], -1, &stmt, NULL);
            sqlite3_bind_text(stmt, 1, [user_id UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [material_id UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [read_flag UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [praise_flag UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 5, [collect_flag UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 6, [join_flag UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 7, [read_times UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 8, [first_time UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 9, [last_time UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 10, [praise_time UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 11, [collect_time UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 12, [join_time UTF8String], -1, NULL);
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                //NSLog(@"存储成功");
                _state = YES;
            }
            else
            {
                //NSLog(@"存储失败");
                _state = NO;
            }
            sqlite3_finalize(stmt);
    }
    else if (dBCenterType == DBCenterType_material_info){
        NSString *user_id = acontent.user_id;
        NSString *material_id = acontent.material_id;
        NSString *class_id = acontent.class_id;
        NSString *plate_id = acontent.plate_id;
        NSString *material_type = acontent.material_type;
        NSString *title = acontent.title;
        NSString *content = acontent.content;
        NSString *picture = acontent.picture;
        NSString *video = acontent.video;
        NSString *recommend_flag = acontent.recommend_flag;
        NSString *verify_user = acontent.verify_user;
        NSString *verify_status = acontent.verify_status;
        NSString *refuse_reasion = acontent.refuse_reasion;
        NSString *status = acontent.status;
        NSString *publish_site = acontent.publish_site;
        NSString *publish_user = acontent.publish_user;
        NSString *publish_time = acontent.publish_time;
        NSString *insert_user = acontent.insert_user;
        NSString *insert_time = acontent.insert_time;
        NSString *update_user = acontent.update_user;
        NSString *update_time = acontent.update_time;
        NSString *eduo_id = acontent.eduo_id;
        NSString *publish = acontent.publish;
        NSString *video_real_name = acontent.video_real_name;
        NSString *video_size = acontent.video_size;
        NSString *pictureurl = acontent.pictureurl;
        NSString *templet = acontent.templet;
        NSString *showPicture = acontent.showPicture;
        NSString *searchkey = acontent.searchkey;
        NSString *more_info = acontent.more_info;
        NSString *verify_time = acontent.verify_time;
        NSString *delete_user = acontent.delete_user;
        NSString *delete_time = acontent.delete_time;
        insertSql = [NSString stringWithFormat:@"insert into %@ (user_id,material_id,class_id,plate_id,material_type,title,content,picture,video,recommend_flag,verify_user,verify_status,refuse_reasion,status,publish_site,publish_user,publish_time,insert_user,insert_time,update_user,update_time,eduo_id,publish,video_real_name,video_size,pictureurl,templet,showPicture,searchkey,more_info,verify_time,delete_user,delete_time)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",dbTypeString];
        sqlite3_prepare_v2(dataBase, [insertSql UTF8String], -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [user_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [material_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [class_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [plate_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [material_type UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [title UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [content UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [picture UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [video UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 10, [recommend_flag UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 11, [verify_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 12, [verify_status UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 13, [refuse_reasion UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 14, [status UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 15, [publish_site UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 16, [publish_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 17, [publish_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 18, [insert_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 19, [insert_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 20, [update_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 21, [update_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 22, [eduo_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 23, [publish UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 24, [video_real_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 25, [video_size UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 26, [pictureurl UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 27, [templet UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 28, [showPicture UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 29, [searchkey UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 30, [more_info UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 31, [verify_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 32, [delete_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 33, [delete_time UTF8String], -1, NULL);

        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"存储成功");
            _state = YES;
        }
        else
        {
            //NSLog(@"存储失败");
            _state = NO;
        }
        sqlite3_finalize(stmt);
    }
    else if (dBCenterType == DBCenterType_plate_class){
        NSString *user_id = acontent.user_id;
        NSString *class_id = acontent.class_id;
        NSString *plate_id = acontent.plate_id;
        NSString *insert_user = acontent.insert_user;
        NSString *insert_time = acontent.insert_time;
        NSString *update_user = acontent.update_user;
        NSString *update_time = acontent.update_time;
        NSString *eduo_id = acontent.eduo_id;
        NSString *class_name = acontent.class_name;
        NSString *disp_name = acontent.disp_name;
        NSString *class_sort = acontent.class_sort;
        NSString *used_flag = acontent.used_flag;
        insertSql = [NSString stringWithFormat:@"insert into %@ (user_id,class_id,plate_id,insert_user,insert_time,update_user,update_time,eduo_id,class_name,disp_name,class_sort,used_flag)values(?,?,?,?,?,?,?,?,?,?,?,?)",dbTypeString];
        sqlite3_prepare_v2(dataBase, [insertSql UTF8String], -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [user_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [class_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [plate_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [insert_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [insert_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [update_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [update_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [eduo_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [class_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 10, [disp_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 11, [class_sort UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 12, [used_flag UTF8String], -1, NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"存储成功");
            _state = YES;
        }
        else
        {
            //NSLog(@"存储失败");
            _state = NO;
        }
        sqlite3_finalize(stmt);
    }
    else if (dBCenterType == DBCenterType_promissory_shops){
        NSString *material_id = acontent.material_id;
        NSString *id = acontent.id;
        NSString *scale = acontent.scale;
        NSString *product_code = acontent.product_code;
        NSString *address = acontent.address;
        NSString *longitude = acontent.longitude;
        NSString *sale_type = acontent.sale_type;
        NSString *sale_descript = acontent.sale_descript;
        NSString *telephone = acontent.telephone;
        insertSql = [NSString stringWithFormat:@"insert into %@ (material_id,id,scale,product_code,address,longitude,sale_type,sale_descript,telephone)values(?,?,?,?,?,?,?,?,?)",dbTypeString];
        sqlite3_prepare_v2(dataBase, [insertSql UTF8String], -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [material_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [scale UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [product_code UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [address UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [longitude UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [sale_type UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [sale_descript UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [telephone UTF8String], -1, NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"存储成功");
            _state = YES;
        }
        else
        {
            //NSLog(@"存储失败");
            _state = NO;
        }
        sqlite3_finalize(stmt);
    }
    else if (dBCenterType == DBCenterType_financial_products){
        NSString *material_id = acontent.material_id;
        NSString *id = acontent.id;
        NSString *product_code = acontent.product_code;
        NSString *product_ser = acontent.product_ser;
        NSString *risk_level = acontent.risk_level;
        NSString *subscribe_start = acontent.subscribe_start;
        NSString *subscribe_end = acontent.subscribe_end;
        NSString *value_date_from = acontent.value_date_from;
        NSString *value_date_to = acontent.value_date_to;
        NSString *product_struct = acontent.product_struct;
        NSString *expected_rite = acontent.expected_rite;
        NSString *min_amount = acontent.min_amount;
        NSString *manager_rite = acontent.manager_rite;
        NSString *receipt_time = acontent.receipt_time;
        NSString *asset_manager = acontent.asset_manager;
        NSString *detail_file = acontent.detail_file;
        NSString *file_name = acontent.file_name;
        NSString *file_size = acontent.file_size;
        NSString *ext_risk_level = acontent.ext_risk_level;
        NSString *ext_product_ser = acontent.ext_product_ser;

        insertSql = [NSString stringWithFormat:@"insert into %@ (material_id,id,product_code,product_ser,risk_level,subscribe_start,subscribe_end,value_date_from,value_date_to,product_struct,expected_rite,min_amount,manager_rite,receipt_time,asset_manager,detail_file,file_name,file_size,ext_risk_level,ext_product_ser)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",dbTypeString];
        sqlite3_prepare_v2(dataBase, [insertSql UTF8String], -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [material_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [product_code UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [product_ser UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [risk_level UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [subscribe_start UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [subscribe_end UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [value_date_from UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [value_date_to UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 10, [product_struct UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 11, [expected_rite UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 12, [min_amount UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 13, [manager_rite UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 14, [receipt_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 15, [asset_manager UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 16, [detail_file UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 17, [file_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 18, [file_size UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 19, [ext_risk_level UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 20, [ext_product_ser UTF8String], -1, NULL);

        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"存储成功");
            _state = YES;
        }
        else
        {
            //NSLog(@"存储失败");
            _state = NO;
        }
        sqlite3_finalize(stmt);
    }
    else if (dBCenterType == DBCenterType_user_remark){
        NSString *user_id = acontent.user_id;
        NSString *insert_user = acontent.insert_user;
        NSString *insert_time = acontent.insert_time;
        NSString *update_user = acontent.update_user;
        NSString *update_time = acontent.update_time;
        NSString *remark_id = acontent.remark_id;
        NSString *remark = acontent.remark;
        NSString *is_attention = acontent.is_attention;
        insertSql = [NSString stringWithFormat:@"insert into %@ (user_id,insert_user,insert_time,update_user,update_time,remark_id,remark,is_attention)values(?,?,?,?,?,?,?,?)",dbTypeString];
        sqlite3_prepare_v2(dataBase, [insertSql UTF8String], -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [user_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [insert_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [insert_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [update_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [update_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [remark_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [remark UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [is_attention UTF8String], -1, NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"存储成功");
            _state = YES;
        }
        else
        {
            //NSLog(@"存储失败");
            _state = NO;
        }
        sqlite3_finalize(stmt);
    }
    else if (dBCenterType == DBCenterType_user_info){
        NSString *user_id = acontent.user_id;
        NSString *disp_name = acontent.disp_name;
        NSString *verify_time = acontent.verify_time;
        NSString *telephone = acontent.telephone;
        NSString *remark = acontent.remark;
        NSString *insert_user = acontent.insert_user;
        NSString *insert_time = acontent.insert_time;
        NSString *update_user = acontent.update_user;
        NSString *update_time = acontent.update_time;
        NSString *pictureurl = acontent.pictureurl;
        NSString *login_name = acontent.login_name;
        NSString *real_name = acontent.real_name;
        NSString *vip_number = acontent.vip_number;
        NSString *password = acontent.password;
        NSString *user_consultant = acontent.user_consultant;
        NSString *user_type = acontent.user_type;
        NSString *user_photo = acontent.user_photo;
        NSString *user_status = acontent.user_status;
        NSString *verify_code = acontent.verify_code;
        NSString *expires_time = acontent.expires_time;
        NSString *verify_times = acontent.verify_times;
        NSString *email = acontent.email;
        NSString *mobile = acontent.mobile;
        NSString *qq_code = acontent.qq_code;
        NSString *wechat_code = acontent.wechat_code;
        NSString *blog_type = acontent.blog_type;
        NSString *blog_code = acontent.blog_code;
        NSString *user_changes = acontent.user_changes;
        NSString *user_direct1 = acontent.user_direct1;
        NSString *user_direct2 = acontent.user_direct2;
        NSString *user_direct3 = acontent.user_direct3;
        NSString *invention = acontent.invention;
        insertSql = [NSString stringWithFormat:@"insert into %@ (user_id,disp_name,verify_time,telephone,remark,insert_user,insert_time,update_user,update_time,pictureurl,login_name,real_name,vip_number,password,user_consultant,user_type,user_photo,user_status,verify_code,expires_time,verify_times,email,mobile,qq_code,wechat_code,blog_type,blog_code,user_changes,user_direct1,user_direct2,user_direct3,invention)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",dbTypeString];
        sqlite3_prepare_v2(dataBase, [insertSql UTF8String], -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [user_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [disp_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [verify_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [telephone UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [remark UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [insert_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [insert_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [update_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [update_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 10, [pictureurl UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 11, [login_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 12, [real_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 13, [vip_number UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 14, [password UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 15, [user_consultant UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 16, [user_type UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 17, [user_photo UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 18, [user_status UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 19, [verify_code UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 20, [expires_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 21, [verify_times UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 22, [email UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 23, [mobile UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 24, [qq_code UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 25, [wechat_code UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 26, [blog_type UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 27, [blog_code UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 28, [user_changes UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 29, [user_direct1 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 30, [user_direct2 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 31, [user_direct3 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 32, [invention UTF8String], -1, NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"存储成功");
            _state = YES;
        }
        else
        {
            //NSLog(@"存储失败");
            _state = NO;
        }
        sqlite3_finalize(stmt);
    }
    else if (dBCenterType == DBCenterType_plate_info){
        NSString *plate_id = acontent.plate_id;
        NSString *disp_name = acontent.disp_name;
        NSString *used_flag = acontent.used_flag;
        NSString *insert_user = acontent.insert_user;
        NSString *insert_time = acontent.insert_time;
        NSString *update_user = acontent.update_user;
        NSString *update_time = acontent.update_time;
        NSString *eduo_id = acontent.eduo_id;
        NSString *plate_name = acontent.plate_name;
        NSString *plate_sort = acontent.plate_sort;
        NSString *back_color = acontent.back_color;
        NSString *back_ground = acontent.back_ground;
        NSString *verify_flag = acontent.verify_flag;
        NSString *plate_url = acontent.plate_url;
        NSString *plate_flag = acontent.plate_flag;
        NSString *eduo_close = acontent.eduo_close;
        NSString *back_ground_url = acontent.back_ground_url;
        
        insertSql = [NSString stringWithFormat:@"insert into %@ (plate_id,disp_name,used_flag,insert_user,insert_time,update_user,update_time,eduo_id,plate_name,plate_sort,back_color,back_ground,verify_flag,plate_url,plate_flag,eduo_close,back_ground_url)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",dbTypeString];
        sqlite3_prepare_v2(dataBase, [insertSql UTF8String], -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [plate_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [disp_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [used_flag UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [insert_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [insert_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [update_user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [update_time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [eduo_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [plate_name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 10, [plate_sort UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 11, [back_color UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 12, [back_ground UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 13, [verify_flag UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 14, [plate_url UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 15, [plate_flag UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 16, [eduo_close UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 17, [back_ground_url UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"存储成功");
            _state = YES;
        }
        else
        {
            //NSLog(@"存储失败");
            _state = NO;
        }
        sqlite3_finalize(stmt);
    }



    
    [Datamanager closeDataBase];
    return _state;
}








#pragma mark - 没有做数据库时的收藏
- (id)initWithCollectionMaterialId:(NSString *)newMaterialId withImageDataURL:(NSString *)newImageURL withTitle:(NSString *)newTitle withModuleName:(NSString *)newModuleName withTemplet:(NSString *)newtemplet
{
    self = [super init];
    if (self) {
        self.materialId = newMaterialId;
        self.imageURL = newImageURL;
        self.title = newTitle;
        self.moduleName = newModuleName;
        self.templet = newtemplet;
    }
    return self;
}

+ (BOOL)saveCollectionWithmaterialId:(NSString *)newMaterialId withImageDataURL:(NSString *)newImageURL withTitle:(NSString *)newTitle withModuleName:(NSString *)newModuleName withTemplet:(NSString *)newtemplet
{
    BOOL _state;
    //打开数据库
    dataBase = [Datamanager openDatabase];
    sqlite3_stmt *stmt = nil;
    
    sqlite3_prepare_v2(dataBase, "insert into myCollection(materialId,imageURL,title,modeleName,templet) values(?,?,?,?,?)", -1, &stmt, nil);
    if (newMaterialId == NULL) {
        newMaterialId = @"";
    }
    if (newImageURL == NULL) {
        newImageURL = @"";
    }
    if (newTitle == NULL) {
        newTitle = @"";
    }
    if (newModuleName == NULL) {
        newModuleName = @"";
    }
    if (newtemplet == NULL) {
        newtemplet = @"";
    }
    sqlite3_bind_text(stmt, 1, [newMaterialId UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [newImageURL UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [newTitle UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 4, [newModuleName UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 5, [newtemplet UTF8String], -1, nil);
    if (sqlite3_step(stmt)==SQLITE_DONE) {
        NSLog(@"存储成功，关闭数据库");
        _state = YES;
    }
    else
    {
        NSLog(@"存储失败，关闭数据库");
        _state = NO;
    }
    [Datamanager closeDataBase];//关闭数据库
    return _state;
}
//查询数据库数据
+(NSMutableArray *)findAllMessage
{
    //打开数据库
    dataBase = [Datamanager openDatabase];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(dataBase, "select * from myCollection order by materialId desc", -1, &stmt, nil)==SQLITE_OK) {
        //创建一个可变数组存放所有取到的信息
        NSMutableArray *ary = [[NSMutableArray alloc]init];
        while (sqlite3_step(stmt) == SQLITE_ROW){

            const unsigned char *materialId = sqlite3_column_text(stmt, 1);            
            const unsigned char *iamgeurl = sqlite3_column_text(stmt, 2);
            const unsigned char *title = sqlite3_column_text(stmt, 3);
            const unsigned char *moduleName = sqlite3_column_text(stmt, 4);
            const unsigned char *templet = sqlite3_column_text(stmt, 5);
            DataBaseCenter *dataBC = [[DataBaseCenter alloc]initWithCollectionMaterialId:[NSString stringWithUTF8String:(const char *)materialId] withImageDataURL:[NSString stringWithUTF8String:(const char *)iamgeurl] withTitle:[NSString stringWithUTF8String:(const char *)title] withModuleName:[NSString stringWithUTF8String:(const char *)moduleName] withTemplet:[NSString stringWithUTF8String:(const char *)templet]];
            [ary addObject:dataBC];
        }
        //结束数据库
        sqlite3_finalize(stmt);
        return ary;
    }
    else
    {
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }
}

+(int)deletePalceID:(NSString *)aMaterialId
{
    //打开数据库
    dataBase = [Datamanager openDatabase];
    sqlite3_stmt *stmt = nil;
    //通过数据里的ID来删除数据
    sqlite3_prepare_v2(dataBase, "delete from myCollection where materialId = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [aMaterialId UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    NSLog(@"result.........%d",result);
    sqlite3_finalize(stmt);//结束数据库
    return result;
}

@end
