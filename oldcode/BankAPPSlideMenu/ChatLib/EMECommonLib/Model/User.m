//
//  User.m
//
//  Created by Sean on 11/29/12.
//

#import "User.h"



@implementation User


-(id)initWithAttributes:(NSDictionary*)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self setAttributes:attributes];
    
    return self;
}

-(void)setAttributes:(NSDictionary*)attributes
{
    _isRemeberPassword = [[attributes valueForKey:@"isRemeberPassword"] boolValue];
    _isAutoLogin = [[attributes valueForKey:@"isAutoLogin"] boolValue];
    _isAgreeAgreement = [[attributes valueForKey:@"isAgreeAgreement"] boolValue];
    _userPassword = [attributes valueForKey:@"userPassword"];

    
    self.userId  = [attributes valueForKey:@"userId"];
    self.userName = [attributes valueForKey:@"userName"];
    self.userHeadURL = [attributes valueForKey:@"userHeadURL"];
    self.userSex  =  [[attributes valueForKey:@"userSex"] intValue];
    self.userAddress = [attributes valueForKey:@"userAddress"];
    
    self.userPhoneNumber = [attributes valueForKey:@"userPhoneNumber"];
    self.userNickname = [attributes valueForKey:@"userNickname"];
    self.userIdCard = [attributes valueForKey:@"userIdCard"];
    self.userProvince = [attributes valueForKey:@"userProvince"];
    self.userCity = [attributes valueForKey:@"userCity"];
    self.userProvinceId = [attributes valueForKey:@"userProvinceId"];
    self.userCityId = [attributes valueForKey:@"userCityId"];
    self.userRealName = [attributes valueForKey:@"userRealName"];
    self.userEmail = [attributes valueForKey:@"userEmail"];
    
    self.leftUpLastTime = [attributes valueForKey:@"leftUpLastTime"];

    self.userBirthday = [attributes valueForKey:@"userBirthday"];
    self.userSalary = [attributes valueForKey:@"userSalary"];
    
    self.userSignature = [attributes valueForKey:@"userSignature"];
    self.userTeamName = [attributes valueForKey:@"userTeamName"];
    self.userTeamId = [attributes valueForKey:@"userTeamId"];
    self.userIndustry = [attributes valueForKey:@"userIndustry"];
    self.userJobName = [attributes valueForKey:@"userJobName"];
    self.userRegisterDate = [attributes valueForKey:@"userRegisterDate"];

    _userSNSActiveType = [[attributes valueForKey:@"userSNSActiveType"] intValue];
    _userSNSToken = [attributes valueForKey:@"userSNSToken"];
    _userSNSUserId = [attributes valueForKey:@"userSNSUserId"];
    _userSNSExpireTime  = [[attributes valueForKey:@"userSNSExpireTime"] doubleValue];
    _userSNSsInfoDic  = [NSMutableDictionary dictionaryWithDictionary:[attributes valueForKey:@"userSNSsInfoDic"]];
    self.operate = [attributes valueForKey:@"operate"];
    self.manage = [attributes valueForKey:@"manage"];

  }


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    _isRemeberPassword = [[aDecoder decodeObjectForKey:@"isRemeberPassword"] boolValue];
    _isAutoLogin = [[aDecoder decodeObjectForKey:@"isAutoLogin"] boolValue];
    _isAgreeAgreement = [[aDecoder decodeObjectForKey:@"isAgreeAgreement"] boolValue];
    _userPassword = [aDecoder decodeObjectForKey:@"userPassword"];

 
    
    self.userId  = [aDecoder decodeObjectForKey:@"userId"];
    self.userName = [aDecoder decodeObjectForKey:@"userName"];
    self.userHeadURL = [aDecoder decodeObjectForKey:@"userHeadURL"];
    self.userSex  =  [[aDecoder decodeObjectForKey:@"userSex"] intValue];
    self.userAddress = [aDecoder decodeObjectForKey:@"userAddress"];
    
    self.userPhoneNumber = [aDecoder decodeObjectForKey:@"userPhoneNumber"];
    self.userNickname = [aDecoder decodeObjectForKey:@"userNickname"];
    self.userIdCard = [aDecoder decodeObjectForKey:@"userIdCard"];
    self.userRealName = [aDecoder decodeObjectForKey:@"userRealName"];
    self.userProvince= [aDecoder decodeObjectForKey:@"userProvince"];
    self.userCity = [aDecoder decodeObjectForKey:@"userCity"];
    self.userProvinceId= [aDecoder decodeObjectForKey:@"userProvinceId"];
    self.userCityId = [aDecoder decodeObjectForKey:@"userCityId"];
    self.userEmail = [aDecoder decodeObjectForKey:@"userEmail"];
    
    self.leftUpLastTime = [aDecoder decodeObjectForKey:@"leftUpLastTime"];

    self.userBirthday = [aDecoder decodeObjectForKey:@"userBirthday"];
    self.userSalary = [aDecoder decodeObjectForKey:@"userSalary"];
    
    self.userSignature = [aDecoder decodeObjectForKey:@"userSignature"];
    self.userTeamName = [aDecoder decodeObjectForKey:@"userTeamName"];
    self.userTeamId = [aDecoder decodeObjectForKey:@"userTeamId"];
    self.userIndustry = [aDecoder decodeObjectForKey:@"userIndustry"];
    self.userJobName = [aDecoder decodeObjectForKey:@"userJobName"];
    self.userRegisterDate = [aDecoder decodeObjectForKey:@"userRegisterDate"];
    
    _userSNSActiveType = [[aDecoder decodeObjectForKey:@"userSNSActiveType"] intValue];
    _userSNSToken = [aDecoder decodeObjectForKey:@"userSNSToken"];
    _userSNSUserId = [aDecoder decodeObjectForKey:@"userSNSUserId"];
    _userSNSExpireTime  = [[aDecoder decodeObjectForKey:@"userSNSExpireTime"] doubleValue];
    _userSNSsInfoDic  =  [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[aDecoder decodeObjectForKey:@"userSNSsInfoDic"]];
    self.operate = [aDecoder decodeObjectForKey:@"operate"];
    self.manage = [aDecoder decodeObjectForKey:@"manage"];
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:[NSNumber numberWithBool:_isAutoLogin] forKey:@"isAutoLogin"];
    [aCoder encodeObject:[NSNumber numberWithBool:_isRemeberPassword] forKey:@"isRemeberPassword"];
    [aCoder encodeObject:[NSNumber numberWithBool:_isAgreeAgreement] forKey:@"isAgreeAgreement"];
    [aCoder encodeObject:_userPassword forKey:@"userPassword"];

    
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.userHeadURL forKey:@"userHeadURL"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.userSex] forKey:@"userSex"];
    [aCoder encodeObject:self.userAddress forKey:@"userAddress"];

    [aCoder encodeObject:self.userPhoneNumber forKey:@"userPhoneNumber"];
    [aCoder encodeObject:self.userNickname forKey:@"userNickname"];
    [aCoder encodeObject:self.userIdCard forKey:@"userIdCard"];
    [aCoder encodeObject:self.userProvince forKey:@"userProvince"];
    [aCoder encodeObject:self.userCity forKey:@"userCity"];
    [aCoder encodeObject:self.userProvinceId forKey:@"userProvinceId"];
    [aCoder encodeObject:self.userCityId forKey:@"userCityId"];
    [aCoder encodeObject:self.userRealName forKey:@"userRealName"];
    [aCoder encodeObject:self.userEmail forKey:@"userEmail"];
    
    [aCoder encodeObject:self.leftUpLastTime forKey:@"leftUpLastTime"];

    [aCoder encodeObject:self.userBirthday forKey:@"userBirthday"];
    [aCoder encodeObject:self.userSalary forKey:@"userSalary"];
    
    [aCoder encodeObject:self.userSignature forKey:@"userSignature"];
    [aCoder encodeObject:self.userTeamName forKey:@"userTeamName"];
    [aCoder encodeObject:self.userIndustry forKey:@"userIndustry"];
    [aCoder encodeObject:self.userJobName forKey:@"userJobName"];
    [aCoder encodeObject:self.userRegisterDate forKey:@"userRegisterDate"];
    
    [aCoder encodeObject:[NSNumber numberWithInt:_userSNSActiveType] forKey:@"userSNSActiveType"];
    [aCoder encodeObject:_userSNSToken forKey:@"userSNSToken"];
    [aCoder encodeObject:_userSNSUserId forKey:@"userSNSUserId"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_userSNSExpireTime] forKey:@"userSNSExpireTime"];
    [aCoder encodeObject:_userSNSsInfoDic forKey:@"userSNSsInfoDic"];
 
    [aCoder encodeObject:self.operate forKey:@"operate"];
    [aCoder encodeObject:self.manage forKey:@"manage"];
}

