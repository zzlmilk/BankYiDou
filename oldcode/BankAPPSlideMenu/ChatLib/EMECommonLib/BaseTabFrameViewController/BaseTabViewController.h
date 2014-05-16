//
//  BaseTabViewController.h
//  UiComponentDemo
//
//  Created by Sean Li on 14-2-18.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//

#import "BaseViewController.h"

/**
 * @discussion  在TabBarViewController中的tabBar里面出现的ViewController 必须是BaseTabViewController的子类
 */
@interface BaseTabViewController : BaseViewController

@property(nonatomic,strong)NSString *evTabBarDefaultICONName;//tabBar中默认状态图标名
@property(nonatomic,strong)NSString *evTabBarSelectedICONName;//tabBar中选中状态图标名

/**
 *  @abstract  设置TabViewController 属性
 *  @disscusssion 必须对title 和ICON 名字进行设置
 *  @param title            视图标题
 *  @param defaultICONName  tabBar中默认状态图标名
 *  @param selectedICONName tabBar中选中状态图标名
 */
-(void)setAttributeWithTitle:(NSString*)title
       TabBarDefaultICONName:(NSString*)defaultICONName
      TabBarSelectedICONName:(NSString*)selectedICONName;
@end
