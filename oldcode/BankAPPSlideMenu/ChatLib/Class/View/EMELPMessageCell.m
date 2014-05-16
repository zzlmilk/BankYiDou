//
//  EMELPMessageCell.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-11.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMELPMessageCell.h"
#import "EMEImageLoader.h"
#import "CommonUtils.h"
#import "NSObject+Universal.h"
@interface EMELPMessageCell()<EMEImageLoaderDelegate>
{
    CGRect _temp_frame;
    CGFloat _old_height;
    CGFloat _new_height;
    MessageBubbleType _messageBubbleType;
    EMEImageLoader *imageLoader;

}

@property(nonatomic,strong)UIButton* contentBackgroundButton;
@property(nonatomic,strong)UILabel*  contentLabel;


@property(nonatomic,strong)UILabel* descriptionLabel;

@end

@implementation EMELPMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        
        _temp_frame = CGRectMake(0, 0, 320, 44);
        //头像
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cell.VipImage setImageWithURL:[NSURL URLWithString:RecentEn.contactHeadUrl ] placeholderImage:[UIImage imageNamed:@"icon_btm_client.png"]];
        
        self.headImageButton.enabled = YES;
        self.headImageButton.layer.masksToBounds = NO;
        self.headImageButton.layer.borderWidth  = 2.0;
        self.headImageButton.layer.borderColor = [[UIColor whiteColor] CGColor];
//        self.headImageButton.layer.shadowColor = [UIColorFromRGB(0xCAB8A5)  CGColor];
        self.headImageButton.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        self.headImageButton.layer.shadowRadius = 1;
        self.headImageButton.layer.shadowOpacity = 0.8;
        self.headImageButton.frame =  CGRectMake(12, 10, 70, 68);
        self.headImageButton.backgroundColor = [UIColor grayColor]; //junyi.zhu debug
        [self.headImageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.headImageButton];
        
        //内容背景Button
        _contentBackgroundButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBackgroundButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_contentBackgroundButton];

        //内容
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines =  100;
        [self.contentView addSubview:_contentLabel];
        
        
        //描述  - 只显示在图片和地图上面
        _descriptionLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_descriptionLabel];
        _descriptionLabel.hidden = YES;

            }
    return self;
}



-(void)setAttributeWithDialogEntity:(EMEDialogEntity*)dialogEN
                           Delegate:(id<EMELPMessageCellDelegate>) delegate
                   SelfHeadImageURL:(NSString*)selfHeadImageURL
                 FirendHeadImageURL:(NSString*)friendHeadImageURL
{
    //赋值
    self.delegate = delegate;
    self.dialogEN = dialogEN;
    
    [self setDownloadedImage:[UIImage  imageNamed:@"lp01_touxiang03"]];
    
    NSLog(@"%@",[UserManager shareInstance].user.userId);
    
    
//    if ([self.dialogEN.fromUid  isEqualToString:[UserManager shareInstance].user.userId])
    
    if ([self.dialogEN.fromUid intValue] == [[UserManager shareInstance].user.userId intValue])
    {
        _messageBubbleType  = MessageBubbleTypeForRight;
        
    }else{
        _messageBubbleType = MessageBubbleTypeForLeft;
    }
    
    _contentLabel.text = dialogEN.content;
    
    //头像
    self.imageUrl = ( _messageBubbleType == MessageBubbleTypeForRight ? selfHeadImageURL : friendHeadImageURL);
    
    [self.contentBackgroundButton setBackgroundImage:[self getBubbleImage]
                                            forState:UIControlStateNormal];
    
    
}


-(UIImage*)getBubbleImage
{
    
    NSString* imageName;
    switch (_messageBubbleType) {
        case MessageBubbleTypeForLeft:
            imageName = @"lp07_blue_dialog";
            break;
        case MessageBubbleTypeForRight:
            imageName = @"lp07_gray_dialog";
            break;
        default:
            imageName = @"lp07_gray_dialog";
            break;
    }
    
    return [CommonUtils ImageWithImageName:imageName
                                EdgeInsets:UIEdgeInsetsMake(20.0, 30.0, 21.0, 21.0)];
    
}

-(void)buttonClick:(UIButton*)button
{
    if (button == self.headImageButton) {
        if (_delegate && [_delegate respondsToSelector:@selector(EMELPMessageCellHeaderClick:)]) {
            [_delegate EMELPMessageCellHeaderClick:self ];
        }else{
            NIF_INFO(@"未实现代理 ：EMELPMessageCellHeaderClick ");
        }
    }else if(button == _contentBackgroundButton){
        if (_delegate && [_delegate respondsToSelector:@selector(EMELPMessageCellContentClick:)]) {
            [_delegate EMELPMessageCellContentClick:self ];
        }else{
            NIF_INFO(@"未实现代理 ：EMELPMessageCellContentClick ");
        }
    }else{
        NIF_INFO(@"不能捕获 Button的点击事件：%@",button);
    }

}

