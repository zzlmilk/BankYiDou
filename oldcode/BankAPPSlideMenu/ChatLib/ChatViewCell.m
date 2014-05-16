//
//  ChatViewCell.m
//  BankAPP
//
//  Created by kevin on 14-4-1.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ChatViewCell.h"

@implementation ChatViewCell

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

//UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 200)];
//[label setTextColor:[UIColor blackColor]];
//label.text=@"12345";
//[label setFont:[UIFont fontWithName:@"Chalkduster" size:33]];
//[self addSubview:label];
@end

