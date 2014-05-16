//
//  UserGuideViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-4-8.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "UserGuideViewController.h"
#import "UIButton+defineButton.h"
#import "AppDelegate.h"
#import "MoreViewController.h"

#define CreatImage(imagePath) [UIImage imageNamed:imagePath]
#define CreateView(view,x,y,wid,hei) [[view alloc] initWithFrame:CGRectMake(x, y, wid, hei)]
#define ClearColor [UIColor clearColor]
#define WhiteColor [UIColor whiteColor]

//appdelegate
#define APPDELEGETE  (AppDelegate *)[[UIApplication sharedApplication]delegate]

@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initGuide];
}

/*
 *加载新用户指导页面
 */
- (void)initGuide
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(320*5, self.view.frame.size.height)];
    scrollView.delegate = self;
    [scrollView setPagingEnabled:YES];//视图整页面显示
    for (int i = 1; i < 5; i++) {
        UIImageView *imageV = CreateView(UIImageView, 320*(i-1), 0, 320, self.view.frame.size.height);
        NSString *iName = [NSString stringWithFormat:@"setup%d",i];
        imageV.image = CreatImage(iName);
        [scrollView addSubview:imageV];
    }
    UIImageView *lastImageV = [[UIImageView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        lastImageV.frame = CGRectMake(320*4, 20, 320, self.view.frame.size.height);
    }else{
        lastImageV.frame = CGRectMake(320*4, 0, 320, self.view.frame.size.height);
    }
    lastImageV.userInteractionEnabled = YES;
    if ([self.stringDif isEqualToString:@"10001"]) {
        lastImageV.image = CreatImage(@"setup5");
        UIButton *btn = [UIButton defineButton:CGRectMake(60, 360-30, 200, 22) buttonType:UIButtonTypeCustom buttonTitle:@""];
        //    btn.backgroundColor = ClearColor;
        [btn setImage:[UIImage imageNamed:@"setup-button"] forState:UIControlStateNormal];
        [btn addClickAction:self Action:@selector(firstpressed)];
        [lastImageV addSubview:btn];
    }
    else if ([self.stringDif isEqualToString:@"10002"]){
        lastImageV.image = CreatImage(@"setup7_12");
        UIButton *btn = [UIButton defineButton:CGRectMake(280, 0, 40, 40) buttonType:UIButtonTypeCustom buttonTitle:@""];
        btn.backgroundColor = [UIColor clearColor];
        [btn addClickAction:self Action:@selector(morePressed)];
        [lastImageV addSubview:btn];
    }
    
    [scrollView addSubview:lastImageV];
    [self.view addSubview:scrollView];
    
    _pageControl = CreateView(UIPageControl, 60, self.view.frame.size.height-60, 200, 60);
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    _pageControl.enabled = YES;
    [self.view addSubview:_pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    _pageControl.currentPage = index;
}

- (void)firstpressed
{
    AppDelegate *delegate = APPDELEGETE;
    //
    [delegate presentMainVCBy:self];
}

- (void)morePressed
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
