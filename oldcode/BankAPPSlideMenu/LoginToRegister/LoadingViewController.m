//
//  LoadingViewController.m
//  BankVip2
//
//  Created by kevin on 14-2-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "LoadingViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface LoadingViewController ()

@property (strong, nonatomic) MBProgressHUD *progressHUD;
@end

@implementation LoadingViewController
@synthesize imgView,lb_loading,token;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.imgView.backgroundColor = [UIColor redColor];
    if (IS_IPHONE5) {
        CGRect rect = self.imgView .frame;
        rect.size.height += 88;
        self.imgView.frame = rect;
  
   }
}


- (void)viewDidAppear:(BOOL)animated
{
    NSNumber *deviceid = [UserInfoUtil getUserDeviceID];
    if (0 == [deviceid intValue]) {
        self.lb_loading.hidden = YES;
//        [self requestTokenReg];//junyi.zhu 2014.03.06 以后加，发送token注册
        [self presentModalVC];
    }
    else {
        [NSThread sleepForTimeInterval:1];
        [self presentModalVC];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Request
- (void)requestTokenReg
{
    LoadingPostObj *postData = [[LoadingPostObj alloc] init];
    postData.token = self.token;
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    
    LoadingTask *task = [[LoadingTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask
{
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (NSString *)getErrMessage:(Task *)aTask
{
    NSString *msg;
    if (aTask.responseDict) {
        msg = [aTask.responseDict objectForKey:@"code"];
        if ([msg isEqualToString:@"9999"]) {
            msg = @"失败";
        }
        else if ([msg isEqualToString:@"9003"])
        {
            msg = @"手机号码格式错误";
        }
    }
    else {
        msg = NSLocalizedString(@"RequestFailed", nil);
    }
    return msg;
}



- (void)didTaskFinished:(Task *)aTask
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
   
        if ([aTask isKindOfClass:[LoadingTask class]]) {
            //写入设备ID
            [UserInfoUtil setUserDeviceID:aTask.responseDict];
            
        }
   
        [self presentModalVC];
   
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate exitApp];
    }
}

#pragma mark - Custom Method
- (void)presentModalVC
{
    
    LoginViewController *BankVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:BankVC];
    [navController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:navController animated:NO completion:nil];
//    [self.view removeFromSuperview];
//    [self.navigationController pushViewController:navController animated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    
}




@end
