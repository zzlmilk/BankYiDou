//
//  EMELPFamily.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-5.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserEntity.h"


typedef enum {
     FriendTypeForFriend = 0,//好友
     FriendTypeForBlacklistFriend = 1,//黑名单好友
     FriendTypeForOther = 2 //其他好友
} FriendType;


@interface EMELPFamily : UserEntity
@property(nonatomic,strong)NSMutableArray* userAlbumArray;//相册地址数组
@property(nonatomic,assign)BOOL isOnline;//是否在线
@property(nonatomic,assign)FriendType friendType;//好友类型

-(void)setAttributeWithUserId:(NSString*)userId
                     UserName:(NSString*)userName
                 UserNickName:(NSString*)userNickName
                  UserHeadURL:(NSString*)userHeadURL
                      UserSex:(UserSexType)userSex
                  UserAddress:(NSString*)userAddress
                UserSignature:(NSString*)userSignature
                 UserTeamName:(NSString*)userTeamName
                 UserIndustry:(NSString*)userIndustry
                  UserJobName:(NSString*)userJobName
             UserRegisterDate:(NSDate*)userRegisterDate
               UserAlbumArray:(NSMutableArray*)userAlbumArray
                     isOnline:(BOOL)isOnline
                   FriendType:(FriendType)friendType;

//-(void)setAttributeWithDic:(NSDictionary*)dic;

@end
