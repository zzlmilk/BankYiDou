//
//  EMEChatViewController.h
//  EMEChat
//
//  Created by Sean Li on 3/6/14.
//  Copyright (c) 2014 junyi.zhu All rights reserved.
//

#import "BaseViewController.h"
@interface ChatViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *struserId;//viP  id

//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *socketList;

@property (nonatomic,strong)NSMutableArray* data_array;

@property (nonatomic, strong) NSString *contactHeadUrl;
@property (nonatomic, strong) NSString *contactuid;
@property (nonatomic, strong) NSString *contactName;

//-(NSComparisonResult)myCompareMethodWithDict: (NSMutableDictionary*)theOtherDict;

@end
