//
//  PrivilegeViewController.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-16.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "PrivilegeViewController.h"
#import "PrivilegeTableViewCell.h"
#import "Privilege.h"

@interface PrivilegeViewController ()

@end

@implementation PrivilegeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Privilege privilegePostsWithBlock:^(NSArray *privileges, NSError *error) {
        
        if (privileges) {
            _privileges = [NSMutableArray arrayWithArray:privileges];
            [self.tableView reloadData];
        }
    }];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- PrivilegeTableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _privileges.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *kCellID = @"PrivilegeTableViewCellID";
    
    PrivilegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    Privilege *privilege = [_privileges objectAtIndex:indexPath.row ];
    
    cell.privilege = privilege;
    
	return cell;

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
