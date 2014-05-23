//
//  ResultData.h
//  BankYiDou
//
//  Created by zzlmilk on 14-5-23.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResultData : NSObject

@property (nonatomic,strong) NSString * code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) id info;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *time;



- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
