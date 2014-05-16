//
//  EMEAlertViewManager.h
//  EMEAPP
//
//  Created by YXW on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMEAlertView.h"
CGRect EMEScreenBounds();

@protocol EMEAlertViewManagerDelegate;

@interface EMEAlertViewManager : NSObject

@property(nonatomic,assign)id<EMEAlertViewManagerDelegate> delegate;

+(EMEAlertViewManager*)sharedAlertViewManager;

-(EMEAlertView*)currentAlertView;
-(BOOL)removeAlertView:(EMEAlertView*)alertView;

-(EMEAlertView*)showAlertView:(NSString*)message;

-(EMEAlertView*)showAlertView:(NSString*)message
                     delegate:(id<EMEAlertViewManagerDelegate>)delegate;

-(EMEAlertView*)showAlertViewWithTitle:(NSString*)title
                               Message:(NSString*)message
                          ButtonsTitle:(NSArray*)buttonsTitle
                              UserInfo:(NSDictionary*)userInfo
                             AlertType:(EMEAlertType)alertType
                              delegate:(id<EMEAlertViewManagerDelegate>)delegate;


-(EMEAlertView*)showAlertViewWithTitle:(NSString*)title
                               Message:(NSString*)message
                          ButtonsTitle:(NSArray*)buttonsTitle
                              UserInfo:(NSDictionary*)userInfo
                             AlertType:(EMEAlertType)alertType
                         IconImageName:(NSString*)iconImageName
                              delegate:(id<EMEAlertViewManagerDelegate>)delegate;
@end




@protocol EMEAlertViewManagerDelegate <NSObject>
@optional

-(void)willDismissAlertView:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)didDismissAlertView:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)willShowAlertView:(EMEAlertView *)alertView; // before animation and showing view
-(void)didShowAlertView:(EMEAlertView *)alertView;  // after animation

  @end
