//
//  UploadAndChangeUserPhotoPostObj.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-23.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "UploadAndChangeUserPhotoPostObj.h"
#define kphoto @"photo"
#define Kuid            @"uid"
#define Ktoken          @"token"

@implementation UploadAndChangeUserPhotoPostObj
- (NSArray *)aryKey
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:kphoto];
    [key addObject:Kuid];
    [key addObject:Ktoken];
    
    return key;
}

- (NSArray *)aryValue
{
    NSMutableArray *key = [[NSMutableArray alloc]init];
    [key addObject:self.photo];
    [key addObject:self.uid];
    [key addObject:self.token];
    return key;
}

@end
