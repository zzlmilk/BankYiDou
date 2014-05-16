//
//  settingCell.m
//  JWSlideMenu
//
//  Created by kevin on 14-2-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "SettingCell.h"
#import "MoreViewController.h"


@implementation SettingCell
@synthesize profileImage;
@synthesize profileview;
@synthesize userName;
@synthesize mobutton;

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
