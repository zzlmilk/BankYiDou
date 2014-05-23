//
//  PrivilegeDataSource.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-20.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "PrivilegeDataSource.h"
#import "Privilege.h"
#import "PrivilegeTableViewCell.h"

@implementation PrivilegeDataSource


#pragma Private
-(void)_initialize{
   
    
    downloadCount  =20;
   // _privileges = [[NSMutableArray alloc]init];
    _parameters = [[NSMutableDictionary alloc]init];
    
}

-(id)initWithTableView:(PullRefreshTableView *)aTableView{
    if (self = [super initWithTableView:aTableView]) {
        [self _initialize];
        
    }
    return self;
}



-(void)loadPrivileges{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"75" forKey:@"uid"];
    [dic setObject:@"Z6F484C8s4w095G7p1U5Z1n5v0U4u190t2i3A7wgiXs7l2VQA6EgynZ0G0oAw0Ei" forKey:@"token"];
    
    
    [Privilege privilegePostsParameters:dic WithBlock:^(NSArray *privileges, NSError *error) {
        if (privileges) {
            _privileges = [NSMutableArray arrayWithArray:privileges];
            [self.tableView reloadData];
        }
    }];
}



#pragma mark UITableViewDataSource Protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return  _privileges.count ;
    
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *kCellID = @"PrivilegeTableViewCellID";
    PrivilegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
        Privilege *privilege = [_privileges objectAtIndex:indexPath.row ];
        cell.privilege = privilege;
    
	return cell;
}


#pragma mark UITableViewDelegate Protocol


@end
