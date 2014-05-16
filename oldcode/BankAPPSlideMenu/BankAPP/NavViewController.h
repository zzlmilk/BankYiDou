//
//  NavViewController.h
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Nav.h"
#import "EGORefreshTableHeaderView.h"

@interface NavViewController : UIViewController<EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) Nav *navItem;
@property (strong, nonatomic) NSString *vcTitle;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, readwrite) BOOL isRefreshing;

@property (weak, nonatomic) id requestFunction;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)refreshHeaderInit;
- (void)requestData;
@end
