//
//  EMEAlertView.h
//  EMEAPP
//
//  Created by YXW on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void (^EMEAlertViewBlock)(id alertView,NSInteger buttonIndex);

typedef enum
{
    EMEButtonStyleGray = 1,
    EMEButtonStyleGreen = 2,
    EMEButtonStyleDefault = EMEButtonStyleGray,
} EMEButtonStyle;

typedef enum
{
    EMEAlertTypeForWarning = 1, //警告
    EMEAlertTypeForChoice, //选择
    EMEAlertTypeForConfirm,//确认
} EMEAlertType;

@protocol EMEAlertViewDelegate;

@interface EMEAlertView : NSObject{
}
@property (nonatomic, weak) id <EMEAlertViewDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, strong) NSArray *buttonsTitle;
@property (nonatomic, readonly) NSMutableArray *buttonsStyle;
@property (nonatomic, copy)   EMEAlertViewBlock blockAfterDismiss;

@property (nonatomic, copy )  NSDictionary* info;
@property (nonatomic, assign) EMEAlertType alertType;

@property (nonatomic, copy)  NSString* iconName; //图标名称。 不设置，系统会使用默认的警告图标

@property(nonatomic, getter=isVisible) BOOL hidden;//隐藏
@property(nonatomic,getter=isVisible) BOOL visible;




+(id)alertViewWithTitle:(NSString*)title
                Message:(NSString*)message
           ButtonsTitle:(NSArray*)buttonsTitle
                   Info:(NSDictionary*)info
           AfterDismiss:(EMEAlertViewBlock)block
              AlertType:(EMEAlertType)alertType;

-(id)initWithTitle:(NSString*)title
           Message:(NSString*)message
      ButtonsTitle:(NSArray*)buttonsTitle
              Info:(NSDictionary*)info
      AfterDismiss:(EMEAlertViewBlock)block
         AlertType:(EMEAlertType)alertType;

//设置属性
-(void)setAttributesWithTitle:(NSString*)title
                      Message:(NSString*)message
                 ButtonsTitle:(NSArray*)buttonsTitle
                         Info:(NSDictionary*)info
                 AfterDismiss:(EMEAlertViewBlock)block
                    AlertType:(EMEAlertType)alertType;


-(NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
-(void)setButtonStyle:(EMEButtonStyle)style atIndex:(int)index;

-(void)show;

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
@end

@protocol  EMEAlertViewDelegate <NSObject>

@optional

-(void)AlertViewWillDismiss:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)AlertViewDidDismiss:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)AlertViewWillShow:(EMEAlertView *)alertView; // before animation and showing view
-(void)AlertViewDidShow:(EMEAlertView *)alertView;  // after animation

@end


