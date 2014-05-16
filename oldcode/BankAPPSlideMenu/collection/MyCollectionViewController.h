//
//  MyCollectionViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-27.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyCollectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_aryMessage;//存放数据信息
    
    BOOL JDSideOpenOrNot;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, retain) NSMutableArray *aryMessage;

@end
