//
//  DateStringUtils.m
//  Association
//
//  Created by Chen Bing on 13-6-6.
//  Copyright (c) 2013年 junyi.zhu. All rights reserved.
//

#import "DateStringUtils.h"

@implementation DateStringUtils

+ (NSString *)compareCurrentTime:(NSString *)formatDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([formatDate isKindOfClass:[NSNull class]] || 0 == formatDate.length) {
        return [NSString stringWithFormat:@"无"];
    }
    
    NSDate *compareDate = [formatter dateFromString:formatDate];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return result;
}

+ (NSString *)compareCurrentTimeForAct:(NSString *)formatDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([formatDate isKindOfClass:[NSNull class]] || 0 == formatDate.length) {
        return [NSString stringWithFormat:@"无"];
    }
    
    NSDate *compareDate = [formatter dateFromString:formatDate];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    long temp = 0;
    NSString *result;
    if (timeInterval < 0) {
        result = [NSString stringWithFormat:@"已到期"];
    }
    else if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟后",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时后",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天后",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld个月后",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年后",temp];
    }
    
    return result;
}

//对比时间是否在某个时间段内
+ (BOOL)compareServiceTime:(NSString *)serviceTime withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([startTime isKindOfClass:[NSNull class]] || 0 == startTime.length) {
        return NO;
    }
    else if ([endTime isKindOfClass:[NSNull class]] || 0 == endTime.length) {
        return NO;
    }
    
    //服务端时间差
    NSDate *compareDate = [formatter dateFromString:serviceTime];
    NSTimeInterval  timeInterval = [compareDate timeIntervalSince1970];
    
    //开始时间差
    compareDate = [formatter dateFromString:startTime];
    NSTimeInterval  startTimeInterval = [compareDate timeIntervalSince1970];
    
    //结束时间差
    compareDate = [formatter dateFromString:endTime];
    NSTimeInterval  endTimeInterval = [compareDate timeIntervalSince1970];
    
    if (timeInterval >= startTimeInterval && timeInterval <= endTimeInterval) {
        //正在进行
//        NSLog(@"投票正在进行");
        return YES;
    }
    else if (timeInterval < startTimeInterval) {
        //没有开始
//        NSLog(@"投票没有开始");
    }
    else if (timeInterval > endTimeInterval) {
        //已经过期
//        NSLog(@"投票已经过期");
    }
    
    /*
    if (timeInterval < startTimeInterval) {
        //没有开始
        NSLog(@"没有开始");
    }
    else if (timeInterval >= endTimeInterval) {
        //正在进行
        NSLog(@"正在进行");
        return YES;
    }
    else if (timeInterval > endTimeInterval) {
        //已经结束
        NSLog(@"已经结束");
    }
     */
    
    return NO;
}

//获取结束时间
+ (NSString *)compareEndDate:(NSString *)endDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([endDate isKindOfClass:[NSNull class]] || 0 == endDate.length) {
        return [NSString stringWithFormat:@"30天"];
    }
    
    NSDate *compareDate = [formatter dateFromString:endDate];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    if (timeInterval < 0) {
        //已经过期
        return [NSString stringWithFormat:@"0天"];
    }
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"即将"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟后",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时后",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天后",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld个月后",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年后",temp];
    }
    
    return result;
}


@end
