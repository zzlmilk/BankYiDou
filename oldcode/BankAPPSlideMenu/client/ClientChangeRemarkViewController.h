//
//  ClientChangeRemarkViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-25.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeRemarkPostObj.h"
#import "ChangeRemarkTask.h"

@protocol ClientChangeRemarkViewControllerDelegate <NSObject>

- (void)changeTextInfo:(NSString *)str;

@end

@interface ClientChangeRemarkViewController : UIViewController<TaskDelegate,UITextViewDelegate>

@property (nonatomic,weak) id <ClientChangeRemarkViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *stringUserId;
@property (nonatomic, strong) NSString *strTextRemark;
@property (strong, nonatomic) IBOutlet UITextView *textviewRemark;
@end
