//
//  SecondViewController.h
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "NavViewController.h"
#import "listPlateClassObj.h"
#import "listPlateClassTask.h"

@interface PrivilegeVIPplateFlag : NavViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *aryList;
    
    UIView *clearView;

    BOOL JDSideOpenOrNot;
}
@property (strong, nonatomic) IBOutlet UITableView *vipTableList;
@end
