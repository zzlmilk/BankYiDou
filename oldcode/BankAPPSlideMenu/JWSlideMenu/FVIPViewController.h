//
//  FVIPViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "NavViewController.h"
#import "listPlateClassObj.h"
#import "listPlateClassTask.h"

@interface FVIPViewController : NavViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *aryList;
    
    UIView *clearView;
    
}
@property (strong, nonatomic) IBOutlet UITableView *vipTableList;
@end
