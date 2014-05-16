//
//  ChangeInvestmentViewController.h
//  BankAPP
//
//  Created by kevin on 14-3-17.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "NavViewController.h"
#import "EGORefreshTableHeaderView.h"

@protocol ChangeInvestmentdelegate <NSObject>

- (void)changeInvestmentID: (NSDictionary *)Investmentdict;

@end

@interface ChangeInvestmentViewController : NavViewController <UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
     NSArray * arylist;
    CGPoint point;//判断是上拉还是下拉
    BOOL refresh;

}


@property (strong, nonatomic) IBOutlet UITableView *listtable;
@property (nonatomic,assign) id<ChangeInvestmentdelegate> delegate;
@property (strong, nonatomic)  NSDictionary * arydict;


//下拉属性
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) BOOL _reloading;



@end
