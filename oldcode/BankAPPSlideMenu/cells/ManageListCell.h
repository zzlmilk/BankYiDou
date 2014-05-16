//
//  ManageListCell.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-22.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *imagePerson;

@property (strong, nonatomic) IBOutlet UIImageView *imageZan;
@property (strong, nonatomic) IBOutlet UIImageView *imageCollect;
@property (strong, nonatomic) IBOutlet UIImageView *imageAct;
@end