-(void)setAutoHeight
{
    //默认状态
    self.headImageButton.hidden = NO;
    self.contentLabel.hidden = NO;
    self.contentBackgroundButton.hidden = NO;
    self.descriptionLabel.hidden = YES;
    [self.contentBackgroundButton setImage:nil forState:UIControlStateNormal];
    
    _temp_frame = CGRectMake(0,0, 186.0, 44);

    
    switch (self.dialogEN.type) {
        case MessageTypeForSystemPushAD:
        {
            self.headImageButton.hidden = YES;
            break;
        }
        case MessageTypeForSystemNotic:
        {
            self.headImageButton.hidden = YES;
            _contentLabel.font =  MessageNoticFont;
 
            break;
        }
            
        case MessageTypeForSystemMessage:
        {
            _contentLabel.font =  MessageFont;

            break;
        }
        case MessageTypeForTime:
        {
            self.headImageButton.hidden = YES;
            break;
        }
        case MessageTypeForImage:
        {
            _contentLabel.hidden = YES;
            _descriptionLabel.text = @"图片描述";
            _descriptionLabel.hidden = NO;
            break;
        }
            
        case MessageTypeForMap:
        {
            _contentLabel.hidden = YES;
            _descriptionLabel.text = @"地图描述";
            _descriptionLabel.hidden = NO;
            
            break;
        }
        case MessageTypeForVideoFragment:
        {
            _contentLabel.hidden = YES;
            break;
        }
        case MessageTypeForSoundFragment:
        {
            self.headImageButton.hidden = NO;
            _contentLabel.hidden = YES;
            break;
        }
        default:
            break;
    }

    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentBackgroundButton.backgroundColor = [UIColor  clearColor];

    _contentLabel.textColor = [UIColor blackColor];
    _contentBackgroundButton.layer.shadowRadius = 0.0;
    _contentBackgroundButton.layer.shadowOpacity = 0.0;

    //头像
    if (!self.headImageButton.hidden) {
        _temp_frame.size =  CGSizeMake(45.0, 45.0);
        _temp_frame.origin.x = (_messageBubbleType == MessageBubbleTypeForLeft) ? 8.0 : (320 - 8.0 - _temp_frame.size.width);
        self.headImageButton.frame = _temp_frame;
    }else{
 
        [_contentBackgroundButton setBackgroundImage:nil forState:UIControlStateNormal];
        [_contentBackgroundButton setBackgroundColor:UIColorFromRGB(0xE7DBC9)];
         _contentBackgroundButton.layer.shadowRadius = 8;
         _contentBackgroundButton.layer.shadowOffset = CGSizeMake(-1, -1);
         _contentBackgroundButton.layer.shadowColor = [[UIColor blackColor] CGColor];
         _contentBackgroundButton.layer.shadowOpacity = 0.8;
        
        _contentLabel.textColor = [UIColor whiteColor];

//        _temp_frame = _contentBackgroundButton.frame;
//        _temp_frame.size.width -= 30;
//        _temp_frame.size.height -= 30 ;
//        
//        _temp_frame.origin.x =  (320 - _temp_frame.size.width ) / 2.0;
//        _temp_frame.origin.y = 0.0;
//        _contentBackgroundButton.frame = _temp_frame;
    }

    //内容
    if (!self.contentLabel.hidden) {
        _temp_frame.size = CGSizeMake(MessageCellMaxWidth, self.frame.size.height);
        CGFloat headerImageVieWidth =  8.0 + self.headImageButton.frame.size.width + 5.0;
        
        CGFloat spaceing = 2.0;
        
        if (self.dialogEN.type != MessageTypeForSystemNotic) {
            spaceing = 10;
        }
        
        
        _temp_frame.size.width =  MessageCellMaxWidth - spaceing;
        _temp_frame.origin.y += spaceing;

        _contentLabel.frame = _temp_frame;
        
       //自动获取高度
        _temp_frame.size.height = [CommonUtils lableHeightWithLable:_contentLabel];
        _contentLabel.frame = _temp_frame;
        
        //自动宽度
        CGFloat _temp_width = [CommonUtils lableWidthWithLable:_contentLabel] ;
//        NIF_ALLINFO(@"%lf",_temp_width);
        _temp_frame.size.width = _temp_width <  _contentLabel.frame.size.width  ? _temp_width :  _contentLabel.frame.size.width ;
        
        if (self.dialogEN.type == MessageTypeForSystemMessage) {
              _temp_frame.origin.x =  (_messageBubbleType == MessageBubbleTypeForLeft) ? (headerImageVieWidth + 2*spaceing): (320.0 - headerImageVieWidth -  _temp_frame.size.width- 2*spaceing);
        }else if(self.dialogEN.type == MessageTypeForSystemNotic){
            _temp_frame.origin.x = (320.0 - _temp_frame.size.width) / 2.0;
        }

          _contentLabel.frame = _temp_frame;
        
        
        
        //确定最终的高度
        _temp_frame = _contentBackgroundButton.frame;

        if (self.dialogEN.type == MessageTypeForSystemMessage) {
      
                _temp_frame.size.height =  _contentLabel.frame.size.height +  2*spaceing;
                _temp_frame.size.width = _contentLabel.frame.size.width + 3*spaceing ;
                _temp_frame.origin.x = _contentLabel.frame.origin.x - ((_messageBubbleType == MessageBubbleTypeForLeft) ? 18 : 10) ;
 
        }else if(self.dialogEN.type == MessageTypeForSystemNotic){
        
            _temp_frame.size.height =  _contentLabel.frame.size.height +  6;
            _temp_frame.size.width = _contentLabel.frame.size.width + 6 + 20 ;

            _temp_frame.origin.x = (320.0 - _temp_frame.size.width) / 2.0;
            [_contentBackgroundButton needsRoundCorner:_temp_frame.size.height/2.0];
        }
        
        _contentBackgroundButton.frame = _temp_frame;
 
    }else{//不隐藏内容标签的
     
       if(self.dialogEN.type == MessageTypeForSoundFragment){
            
           _temp_frame.size  =  CGSizeMake(66.0, 54.0);
           _temp_frame.origin.x = ((_messageBubbleType == MessageBubbleTypeForLeft) ? (self.headImageButton.frame.origin.x + self.headImageButton.frame.size.width + 6) : (self.headImageButton.frame.origin.x - _temp_frame.size.width - 6));
           [_contentBackgroundButton setImage:[UIImage imageNamed:@"lp07_video_icon"] forState:UIControlStateNormal];
           [_contentBackgroundButton setImageEdgeInsets:UIEdgeInsetsMake(8, ((_messageBubbleType == MessageBubbleTypeForLeft) ? 12: 0), 8, 8)];
           _contentBackgroundButton.frame = _temp_frame;

           
        }
        

    }
}





