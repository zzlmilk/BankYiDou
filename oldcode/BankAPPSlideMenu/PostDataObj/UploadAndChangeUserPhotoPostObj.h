//
//  UploadAndChangeUserPhotoPostObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-23.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface UploadAndChangeUserPhotoPostObj : SuperPostObj
@property (nonatomic,strong) NSData *photo;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

- (NSArray *)aryKey;
- (NSArray *)aryValue;

@end
