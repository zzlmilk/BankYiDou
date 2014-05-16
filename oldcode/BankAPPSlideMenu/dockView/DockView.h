//
//  DockView.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DockViewDelegate <NSObject>

-(void) dockViewDidSelectIndex:(NSInteger) index;

@end

@interface DockView : UIView
{
    NSArray *_iconArrayClick_k;//客户
    NSArray *_iconArrayClick_l;//理财顾问

    NSArray *_titleArray_k;
    NSArray *_titleArray_l;
}

@property (assign,nonatomic) id<DockViewDelegate> dockDelegate;

@property (nonatomic, strong) NSArray *iconArray_k;//客户
@property (nonatomic, strong) NSArray *iconArray_l;//理财顾问

@property (nonatomic, strong) NSArray *iconArray_k2;

@property (nonatomic, strong) NSArray *titleArray_k;
@property (nonatomic, strong) NSArray *titleArray_l;

@property (nonatomic)BOOL isKehu;

@property (strong,nonatomic)UILabel * lableunread;


- (void)btnClicked:(UIButton *)button;
- (void)resetLabelunread;
+ (DockView *)sharedDockView;

@end
