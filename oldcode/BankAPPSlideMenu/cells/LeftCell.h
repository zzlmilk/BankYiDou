//
//  LeftCell.h
//  BankAPP
//
//  Created by kevin on 14-4-18.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *HeadImage;
@property (strong, nonatomic) IBOutlet UILabel *LableTitle;
@property (strong, nonatomic) IBOutlet UILabel *unreadCount;

@end
