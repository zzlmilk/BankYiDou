//
//  NetWorkWatchDogManager.h
//  网络监听程序

//
//  Created by Sean Li on 13-9-5.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface NetWorkWatchDogManager : NSObject


+(NetWorkWatchDogManager*)shareInstance;
+(void)destroyInstance;

/*!
 *@abstract 开始网络看守
 *@discussion 在程序开始启动的时候调用
 */

-(void) startWatchDog;

/*!
 *@abstract  停止网络看守
 *@discussion 在程序退出调用
 */
-(void) stopWatchDog;

#pragma mark 是什么网络
- (BOOL) isReachableViaWWAN;//  3g/2g
- (BOOL) isReachableViaWiFi;//  wifi
- (BOOL) isHaveNetWork;

//代码内判断网络状况
+ (BOOL) isConnectNetWork;

-(BOOL) isSocketConnet;


//是否是背景运行状态
-(BOOL)isBackGroundRunMode;
@end
