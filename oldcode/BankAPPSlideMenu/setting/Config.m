//
//  Config.m
//  Association
//
//  Created by jinke on 3/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//  


#import "Config.h"

static NSString *kAssociationId = @"association_relay_china";
static NSString *kAccountId = @"accountId";
static NSString *kMsgId = @"msgID";


static NSString *kLayoutCfg = @"layoutCfg";
static NSString * const kUmengAppKey = @"abc";  // TODO: apply for umeng key


//static NSString *kUrlWebServer = @"http://172.16.204.228/data/ds";//服务器版本

static NSString *kUrlWebServer = @"http://117.79.93.103/data/ds";//服务器版本

static NSString *kServiceActioncatchBankRegistType = @"/uc/catchBankRegistType";//获取银行注册方式 1
static NSString *kServiceActioncheckPhoneExists = @"/uc/checkPhoneExists";//判断用户是否存在 2
//理财顾问ID查询接口（业务上暂不使用）  3
static NSString *kServiceActionsendSMS =@"/uc/sendSMS";//下发短信 4
static NSString *kServiceActionregistCheck = @"/uc/registCheck";//注册信息验证  5
static NSString *kServiceActionRegister = @"/uc/regist";//注册  6
static NSString *kServiceActionLogin = @"/uc/login";//登录 7
static NSString *kServiceActionucrecordUserStatusLog = @"/uc/recordUserStatusLog";//用户登陆日志记录接口   /uc/recordUserStatusLog     8   未完成
static NSString *kServiceActionlistConsultants = @"/uc/listConsultant";//理财顾问列表接口      /uc/listConsultants    9
static NSString *kServiceActioncatchConsultant = @"/uc/catchConsultant";//理财顾问详情接口      /uc/catchConsultant    10
static NSString *kServiceActionsetConsultantIdForVIP = @"/uc/changeConsultantForVIP";//设置     顾问接口      /uc/changeConsultantForVIP   11
static NSString *kServiceActionupdatePwdByOldPwd = @"/uc/changePwdByOldPwd";//更改密码接口         /uc/updatePwdByOldPwd      12                                                    
static NSString *kServiceActionupdatePwdByVercode = @"/uc/changePwdByVercode";//找回密码接口     13
static NSString *kServiceActioncatchBankPlates =@"/uc/listPlateInfo";  // 左侧栏  14
static NSString *kServiceActionmirecordUserStatusLog = @"/mi/recordUserOperateLog"; //记录用户登录状态日志 15
static NSString *kServiceActionlistPlateClass = @"/mi/listPlateClass";// 模块子分类列表接口 16
static NSString *kServiceActionmicatchMaterialInfos = @"/mi/listMaterialInfo";  //首页   17
static NSString *kServiceActionmicatchMaterialDetail = @"/mi/catchMaterialInfo";//素材详情接口         /mi/catchMaterialInfo     18   未完成
static NSString *kServiceActioncatchCustomerVIP = @"/uc/catchCustomerVIPWithRemark";//获取客户VIP详情数据(含备注)   /uc/catchCustomerVIP        19 
static NSString *kServiceActionlistCustomersVIPWithRemark = @"/uc/listCustomerVIPWithRemark";//理财顾问登陆获取VIP客户数据列表信息(含用户备注数据)  /uc/listCustomerVIPWithRemark    20
static NSString *kServiceActionlistCustomersVipWithOperateStatus = @"/uc/listCustomerVipWithOperateStatus";//获取针对指定素材操作的VIP客户列表信息        /uc/listCustomerVipWithOperateStatus      21    未完成
static NSString *kServiceActioncatchCustomerVIPWithOperateHistory = @"/uc/catchCustomerVIPWithOperateHistory";//22、	理财顾问获取客户VIP详细信息，含该客户的最近浏览记录
//23未写
static NSString *kServiceActionchangeAttention = @"/uc/changeAttention";//24 24、	理财顾问关注（取消关注）自己的VIP客户接口
static NSString *kServiceActionchangeRemark = @"/uc/changeRemark";//25.修改备注接口

