//
//  Config.h
//  Association
//
//  Created by jinke on 3/23/13.
//  Copyright (c) 2013 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SDWebImageCompat.h"

@interface Config : NSObject

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSString *layoutCfg;
@property (strong, nonatomic) NSString *settingCfg;
@property (weak, readonly, nonatomic) NSString *umengAppKey;
@property (weak, readonly, nonatomic) NSString *associationId;
@property (strong, nonatomic) NSString *accountId;
@property (strong, nonatomic) NSString *msgId;
+ (Config*) sharedInstance;

-(NSString *)urlUpdateMessagesStatu;
-(NSString *)urlcatchLastVersion;
-(NSString *)urlLogout;
-(NSString *)urlCheckToken;
-(NSString *)urlucrecordUserStatusLog;
-(NSString *)urlchangeRemark;
-(NSString *)urluploadAndChangeUserPhoto;
-(NSString *)urlchangeUserOtherInfo;
-(NSString *)urllistMaterialInfoForPage;
-(NSString *)urlchangeUserMobile;
-(NSString *)urlchangeAttention;
-(NSString *)urlcatchCustomerVIPWithOperateHistory;
-(NSString *)urlmirecordUserStatusLog;
-(NSString *)urllistCustomersVipWithOperateStatus;
-(NSString *)urllistCustomersVIPWithRemark;
-(NSString *)urlcatchCustomerVIP;
-(NSString *)urlcatchMaterialDetail;
-(NSString *)urlsetConsultantIdForVIP;
-(NSString *)urlcatchConsultant;
-(NSString *)urllistConsultants;
-(NSString *)urlupdatePwdByOldPwd;
-(NSString *)urlupdatePwdByVercode;
-(NSString *)urlcatchMaterialInfos;
-(NSString *)urlcatchBankPlates;
-(NSString *)urlregistCheck;
-(NSString *)urlcatchBankRegistType;
-(NSString *)urlRegister;
-(NSString *)urlLogin;
-(NSString *)urlsendSMS;
-(NSString *)urlcheckPhoneExists;
- (NSString *)urlGetCode;
- (NSString *)urlLayout;
- (NSString *)urlGetArticles;
- (NSString *)urlGetArticlesDetail;
- (NSString *)urlGetPictures;
- (NSString *)urlGetPictureDetail;
- (NSString *)urlGetImage:(NSString *)imageName width:(NSInteger)theWidth height:(NSInteger)theHeight;
- (NSString *)urllistPlateClass;
- (NSString *)urlgetAdv;
- (NSString *)urlgetAction;
- (NSString *)urlgetActionDetail;
- (NSString *)urlgetOption;
- (NSString *)urlActionApply;
- (NSString *)urlActionCancel;

- (NSString *)urlgetVoteList;
- (NSString *)urlgetVoteDetail;
- (NSString *)urlgetVotePost;

- (NSString *)urlApplyVote;
- (NSString *)urlgetMemberDetail;


- (NSString *)urlGetAllMembers;
- (NSString *)urlGetLatestMembers;
- (NSString *)urlGetMemberInfo;
// Forum
- (NSString *)urlForum;
- (NSString *)urlForumList;
- (NSString *)urlForumDetail;
- (NSString *)urlForumDiscuss;
- (NSString *)urlForumPost;
- (NSString *)urlForumReply;
- (NSString *)urlForumDelete;
- (NSString *)urlForumTop;
// Forum    end

- (NSString *)urlImagePath;

// Comment
- (NSString *)urlCommentPost;
- (NSString *)urlCommentPraise;
- (NSString *)urlCommentAllow;
- (NSString *)urlCommentDelete;
// Comment end

// Video
- (NSString *)urlVideoList;
- (NSString *)urlVideoDetail;
// Video end

// FAQ
- (NSString *)urlFaqList;
- (NSString *)urlFaqPost;
// FAQ end

// Utility
- (NSString *)urlUtilityLatestVersion;
- (NSString *)urlUtilityParameter;
// Utility end

// Notice
- (NSString *)urlNotice;
// Notice end

// log
- (NSString *)urlLog;

- (NSString *)urlNoticeHome;

- (NSString *)urlMemberResource;

- (NSString *)associationId;

//成员图片列表
-(NSString *)urlGetMemberPicList;
@end
