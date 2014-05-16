//
//  EMELPGroup.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-5.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMELPGroup.h"

@implementation EMELPGroup




-(void)setAttributeWithGroupId:(NSString*)groupId
                  GroupHeadURL:(NSString*)groupHeadURL
                     GroupName:(NSString*)groupName
                     GroupInfo:(NSString*)groupInfo
           GroupMembersIDArray:(NSMutableArray*)groupMembersIDArray
{
    self.groupId = groupId;
    self.groupHeadURL = groupHeadURL;
    self.groupName = groupName;
    self.groupInfo = groupInfo;
    
    if (groupMembersIDArray) {
        [self.groupMembersIDArray removeAllObjects];
        [self.groupMembersIDArray addObjectsFromArray:groupMembersIDArray];
    }
}

#pragma mark - getter
-(NSMutableArray*)groupMembersIDArray
{
    if (_groupMembersIDArray == nil) {
        _groupMembersIDArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _groupMembersIDArray;
}




@end