static NSString *kServiceActionchangeUserMobile = @"/uc/changeUserMobile";//26.修改手机号码接口
static NSString *kServiceActionchangeUserOtherInfo = @"/uc/changeUserOtherInfo";//27、	用户更多信息修改接口

static NSString *kServiceActionUpdateMessagesStatu = @"/sc/updateMessagesStatu";//30. 修改消息状态接口
static NSString *kServiceActionuploadAndChangeUserPhoto = @"/uc/uploadAndChangeUserPhoto";//31、	上传并直接修改当前用户图标接口

static NSString *kServiceActionlistMaterialInfoForPage = @"/mi/listMaterialInfoForPage";//32 新素材列表接口

static NSString *kServiceActionCheckToken = @"/uc/checkToken";//33  验证用户token接口
static NSString *kServiceActionLogout = @"/uc/logout";//34  用户登出接口
static NSString *kServiceActionCatchLastVersion = @"vs/catchLastVersion";//35  软件最新版本信息接口

static NSString *kServiceActionGetCode = @"/Member/VerificationCode";//验证方式-未用

static NSString *Navigation = @"/Navigation";
static NSString *KServiceActionOption = @"/Utility/Dictionary";
static NSString *KServiceActionApply = @"/Action/Apply";
static NSString *KServiceActionCancel = @"/Action/Cancel";
static NSString *kServiceApplyApplyVote = @"/Vote/Post";

static NSString *kServiceActionGetAllMembers = @"/Member/List";
static NSString *kServiceActionGetLatestMembers = @"/Member/NewJoiners";
static NSString *kServiceActionGetMemberInfo = @"/Member/Detail";

static NSString *kServiceActionGetArticle = @"/Paper/List";
static NSString *kServiceActionGetArticleDetail = @"/Paper/Detail";

static NSString *kServiceActionGetPicture = @"/PictureM/NewList";
static NSString *kServiceActionGetpictureDetail = @"/Picture/Detail";
static NSString *kServiceGetMemberPictureList = @"/MemberPicture/LookMemberPicture";

static NSString *kServiceActionGetVoteList = @"/Vote/List";
static NSString *kServiceActionGetVoteDetail = @"/Vote/Detail";
static NSString *kServiceActionGetVotePost = @"/Vote/Post";

static NSString *kServiceActionGetAdvert = @"/NoticeV2";

static NSString *kServiceActionGetAction = @"/Action/List";
static NSString *kServiceActionGetActionDeatil = @"/Action/Detail";

static NSString *kServiceActionGetMemberDeatil = @"/Member/Detail";
// Forum
static NSString *kServiceFroum = @"/Forum";
static NSString *kServiceFroumList = @"/Forum/List";
static NSString *kServiceForumDetail = @"/Forum/Detail";
static NSString *kServiceForumDiscuss = @"Forum/Discuss";
static NSString *kServiceForumPost = @"/Forum/Post";
static NSString *kServiceForumReply = @"/Forum/Reply";
static NSString *kServiceForumDelete = @"/Forum/Delete";
static NSString *kServiceForumTop = @"/Forum/Top";
// Forum    end

static NSString *kServiceMemberResource = @"/Member/Resouce";

// Comment
static NSString *KServiceCommentPost = @"/Comment/Post";
static NSString *KServiceCommentPraise = @"/Comment/Praise";
static NSString *KServiceCommentDelete = @"/Comment/Delete";
static NSString *KServiceCommentAllow = @"/Comment/Allow";
// Comment end

static NSString *kServiceNoticeHome = @"/Notice/Home";

static NSString *kServiceImagePath = @"/Image?filename=";

static NSString *kServiceFaqList = @"/FAQ/List";
static NSString *kServiceFaqPost = @"/FAQ/Post";

// Video
static NSString *kServiceVideoList = @"/Video/List";
static NSString *kServiceVideoDetail = @"/Video/Detail";
// Video end

// Utility
static NSString *kServiceUtilityLatestVersion = @"/Utility/LatestVersion";
static NSString *kServiceUtilityParameter = @"/Utility/Parameter";
// Utility end

// Notice
static NSString *kServiceNotice = @"/NoticeV2";


static NSString *kServiceLog = @"/MemberLog/List";
// Notice end


