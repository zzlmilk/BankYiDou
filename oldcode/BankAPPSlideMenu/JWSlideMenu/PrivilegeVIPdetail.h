//
//  Second2ViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-14.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "NavViewController.h"
#import "EGORefreshTableFootView.h"
#import "EGORefreshTableHeaderView.h"

@interface PrivilegeVIPdetail : NavViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableFootDelegate,EGORefreshTableHeaderDelegate>
{
    UIButton *btnLocal;
    UIButton *btnCountry;
    NSMutableArray *aryList;
    NSString *_strMaxTime;
    
    EGORefreshTableFootView *_refreshFootView;//加载更多
    CGPoint point;//判断是上拉还是下拉
    BOOL refresh;

}
@property (strong, nonatomic) IBOutlet UITableView *tableList;
@property (nonatomic, strong) NSString *strMaxTime;
@property (nonatomic, strong) NSString *strPlateId;
@property (nonatomic, strong) NSString *strClassId;

//下拉属性
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) BOOL _reloading;


- (void)addBasicView;

@end
