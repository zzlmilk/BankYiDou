//
//  ZeroViewController.h
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "NavViewController.h"

@interface ZeroViewController : NavViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
NSArray * arylist;
CGPoint point;//判断是上拉还是下拉
BOOL refresh;
}

//下拉属性
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) BOOL _reloading;
@property (strong, nonatomic) IBOutlet UITableView *listTable;
@property (strong, nonatomic)  NSDictionary * arydict;

@end
