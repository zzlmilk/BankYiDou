//
//  ClientSeeViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatchCustomerVIPWithOperateHistoryObj.h"
#import "CatchCustomerVIPWithOperateHistoryTask.h"

#import "EGORefreshTableHeaderView.h"

@interface ClientSeeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TaskDelegate,EGORefreshTableHeaderDelegate>
{
    CGPoint point;//判断是上拉还是下拉
    BOOL refresh;
}
- (IBAction)btnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tablelist;
@property (strong, nonatomic) IBOutlet UIImageView *imagePerson;

@property (nonatomic, strong) NSString *stringUserId;
@property (nonatomic, strong) NSString *stringName;
//下拉属性
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) BOOL _reloading;


@end
