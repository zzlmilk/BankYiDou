//
//  EMELPGroup.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-5.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMELPGroup : NSObject
@property(nonatomic,copy)NSString* groupId;
@property(nonatomic,copy)NSString* groupHeadURL;
@property(nonatomic,copy)NSString* groupName;
@property(nonatomic,copy)NSString* groupInfo;
@property(nonatomic,strong)NSMutableArray* groupMembersIDArray;

-(void)setAttributeWithGroupId:(NSString*)groupId
                  GroupHeadURL:(NSString*)groupHeadURL
                     GroupName:(NSString*)groupName
                     GroupInfo:(NSString*)groupInfo
           GroupMembersIDArray:(NSMutableArray*)groupMembersIDArray;


@end
