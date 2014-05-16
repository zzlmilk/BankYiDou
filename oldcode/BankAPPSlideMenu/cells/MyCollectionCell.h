//
//  MyCollectionCell.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-1.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailInfo;

@property (strong, nonatomic) IBOutlet UIImageView *imageInfo;
@end
