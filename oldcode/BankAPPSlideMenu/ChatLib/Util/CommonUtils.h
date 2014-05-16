//
//  CommonUtils.h
//  EMEAPP
//
//  Created by Sean Li on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface CommonUtils : NSObject
#pragma mark - 获取字符长度

+(NSInteger)stringLengthWithString:(NSString*)newString;

#pragma mark - 路径获取
+ (NSString*) GetDocumentsPath;
// Returns the URL to the application's Documents directory.
+(NSURL *)applicationDocumentsDirectory;


#pragma mark - 打开HTTP连接
+(void)openURL:(NSString*)url;
+(void)CallPhoneWith:(NSString*)phoneNumber;

#pragma mark - 合法性检查
+ (BOOL) validate_email:(NSString*) email;
+ (BOOL) validate_phone_number:(NSString*) phone_number;
+ (BOOL) validate_string_number:(NSString*)string_number;
+ (BOOL) validate_identitycard:(NSString*)identitycard;

#pragma mark - 图片相关处理
+(UIImage*)ImageWithImageName:(NSString*)imageName EdgeInsets:(UIEdgeInsets)edgeInsets;

#pragma mark - 获取自动缩放比例吃出
/**
 *@mothod 自动适配
 */
//newSize 实际的尺寸
+(CGRect)autoFitSize:(CGRect)old_frame  newSize:(CGSize)newSize;

#pragma mark - 自动适配尺寸
+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize;


#pragma  mark - 日期格式处理
+(id)shareDateFormater;
/*
 *日期转换为字符串函数
 *参数：DateFormatter 的格式如 2012-02-05  这种日期使用  yyyy-MM-dd
 */
+ (NSDate *)StringConvertToDateWithString:(NSString * )dateString  DateFormatter:(NSString*)formatter;
+ (NSString *)DateConvertToStringWithDate:(NSDate *)date  DateFormatter:(NSString*)formatter;

//转换有好字符串描述
//比如  最后一天，上一周等时间描述
+ (NSString *)DateConvertToFriendlyStringWithDate:(NSDate *)date;
//转换秒为  x小时x分钟x秒模式
+ (NSString*)SecondConvertToFriendlyStringWithSecond:(NSInteger)second;

//转换秒为  x小时x分钟x秒模式 isUTC = YES 时间显示为 23:59:59
+ (NSString*)SecondConvertToFriendlyStringWithSecond:(NSInteger)second isUTC:(BOOL)isUTC;

+ (NSMutableDictionary*)DicConvertToFriendlyStringWithSecond:(NSInteger)second;

#pragma mark - alert 弹出框
+(id)AlertIsExist;
+(void)AlertViewClear;
+(id)AlertWithMsg:(NSString*)msg;
+(id)AlertWithTitle:(NSString*)title  Msg:(NSString*)msg;
+(id)AlertWithTitle:(NSString*)title  Msg:(NSString*)msg Delegate:(id)delegate;
+(id)AlertWithTitle:(NSString*)title  OkButtonTitle:(NSString*)okTitle CancelButtonTitle:(NSString*)cancelTitle Msg:(NSString*)msg Delegate:(id)delegate Tag:(NSInteger)tag;


//获取window 视窗
+(id)getWindowView;
#pragma mark - 获取字符串所需要的高和宽
+(CGFloat) lableWithTextStringHeight:(NSString*)labelString andTextFont:(UIFont*)font  andLableWidth:(float)width;
+(CGFloat) lableWithTextStringWidth:(NSString*)labelString andTextFont:(UIFont*)font  andLableHeight:(float)height;
//根据文字的大小和既定的宽度，来计算文字所占的高度  // 可以修改成  类别
+(CGFloat) lableHeightWithLable:(UILabel*)label;
//根据文字的大小和既定的宽度，来计算文字所占的宽度
+(CGFloat) lableWidthWithLable:(UILabel*)label; // 可以修改成  类别

#pragma mark 排序
+ (void) SortForArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo;

#pragma mark 本地通知
+(void)localNotificationSendWithBody:(NSString*)body  SoundName:(NSString*)soundName  Info:(NSDictionary*)info;
@end