+(NSString*)SNSNameWithUserSNSType:(UserSNSType)userSNSType
{
    
     NSString* key = @"none";
    switch (userSNSType) {
        case UserSNSTypeForNone:
            key = @"none";
            break;
        case UserSNSTypeForQQ:
            key = @"qq";
            break;
        case UserSNSTypeForXiaoNei:
            key = @"xiaonei";
            break;
        case UserSNSTypeForSina:
            key = @"sina";
            break;
        case UserSNSTypeForWeiXin:
            key = @"weixin";
            break;
        case UserSNSTypeForFaceBook:
            key = @"facebook";
            break;
        case UserSNSTypeForTwitter:
            key = @"twitter";
            break;
        default:
            key = @"none";
            break;
    }
    return key;
}


//调试的时候输出自定义对象信息
- (NSString*) description
{
    NSMutableString* res = [NSMutableString stringWithFormat:@"uid = %@\n", self.userId];
    [res appendFormat:@"username = %@ \n",self.userName];
    [res appendFormat:@"password = %@ \n",self.userPassword];
    [res appendFormat:@"nickName = %@ \n",self.userNickname];
    [res appendFormat:@"userHeadURL = %@ \n",self.userHeadURL];

    [res appendFormat:@"isRememberPassword = %d \n",self.isRemeberPassword];
    [res appendFormat:@"isAotuLogin = %d \n",self.isAutoLogin];

    
    [res appendFormat:@"real_name = %@ \n",self.userRealName];
    [res appendFormat:@"email = %@ \n",self.userEmail];
    
    [res appendFormat:@"leftUpLastTime = %@ \n",self.leftUpLastTime];

    [res appendFormat:@"phone_number =  %@ \n",self.userPhoneNumber];
    [res appendFormat:@"address = %@ \n",self.userAddress];
    [res appendFormat:@"birthday = %@ \n",self.userBirthday];
    [res appendFormat:@"salary = %@ \n",self.userSalary];
 
    return res ;
    
}

@end
