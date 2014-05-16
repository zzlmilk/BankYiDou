//
//  listPlateClassObj.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-14.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SuperPostObj.h"

@interface listPlateClassObj : SuperPostObj
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *plateId;

- (NSArray *)aryKey;
- (NSArray *)aryValue;
@end
