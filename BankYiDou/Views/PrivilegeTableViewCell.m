//
//  PrivilegeTableViewCell.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-19.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "PrivilegeTableViewCell.h"


@implementation PrivilegeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setPrivilege:(Privilege *)privilege{
    if (privilege) {
        self.titleLabel.text = privilege.title;
        self.timeLabel.text=privilege.time;
        self.privilegeImageView.image = privilege.privilegeImage;
    }
    
}


@end
