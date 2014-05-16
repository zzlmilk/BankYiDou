//
//  ClientListCell.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imagePerson;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo;
@property (strong, nonatomic) IBOutlet UIButton *btnCareOrNot;
@end
