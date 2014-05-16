//
//  EMEAlertViewManager.m
//  EMEAPP
//
//  Created by YXW on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEAlertViewManager.h"
#import "EMEAlertView.h"


@interface EMEAlertViewManager ()<EMEAlertViewDelegate>
{
         id _currentAlertView;

}

@property (nonatomic, strong)NSMutableArray *alertViewQueue;

@end

@implementation EMEAlertViewManager
static EMEAlertViewManager *s_haredAlertViewManager = nil;

+(EMEAlertViewManager*)sharedAlertViewManager
{
    @synchronized(self)
    {
        if(!s_haredAlertViewManager)
            s_haredAlertViewManager = [[EMEAlertViewManager alloc] init];
    }
    
    return s_haredAlertViewManager;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _alertViewQueue = [[NSMutableArray alloc] init];
     }
    
    return self;
}

-(void)dealloc
{
    _delegate = nil;
    
    [_alertViewQueue removeAllObjects];
}


-(EMEAlertView*)currentAlertView
{
    if (_alertViewQueue && [_alertViewQueue count] > 1) {
        EMEAlertView*  alertView = [self.alertViewQueue lastObject];
        if (alertView.isVisible) {
            return alertView;
        }else{
            return nil;
        }
    }
    return nil;
}

-(BOOL)removeAlertView:(EMEAlertView*)alertView;
{
    [self.alertViewQueue removeObject:alertView];
    
//    if ([self.alertViewQueue count] > 0) {
//        EMEAlertView* alertView = [self.alertViewQueue lastObject];
//        //alertView.hidden = NO;
//        [alertView show];
//    }
    return YES;
}

#pragma mark - public

-(EMEAlertView*)showAlertView:(NSString*)message
{
    
    return  [self showAlertViewWithTitle:@""
                                 Message:message
                            ButtonsTitle:[NSArray arrayWithObjects:@"确定", nil]
                                UserInfo:nil
                               AlertType:EMEAlertTypeForWarning
                           IconImageName:nil
                                delegate:nil];
    
   
}

-(EMEAlertView*)showAlertView:(NSString*)message
                     delegate:(id<EMEAlertViewManagerDelegate>)delegate
{
    return  [self showAlertViewWithTitle:@""
                                 Message:message
                            ButtonsTitle:[NSArray arrayWithObjects:@"确定", nil]
                                UserInfo:nil
                               AlertType:EMEAlertTypeForWarning
                           IconImageName:nil
                                delegate:delegate];
}


-(EMEAlertView*)showAlertViewWithTitle:(NSString*)title
                               Message:(NSString*)message
                          ButtonsTitle:(NSArray*)buttonsTitle
                              UserInfo:(NSDictionary*)userInfo
                             AlertType:(EMEAlertType)alertType
                              delegate:(id<EMEAlertViewManagerDelegate>)delegate
{

    return   [self showAlertViewWithTitle:title
                                  Message:message
                             ButtonsTitle:buttonsTitle
                                 UserInfo:userInfo
                                AlertType:alertType
                            IconImageName:nil
                                 delegate:delegate];
    
}




-(EMEAlertView*)showAlertViewWithTitle:(NSString*)title
                               Message:(NSString*)message
                          ButtonsTitle:(NSArray*)buttonsTitle
                              UserInfo:(NSDictionary*)userInfo
                             AlertType:(EMEAlertType)alertType
                         IconImageName:(NSString*)iconImageName
                              delegate:(id<EMEAlertViewManagerDelegate>)delegate
{
    self.delegate = delegate;
    EMEAlertView *alertView = [EMEAlertView alertViewWithTitle:title
                                                       Message:message
                                                  ButtonsTitle:buttonsTitle
                                                          Info:userInfo
                                                  AfterDismiss:nil
                                                     AlertType:alertType];
    alertView.delegate = self;
    [self.alertViewQueue addObject:alertView];
    [alertView show];
    return alertView;

}


#pragma mark -   EMEAlertViewDelegate <NSObject>


-(void)AlertViewWillDismiss:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_delegate && [_delegate respondsToSelector:@selector(willDismissAlertView:clickedButtonAtIndex:)]) {
        [_delegate willDismissAlertView:alertView clickedButtonAtIndex:buttonIndex];
    }

}

-(void)AlertViewDidDismiss:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (_delegate && [_delegate respondsToSelector:@selector(didDismissAlertView:clickedButtonAtIndex:)]) {
        [_delegate didDismissAlertView:alertView clickedButtonAtIndex:buttonIndex];
    }
    
    [self removeAlertView:alertView];

}

-(void)AlertViewWillShow:(EMEAlertView *)alertView
{
    //防止多个弹出框显示
    if ([self.alertViewQueue  count] > 0) {
        for (NSInteger i= 0; i < ([self.alertViewQueue count] - 1); i++) {
            UIAlertView* tempAlertView = [self.alertViewQueue objectAtIndex:i];
            tempAlertView.hidden = YES;
        }
    }
  
 
    if (_delegate && [_delegate respondsToSelector:@selector(willShowAlertView:)]) {
        [_delegate willShowAlertView:alertView];
    }
}

-(void)AlertViewDidShow:(EMEAlertView *)alertView
{
    if (_delegate && [_delegate respondsToSelector:@selector(didShowAlertView:)]) {
        [_delegate didShowAlertView:alertView];
    }
    
}


@end
