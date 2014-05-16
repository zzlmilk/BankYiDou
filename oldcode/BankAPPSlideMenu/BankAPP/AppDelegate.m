//
//  AppDelegate.m
//  BankAPP
//
//  Created by junyi.zhu on 14-2-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "AppDelegate.h"
#import "LoadingViewController.h"
#import "LoginViewController.h"
#import "ZeroViewController.h"
#import "HomePageplateFlag.h"
#import "PrivilegeVIPplateFlag.h"
#import "ExclusiveMoneyplateFlag.h"
#import "FinancialAdvisorplateFlag.h"
#import <sqlite3.h>
#import "Datamanager.h"

#import "Reachability.h"
#import "UserGuideViewController.h"
#define FIRST @"firstLaunch" //首次登陆

//-(CGAffineTransform)transformForOrientation{
//    UIInterfaceOrientation orientation= [[UIApplication sharedApplication] statusBarOrientation];
//    if (UIInterfaceO/jpush
//#import "APService.h"

//引入Help类.h文件
//#import "FRUncaughtExceptionHandler.h"

@implementation AppDelegate

@synthesize window=_window;
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (void)reachabilityChanged
{
	NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
	if (netStatus) {
		return;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络异常"
                                                        message:@"请检测您的网络状态"
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
	}
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
	internetReach = [Reachability reachabilityWithHostname:@"www.apple.com"];
	[internetReach startNotifier];
    
    //判断是不是第一次登陆
    if (![[NSUserDefaults standardUserDefaults] boolForKey:FIRST]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:FIRST];
        //如果是第一次登陆，使用 （欢迎页面）
        UserGuideViewController *userGVC = [[UserGuideViewController alloc]init];
        userGVC.stringDif = @"10001";
        self.window.rootViewController = userGVC;
    }
    else
    {
        //不是第一次登陆
        NSLog(@"2345");
        [self initMainVC];
    }
    
    sqlite3 *dataBase;
    dataBase = [Datamanager openDatabase];
    char *errorMsg;
    const char *createSql="create table if not exists 'myCollection' (id integer primary key, materialId text,imageURL text,title text,modeleName text,templet text)";
    if (sqlite3_exec(dataBase, createSql, NULL, NULL, &errorMsg) == SQLITE_OK) {
    }
    if (errorMsg!=nil) {
        NSLog(@"%s",errorMsg);
    }
    [Datamanager closeDataBase];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:UIColorFromRGB(0x78050C)];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.clipsToBounds =YES;
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
        self.window.bounds = CGRectMake(0,20, self.window.frame.size.width, self.window.frame.size.height);
        //Added on 19th Sep 2013
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x78050C)];//junyi  debug
    }
    
    //self.edgesForExtendedLayout = UIRectEdgeNone; 解决 
    /*
    + (void)fixNavBarColor:(UINavigationBar*)bar {
        if (iosVersion >= 7) {
            bar.barTintColor = [UIColor redColor];
            bar.translucent = NO;
        }else {
            bar.tintColor = [UIColor redColor];
            bar.opaque = YES;
        }
    }*/

    [self alertRemoteNotification];//远程通知
    [self.window makeKeyAndVisible];
    

    //判断程序是不是由推送服务完成的
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送通知"
                                                           message:@"这是通过推送窗口启动的程序，你可以在这里处理推送内容"
                                                          delegate:nil
                                                 cancelButtonTitle:@"知道了"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    return YES;
}

//直接加载
- (void)initMainVC
{
    [self openLoadingViewController:@""];
}
//点击userGCD上得进入按钮，推出
- (void)presentMainVCBy:(UserGuideViewController *)userGVC
{
    [self openLoadingViewController:@""];
}


#pragma mark - Push Message
//提示订阅
- (void)alertRemoteNotification
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

//iPhone 从APNs服务器获取deviceToken后回调此方法
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [[token description] stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉中间空格
    NSLog(@"deviceToken:%@", token);
    
//    [self openLoadingViewController:token];
    //    // jpush 
    //    // Required
    //    [APService registerDeviceToken:deviceToken];
}

//注册push功能失败 后 返回错误信息，执行相应的处理
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Push Register Error:%@", err.description);
    //    [self showAlert:err.description];
//    [self openLoadingViewController:@""];
    
}

// 接收到推送消息，解析处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"remote notification: %@",[userInfo description]);
    [self showAlert:userInfo.description];
    //    //jpush
    //    // Required
//    [APService handleRemoteNotification:userInfo];
}

- (void)showAlert:(id)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - openLoadingViewController
- (void)openLoadingViewController:(NSString *)token
{
    LoadingViewController*  loadingVC = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    loadingVC.token = token;
    self.window.rootViewController = loadingVC;
//    [self.window makeKeyAndVisible];
}

#pragma mark - 回到登陆界面
- (void)exitApp1
{
    [self openLoadingViewController:@""];
}

#pragma mark - 杀死进程
- (void)exitApp
{
    //缩小动画
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.window.transform=CGAffineTransformScale([self transformForOrientation], 0.001, 0.0011);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

-(CGAffineTransform)transformForOrientation{
    UIInterfaceOrientation orientation= [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationLandscapeLeft == orientation) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    }
    else if (UIInterfaceOrientationLandscapeRight == orientation) {
        return CGAffineTransformMakeRotation(M_PI/2);
    }
    else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
        return CGAffineTransformMakeRotation(-M_PI);
    }
    else {
        return CGAffineTransformIdentity;
    }
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
//}

//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

#pragma mark - Core Data stack
    
// Returns the managed object context for the application.
//// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return _managedObjectContext;
//}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
//- (NSManagedObjectModel *)managedObjectModel
//{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BankAPP" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}


@end
