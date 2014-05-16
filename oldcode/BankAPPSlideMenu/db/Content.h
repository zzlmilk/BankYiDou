//
//  Content.h
//  BankAPP
//
//  Created by LiuXueQun on 14-5-7.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Content : NSObject

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *material_id;
@property (nonatomic, strong) NSString *class_id;
@property (nonatomic, strong) NSString *plate_id;

//DBCenterType_material_user  素材信息用户关联表 10+2
/*user_id  用户ID
 *material_id  素材ID
 */
@property (nonatomic, strong) NSString *read_flag;//阅读标志
@property (nonatomic, strong) NSString *praise_flag;//赞标志
@property (nonatomic, strong) NSString *collect_flag;//收藏标志
@property (nonatomic, strong) NSString *join_flag;//参加标志
@property (nonatomic, strong) NSString *read_times;//阅读次数
@property (nonatomic, strong) NSString *first_time;//第一次阅读时间
@property (nonatomic, strong) NSString *last_time;//最后一次阅读时间
@property (nonatomic, strong) NSString *praise_time;//赞时间
@property (nonatomic, strong) NSString *collect_time;//收藏时间
@property (nonatomic, strong) NSString *join_time;//参加时间

//DBCenterType_material_info://素材信息 29+4
/*user_id   
 *material_id   素材ID
 *class_id  板块分类ID
 *plate_id  板块ID
 */
@property (nonatomic, strong) NSString *material_type; //素材类型
@property (nonatomic, strong) NSString *title;//素材标题
@property (nonatomic, strong) NSString *content;//文字内容
@property (nonatomic, strong) NSString *picture;//图片信息
@property (nonatomic, strong) NSString *video;//视频信息
@property (nonatomic, strong) NSString *recommend_flag;//推荐标志
@property (nonatomic, strong) NSString *verify_user;//审核人
@property (nonatomic, strong) NSString *verify_status;//审核状态
@property (nonatomic, strong) NSString *refuse_reasion;//未通过原因
@property (nonatomic, strong) NSString *status;//状态
@property (nonatomic, strong) NSString *publish_site;//素材发布方
@property (nonatomic, strong) NSString *publish_user;//发布者
@property (nonatomic, strong) NSString *publish_time;//发布时间
@property (nonatomic, strong) NSString *insert_user;//登陆者
@property (nonatomic, strong) NSString *insert_time;//登录时间
@property (nonatomic, strong) NSString *update_user;//变更者
@property (nonatomic, strong) NSString *update_time;//变更时间
@property (nonatomic, strong) NSString *eduo_id;//对应eduoId
@property (nonatomic, strong) NSString *publish;//素材状态
@property (nonatomic, strong) NSString *video_real_name;//视频名
@property (nonatomic, strong) NSString *video_size;//视频大小
@property (nonatomic, strong) NSString *pictureurl;//图片url
@property (nonatomic, strong) NSString *templet;//板块
@property (nonatomic, strong) NSString *showPicture;//图片是否显示
@property (nonatomic, strong) NSString *searchkey;//搜索主键
@property (nonatomic, strong) NSString *more_info;//额外表示信息
@property (nonatomic, strong) NSString *verify_time;//审核时间
@property (nonatomic, strong) NSString *delete_user;//删除人
@property (nonatomic, strong) NSString *delete_time;//删除时间

//DBCenterType_plate_class://VIP特权、尊享理财一级列表信息  12
/*user_id
 *class_id   分类ID
 *plate_id   板块ID
 *insert_user  登陆者
 *insert_time  登陆时间
 *update_user   变更者
 *update_time  变更时间
 *eduo_id  对应eduoId
 */
@property (nonatomic, strong) NSString *class_name; //系统名
@property (nonatomic, strong) NSString *disp_name;  //显示名
@property (nonatomic, strong) NSString *class_sort;//显示顺序
@property (nonatomic, strong) NSString *used_flag;//启用标志

//DBCenterType_promissory_shops://VIP特权详细信息 9个字段
/*material_id  素材ID
 */
@property (nonatomic, strong) NSString *id;//商户ID
@property (nonatomic, strong) NSString *scale;//范围
@property (nonatomic, strong) NSString *product_code;//产品编号
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *longitude;//百度地图链接
@property (nonatomic, strong) NSString *sale_type;//优惠类型
@property (nonatomic, strong) NSString *sale_descript;//优惠说明
@property (nonatomic, strong) NSString *telephone;//电话

