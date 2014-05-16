//
//  MoreInfoViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeUserOtherInfoPostObj.h"
#import "ChangeUserOtherInfoTask.h"
@interface MoreInfoViewController : UIViewController<TaskDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *qqNum;
@property (strong, nonatomic) IBOutlet UITextField *weixinNum;
@property (strong, nonatomic) IBOutlet UITextField *weiboNum;
@property (strong, nonatomic) IBOutlet UIButton *btnSina;
@property (strong, nonatomic) IBOutlet UIButton *btnT;
- (IBAction)btnClicked:(id)sender;
@end
