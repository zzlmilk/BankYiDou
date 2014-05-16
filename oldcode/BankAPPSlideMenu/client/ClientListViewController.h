//
//  ClientListViewController.h
//  copy
//
//  Created by kevin on 14-3-25.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCustomersVIPWithRemarkPostObj.h"
#import "ListCustomersVIPWithRemarkTask.h"

#import "ChangeAttentionObj.h"
#import "ChangeAttentionTask.h"

#import "EGORefreshTableHeaderView.h"

@interface ClientListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TaskDelegate,UISearchBarDelegate,EGORefreshTableHeaderDelegate>
{
    CGPoint point;//判断是上拉还是下拉
    BOOL refresh;
}
@property (strong, nonatomic) IBOutlet UITableView *tablelist;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBr;
//下拉属性
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) BOOL _reloading;

@end

