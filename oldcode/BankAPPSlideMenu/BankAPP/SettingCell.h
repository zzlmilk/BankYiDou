//
//  settingCell.h
//  JWSlideMenu
//
//  Created by kevin on 14-2-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

@property (strong,nonatomic) IBOutlet UIImageView *profileImage;
@property (strong,nonatomic) IBOutlet UIView *profileview;
@property (strong,nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIButton *mobutton;

@property (retain, nonatomic) UIViewController *presentingController;



@end
