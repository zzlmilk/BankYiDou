//
//  UIButton+defineButton.m
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

#import "UIButton+defineButton.h"

@implementation UIButton (defineButton)
#pragma mark - defineAll
+(UIButton *) defineButton:(CGRect) rect buttonType:(UIButtonType) type buttonTitle:(NSString*) title buttonAction:(SEL) action{
    UIButton * button = [UIButton buttonWithType:type];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
#pragma mark - define
+(UIButton *) defineButton:(CGRect) rect buttonType:(UIButtonType) type buttonTitle:(NSString*) title{
    UIButton * button = [UIButton buttonWithType:type];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

#pragma mark - action
-(void) addClickAction:(id) target Action: (SEL) aciton{
    
    [self addTarget:target action:aciton forControlEvents:UIControlEventTouchUpInside];
    
}
@end
