//
//  EMELPFamily.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-5.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMELPFamily.h"

@implementation EMELPFamily


-(id)init
{
    self = [super init];
    if (self) {
        _userAlbumArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

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
                   FriendType:(FriendType)friendType
{
    self.userId = userId;
    self.userName = userName;
    self.userNickname = userNickName;
    if (userHeadURL) {
        self.userHeadURL = userHeadURL;
    }
    self.userSex = userSex;
    self.userAddress = userAddress;
    self.userSignature = userSignature;
    self.userTeamName = userTeamName;
    self.userIndustry = userIndustry;
    self.userJobName = userJobName;
    self.userRegisterDate = userRegisterDate;
    
    if (userAlbumArray) {
        [self.userAlbumArray removeAllObjects];
        [self.userAlbumArray addObjectsFromArray:userAlbumArray];
    }
     self.isOnline= isOnline;
    self.friendType= friendType;


}

//-(void)setAttributeWithDic:(NSDictionary*)dic
//{
//   [self setAttributeWithUserId:[dic objectForKey:@"UserId"]
//                       UserName:[dic objectForKey:@"UserName"]
//                   UserNickName:[dic objectForKey:@"UserNickName"]
//                    UserHeadURL:[dic objectForKey:@"UserHeadURL"]
//                        UserSex:[[dic objectForKey:@"UserSex"] intValue]
//                    UserAddress:[dic objectForKey:@"UserAddress"]
//                  UserSignature:[dic objectForKey:@"UserSignature"]
//                   UserTeamName:[dic objectForKey:@"UserTeamName"]
//                   UserIndustry:[dic objectForKey:@"UserIndustry"]
//                    UserJobName:[dic objectForKey:@"UserJobName"]
//               UserRegisterDate:[dic objectForKey:@"UserRegisterDate"]
//                 UserAlbumArray:[dic objectForKey:@"UserAlbumArray"]
//                       isOnline:[[dic objectForKey:@"isOnline"] boolValue]
//                     isMyFriend:[[dic objectForKey:@"isMyFriend"] boolValue]];
//}

@end
