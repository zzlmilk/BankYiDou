//
//  PrivilegeViewController.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-16.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivilegeDataSource.h"
#import "PullRefreshTableView.h"

@class PullRefreshTableViewDataSource;
@interface PrivilegeViewController : UITableViewController
{
    PrivilegeDataSource *privilegeDataSource;
    PullRefreshTableViewDataSource * dataSource;
}


@property(strong,nonatomic) IBOutlet PullRefreshTableView *privilegeTableView;




@end