+(CGFloat)getNeedHeightWithDialogEn:(EMEDialogEntity*)dialogEn
{

    NSInteger height = 44.0;
    MessageType type =dialogEn.type;
    if (type == MessageTypeForSystemNotic) {
        height = [CommonUtils lableWithTextStringHeight:dialogEn.content
                                            andTextFont:MessageNoticFont
                                          andLableWidth:MessageCellMaxWidth];
        height += 16.0;
    }else if(type == MessageTypeForMap){
        height = 105;
    }else if( type == MessageTypeForSystemPushAD){
        height = [CommonUtils lableWithTextStringHeight:dialogEn.content
                                            andTextFont:MessageFont
                                          andLableWidth:MessageCellMinWidth];
        height +=  30.0;
    }else if(type == MessageTypeForImage){
        height = 140.0;
    }else if(type == MessageTypeForSystemMessage){
        height = [CommonUtils lableWithTextStringHeight:([CommonUtils stringLengthWithString:dialogEn.content] <= 0) ? @"占位字符" :dialogEn.content
                                            andTextFont:MessageFont
                                          andLableWidth:MessageCellMinWidth];
        height +=  30.0+8.0;
    }else if(type == MessageTypeForSoundFragment){
        height = 52 + 16;
    }else{
        
        height = [CommonUtils lableWithTextStringHeight:dialogEn.content
                                            andTextFont:MessageFont
                                          andLableWidth:MessageCellMinWidth];
        height +=  30.0;
        
    }
    
    return  height;

}

-(void)setImageUrl:(NSString *)imgUrl{
    if (![_imageUrl  isEqualToString:imgUrl]) {
        _imageUrl = imgUrl;
    }
	self.headImageButton.hidden = NO;
    
    [imageLoader cancelWithDelegate];
	imageLoader = [[EMEImageLoader alloc] initWithName:imgUrl WithPrefix:nil];
    imageLoader.delegate = self;
	[imageLoader startLoad];
    
    
}

-(void)cancelDownload
{
    [imageLoader cancel];
}



- (void)dealloc {
    [self cancelDownload];
    
}

- (void)setDownloadedImage:(UIImage *)image {
    [self.headImageButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.headImageButton setBackgroundImage:image forState:UIControlStateDisabled];
    
}

- (UIImage *)downloadedImage {
    UIImage *image = [self.headImageButton backgroundImageForState:UIControlStateNormal];
    if (!image) {
        image = [self.headImageButton backgroundImageForState:UIControlStateDisabled];
    }
    return image;
}


#pragma mark - EMEImageLoaderDelegate

- (void)loadFinishedWithImage:(UIImage *)image withLoader:(EMEImageLoader*)loader {
	[self setDownloadedImage:image];
    NIF_DEBUG(@"下载头像成功:%@",image);
    [self.headImageButton setNeedsDisplay];
    
 
}

- (void)loadFailedwithError:(NSError *)e withLoader:(EMEImageLoader *)loader {
    
    [self setDownloadedImage:[UIImage imageNamed:@"1305774588258.png"]];
    [self.headImageButton setImage:[UIImage imageNamed:@"1305774588258.png"] forState:UIControlStateNormal];//junyi.zhu debug
    [self.headImageButton setNeedsDisplay];
    NIF_DEBUG(@"下载头像失败");
}

#pragma mark - setter

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setAutoHeight];

 }

-(void)setIsCanClickContent:(BOOL)isCanClickContent
{
    self.contentBackgroundButton.enabled = isCanClickContent;
}



@end
