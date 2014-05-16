//
//  EMETabbarView.m
//  UiComponentDemo
//
//  Created by Sean Li on 14-2-25.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//

#import "EMETabbarView.h"

#define BaseTabItemButtonTag 100
#define BaseTabItemIconImageViewTag 200
#define BaseTabItemIconTitleLableTag 300

@interface EMETabbarView ()
@property(nonatomic,copy)EMETabBarCurrentSelectedItemDidChangedBlock tabBarCurrentSelectedItemDidChangedBlock;//表示当前的选项发生变更
@property(nonatomic,strong)UIImageView *evTabMaskImageView;
@property(nonatomic,strong)UIImageView *evTabBackGroudView;
@property(nonatomic,strong)UIImageView *evTabTopSplitImageView;
@end

@implementation EMETabbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setAttributesWithBackgroudImageName:(NSString*)backGroudImageName
                             MaskImageName:(NSString*)maskImageName
                   ItemSpliteLineImageName:(NSString*)itemSpliteLineImageName
                          TabbarItemsModel:(NSMutableArray*)tabbarItemsModel
                             SelectedIndex:(NSInteger)selectedIndex{
    self.evTabbarBackGroudImageName = backGroudImageName;
    self.evTabbarMaskImageName = maskImageName;
    self.evTabbarItemSpliteLineImageName = itemSpliteLineImageName;
    self.evTabbarItemsModelArray = tabbarItemsModel;
    self.evSelectedIndex = selectedIndex;
}



#pragma mark - define
-(void)initTabbarItemsView
{

    //1. 移除老的视图
    for (UIView* tempView in [self subviews]) {
        [tempView removeFromSuperview];
    }
    
    //1.1 添加背景视图
    if (self.evTabbarBackGroudImageName) {
        self.evTabBackGroudView.frame = CGRectMake(0, 0,self.frame.size.width , self.frame.size.height);
        [self addSubview:self.evTabBackGroudView];
    }
    
    //2. 添加视图
    NSInteger tab_count = [self.evTabbarItemsModelArray count];
    CGFloat tab_width = 320.0/tab_count;
    CGRect temp_lable_frame = CGRectMake(0.0,30, tab_width, 24);
    CGRect temp_imageview_frame = CGRectMake((tab_width-60)/2,self.frame.size.height-44,60, 44);
    CGRect temp_split_imageview_frame = CGRectMake(tab_width-0.5,self.frame.size.height-47,1, 47);
    CGRect temp_button_frame = CGRectMake(0.0,0.0,tab_width, self.frame.size.height);
    
    if (self.evTabbarItemSpliteLineImageName == nil) {
        NIF_ERROR(@"必须设置分割线");
    }
    
    //分割线
    for (int i = 0 ; i< tab_count-1 ; i++) {
        UIImageView* tab_split_imageview = [[UIImageView alloc] init];
        tab_split_imageview.backgroundColor = [UIColor clearColor];
        tab_split_imageview.frame = temp_split_imageview_frame;
        tab_split_imageview.tag =60+i ;
        temp_split_imageview_frame.origin.x += tab_width;
        tab_split_imageview.image = [UIImage imageNamed:self.evTabbarItemSpliteLineImageName];
        [self addSubview:tab_split_imageview];
    }
    
    if (self.evTabTopsplitImageName) {
        self.evTabTopSplitImageView.frame = CGRectMake(0, 0, 320, 1);
        [self addSubview:self.evTabTopSplitImageView];
    }
    
    
	//激活遮罩标示层
	self.evTabMaskImageView.frame = CGRectMake(0,0, tab_width, self.frame.size.height);
 	[self addSubview:self.evTabMaskImageView];
	
    for (int i = 0 ; i< tab_count ; i++) {
        EMETabBarItemModel* tabbatItemModel = [self.evTabbarItemsModelArray objectAtIndex:i];
        
        //标题
        if (tabbatItemModel.evTitle && !_hiddenTittle) {
            UILabel * tab_title_label  =[[UILabel alloc] init];
            tab_title_label.backgroundColor = [UIColor clearColor];
            tab_title_label.textColor = UIColorFromRGB(0x9b9ba1);
            tab_title_label.text =  [tabbatItemModel.evTitle capitalizedString];
            tab_title_label.font = [UIFont boldSystemFontOfSize:10.0];
            tab_title_label.frame = temp_lable_frame;
            tab_title_label.tag = BaseTabItemIconTitleLableTag+i;
            temp_lable_frame.origin.x += tab_width;
            tab_title_label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:tab_title_label];
        }
        
        //图标
        UIImageView* tab_imageview = [[UIImageView alloc] init];
        tab_imageview.backgroundColor = [UIColor clearColor];
        tab_imageview.frame = temp_imageview_frame;
        tab_imageview.image = [UIImage imageNamed:tabbatItemModel.evDefaultIconName];
        tab_imageview.tag = BaseTabItemIconImageViewTag + i;
        temp_imageview_frame.origin.x += tab_width;
        [self addSubview:tab_imageview];
        
        //按钮
        UIButton* tab_button = [UIButton buttonWithType:UIButtonTypeCustom];
        tab_button.layer.zPosition = 999;
        tab_button.backgroundColor = [UIColor clearColor];
        tab_button.tag = BaseTabItemButtonTag+i;
        tab_button.frame  =  temp_button_frame;
        temp_button_frame.origin.x +=  tab_width;
        
        [tab_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:tab_button];
        
    }
    [self setEvSelectedIndex:0];//默认选择 home
 

}

