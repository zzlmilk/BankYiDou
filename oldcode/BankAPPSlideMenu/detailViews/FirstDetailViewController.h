//
//  FirstDetailViewController.h
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
@interface FirstDetailViewController : UIViewController<TaskDelegate,UIWebViewDelegate>

@property (nonatomic, strong) NSString *strMaterialId;

@property (nonatomic, strong) NSDictionary *dictAll;

/* 进入:用来区分是否进行读操作
 * 首    页 1111 （读）
 * 尊享理财  1222   （读）
 * 理财顾问由客户列表页进入 1333    （不读）
 * 收藏进入  1444 （不读）
 */

@property (nonatomic, strong) NSString *strIndex;

@property (strong, nonatomic) IBOutlet UILabel *lbltitle;
@property (strong, nonatomic) IBOutlet UILabel *lblStyle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lbl_qixian;
@property (strong, nonatomic) IBOutlet UILabel *lbl_qigou;
@property (strong, nonatomic) IBOutlet UILabel *lbl_fengxian;
@property (strong, nonatomic) IBOutlet UILabel *lbl_shouxufei;
@property (strong, nonatomic) IBOutlet UILabel *lbl_other_time;
@property (strong, nonatomic) IBOutlet UILabel *lbl_other_Mahager;
@property (strong, nonatomic) IBOutlet UILabel *lbl_shouyilv;
@property (strong, nonatomic) IBOutlet UILabel *lbl_beishu;
@property (strong, nonatomic) IBOutlet UIWebView *webView_html;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UILabel *lbl_rengouTime;
@property (strong, nonatomic) IBOutlet UILabel *lbl_shouyiTime;
@end
