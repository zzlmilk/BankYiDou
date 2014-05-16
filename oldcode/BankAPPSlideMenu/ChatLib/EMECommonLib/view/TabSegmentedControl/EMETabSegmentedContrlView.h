//
//  EMETabSegmentedContrlView.h
//  UiComponentDemo
//
//  Created by Sean Li on 14-2-21.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//

#import <UIKit/UIKit.h>

#define DefualtTabBackGroudImageName @"32gongqiu_tab_bg01"
#define DefaultSeletedTabBackGroudImageName @"32gongqiu_tab_bg02"

typedef void (^EMETabSegmentedDidChangedBlock)(NSInteger currentTabIndex);


@interface EMETabSegmentedContrlView : UIView

@property(nonatomic,strong)NSArray *evTabNamesArray;
@property(nonatomic,strong)NSString *evTabBackGroudImageName;//tab选中 背景色，默认是DefaultSeletedTabBackGroudImageName
@property(nonatomic,strong)NSString *evSelectedTabBackgroudImageName;//tab默认DefualtTabBackGroudImageName
@property(nonatomic,assign)NSInteger evSelectedIndex;
@property(nonatomic,copy)EMETabSegmentedDidChangedBlock evTabSegmentedDidChangedBlock;

-(void)setAttributeWithTabNamesArray:(NSArray*)tabNamesArray
               TabBackGroudImageName:(NSString*)tabBackGrouImageName
       SelectedTabBackGroudImageName:(NSString*)selectedTabBackGrouImageName
                  defaultSelectIndex:(NSInteger)selectIndex
         TabSegmentedDidChangedBlock:(EMETabSegmentedDidChangedBlock)tabSegmentedDidChangedBlock;


@end
