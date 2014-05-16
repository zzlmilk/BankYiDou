//
//  NavViewController.m
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "NavViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)refreshHeaderInit
{
    
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -88, self.view.bounds.size.width,88)];
    self.refreshHeaderView.delegate = self;
    self.isRefreshing = NO;
    [self.tableView addSubview:self.refreshHeaderView];
}

- (void)viewDidLoad
{
    [self refreshHeaderInit];
	// Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadData
{
    if (self.isRefreshing)
    {
        self.isRefreshing = NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
}

- (void)requestData
{
    
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    self.isRefreshing = YES;
    [self requestData];
    [self performSelector:@selector(reloadData) withObject:self afterDelay:1.0f];  //make a delay to show loading process for a while
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.isRefreshing; // should return if data source model is reloading
}


#pragma mark-
#pragma mark- UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