@implementation Config
@synthesize userDefaults;
@synthesize umengAppKey;
@synthesize accountId;
@synthesize layoutCfg;
@synthesize settingCfg;

@synthesize msgId;



static Config *sharedConfig = nil;
+ (Config*)sharedInstance
{
    if (sharedConfig == nil) {
        sharedConfig = [[super allocWithZone:NULL] init];
        sharedConfig.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return sharedConfig;
}

-(NSString *)associationId {
    return kAssociationId;
}


#pragma mark - urls



-(NSString *)urlcatchBankRegistType{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActioncatchBankRegistType];  //1
}
-(NSString *)urlcheckPhoneExists{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActioncheckPhoneExists];     //2
}
-(NSString *)urlsendSMS{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionsendSMS];              //4
}
-(NSString *)urlregistCheck{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionregistCheck];          //5
}
- (NSString *)urlRegister
{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionRegister];             //6
}
-(NSString *)urlLogin {
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionLogin];               //7
}
-(NSString *)urlucrecordUserStatusLog{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionucrecordUserStatusLog];  // 8
}
-(NSString *)urllistConsultants{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionlistConsultants];     // 9
}
-(NSString *)urlcatchConsultant{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActioncatchConsultant];     // 10
}
-(NSString *)urlsetConsultantIdForVIP{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionsetConsultantIdForVIP];     // 11
}
-(NSString *)urlupdatePwdByOldPwd{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionupdatePwdByOldPwd];      //12
}
-(NSString *)urlupdatePwdByVercode{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionupdatePwdByVercode];     //13
}
-(NSString *)urlcatchBankPlates{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActioncatchBankPlates];         //14
}
-(NSString *)urlmirecordUserStatusLog{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionmirecordUserStatusLog];  //15
}
- (NSString *)urllistPlateClass
{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionlistPlateClass];          //16
}
-(NSString *)urlcatchMaterialInfos{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionmicatchMaterialInfos];    //17
}
-(NSString *)urlcatchMaterialDetail{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionmicatchMaterialDetail];    //18
}
-(NSString *)urlcatchCustomerVIP{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActioncatchCustomerVIP];         //19
}
-(NSString *)urllistCustomersVIPWithRemark{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionlistCustomersVIPWithRemark];         //20
}
-(NSString *)urllistCustomersVipWithOperateStatus{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionlistCustomersVipWithOperateStatus];         //21
}

-(NSString *)urlUpdateMessagesStatu{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionUpdateMessagesStatu];         //30
}
-(NSString *)urlCheckToken{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionCheckToken];//33
}
-(NSString *)urlLogout{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionLogout];//34
}
-(NSString *)urlcatchLastVersion{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionCatchLastVersion];//35
}

-(NSString *)urlcatchCustomerVIPWithOperateHistory{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActioncatchCustomerVIPWithOperateHistory];
}
-(NSString *)urlchangeAttention
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionchangeAttention];
}
-(NSString *)urlchangeUserMobile
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionchangeUserMobile];
}
-(NSString *)urlchangeRemark{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionchangeRemark];
}

- (NSString *)urlGetCode
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetCode];
}

- (NSString *)urlLayout
{
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, Navigation];
}

-(NSString *)urlGetArticles {
    return [NSString stringWithFormat:@"%@%@", kUrlWebServer, kServiceActionGetArticle];
}

-(NSString *)urlGetArticlesDetail{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer, kServiceActionGetArticleDetail];

}

-(NSString *)urlGetPictures{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer, kServiceActionGetPicture];
}

-(NSString *)urlGetPictureDetail{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer, kServiceActionGetpictureDetail];
}
-(NSString *)urlGetMemberPicList{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer, kServiceGetMemberPictureList];
}
-(NSString *)urllistMaterialInfoForPage{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer, kServiceActionlistMaterialInfoForPage];
}

-(NSString *)urlchangeUserOtherInfo{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionchangeUserOtherInfo];
}

-(NSString *)urluploadAndChangeUserPhoto{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionuploadAndChangeUserPhoto];
}


