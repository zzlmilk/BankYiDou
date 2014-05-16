//
//  EMELPMessageCell.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-11.
//  Copyright (c) 2013年 YXW. All rights reserved.
//
#import <UIKit/UIKit.h>
 #import "EMEDialogEntity.h"

#define MessageFont [UIFont systemFontOfSize:14.0]
#define MessageNoticFont  [UIFont systemFontOfSize:12.0]
#define MessageCellMinWidth  160
#define MessageCellMaxWidth  190

typedef enum {
    MessageBubbleTypeForLeft, //对话气泡向左
    MessageBubbleTypeForRight//对话气泡向右
} MessageBubbleType;


@protocol EMELPMessageCellDelegate ;

@interface EMELPMessageCell : UITableViewCell

@property(nonatomic,strong)EMEDialogEntity* dialogEN;
@property(nonatomic,assign)id<EMELPMessageCellDelegate> delegate;
@property(nonatomic,assign) BOOL isCanClickContent;
@property(nonatomic, strong)UIButton *headImageButton;
@property (nonatomic, strong) NSString *imageUrl;



-(void)setAttributeWithDialogEntity:(EMEDialogEntity*)dialogEN
                           Delegate:(id<EMELPMessageCellDelegate>) delegate
                   SelfHeadImageURL:(NSString*)selfHeadImageURL
                 FirendHeadImageURL:(NSString*)friendHeadImageURL;


//获取聊天对话框的高度
+(CGFloat)getNeedHeightWithDialogEn:(EMEDialogEntity*)dialogEn;

@end

@protocol EMELPMessageCellDelegate <NSObject>

@optional

-(void)EMELPMessageCellHeaderClick:(EMELPMessageCell*)messageCell ;
-(void)EMELPMessageCellContentClick:(EMELPMessageCell *)messageCell ;
@end

