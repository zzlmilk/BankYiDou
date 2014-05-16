//
//  DataBaseCenter.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-27.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

/*
 数据库
 首先调用share取到数据库对象
 DataBaseCenter *dbCenter = [DataBaseCenter share];
 [dbCenter saveDataWithType:DBCenterType_History AndData:content];
 [dbCenter deleteDataWithType:DBCenterType_History ID:@"005"];
 NSArray *arrar = [dbCenter selectDataWithType:DBCenterType_History];
 */

#import <Foundation/Foundation.h>
#import "Datamanager.h"
#import "Content.h"
@interface DataBaseCenter : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *materialId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *templet;

+(DataBaseCenter *)share;

- (BOOL)saveDataWithType:(DBCenterType)dBCenterType AndData:(Content*)acontent;



#pragma mark - 收藏
//初始化
- (id)initWithCollectionMaterialId:(NSString *)newMaterialId withImageDataURL:(NSString *)newImageURL withTitle:(NSString *)newTitle withModuleName:(NSString *)newModuleName withTemplet:(NSString *)newtemplet;

//存储数据
+ (BOOL)saveCollectionWithmaterialId:(NSString *)newMaterialId withImageDataURL:(NSString *)newImageURL withTitle:(NSString *)newTitle withModuleName:(NSString *)newModuleName withTemplet:(NSString *)newtemplet;

//查找数据
+ (NSMutableArray *)findAllMessage;

//删除
+(int)deletePalceID:(NSString *)aMaterialId;
@end
