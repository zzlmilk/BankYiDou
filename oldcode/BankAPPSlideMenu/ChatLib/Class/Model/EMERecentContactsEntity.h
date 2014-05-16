//
//  EMERecentContactsEntity.h
//  EMEAPP
//
//  Created by Sean Li on 13-12-17.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEDialogEntity.h"

@interface EMERecentContactsEntity : EMEDialogEntity
@property (nonatomic,strong)NSString* fromSource;//来源默认为 LP家族
@property (nonatomic,strong)NSString* contactUid;//表示联系人ID，  如果id是群组id，这表示群消息
@property (nonatomic,strong)NSString* contactNickName;//表示最近联系人 昵称
@property (nonatomic,strong)NSString* contactHeadUrl;//表示最近联系人 头像像地址

@property (nonatomic,assign)NSInteger unReadMessagesCount;//未读消息统计


-(void)setAttributeWithContactUid:(NSString *)contactUid
                       FromSource:(NSString *)fromSource
                  ContactNickName:(NSString *)contactNickName
                   ContactHeadUrl:(NSString *)contactHeadUrl;
-(void)addNewUnReadMessagesCount;
@end
