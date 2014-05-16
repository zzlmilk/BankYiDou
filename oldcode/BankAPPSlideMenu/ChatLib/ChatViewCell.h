//
//  ChatViewCell.h
//  BankAPP
//
//  Created by kevin on 14-4-1.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMERecentContactsEntity.h"

@interface ChatViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *VipImage;
@property (strong, nonatomic) IBOutlet UILabel *VipName;
@property (strong, nonatomic) IBOutlet UILabel *socketContents;
@property (strong, nonatomic) IBOutlet UILabel *unReadNum;


@end
