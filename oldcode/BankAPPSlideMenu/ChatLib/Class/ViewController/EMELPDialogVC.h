//
//  EMELPDialogVC.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMELPFamily.h"
#import "EMELPGroup.h"
#import "BaseViewController.h"
@interface EMELPDialogVC :BaseViewController

@property(nonatomic,readonly)UIView *buttom_view;//开放底部
@property(nonatomic,strong)EMELPFamily* familyMember;
@property(nonatomic,strong)EMELPGroup*  group;

@property(nonatomic,strong) Class needPopToViewControllerClass;//需要跳转道的页面

@property (strong,nonatomic) NSString *touid;
@property (strong,nonatomic) NSString *toName;
@property (strong,nonatomic) NSString *tourl;
@property (nonatomic,strong) NSString *theuserid;

-(void)setAttributeFamilyMember:(EMELPFamily*)family Group:(EMELPGroup*)group;
-(BOOL)checkNetWorkStatus;

@end
