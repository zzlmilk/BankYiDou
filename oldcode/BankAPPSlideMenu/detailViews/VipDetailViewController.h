//
//  VipDetailViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordUserOperateLogTask.h"
#import "RecordUserStatusLogObj.h"
#import "CatchMaterialDetailPostObj.h"
#import "CatchMaterialDetailTask.h"
@interface VipDetailViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSDictionary *dictList;

@property (strong, nonatomic) IBOutlet UILabel *lblphone;
@property (strong, nonatomic) IBOutlet UILabel *lblAdress;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imagePicture;
@property (strong, nonatomic) IBOutlet UILabel *lblFBTime;

@property (nonatomic, strong) NSString *strMaterialId;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

/* 进入:用来区分是否进行读操作
 * 首    页 1111 （读）
 * 尊享理财  1222   （读）
 * 理财顾问由客户列表页进入 1333    （不读）
 * 收藏进入  1444 （不读）
 */
@property (nonatomic, strong) NSString *strIndex;
@property (strong, nonatomic) IBOutlet UIWebView *webview_vip;
- (IBAction)mobile:(id)sender;
@end
