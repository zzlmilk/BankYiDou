//
//  EMEAlertView.m
//  EMEAPP
//
//  Created by YXW on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEAlertView.h"


#define AlertViewWidth 280.0f
#define AlertContentLabelWidth 240.0f
#define AlertContentButtonAreaHeight 50.0f  //放Button 的地方默认高度
#define AlertViewHeight 175.0f
#define AlertSpace  12;

CGRect XYScreenBounds()
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient){
        orient = UIDeviceOrientationPortrait;
    }
    return bounds;
}


@interface EMEAlertView()

@property(nonatomic, strong)UIImageView *alertView;
@property(nonatomic, strong)UIView *blackBG;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UIImageView* warningIconImageView;

@end

@implementation EMEAlertView


+(id)alertViewWithTitle:(NSString*)title
                Message:(NSString*)message
           ButtonsTitle:(NSArray*)buttonsTitle
                   Info:(NSDictionary*)info
           AfterDismiss:(EMEAlertViewBlock)block
              AlertType:(EMEAlertType)alertType

{
    return [[EMEAlertView alloc] initWithTitle:title
                                       Message:message
                                  ButtonsTitle:buttonsTitle
                                          Info:info
                                  AfterDismiss:block
                                     AlertType:alertType];
}

-(id)initWithTitle:(NSString*)title
           Message:(NSString*)message
      ButtonsTitle:(NSArray*)buttonsTitle
              Info:(NSDictionary*)info
      AfterDismiss:(EMEAlertViewBlock)block
         AlertType:(EMEAlertType)alertType

{
    self = [self init];
    if(self)
    {
        [self setAttributesWithTitle:title
                             Message:message
                        ButtonsTitle:buttonsTitle
                                Info:info
                        AfterDismiss:block
                           AlertType:(EMEAlertType)alertType
         ];
    }
    return self;
}

-(void)setAttributesWithTitle:(NSString *)title
                      Message:(NSString *)message
                 ButtonsTitle:(NSArray *)buttonsTitle
                         Info:(NSDictionary *)info
                 AfterDismiss:(EMEAlertViewBlock)block
                    AlertType:(EMEAlertType)alertType

{
    self.title = title;
    self.message = message;
    self.buttonsTitle = buttonsTitle;
    self.info = info;
    self.blockAfterDismiss = block;
    self.alertType = alertType;
}

-(NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0 && [self.buttonsTitle count] > buttonIndex) {
        return [self.buttonsTitle objectAtIndex:buttonIndex];
    }else{
        return  nil;
    }
}


-(void)setButtonStyle:(EMEButtonStyle)style atIndex:(int)index
{
    if(index < [_buttonsStyle count])
        [_buttonsStyle replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:style]];
}


-(void)show
{
    [self setHidden:NO];
    
    [self prepareAlertToDisplay];
    if (_delegate && [_delegate respondsToSelector:@selector(AlertViewWillShow:)]) {
        [_delegate AlertViewWillShow:self];
    }
    [self showAlertViewWithAnimation];
 
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (animated) {
        if (_delegate && [_delegate respondsToSelector:@selector(AlertViewWillDismiss:clickedButtonAtIndex:)]) {
            [_delegate AlertViewWillDismiss:self clickedButtonAtIndex:buttonIndex];
        }
    }

    [UIView animateWithDuration:0.2f
                     animations: ^{
                         if (animated) {
                             _blackBG.alpha = 0.0f;
                         }
                         
                     }completion:^(BOOL finished){
                         
                         [_alertView removeFromSuperview];
                         [_blackBG   removeFromSuperview];
                         _visible = NO;
                         
                         if(_blockAfterDismiss){
                             _blockAfterDismiss(self,buttonIndex);
                         }else {
                             if (_delegate && [_delegate respondsToSelector:@selector(AlertViewDidDismiss:clickedButtonAtIndex:)]) {
                                 [_delegate AlertViewDidDismiss:self clickedButtonAtIndex:buttonIndex];
                             }
                         }
                         
                     }];
}

#pragma mark - define
-(void)buttonClick:(UIButton*)button
{
    [self dismissWithClickedButtonIndex:button.tag animated:YES];
}

#pragma mark - private
-(UIImage*)buttonImageByStyle:(EMEButtonStyle)style state:(UIControlState)state
{
    switch(style)
    {
        default:
        case EMEButtonStyleGray:
            return [[UIImage imageNamed:(state == UIControlStateNormal ? @"g_button_bg01.png" : @"g_button_bg02.png")] stretchableImageWithLeftCapWidth:22 topCapHeight:0];
        case EMEButtonStyleGreen:
            return [[UIImage imageNamed:(state == UIControlStateNormal ? @"g_button_bg01" : @"g_button_bg02")] stretchableImageWithLeftCapWidth:22 topCapHeight:0];
    }
}


