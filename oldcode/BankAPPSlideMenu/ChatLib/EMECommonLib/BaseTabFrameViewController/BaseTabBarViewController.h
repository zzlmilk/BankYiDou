//
//  BaseTabBarViewController.h
//  UiComponentDemo
//
//  Created by Sean Li on 14-2-18.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMETabbarView.h"
 

@interface BaseTabBarViewController :UITabBarController

@property(nonatomic,strong)NSString* evTabbarBackGroudImageName;//tabbar中的背景图片名字
@property(nonatomic,strong)NSString* evTabbarMaskImageName;//tabbar中点击会跟随变动的图片
@property(nonatomic,strong)NSString* evTabbarItemSplitImageName;//tabbar分割线

@property(nonatomic,strong)EMETabbarView *evTabBarView;

@property(nonatomic,assign)NSInteger evMenuTabViewControllerIndex;//菜单对应的索引值，默认0

/**
 *  更新TabVC 信息，如title,evTabBarDefaultICONName 信息变更，需要更新tabbar 视图
 *
 *  @param tabVCclass 信息变更的类classs
 *
 */
-(void)updateInfoForTabbarWithTabVCClassName:(Class)tabVCclass;


/**
 *  跳转到指定页面
 *
 *  @param tabVCclass  标签TabVC类名   默认权重最高
 *  @param tabVCIndex  需要跳转到的TabVC当前所处索引  默认权重最低
 *  @discussion 两个参数可以任选一个，其中如果两个参数都填写，则默认优先以tabVCclass 为准
 */
-(void)gotoTabViewControllerWithTabVCClassName:(Class)tabVCclass
                                  orTabVCIndex:(NSInteger)tabVCIndex;
@end
