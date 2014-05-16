//
//  aboutViewController.m
//  BankAPP
//
//  Created by kevin on 14-2-24.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize lbl_content,lbl_contentHidden,navBar,navItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    return self;
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        CGRect frame=self.view.frame;
//        if (frame.size.height==[[NSUserDefaults standardUserDefaults] floatForKey:@"windowHeight"])
//        {
//            frame.size.height-=20;
//        }
//        self.view.frame=frame;
//    }
//}

//-(void) setTitle:(NSString *)title
//{
//    [super setTitle:title];
//    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
//    if (!titleView) {
//        titleView =[[UILabel alloc]initWithFrame:CGRectZero];
//        titleView.backgroundColor =[UIColor clearColor];
//        titleView.font =[UIFont boldSystemFontOfSize:20.0];
//        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//        titleView.textColor =[UIColor whiteColor];
//        self.navigationItem.titleView =titleView;
//    }
//    titleView.text =title;
//    [titleView sizeToFit];
//    
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置导航条
//    UIImage *navBgImage = [UIImage imageWithCGImage:[[UIImage imageNamed:@"body_title.jpg"] CGImage] scale:2 orientation:UIImageOrientationUp];
//    [self.navBar setBackgroundImage:navBgImage forBarMetrics:UIBarMetricsDefault];
//
    
    
    
    
    
    
    
    
    
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:18];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"使用条款";
    self.navItem.titleView = t;
    
//    [lbl_content setText:@" "];
    lbl_content.font = [UIFont systemFontOfSize:16];
    [self requestParameter];
    
    
    
    
//   self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    if (!IS_IPHONE5) {
//        CGRect rect = self.aboutImageView.frame;
//        rect.size.height = 416;
//        self.aboutImageView.frame = rect;}
    
        
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//            self.extendedLayoutIncludesOpaqueBars = NO;
//            self.modalPresentationCapturesStatusBarAppearance = NO;
//            self.navigationController.navigationBar.barTintColor =[UIColor grayColor];
//            self.tabBarController.tabBar.barTintColor =[UIColor grayColor];
//        }
//        self.navigationController.navigationBar.translucent = NO;
//        self.tabBarController.tabBar.translucent = NO;


    
}

- (void)viewDidUnload {
    //    [self setLbl_content:nil];
    [self setNavBar:nil];
    [self setNavItem:nil];
    [super viewDidUnload];
}


#pragma mark - Network
- (void)requestParameter
{
//    SuperPostObj *postData = [[SuperPostObj alloc] init];
//    NSDictionary *postDict = [postData getPostDictWithData:CLUBID];
//    ParameterTask *task = [[ParameterTask alloc] initWithPostDict:postDict withDelegate:self];
//    [task run];
}

#pragma mark - Button Action
- (IBAction)closeClick:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];  6.0
    [self dismissViewControllerAnimated:NO completion:nil];

    //- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
