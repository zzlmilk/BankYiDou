//
//  ManageListVController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCustomersVipWithOperateStatusPostObj.h"
#import "ListCustomersVipWithOperateStatusTask.h"
@interface ManageListVController : UIViewController<UITableViewDataSource,UITableViewDelegate,TaskDelegate>
@property (nonatomic, strong)NSString *strmaterialId;

@property (strong, nonatomic) IBOutlet UILabel *lblSee;
@property (strong, nonatomic) IBOutlet UILabel *lblNotSee;
@property (strong, nonatomic) IBOutlet UITableView *tablelist;
- (IBAction)btnClicked:(id)sender;
@end
