//
//  ClientVIpDetailVC.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-21.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//
/*
 *聊天界面右上角点击进入
 *
 *vip客户详情
 *
 *
 *
 */

#import <UIKit/UIKit.h>
#import "CatchCustomerVIPPostObj.h"
#import "CatchCustomerVIPTask.h"
#import "ClientChangeRemarkViewController.h"


#import "ChangeAttentionObj.h"
#import "ChangeAttentionTask.h"
@interface ClientVIpDetailVC : UIViewController<TaskDelegate,ClientChangeRemarkViewControllerDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblBZhu;
@property (strong, nonatomic) IBOutlet UIButton *btnCareOrNot;
@property (strong, nonatomic) IBOutlet UIImageView *imagePerson;
@property (strong, nonatomic) IBOutlet UITextView *textviewInfo;

@property (nonatomic, strong) NSString *strUserId;//预留接口

- (IBAction)btnClicked:(id)sender;
@end
