
#define CURRENT_APP_DOT_VERSION                              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define CURRENT_APP_VERSION                                  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define ISWIFI                                               ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]!= NotReachable)

//沙箱 分类
#define SANDBOX_CATEGORY_GROUP_PATH                          @"eme_category_group"
//城市配置数据
#define SANDBOX_AREA_PATH                                    @"eme_province_city_area"
//所属团队
#define SANDBOX_TEAM_PATH                                    @"eme_team"

//色块配置
#define SANDBOX_COLOR_PATH                                   @"colors"
//文字大小配置
#define SANDBOX_FONT_PATH                                    @"fonts"
//公告
#define SANDBOX_NOTICE_PATH                                  @"eme_notice"
//应用配置
#define SANDBOX_CONFIG_PATH                                  @"config"
//联系我们
#define SANDBOX_CONTACTUS_PATH                               @"contactus"
//图片
#define ImageCache                                           @"ImageCache"
// sizeWithFont 方法传入的高度
#define theSizeHeight                                         99999

//系统设置
#define EME_USER_AUTOLOGIN_USERDEFAULT_KEY                   @"EME_USER_AUTOLOGIN_USERDEFAULT_KEY"//是否自动登录

#define EME_NEWMESSAGE_NOTIFICATION_USERDEFAULT_KEY          @"EME_NEWMESSAGE_NOTIFICATION_USERDEFAULT_KEY"//是否接收新消息通知   --- 注意默认开启，所以NO 表示开启
#define EME_NEWMESSAGE_VOICE_USERDEFAULT_KEY                 @"EME_NEWMESSAGE_VOICE_USERDEFAULT_KEY"//是否有提示声音   --- 注意默认开启，所以NO 表示开启
#define EME_NEWMESSAGE_SHAKE_USERDEFAULT_KEY                 @"EME_NEWMESSAGE_SHAKE_USERDEFAULT_KEY"//是否有震动     --- 注意默认开启，所以NO 表示开启

#define EME_NEWMESSAGE_NEEDVALIDATE_USERDEFAULT_KEY          @"EME_NEWMESSAGE_NEEDVALIDATE_USERDEFAULT_KEY"//加好友需要验证
//取window高度
#define GETSCREENHEIGHT                                      ([[[UIDevice currentDevice] systemVersion] intValue]<7?([[UIScreen mainScreen] bounds].size.height-([UIApplication sharedApplication].statusBarHidden?0:20.0)):([[UIScreen mainScreen] bounds].size.height))

#define EME_SYSTEMVERSION                                    [[[UIDevice currentDevice] systemVersion] intValue]


#define IS_IPHONE                                            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define IS_IPOD                                              [[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]


//颜色获取
#define UIColorFromRGB(rgbValue)                             [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorWithAlphaFromRGB(rgbValue,alpha)              [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]
 
//url参数是否utf-16编码
#define IS_UTF16ENCODE                                      NO
//获取用户的id
#define CurrentUserID                                       [UserManager shareInstance].user.userId

#define HaveNewMessageNotice @"HaveNewMessageNotice"  //有一条新消息

//接口地址        config.json文件配置
#ifdef DEBUG
#define EMERequestURL                                    [[EMEConfigManager shareConfigManager] getDebugAppUrl]
#define IMSSERVERHOST                                    [[EMEConfigManager shareConfigManager] getDebugServerHost]
#define IMSSERVERPORT                                    [[[EMEConfigManager shareConfigManager] getDebugServerPort] intValue]

#else
#define EMERequestURL                                    [[EMEConfigManager shareConfigManager] getReleaseAppUrl]
#define IMSSERVERHOST                                    [[EMEConfigManager shareConfigManager] getReleaseServerHost]
#define IMSSERVERPORT                                    [[[EMEConfigManager shareConfigManager] getReleaseServerPort] intValue]

#endif

//图片接口地址
#define EME_IMAGE_UPLOAD_URL_PRIFIX                          @""
//上传图片接口地址
#define EMEURL_UPLOADIMAGE                                   [NSString stringWithFormat:@"%@/emeupload",EME_IMAGE_UPLOAD_URL_PRIFIX]

//图片相对路径
#define EME_IMAGE_URL_PRIFIX                                 @""

//图片绝对路径
#define IMAGE_URL(imgurl)                                    [NSString stringWithFormat:@"%@%@",EME_IMAGE_URL_PRIFIX,imgurl]


//取颜色
#define UIColorFromString(value) [[EMEConfigManager shareConfigManager] evColorForKey:value]
//取字体大小
#define UIFontFromString(value) [[EMEConfigManager shareConfigManager] evFontForKey:value]

#define MAPAPIKey  @"7df4a522cfdd7bd2ce23ea35ea6ebcac"

typedef enum {
    EME_SPEEDDIAL_HOME,//菜单九宫格
    EME_SPEEDDIAL_GROUP,//团购九宫格
} EMESPEEDDIALTYPE;


typedef enum {
    EMEServiceTypeForTrade = 0,//销售
    EMEServiceTypeForLPFamily = 1,//LP家族
    EMEServiceTypeForPersonCenter,//个人中心
    EMEServiceTypeForGroupMien,//团队风采
    EMEServiceTypeForActivity,//活动聚会
    EMEServiceTypeForClinic,//企业诊所
    EMEServiceTypeForFiscal,//融资
    EMEServiceTypeForTalent,//投资
    EMEServiceTypeForMap, //地图－公司列表
    EMEServiceTypeForNews,//新闻咨询
    EMEServiceTypeForNotice,//通知公告
    EMEServiceTypeForRecommend,//新品推荐
    EMEServiceTypeForCases, //成功案例
    EMEServiceTypeForShop, //吉祥美食
    EMEServiceTypeForCommon,//共用模块
    EMEServiceTypeForRecruit, //招聘
    EMEServiceTypeForMerchants,//招商加盟
    EMEServiceTypeForAboutUs//关于我们
}EMEServiceType;
 
typedef enum {
    TipsHorizontalPostionForCenter,//默认居中
    TipsHorizontalPostionForLeft,
    TipsHorizontalPostionForRight,
}TipsHorizontalPostion;//提示水平位置控制

typedef enum
{
    TipsVerticalPostionForCenter = 0,//默认居中
    TipsVerticalPostionForBelowNavGation,
    TipsVerticalPostionForBottom//注意显示在下面的，如果传递view过来，则需要使用有箭头的图标
} TipsVerticalPostion;//提示垂直位置，上中下


typedef enum {
    TipsTypeForNone,
    TipsTypeForSuccess,
    TipsTypeForFail,
    TipsTypeForWorning,
} TipsType;//提示类型

typedef enum {
    TipsPositionTypeForTopBelowNavGation,
    TipsPositionTypeForCenter,
    TipsPositionTypeForBottom,//注意显示在下面的，如果传递view过来，则需要使用有箭头的图标
    
} TipsPositionType;//提示显示位置，上中下



