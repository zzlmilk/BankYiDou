//
//  FouthViewController.h
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "NavViewController.h"
#import "MaterialInfosPostObj.h"
#import "MaterialInfosTask.h"

#import "listPlateClassObj.h"
#import "listPlateClassTask.h"

#import "ListMaterialInfoForPageObj.h"
#import "ListMaterialInfoForPageTask.h"

#import "EGORefreshTableFootView.h"
#import "EGORefreshTableHeaderView.h"

@interface ExclusiveMoneyplateFlag : NavViewController<UITableViewDataSource,UITableViewDelegate,TaskDelegate,EGORefreshTableHeaderDelegate,EGORefreshTableFootDelegate>
{
    UIButton *btnEarning;//预期收益
    UIButton *btnTime;//剩余时间
    
    NSArray *aryRequstData;//接收右上角分类数据
    NSMutableArray *aryList;//接收页面数据
    BOOL openOrNot;
    
    UITableView *table;
    
    EGORefreshTableFootView *_refreshFootView;//加载更多
    CGPoint point;//判断是上拉还是下拉
    BOOL refresh;
    
    UIView *clearView;
    BOOL JDSideOpenOrNot;
}
//下拉属性
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) BOOL _reloading;

@property (nonatomic, strong) NSString *strMaxTime;
@end
