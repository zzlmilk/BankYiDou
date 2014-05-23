//
//  PullRefreshTableView.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-20.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "PullRefreshTableView.h"
#import "EGORefreshTableHeaderView.h"


@implementation PullRefreshTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpRefreshHeaderView];

    }
    return self;
}


#pragma Private
-(void)setUpRefreshHeaderView{
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f -self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    [self addSubview:_refreshHeaderView];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
