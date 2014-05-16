//
//  ChangeMobileNumVController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeUsermobile.h"
#import "ChangeUserMobileObj.h"

#import "sendSMSPostObj.h"
#import "sendSMSPTask.h"
@interface ChangeMobileNumVController : UIViewController<TaskDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UITextField *fieldNewPWord;//旧手机号，这里命名错误
@property (strong, nonatomic) IBOutlet UITextField *fieldNewMobile;
@property (strong, nonatomic) IBOutlet UITextField *fieldVercode;
- (IBAction)btnClicked:(id)sender;
@end
