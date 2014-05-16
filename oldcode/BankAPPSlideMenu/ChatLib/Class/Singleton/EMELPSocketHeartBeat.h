//
//  EMELPSocketHeartBeat.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-26.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SendHeartBeatNSTimeInterval  40


@interface EMELPSocketHeartBeat : NSObject
//注需要在软件运行的时候  启动一下，修正为自动触发机制
+(EMELPSocketHeartBeat*)shareInstance;

+(void)destroyInstance;

/**
 *@method 开始心跳包
 */
-(void)startHeartBeat;

/**
 *@method 停止心跳包
 */
-(void)stopHeartBeat;

@end
