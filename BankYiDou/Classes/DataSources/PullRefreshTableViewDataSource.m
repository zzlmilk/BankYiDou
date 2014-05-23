//
//  PullRefreshTableViewDataSource.m
//  SyjRedess
//
//  Created by rex on 12-10-20.
//
//

#import "PullRefreshTableViewDataSource.h"
#import "PullRefreshTableView.h"


@interface PullRefreshTableViewDataSource (private)
@end

@implementation PullRefreshTableViewDataSource



-(id)initWithTableView:(PullRefreshTableView *)aTableView{
    if (self = [super init]) {
        _tableView = aTableView;
        _tableView.delegate=self;
        _tableView.dataSource=self;
         [_tableView setUpRefreshHeaderView];
        _tableView.refreshHeaderView.delegate=self;
        

    }
    
    return self;
}


- (void)setTableView:(PullRefreshTableView *)aTableView {
	if (_tableView != aTableView) {
        _tableView = aTableView;
        _tableView.dataSource=self;
        _tableView.delegate =self;
        [_tableView setUpRefreshHeaderView];
        _tableView.refreshHeaderView.delegate=self;        
        [_tableView reloadData];

	}
}



-(void)loadPrivileges{
    
}

- (void)loadMore{

}


#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    _reloading = YES;
    [self loadPrivileges];
}


- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_tableView.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
	
}




#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{    
	return [NSDate date]; // should return date data source was last changed
}



#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    [_tableView.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_tableView.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark - TableViewDelegate 


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}





@end
