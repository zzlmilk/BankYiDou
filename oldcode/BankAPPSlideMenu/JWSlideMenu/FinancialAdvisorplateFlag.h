//
//  EightViewController.h
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "NavViewController.h"
#import "ChangeRemarkViewController.h"
#import "ChangeInvestmentViewController.h"

@interface FinancialAdvisorplateFlag : NavViewController <ChangeRemarkViewControllerdelegate,ChangeInvestmentdelegate>
{
    UIView *clearView;
    BOOL JDSideOpenOrNot;
}
@property (strong, nonatomic) IBOutlet UIImageView *investmentImage;
@property (strong, nonatomic) IBOutlet UILabel *investmentName;
@property (strong, nonatomic) IBOutlet UITextView *theText;

- (IBAction)changeInvestment:(UIButton *)sender;
- (IBAction)changeRemark:(UIButton *)sender;
@end
 