- (NSString *)urlGetImage:(NSString *)imageName width:(NSInteger )theWidth height:(NSInteger )theHeight{
    return [NSString stringWithFormat:@"%@/Image?filename=%@&w=%d&h=%d",kUrlWebServer,imageName,theWidth,theHeight];
}
- (NSString *)urlgetAdv{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetAdvert];
}


- (NSString *)urlgetAction
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetAction];
}

- (NSString *)urlgetActionDetail
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetActionDeatil];
}

- (NSString *)urlgetMemberDetail
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetMemberDeatil];
}

- (NSString *)urlgetOption
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,KServiceActionOption];
}

- (NSString *)urlActionApply
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,KServiceActionApply];
}

- (NSString *)urlActionCancel
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,KServiceActionCancel];
}

- (NSString *)urlgetVoteList
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetVoteList];
}
- (NSString *)urlgetVoteDetail
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetVoteDetail];
}
- (NSString *)urlgetVotePost
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetVotePost];
}

- (NSString *)urlApplyVote
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceApplyApplyVote];
}

- (NSString *)urlGetAllMembers {
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetAllMembers];
}

- (NSString *)urlGetLatestMembers {
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetLatestMembers];
}

- (NSString *)urlGetMemberInfo {
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetMemberInfo];
}

#pragma mark - Forum
- (NSString *)urlForum
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceFroum];
}

- (NSString *)urlForumList
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceFroumList];
}

- (NSString *)urlMemberResource
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceMemberResource];
}

- (NSString *)urlForumDetail
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceForumDetail];
}

- (NSString *)urlForumDiscuss
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceForumDiscuss];
}

- (NSString *)urlForumPost
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceForumPost];
}

- (NSString *)urlForumReply
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceForumReply];
}

- (NSString *)urlForumDelete
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceForumDelete];
}

- (NSString *)urlForumTop
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceForumTop];
}

#pragma mark - Video
- (NSString *)urlVideoList
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceVideoList];
}
- (NSString *)urlVideoDetail
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceVideoDetail];
}

#pragma mark - FAQ
- (NSString *)urlFaqList{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceFaqList];
}

- (NSString *)urlFaqPost{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceFaqPost];
}

#pragma mark - Utility
- (NSString *)urlUtilityLatestVersion
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceUtilityLatestVersion];
}

- (NSString *)urlUtilityParameter
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceUtilityParameter];
}

#pragma mark - Notice
- (NSString *)urlNotice
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceNotice];
}

- (NSString *)urlLog
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceLog];
}


#pragma mark - Comment
- (NSString *)urlCommentPost
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,KServiceCommentPost];
}
- (NSString *)urlCommentPraise
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,KServiceCommentPraise];
}
- (NSString *)urlCommentAllow
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,KServiceCommentAllow];
}
- (NSString *)urlCommentDelete
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,KServiceCommentDelete];
}


- (NSString *)urlNoticeHome
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceNoticeHome];
}

- (NSString *)urlClubNotice
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceActionGetAdvert];
}

- (NSString *)urlImagePath
{
    return [NSString stringWithFormat:@"%@%@",kUrlWebServer,kServiceImagePath];
}



#pragma mark - properties
-(void)setAccountId:(NSString *)theAccountId {
    [self.userDefaults setObject:theAccountId forKey:kAccountId];
    [self.userDefaults synchronize];
}

-(NSString *)accountId {
    return [self.userDefaults stringForKey:kAccountId];
}

-(void)setMsgId:(NSString *)theMsgId{
    [self.userDefaults setObject:theMsgId forKey:kMsgId];
    [self.userDefaults synchronize];
}

-(NSString *)msgId {
    return [self.userDefaults stringForKey:kMsgId];
}

-(NSString *)umengAppKey {
    return kUmengAppKey;
}

-(void)setLayoutCfg:(NSString *)theLayoutCfg {
    [self.userDefaults setObject:theLayoutCfg forKey:kLayoutCfg];
    [self.userDefaults synchronize];
}

-(NSString *)layoutCfg {
    return [self.userDefaults stringForKey:kLayoutCfg];
}
@end
