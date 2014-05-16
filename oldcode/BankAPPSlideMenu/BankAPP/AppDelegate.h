//
//  AppDelegate.h
//  BankAPP
//
//  Created by junyi.zhu on 14-2-19.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
//引入控制器.h文件
#import "LoadingViewController.h"
@class UserGuideViewController;
@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability *internetReach;
}
@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//@property (strong, nonatomic) RegisterViewController *registerVC;

//退出软件
- (void)exitApp;

- (void)exitApp1;

- (void) presentMainVCBy:(UserGuideViewController*)userGVC;

//
//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

@end
