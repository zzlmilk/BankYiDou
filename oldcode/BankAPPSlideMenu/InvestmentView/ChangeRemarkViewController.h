//
//  ChangeRemarkViewController.h
//  BankAPP
//
//  Created by kevin on 14-3-17.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NavViewController.h"

@protocol ChangeRemarkViewControllerdelegate <NSObject>

- (void)changeLabelText: (NSString *)text;

@end

@interface ChangeRemarkViewController : NavViewController<UITextViewDelegate>
{
    UIButton * saveButton;
}
@property (nonatomic,weak) id <ChangeRemarkViewControllerdelegate> delegate;

@property (strong, nonatomic) NSString * strRemark;

- (void)addView;
@property (strong, nonatomic) IBOutlet UITextView *remarkText;

@end

