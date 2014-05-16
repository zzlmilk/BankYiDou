//
//  MyCollectionCell.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-1.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "MyCollectionCell.h"

@implementation MyCollectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
