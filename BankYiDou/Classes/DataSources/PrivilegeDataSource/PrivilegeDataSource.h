//
//  PrivilegeDataSource.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-20.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullRefreshTableViewDataSource.h"


@class Privilege;
@protocol PrivilegeDataSourceDelegate <NSObject>

- (void)privilegeSelected:(Privilege *)privilege;

@end

@interface PrivilegeDataSource : PullRefreshTableViewDataSource
{
    int downloadCount;
    CGPoint lastOffset;
}

@property (nonatomic, unsafe_unretained) id<PrivilegeDataSourceDelegate> privilegeDataSourceDelegate;

@property(nonatomic,strong) NSMutableArray *privileges;
@property(strong,nonatomic) NSMutableDictionary *parameters;



-(void)loadPrivileges;

@end
