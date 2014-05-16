//
//  DockView.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "DockView.h"
#import "EMERecentContactsEntity.h"
#import "NSObject+CoreDataExchange.h"


#define BASETAG 345

@implementation DockView
@synthesize iconArray_k;
@synthesize iconArray_l;

@synthesize titleArray_k;
@synthesize titleArray_l;

@synthesize lableunread;

static DockView * shareInstance = nil;

+ (DockView *)sharedDockView
{
    if (shareInstance == nil) {
        shareInstance = [[DockView alloc] init];
    }
    return shareInstance;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
        imagev.image = [UIImage imageNamed:@"uc_bg_btm.png"];
        [self addSubview:imagev];
        
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        NSString *string = [mySettingData objectForKey:@"userType"];
        
        self.iconArray_k = [NSArray arrayWithObjects:@"dock_tequan",@"dock_liuyan",@"dock_dianlian", nil];
        self.iconArray_l = [NSArray arrayWithObjects:@"dock_tequan",@"dock_liuyan",@"icon_btm_client", nil];
        
        self.titleArray_k = [NSArray arrayWithObjects:@"特权",@"留言",@"电联", nil];
        self.titleArray_l = [NSArray arrayWithObjects:@"特权",@"留言",@"客户", nil];
        
        for (int buttonIndex = 0; buttonIndex < 3;  buttonIndex++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = BASETAG +buttonIndex;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if ([string isEqualToString:@"0"]) {
                [btn setImage:[UIImage imageNamed:[self.iconArray_k objectAtIndex:buttonIndex]] forState:UIControlStateNormal];
            }
            else if ([string isEqualToString:@"1"]){
                [btn setImage:[UIImage imageNamed:[self.iconArray_l objectAtIndex:buttonIndex]] forState:UIControlStateNormal];
            }
            btn.frame = CGRectMake(15*(buttonIndex+1)+buttonIndex*100+15, 5, 30, 30);
            [self addSubview:btn];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(15*(buttonIndex+1)+buttonIndex*100+15, 38, 60, 15);
            label.font = [UIFont systemFontOfSize:13];
            label.backgroundColor = [UIColor clearColor];
            if ([string isEqualToString:@"0"]) {
                label.text = [self.titleArray_k objectAtIndex:buttonIndex];
            }
            else if ([string isEqualToString:@"1"]){
                label.text = [self.titleArray_l objectAtIndex:buttonIndex];
            }
            [self addSubview:label];
        }
    }
    lableunread = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 20, 20)];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"提示数20X20.png"]];
    [lableunread setBackgroundColor:color];
//    EMERecentContactsEntity * RecentEn = [[EMERecentContactsEntity alloc]init];
//    [RecentEn addNewUnReadMessagesCount];
    
    lableunread.font =[UIFont fontWithName:@"Arial" size:11];
    lableunread.textColor = [UIColor whiteColor];
    lableunread.textAlignment = NSTextAlignmentCenter;
    lableunread.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:lableunread];
    
    [self resetLabelunread];

    return self;
}

- (void)resetLabelunread
{
    NSArray* temp_array = [self getlatestRecentContactEntiesWithLimitTime];
    
    long count = 0;
    for (EMERecentContactsEntity* entity in temp_array) {
        count = entity.unReadMessagesCount + count;
    }
    NSLog(@"count:%ld",count);
    
    lableunread.text =[NSString stringWithFormat:@"%ld", count];
    
    int intString = [self.lableunread.text intValue];

    if (intString <=0) {
        [self.lableunread setHidden:YES];
    }
    else if(intString >0) {
        [self.lableunread setHidden:NO];
        
    }
    else if(intString > 100 ){
        self.lableunread.text =@"99+";
    }
    
}

- (void)btnClicked:(UIButton *)button
{
    UIButton *btn = (UIButton *)button;
    NSLog(@"kehu...%ld",(long)btn.tag);

    NSInteger index = btn.tag - BASETAG;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *bt = (UIButton *)view;
            if (bt.selected) {
                //留着后边优化的时候用
//                NSString * imageName = [self.iconArray_k objectAtIndex:(bt.tag - BASETAG)];
//                [bt setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                [bt setSelected:NO];
            }
        }
    }
    [btn setSelected:YES];
    
    //推视图
    
    
    //开辟新线程去请求数据
    NSString *str = [NSString stringWithFormat:@"%ld",(long)index];
    [NSThread detachNewThreadSelector:@selector(newThread:) toTarget:self withObject:str];
}

- (void)newThread:(id)sender
{
    NSLog(@"开辟新线程去请求数据");
    @try {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        //NSData *data = (NSData *)sender;
        //NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSInteger indx = [sender integerValue];
        [self.dockDelegate dockViewDidSelectIndex:indx];
    }
    @catch (NSException *exception) {
        //NSLog(@"%@",[exception name]);
    }
    @finally {
        //  //NSLog(@"不管报不报错都会执行的代码");
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
