//
//  ChangePassWordVController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdatePwdByOldPwdPostObj.h"
#import "UpdatePwdByOldPwdTask.h"
@interface ChangePassWordVController : UIViewController<TaskDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *fieldOldPWord;
@property (strong, nonatomic) IBOutlet UITextField *fieldNewPWord;
@property (strong, nonatomic) IBOutlet UITextField *fieldtruePWord;
- (IBAction)btnClicked:(id)sender;

@end
