//
//  PrivilegeTableViewCell.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-19.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Privilege.h"

@interface PrivilegeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *privilegeImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;



@property(nonatomic,strong)Privilege *privilege;

@end
