//
//  Content.m
//  BankAPP
//
//  Created by LiuXueQun on 14-5-7.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "Content.h"

@implementation Content

@synthesize user_id;
@synthesize material_id;
@synthesize class_id;
@synthesize plate_id;

@synthesize read_flag;
@synthesize praise_flag;
@synthesize collect_flag;
@synthesize join_flag;
@synthesize read_times;
@synthesize first_time;
@synthesize last_time;
@synthesize praise_time;
@synthesize collect_time;
@synthesize join_time;

@synthesize material_type;
@synthesize title;
@synthesize content;
@synthesize picture;
@synthesize video;
@synthesize recommend_flag;
@synthesize verify_user;
@synthesize verify_status;
@synthesize refuse_reasion;
@synthesize status;
@synthesize publish_site;
@synthesize publish_user;
@synthesize publish_time;
@synthesize insert_user;
@synthesize insert_time;
@synthesize update_user;
@synthesize update_time;
@synthesize eduo_id;
@synthesize publish;
@synthesize video_real_name;
@synthesize video_size;
@synthesize pictureurl;
@synthesize templet;
@synthesize showPicture;
@synthesize searchkey;
@synthesize more_info;
@synthesize verify_time;
@synthesize delete_user;
@synthesize delete_time;

@synthesize class_name;
@synthesize disp_name;
@synthesize class_sort;
@synthesize used_flag;

@synthesize id;
@synthesize scale;
@synthesize product_code;
@synthesize address;
@synthesize longitude;
@synthesize sale_type;
@synthesize sale_descript;
@synthesize telephone;

@synthesize product_ser;
@synthesize risk_level;
@synthesize subscribe_start;
@synthesize subscribe_end;
@synthesize value_date_from;
@synthesize value_date_to;
@synthesize product_struct;
@synthesize expected_rite;
@synthesize min_amount;
@synthesize manager_rite;
@synthesize receipt_time;
@synthesize asset_manager;
@synthesize detail_file;
@synthesize file_name;
@synthesize file_size;
@synthesize ext_risk_level;
@synthesize ext_product_ser;

//DBCenterType_user_remark://移动端用户备注表  8
//user_id  insert_user  insert_time  update_user   update_time
@synthesize remark_id;
@synthesize remark;
@synthesize is_attention;

@synthesize login_name;
@synthesize real_name;
@synthesize vip_number;
@synthesize password;
@synthesize user_consultant;
@synthesize user_type;
@synthesize user_photo;
@synthesize user_status;
@synthesize verify_code;
@synthesize expires_time;
@synthesize verify_times;
@synthesize email;
@synthesize mobile;
@synthesize qq_code;
@synthesize wechat_code;
@synthesize blog_type;
@synthesize blog_code;
@synthesize user_changes;
@synthesize user_direct1;
@synthesize user_direct2;
@synthesize user_direct3;
@synthesize invention;

//DBCenterType_plate_info://左侧请求模块  17
//plate_id   disp_name   used_flag   insert_user   insert_time   update_user   update_time   eduo_id
@synthesize plate_name;
@synthesize plate_sort;
@synthesize back_color;
@synthesize back_ground;
@synthesize verify_flag;
@synthesize plate_url;
@synthesize plate_flag;
@synthesize eduo_close;
@synthesize back_ground_url;




@end
