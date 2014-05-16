//
//  LoadingViewController.h
//  BankVip2
//
//  Created by kevin on 14-2-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//11111111

#import <UIKit/UIKit.h>

#import "LoadingPostObj.h"
#import "LoadingTask.h"

@interface LoadingViewController : UIViewController <TaskDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lb_loading;

@end
