//
//  BaseMenuViewController.h
//  BankAPP
//
//  Created by junyi.zhu on 14-2-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingCell.h"


@interface leftMenuViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>{
    UIViewController *vc;
}

@property (strong,nonatomic) NSMutableArray *array;
@property (strong,nonatomic) NSMutableArray * array2;
@property (strong,nonatomic) NSMutableArray * array3;
@property (strong,nonatomic) NSDictionary * menuDic;
@property (strong,nonatomic) NSString *imageURL;
@property (strong,nonatomic) SettingCell *CustomCell;
@property (strong,nonatomic) UIColor *menuLabelColor;
@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UITableView *leftlist;
@property (strong,nonatomic) NSString * upTime;

- (void)btnClicked:(id)sender;

@end
