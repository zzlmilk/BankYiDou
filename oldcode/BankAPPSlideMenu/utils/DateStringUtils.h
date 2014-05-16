//
//  DateStringUtils.h
//  Association
//
//  Created by Chen Bing on 13-6-6.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateStringUtils : NSObject

+ (NSString *)compareCurrentTime:(NSString *)formatDate;
+ (NSString *)compareCurrentTimeForAct:(NSString *)formatDate;

//对比时间是否在某个时间段内
+ (BOOL)compareServiceTime:(NSString *)serviceTime withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime;

//获取结束时间
+ (NSString *)compareEndDate:(NSString *)endDate;

@end
