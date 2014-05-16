//
//  FirstViewController.h
//  JWSlideMenu
//
//  Created by Jeremie Weldin on 11/15/11.
//  Copyright (c) 2011 Jeremie Weldin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "MaterialInfosPostObj.h"
#import "MaterialInfosTask.h"
#import "EGORefreshTableFootView.h"
#import "EGORefreshTableHeaderView.h"

#import "leftMenuViewController.h"
@interface HomePageplateFlag : NavViewController<UITableViewDataSource,UITableViewDelegate,TaskDelegate,EGORefreshTableFootDelegate,EGORefreshTableHeaderDelegate,UIActionSheetDelegate>
{
    NSArray *aryRequstData;
    NSMutableArray *aryList;//接收数据
    
    EGORefreshTableFootView *_refreshFootView;//加载更多
    CGPoint point;//判断是上拉还是下拉
    BOOL refresh;
    
    NSString *_strMaxTime;
    
    UIView *clearView;
    BOOL JDSideOpenOrNot;
}
@property (nonatomic, strong) leftMenuViewController *leftVC;

@property (strong, nonatomic) IBOutlet UITableView *tableviewlist;
@property (nonatomic, strong) NSString *strMaxTime;
//下拉属性
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) BOOL _reloading;

@end
