//
//  UIButton+defineButton.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-8.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//
/*
 定义拓展类顺序
 1.define+名称 : eg.defineButton
 2.首先设置位置 rect
 3.设置属性时 buttonType:(UIButtonType) type
 */
#import <UIKit/UIKit.h>

@interface UIButton (defineButton)
//基础定义+点击事件
+(UIButton *) defineButton:(CGRect) rect buttonType:(UIButtonType) type buttonTitle:(NSString*) title buttonAction:(SEL) action;
//基础定义
+(UIButton *) defineButton:(CGRect) rect buttonType:(UIButtonType) type buttonTitle:(NSString*) title ;
//添加点击事件
-(void) addClickAction:(id) target Action: (SEL) aciton;
@end
