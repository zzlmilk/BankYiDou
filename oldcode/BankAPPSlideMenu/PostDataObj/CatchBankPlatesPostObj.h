//
//  CatchBankPlatesPostObj.h
//  BankAPP
//
//  Created by kevin on 14-3-7.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"
@interface CatchBankPlatesPostObj : SuperPostObj

//lastTime 上次拉去银行版块信息时间（为空则显示所有文件数据的条数）   UID 注册用户的用户ID
//token  64位唯一用户识别码，做身份认证使用
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *lastTime;
@property (strong, nonatomic) NSString *uid;


- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end