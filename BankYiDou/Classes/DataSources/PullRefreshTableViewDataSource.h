//
//  PullRefreshTableViewDataSource.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-20.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "EGORefreshTableHeaderView.h"
#import "PullRefreshTableView.h"

//#import "LoadMoreView.h"

@class PullRefreshTableView;
@interface PullRefreshTableViewDataSource : NSObject<UITableViewDelegate, UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    
}


@property (nonatomic) BOOL reloading;
@property (nonatomic,strong) PullRefreshTableView *tableView;


-(void)reloadTableViewDataSource;
-(id)initWithTableView:(PullRefreshTableView *)aTableView;

@end