//DBCenterType_financial_products
//理财产品表 比服务器多了2个字段ext_risk_level，ext_product_ser   20
/*id   理财产品ID
 *material_id   素材ID
 *product_code  产品编码
 */
@property (nonatomic, strong) NSString *product_ser; //产品系列（用下边那个ext_product_ser）
@property (nonatomic, strong) NSString *risk_level;//风险等级(用下边那个ext_risk_level)
@property (nonatomic, strong) NSString *subscribe_start;//认购开始时间
@property (nonatomic, strong) NSString *subscribe_end;//认购结束时间
@property (nonatomic, strong) NSString *value_date_from;//起息日
@property (nonatomic, strong) NSString *value_date_to;//到息日
@property (nonatomic, strong) NSString *product_struct;//产品结构
@property (nonatomic, strong) NSString *expected_rite;//预期收益率
@property (nonatomic, strong) NSString *min_amount;//起购额
@property (nonatomic, strong) NSString *manager_rite;//产品管理费率
@property (nonatomic, strong) NSString *receipt_time;//到账时间
@property (nonatomic, strong) NSString *asset_manager;//资产管理人
@property (nonatomic, strong) NSString *detail_file;//详细资料
@property (nonatomic, strong) NSString *file_name;//file_name
@property (nonatomic, strong) NSString *file_size;//file_size
@property (nonatomic, strong) NSString *ext_risk_level;
@property (nonatomic, strong) NSString *ext_product_ser;

//DBCenterType_user_remark://移动端用户备注表  8
/*user_id   用户ID
 *insert_user  创建人
 *insert_time  创建时间
 *update_user   修改人
 *update_time   修改时间
 ***/
@property (nonatomic, strong) NSString *remark_id; //备注ID
@property (nonatomic, strong) NSString *remark;  //备注
@property (nonatomic, strong) NSString *is_attention; //是否关注

//DBCenterType_user_info://移动端用户表   32
/*user_id  用户ID
 *disp_name   昵称
 *verify_time   最后一次验证码获得时间
 *telephone   电话/座机号
 *remark   备注
 *insert_user 创建人
 *insert_time   创建时间
 *update_user  修改人
 *update_time  修改时间
 *pictureurl 头像url
 */
@property (nonatomic, strong) NSString *login_name;//用户名
@property (nonatomic, strong) NSString *real_name;//姓名
@property (nonatomic, strong) NSString *vip_number;//vip编号
@property (nonatomic, strong) NSString *password;//密码
@property (nonatomic, strong) NSString *user_consultant;//用户顾问
@property (nonatomic, strong) NSString *user_type;//用户类型
@property (nonatomic, strong) NSString *user_photo;//头像
@property (nonatomic, strong) NSString *user_status;//状态
@property (nonatomic, strong) NSString *verify_code;//验证码
@property (nonatomic, strong) NSString *expires_time;//验证码过期时间
@property (nonatomic, strong) NSString *verify_times;//验证码获得次数
@property (nonatomic, strong) NSString *email;//邮箱
@property (nonatomic, strong) NSString *mobile;//手机号
@property (nonatomic, strong) NSString *qq_code;//QQ
@property (nonatomic, strong) NSString *wechat_code;//微信号
@property (nonatomic, strong) NSString *blog_type;//微博类型
@property (nonatomic, strong) NSString *blog_code;//微博号
@property (nonatomic, strong) NSString *user_changes;//用户最后修改次数
@property (nonatomic, strong) NSString *user_direct1;//一级督导
@property (nonatomic, strong) NSString *user_direct2;//二级督导
@property (nonatomic, strong) NSString *user_direct3;//三级督导
@property (nonatomic, strong) NSString *invention;//邀请码

//DBCenterType_plate_info://左侧请求模块  17
/*plate_id   板块ID
 *disp_name   显示名
 *used_flag   启用标志
 *insert_user   登陆者
 *insert_time   登陆时间
 *update_user   变更者
 *update_time   变更时间
 *eduo_id   对应eduo_Id
 */
@property (nonatomic, strong) NSString *plate_name;//板块名字
@property (nonatomic, strong) NSString *plate_sort;//板块顺序
@property (nonatomic, strong) NSString *back_color;//背景色
@property (nonatomic, strong) NSString *back_ground;//背景图
@property (nonatomic, strong) NSString *verify_flag;//素材审核标志
@property (nonatomic, strong) NSString *plate_url;//启用url链接
@property (nonatomic, strong) NSString *plate_flag;//板块类型
@property (nonatomic, strong) NSString *eduo_close;//eduo关闭
@property (nonatomic, strong) NSString *back_ground_url;//背景图url



@end