-(void)prepareAlertToDisplay
{
    CGRect screenBounds = XYScreenBounds();
    CGRect frame = CGRectMake(0, 0, AlertViewWidth, AlertViewHeight);

    CGFloat contentLableHeight = [CommonUtils lableWithTextStringHeight:self.message andTextFont:self.contentLabel.font andLableWidth:AlertContentLabelWidth-25.0];
    CGFloat contentLableWidth = [CommonUtils lableWithTextStringWidth:self.message andTextFont:self.contentLabel.font andLableHeight:self.contentLabel.font.lineHeight];
    
    //12
    if ((contentLableHeight + AlertContentButtonAreaHeight + 2*12) > AlertViewHeight){
        frame.size.height += AlertViewHeight - (contentLableHeight + AlertContentButtonAreaHeight + 2*12);
    }
    
    //背景视图
    self.alertView.frame =frame;
    self.alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
    
    //标题
    //如果有标题内容，则添加标题
    if (self.title) {
#warning 暂时未涉及到标题
        self.titleLabel.text = self.title;
        [self.alertView addSubview:self.titleLabel];
    }

    
    // 内容
    frame.size.height = contentLableHeight;
    frame.origin.y = (self.alertView.frame.size.height -  frame.size.height - AlertContentButtonAreaHeight) / 2.0 - 8.0;
    frame.size.width = AlertContentLabelWidth - 25.0;
    
    //让比较短的文字居中
    if (contentLableWidth < frame.size.width) { //表示文字比较少
        frame.origin.x = 48 + (frame.size.width - contentLableWidth)/2.0;
    }else{
        frame.origin.x = 48;
    }
    
    self.contentLabel.numberOfLines = 10;
    self.contentLabel.text = self.message;
    self.contentLabel.frame = frame;
    [self.alertView addSubview:self.contentLabel];
    
    
    //图标

    NSString* alertIconImageName = @"g_alert_icon";
    switch (self.alertType) {
        case EMEAlertTypeForWarning:
        {
            alertIconImageName = @"g_alert_icon";
            break;
        }
        case EMEAlertTypeForChoice:
        {
            alertIconImageName = @"g_alert_icon";
            break;
        }
        case EMEAlertTypeForConfirm:
        {
            alertIconImageName = @"jy06_gou";
            break;
        }
        default:
        {
            alertIconImageName = @"g_alert_icon";
            break;
        }
    }
 
    
    self.warningIconImageView.image = [UIImage imageNamed:alertIconImageName];
    frame.size = self.warningIconImageView.image.size;
    frame.origin.y = (self.alertView.frame.size.height -  frame.size.height - AlertContentButtonAreaHeight) / 2.0 - 8.0;
    //让图标和文字居中
    if (contentLableWidth <  self.contentLabel.frame.size.width) { //表示文字比较少
        frame.origin.x = 20 + (self.contentLabel.frame.size.width - contentLableWidth)/2.0;
    }else{
        frame.origin.x = 20;
    }
    self.warningIconImageView.frame = frame;
    [self.alertView addSubview:self.warningIconImageView];
 

    
    //按钮
    frame.size = CGSizeMake(70, 35);
    frame.origin.y = 120 + self.alertView.frame.size.height - AlertViewHeight;
    float buttonPadding = (self.alertView.frame.size.width - [self.buttonsTitle count]*frame.size.width)/([self.buttonsTitle count]+1);
    
    for(int i = 0; i < self.buttonsTitle.count; i++)
    {
        NSString *buttonTitle = [self.buttonsTitle objectAtIndex:i];
        EMEButtonStyle style = [[self.buttonsStyle objectAtIndex:i] intValue];
        
        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:buttonTitle forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //        _button.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [_button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateNormal]
                           forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateHighlighted]
                           forState:UIControlStateHighlighted];
        frame.origin.x = buttonPadding+i*(buttonPadding+frame.size.width);
        _button.frame =  frame;
        _button.tag = i;
        
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:_button];
    }
}




#pragma mark - animation

-(void)showAlertViewWithAnimation
{
         UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
 
            NSArray *windows = [UIApplication sharedApplication].windows;
    
    if ([windows count] >0) {
            keyWindow = [windows objectAtIndex:0];
    }
    
        _visible = YES;

  
    _blackBG.alpha = 0.0f;
    CGRect frame = _alertView.frame;
    frame.origin.y = -AlertViewHeight;
    _alertView.frame = frame;
    _blackBG.alpha = 0.5f;
    _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
    
    
     __weak  EMEAlertView* weakSelf = (EMEAlertView*)self;
    [UIView animateWithDuration:0.2f animations:^{
        [keyWindow addSubview:weakSelf.blackBG];
        [keyWindow addSubview:weakSelf.alertView];
        
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(AlertViewDidShow:)]) {
            [_delegate AlertViewDidShow:self];
        }
    }];

    

  
}




#pragma mark - setter
-(void)setButtonsTitle:(NSArray *)buttonsTitle
{
    _buttonsTitle = buttonsTitle;
    _buttonsStyle = nil;
    _buttonsStyle = [NSMutableArray arrayWithCapacity:buttonsTitle.count];
    for (int i = 0; i < buttonsTitle.count; i++)
    {
        [_buttonsStyle addObject:[NSNumber numberWithInt:EMEButtonStyleDefault]];
    }
}

-(void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    self.blackBG.hidden = hidden;
    self.alertView.hidden = hidden;
    _visible = !hidden;
}

#pragma mark - getter

-(BOOL)isHidden
{
    return _visible;
}

-(UIImageView*)alertView
{
    if (_alertView == nil) {
        _alertView = [[UIImageView alloc] initWithImage:[CommonUtils ImageWithImageName:@"jy06_layer_bg" EdgeInsets:UIEdgeInsetsMake(20, 20, 50, 20)]];
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}

-(UIView*)blackBG
{
    if(_blackBG == nil)
    {
        CGRect screenBounds = XYScreenBounds();
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    return _blackBG;
    
}

-(UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

-(UILabel*)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _contentLabel;
}

-(UIImageView*)warningIconImageView
{
    if (_warningIconImageView == nil) {
        _warningIconImageView = [[UIImageView alloc] init];
    }
    return _warningIconImageView;
}

@end
