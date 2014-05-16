//
//  EMETabSegmentedContrlView.m
//  UiComponentDemo
//
//  Created by Sean Li on 14-2-21.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//

#import "EMETabSegmentedContrlView.h"
#define BaseTabButtonIndexTag  2000
@interface EMETabSegmentedContrlView ()
@end

@implementation EMETabSegmentedContrlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

     }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        _evSelectedIndex = 0;
        _evTabBackGroudImageName  = DefualtTabBackGroudImageName;
        _evSelectedTabBackgroudImageName  = DefaultSeletedTabBackGroudImageName;
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

-(void)setAttributeWithTabNamesArray:(NSArray*)tabNamesArray
               TabBackGroudImageName:(NSString*)tabBackGrouImageName
       SelectedTabBackGroudImageName:(NSString*)selectedTabBackGrouImageName
                  defaultSelectIndex:(NSInteger)selectIndex
         TabSegmentedDidChangedBlock:(EMETabSegmentedDidChangedBlock)tabSegmentedDidChangedBlock
{
    if (tabBackGrouImageName) {
        _evTabBackGroudImageName = tabBackGrouImageName;
    }else{
        _evTabBackGroudImageName = DefualtTabBackGroudImageName;
    }
    
    if (selectedTabBackGrouImageName) {
        _evSelectedTabBackgroudImageName = selectedTabBackGrouImageName;
    }else{
        _evTabBackGroudImageName = DefaultSeletedTabBackGroudImageName;
     }
    
    self.evTabNamesArray = tabNamesArray;

    _evSelectedIndex = selectIndex;
    
    if (tabSegmentedDidChangedBlock) {
        _evTabSegmentedDidChangedBlock = tabSegmentedDidChangedBlock;
    }else{
        NIF_ALLINFO(@"请设置并实现相应的block 参数");
    }

}

#pragma mark - define
-(void)buttonClick:(UIButton*)button
{
    NIF_ALLINFO(@"TabButton Click");
    if (button.tag >= BaseTabButtonIndexTag) {
        //处理事务
        [self setEvSelectedIndex:button.tag - BaseTabButtonIndexTag];
        
        if (self.evTabSegmentedDidChangedBlock) {
            self.evTabSegmentedDidChangedBlock(button.tag - BaseTabButtonIndexTag);
        }
    }
}

#pragma mark - setter
-(void)setEvTabNamesArray:(NSArray *)evTabNamesArray
{
  
    _evTabNamesArray = [NSArray arrayWithArray:evTabNamesArray];
    
    if (!self.evTabNamesArray || [self.evTabNamesArray count] == 0) {
        NIF_ALLINFO(@"请设置Tab名称 evTabNamesArray");
    }
    
    CGRect etFrame =  CGRectMake(0, 0, 95, 35);
    NSInteger space = (320 - [self.evTabNamesArray count]*etFrame.size.width)/([self.evTabNamesArray count] +1);
    if (space <= 0) {
        NIF_ALLINFO(@"你设置的项目比较多，建议设置标签数目为3");
        return;
    }
    UIImage* tabBackGroudImage = [UIImage imageNamed:self.evTabBackGroudImageName];
    UIImage* tabSelectedBackGroudImage = [UIImage imageNamed:self.evSelectedTabBackgroudImageName];
    for (NSInteger i=0; i< [self.evTabNamesArray count] ; i++) {
        NSString* tabTitle = [self.evTabNamesArray objectAtIndex:i];
        UIButton* tabButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.backgroundColor = [UIColor clearColor];
        [tabButton setBackgroundImage:tabBackGroudImage forState:UIControlStateNormal];
        [tabButton setBackgroundImage:tabSelectedBackGroudImage forState:UIControlStateSelected];
        [tabButton setTitle:tabTitle forState:UIControlStateNormal];
        tabButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tabButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [tabButton setTitleColor:UIColorFromRGB(0xA69383)  forState:UIControlStateSelected];
        tabButton.tag = BaseTabButtonIndexTag + i;
        etFrame.origin.x = space +(space + etFrame.size.width)*i;
        tabButton.frame = etFrame;
        [tabButton addTarget:self action:@selector(buttonClick:)  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tabButton];
    }
    [self setNeedsDisplay];
}

-(void)setEvSelectedIndex:(NSInteger)evSelectedIndex
{
    _evSelectedIndex = evSelectedIndex;
    
    for (UIView* tempView in [self subviews]) {
        if ([tempView isKindOfClass:[UIButton class]]) {
            [((UIButton*)tempView) setSelected:NO];
         }
    }

    UIButton* selectButton = (UIButton*)[self viewWithTag:BaseTabButtonIndexTag+self.evSelectedIndex];
    [selectButton setSelected:YES];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}


@end
