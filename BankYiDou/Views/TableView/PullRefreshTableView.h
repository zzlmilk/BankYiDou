//
//  PullRefreshTableView.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-20.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGORefreshTableHeaderView;

@interface PullRefreshTableView : UITableView<UIScrollViewDelegate>
{

    
}



@property (nonatomic,strong)EGORefreshTableHeaderView *refreshHeaderView;


-(void)setUpRefreshHeaderView;


@end