-(void)buttonClick:(UIButton*)button
{
    NIF_ALLINFO(@"buttonClick");
    if (button.tag >= BaseTabItemButtonTag) {//表示点中tabbar
        [self setEvSelectedIndex:button.tag -BaseTabItemButtonTag];
    }

}

//更换指定位置的图标
-(void)updateTabBarItemModelWithIndex:(NSInteger)index
                          tabbarModle:(EMETabBarItemModel*)tabBarItemModel
{
    
    if (index >=0 && self.evTabbarItemsModelArray  && index < [self.evTabbarItemsModelArray count]) {
        [self.evTabbarItemsModelArray  replaceObjectAtIndex:index withObject:tabBarItemModel];
        
        //图标
        UIImageView *iconImageView =(UIImageView*)[self viewWithTag:BaseTabItemIconImageViewTag+index];
        if (iconImageView) {
            iconImageView.image = [UIImage imageNamed:tabBarItemModel.evDefaultIconName];
        }
        //标题
        UILabel* titleLabel = (UILabel*)[self viewWithTag:BaseTabItemIconTitleLableTag+index];
        if (titleLabel) {
            titleLabel.text = tabBarItemModel.evTitle;
        }
        
    }else{
        NIF_ERROR(@"设置数据越界");
    }
    
}



- (CGFloat) horizontalLocationFor:(NSInteger)tabIndex
{
    CGFloat tabItemWidth = 320 / 5.0;
    CGFloat halfTabItemWidth = 0;
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}


-(void)registerCurrentSelectedItemDidChangedBlock:(EMETabBarCurrentSelectedItemDidChangedBlock)CurrentSelectedItemDidChangedBlock
{
    self.tabBarCurrentSelectedItemDidChangedBlock = CurrentSelectedItemDidChangedBlock;
}


-(void)setEvSelectedIndex:(NSInteger)evSelectedIndex Animated:(BOOL)animated
{
    _evSelectedIndex = evSelectedIndex;
    if (self.tabBarCurrentSelectedItemDidChangedBlock) {
        self.tabBarCurrentSelectedItemDidChangedBlock(_evSelectedIndex);
    }
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
    }

    CGRect frame = self.evTabMaskImageView.frame;
  	frame.origin.x = [self horizontalLocationFor:self.evSelectedIndex];
    self.evTabMaskImageView.frame = frame;
    
    if (animated) {
        [UIView commitAnimations];
    }
}


#pragma mark - setter
-(void)setEvTabbarBackGroudImageName:(NSString *)evTabbarBackGroudImageName
{
    _evTabbarBackGroudImageName = evTabbarBackGroudImageName;
    self.evTabBackGroudView.image = [UIImage imageNamed:_evTabbarBackGroudImageName];
}

-(void)setEvTabbarMaskImageName:(NSString *)evTabbarMaskImageName
{
    _evTabbarMaskImageName = evTabbarMaskImageName;
    self.evTabMaskImageView.image = [UIImage imageNamed:_evTabbarMaskImageName];

}

-(void)setEvTabbarItemsModelArray:(NSMutableArray *)evTabbarItemsModelArray
{
    if (evTabbarItemsModelArray == nil || [evTabbarItemsModelArray count] == 0) {
        NIF_ERROR(@"数组为空，请重新设置");
        return;
    }
    if (nil==_evTabbarItemsModelArray) {
        _evTabbarItemsModelArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    [_evTabbarItemsModelArray removeAllObjects];
    [_evTabbarItemsModelArray addObjectsFromArray:evTabbarItemsModelArray];
    [self initTabbarItemsView];
}

-(void)setEvSelectedIndex:(NSInteger)evSelectedIndex
{
    [self setEvSelectedIndex:evSelectedIndex Animated:NO];
   
}


-(void)setEvTabTopsplitImageName:(NSString *)evTabTopsplitImageName
{
    _evTabTopsplitImageName = evTabTopsplitImageName;
    self.evTabTopSplitImageView.image = [UIImage imageNamed:self.evTabTopsplitImageName];
    
}

-(void)setHiddenTittle:(BOOL)hiddenTittle
{
    if (hiddenTittle != _hiddenTittle) {
        _hiddenTittle = hiddenTittle;
        for (UILabel* tempLable in self.subviews) {
            
            if (tempLable.tag >= BaseTabItemIconTitleLableTag) {
                tempLable.hidden = self.hiddenTittle;
            }
        }
    }
    
   
}

#pragma mark - getter
-(UIImageView*)evTabBackGroudView
{
    if (nil == _evTabBackGroudView) {
        _evTabBackGroudView = [[UIImageView alloc] init];
        _evTabBackGroudView.backgroundColor = [UIColor clearColor];
    }
    return _evTabBackGroudView;
}

-(UIImageView*)evTabMaskImageView
{
    if(nil == _evTabMaskImageView){
        _evTabMaskImageView = [[UIImageView alloc] init];
        _evTabMaskImageView.backgroundColor = [UIColor clearColor];
    }
    return _evTabMaskImageView;
}

-(UIImageView*)evTabTopSplitImageView
{
    if (nil == _evTabTopSplitImageView) {
        _evTabTopSplitImageView = [[UIImageView alloc] init];
        _evTabTopSplitImageView.backgroundColor = [UIColor clearColor];
    }
    return _evTabTopSplitImageView;
}


@end
