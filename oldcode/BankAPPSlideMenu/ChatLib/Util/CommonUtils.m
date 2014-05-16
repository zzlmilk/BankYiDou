//
//  CommonUtils.m
//  EMEAPP
//
//  Created by Sean Li on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils
#pragma mark - 获取字符长度

+(NSInteger)stringLengthWithString:(NSString*)newString
{
    if (!newString || [[newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] ==0 ) {
        return 0;
    }else{
        const char  *cString = [newString UTF8String];
        
        return strlen(cString);
        
    }
}

#pragma mark - 路径获取
+ (NSString*) GetDocumentsPath;
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}

+(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



#pragma mark - 打开连接
+(void)openURL:(NSString*)url{
    if (url != nil) {
        // 为了处理  http://www.baidu.com  和  www.baidu.com 这两种字符
        url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        url =  [NSString stringWithFormat:@"http://%@",url];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

+(void)CallPhoneWith:(NSString*)phoneNumber{
    if (IS_IPHONE && !IS_IPOD) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]];
        //方法一
        //[[UIApplication sharedApplication] openURL:phoneURL]; //拨号
        
        //方法二
        static UIWebView* phoneCallWebView ;
        if (!phoneCallWebView ) {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }else{
        [self.class AlertWithMsg:@"您的设备不支持打电话"];
    }
}

#pragma mark - 合法性检查

+ (BOOL) validate_email:(NSString*) email
{
    NSString *email_regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", email_regex];
    return [predicate evaluateWithObject:email];
}

+ (BOOL) validate_phone_number:(NSString*) phone_number
{
    //添加了兼容 0  +86 前缀方法
    phone_number = [CommonUtils handle_phone_number:phone_number];
    
    NSString *phone_number_regex = @"^1[0-9]{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone_number_regex];
    return [predicate evaluateWithObject:phone_number];
    
    
    //#warning  需要优化电话号码验证
    //    /**
    //     * 手机号码
    //     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     * 联通：130,131,132,152,155,156,185,186
    //     * 电信：133,1349,153,180,189
    //     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    /**
    //     10         * 中国移动：China Mobile
    //     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //     15         * 中国联通：China Unicom
    //     16         * 130,131,132,152,155,156,185,186
    //     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    /**
    //     20         * 中国电信：China Telecom
    //     21         * 133,1349,153,180,189
    //     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //
    //    BOOL bRegext = ([regextestmobile evaluateWithObject:phone_number] == YES)
    //    || ([regextestcm evaluateWithObject:phone_number] == YES)
    //    || ([regextestct evaluateWithObject:phone_number] == YES)
    //    || ([regextestcu evaluateWithObject:phone_number] == YES);
    //
    //    return bRegext;
}

+ (BOOL) validate_string_number:(NSString*)string_number
{
    NSString *number_regex = @"\\d";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number_regex];
    return [predicate evaluateWithObject:string_number];
    
}

+ (BOOL) validate_identitycard:(NSString*)identitycard{
    //仅位数验证
    if (identitycard.length == 18) {
        return YES;
    }
    return NO;
}


#pragma mark - 图片相关处理

+(UIImage*)ImageWithImageName:(NSString*)imageName EdgeInsets:(UIEdgeInsets)edgeInsets
{
    
    UIImage* temp_image = nil;
    if (imageName == nil) {
        return nil;
    }
    
    if (EME_SYSTEMVERSION >= 6) {
        temp_image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:edgeInsets
                                                                    resizingMode:UIImageResizingModeStretch] ;
    }else  if (EME_SYSTEMVERSION >= 5){
        temp_image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:edgeInsets];
    } else{
        temp_image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top];
    }
        
   

    return temp_image;
    
}

#pragma mark - 获取自动缩放比例吃出
//newSize使用来获取比例的
+(CGRect)autoFitSize:(CGRect)old_frame  newSize:(CGSize)newSize{
    
    if (old_frame.size.width < newSize.width) {
        newSize.height = newSize.height*old_frame.size.width/newSize.width;
        newSize.width = old_frame.size.width;
        
    }
    if (old_frame.size.height < newSize.height) {
        newSize.width  = newSize.width*old_frame.size.height/newSize.height;
        newSize.height = old_frame.size.height;
    }
    
    return CGRectMake(old_frame.origin.x+(old_frame.size.width-newSize.width)/2.0, old_frame.origin.y+(old_frame.size.height-newSize.height)/2.0, newSize.width, newSize.height);
}


#pragma mark - 自动适配尺寸
+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize
{
	CGFloat scale;
	CGSize newsize;
	
	if(thisSize.width<aSize.width && thisSize.height < aSize.height)
	{
		newsize = thisSize;
	}
	else
	{
		if(thisSize.width >= thisSize.height)
		{
			scale = aSize.width/thisSize.width;
			newsize.width = aSize.width;
			newsize.height = thisSize.height*scale;
		}
		else
		{
			scale = aSize.height/thisSize.height;
			newsize.height = aSize.height;
			newsize.width = thisSize.width*scale;
		}
	}
	return newsize;
}

// Proportionately resize, completely fit in view, no cropping
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize
{
	// calculate the fitted size
	CGSize size = [self.class fitSize:image.size inSize:viewsize];
	
	UIGraphicsBeginImageContext(size);
    
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[image drawInRect:rect];
	
	UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newimg;
}




#pragma  mark - 日期格式处理

#define DEFAULTDATEFORMATTER @"yyyy-MM-dd"
#define DAYSECENDS 86400.0
static NSDateFormatter *CommonShareDateFormatter = nil;
+(id)shareDateFormater
{
    if (CommonShareDateFormatter == nil) {
        CommonShareDateFormatter = [[NSDateFormatter alloc]  init];
    }
    
    return CommonShareDateFormatter;
}
/*
 *日期转换为字符串函数
 *参数：DateFormatter 的格式如 2012-02-05  这种日期使用  yyyy-MM-dd
 */
+ (NSDate *)StringConvertToDateWithString:(NSString * )dateString  DateFormatter:(NSString*)formatter
{
    if (!dateString) {
        return nil;
    }
    NSDateFormatter * dateFormatter = [self.class shareDateFormater];
    if (formatter == nil) {
        formatter = DEFAULTDATEFORMATTER;
    }
    [dateFormatter setDateFormat: formatter];
    NSDate *date = nil;
    NSError *error = nil;
    
    if ([dateFormatter getObjectValue:&date forString:dateString range:nil error:nil]) {
        NIF_INFO(@"%@",error);
    }
    //     [dateFormatter dateFromString:string]; iOS5 上面有问题
    //    NSString *date_string = @"1983-05-01T00:00:00+08:00";
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    //     // insert code here...
    //    NSLog(@"%@",[dateFormatter dateFromString:date_string]);
    
    return date;
}
+ (NSString *)DateConvertToStringWithDate:(NSDate *)date  DateFormatter:(NSString*)formatter
{
    
    NSDateFormatter * dateFormatter = [self.class shareDateFormater];
    if (formatter == nil) {
        formatter = DEFAULTDATEFORMATTER;
    }
    [dateFormatter setDateFormat: formatter];
    NSString *dateString = [dateFormatter stringFromDate:date ];
    return dateString;
}

//放回有好字符串描述
//比如  最后一天，上一周等
+ (NSString *)DateConvertToFriendlyStringWithDate:(NSDate *)date
{
    
    NSDate * currentDate=[NSDate date];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=kCFCalendarUnitMinute|kCFCalendarUnitHour|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    
     NSDateComponents * currentConponent= [cal components:unitFlags fromDate:currentDate];
    NSDateComponents * oldConponent = [cal components:unitFlags fromDate:date];
    
    NSDateFormatter *outputFormatter = [self.class shareDateFormater];

    
//    NSInteger oldMonth = [oldConponent month];
    //    NSInteger oldHour = [oldConponent hour];
    //    NSInteger oldMinute = [oldConponent minute];
    NSInteger oldWeekday = [oldConponent weekday];
    NSInteger currentWeekday = [currentConponent weekday];

    NSString *week;
    //NSString *weekday;
    
    
    
    NSInteger spanDays = (NSInteger)(([currentDate timeIntervalSince1970] - [date timeIntervalSince1970])/DAYSECENDS);
    
    NSString * nsDateString;
    switch (oldWeekday) {
        case 1:
            week = @"星期天";
            //weekday = @"Sunday";
            break;
        case 2:
            week = @"星期一";
            // weekday = @"Monday";
            break;
        case 3:
            week = @"星期二";
            //weekday = @"Tuesday";
            break;
        case 4:
            week = @"星期三";
            // weekday = @"Wednesday";
            break;
        case 5:
            week = @"星期四";
            //weekday = @"Thursday";
            break;
        case 6:
            week = @"星期五";
            //weekday = @"Friday";
            break;
        case 7:
            week = @"星期六";
            //weekday = @"Saturday";
            break;
        default:
            break;
    }
    
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    

    if (spanDays == 0)
    {
        nsDateString = [NSString stringWithFormat:@"%@",newDateString];
    }
    else if (spanDays  == 1)
    {

        nsDateString = [NSString stringWithFormat:@"昨天 %@",newDateString];
    }
    else if (( 1 < spanDays ) &&  (spanDays < 7))
    {
        NSInteger newCurrentWeekday = currentWeekday == 1 ? 8 : currentWeekday;
        NSInteger newOldWeekday = oldWeekday == 1 ? 8 : oldWeekday;

        if (newCurrentWeekday <= newOldWeekday) {
            [outputFormatter setDateFormat:@"MM月dd日"];
            nsDateString = [NSString stringWithFormat:@"%@ %@ %@",[outputFormatter stringFromDate:date],week,newDateString];//处理结果，  星期一、上星期二
        }else{
            nsDateString = [NSString stringWithFormat:@"%@ %@",week,newDateString];
        }
    }
    
    else // if(time>=7  )
    {
        [outputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
       nsDateString = [outputFormatter stringFromDate:date];
    }
    
    
    return nsDateString;
}

//转换秒为  x小时x分钟x秒模式
+ (NSString*)SecondConvertToFriendlyStringWithSecond:(NSInteger)second
{
    return [self.class SecondConvertToFriendlyStringWithSecond:second isUTC:NO];
}


//转换秒为  x小时x分钟x秒模式 isUTC = YES 时间显示为 23:59:59
+ (NSString*)SecondConvertToFriendlyStringWithSecond:(NSInteger)second isUTC:(BOOL)isUTC
{

    NSMutableString * friendlyString = [[NSMutableString alloc] init];
    NSInteger hours = (NSInteger)(floorf(second/(60*60.0)));
    NSInteger minutes =  ((NSInteger)floorf(second/60.0))%60;
    NSInteger leftSecond =   second%60;
    
    if (hours > 0) {
        [friendlyString appendFormat:@"%02d%@",hours,(isUTC ? @":" : @"小时")];
    }
    if (minutes > 0) {
        [friendlyString appendFormat:@"%02d%@",minutes,(isUTC ? @":" : @"分")];
    }
    if (leftSecond > 0) {
        [friendlyString appendFormat:@"%02d%@",leftSecond,(isUTC ? @"" : @"秒")];
    }
    return friendlyString;
}


//转换秒为  x小时x分钟x秒模式 isUTC = YES 时间显示为 23:59:59
+ (NSMutableDictionary*)DicConvertToFriendlyStringWithSecond:(NSInteger)second
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSInteger hours = (NSInteger)(floorf(second/(60*60.0)));
    NSInteger minutes =  ((NSInteger)floorf(second/60.0))%60;
    
    if (hours > 0) { 
        [resultDic setObject:[NSString stringWithFormat:@"%02d",hours] forKey:@"hour"];
    }
    if (minutes > 0) {
        [resultDic setObject:[NSString stringWithFormat:@"%02d",minutes] forKey:@"minute"];
    }
    return resultDic;
}

#pragma mark - alert 弹出框
static UIAlertView*     _p_s_alertView = nil;

+(id)AlertIsExist
{
    return _p_s_alertView;
}

+(void)AlertViewClear
{
    if (_p_s_alertView != nil && _p_s_alertView.visible) {
        _p_s_alertView.delegate = nil;
        _p_s_alertView.cancelButtonIndex=0;
        [_p_s_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _p_s_alertView = nil;
    }
    
}

+(id)AlertWithMsg:(NSString*)msg
{
    return  [self.class AlertWithTitle:Nil Msg:msg];
}

+(id)AlertWithTitle:(NSString*)title  Msg:(NSString*)msg
{
    return  [self.class AlertWithTitle:title Msg:msg Delegate:nil];
}
+(id)AlertWithTitle:(NSString*)title  Msg:(NSString*)msg Delegate:(id)delegate{
    return  [self.class AlertWithTitle:title OkButtonTitle:@"确定" CancelButtonTitle:nil Msg:msg Delegate:delegate Tag:0];
}

+(id)AlertWithTitle:(NSString*)title
      OkButtonTitle:(NSString*)okTitle
  CancelButtonTitle:(NSString*)cancelTitle
                Msg:(NSString*)msg
           Delegate:(id)delegate
                Tag:(NSInteger)tag
{
    //先清理弹出框
    [self.class AlertViewClear];
    
    if (msg == nil) {
        return nil;
    }
    //    if (cancelTitle == nil) {
    //        cancelTitle = @"取消";
    //    }
    _p_s_alertView = nil;
    
    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:title==nil?@"提示":title
                                                        message:msg
                                                       delegate:delegate
                                              cancelButtonTitle:cancelTitle
                                              otherButtonTitles:okTitle, nil];
    _p_s_alertView = alertview;
    
    if (tag > 0) {
        alertview.tag = tag;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
     [alertview show];
    });
    
    return alertview;
}




//获取window 视窗
+(id)getWindowView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    if ([windows count] >0) {
        keyWindow = [windows objectAtIndex:0];
    }
    return keyWindow;

}

#pragma mark - 获取字符串所需要的高和宽

//根据文字的大小和既定的宽度，来计算文字所占的高度
+(CGFloat) lableWithTextStringHeight:(NSString*)labelString andTextFont:(UIFont*)font  andLableWidth:(float)width
{
     
    return [labelString sizeWithFont:font constrainedToSize:CGSizeMake(width, 100000) lineBreakMode:NSLineBreakByWordWrapping].height ;
}


//根据文字的大小和既定的宽度，来计算文字所占的宽度
+(CGFloat) lableWithTextStringWidth:(NSString*)labelString andTextFont:(UIFont*)font  andLableHeight:(float)height
{
    
    return [labelString sizeWithFont:font constrainedToSize:CGSizeMake(320,height) lineBreakMode:NSLineBreakByWordWrapping].width;
}

//根据文字的大小和既定的宽度，来计算文字所占的高度  // 可以修改成  类别
+(CGFloat) lableHeightWithLable:(UILabel*)label
{
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 100000) lineBreakMode:NSLineBreakByWordWrapping].height ;
}

//根据文字的大小和既定的宽度，来计算文字所占的宽度
+(CGFloat) lableWidthWithLable:(UILabel*)label // 可以修改成  类别
{
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(320,label.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping].width;
}


#pragma mark - pravite

#pragma mark  处理电话号码
//处理  0 +86 等前缀,系统将统一去掉这些前缀
+ (NSString*)handle_phone_number:(NSString*) phone_number
{
    if ([phone_number hasPrefix:@"0"]) {
        return  [phone_number substringFromIndex:1];
    }else if([phone_number hasPrefix:@"+86"]){
        return  [phone_number substringFromIndex:3];
    }else if([phone_number hasPrefix:@"86"]){
        return  [phone_number substringFromIndex:2];
    }else{
        return phone_number;
    }
}


#pragma mark 排序
+ (void) SortForArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo
{
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    [dicArray sortUsingDescriptors:descriptors];
}

#pragma mark 本地通知
+(void)localNotificationSendWithBody:(NSString*)body  SoundName:(NSString*)soundName  Info:(NSDictionary*)info
{
    UILocalNotification *newNotification = [[UILocalNotification alloc] init];
    if (newNotification) {
        //时区
        newNotification.timeZone=[NSTimeZone defaultTimeZone];
        //推送事件---10秒后
//        newNotification.fireDate=[[NSDate date] dateByAddingTimeInterval:10];
        
        if (!body) {
            body = @"你有一条新消息!";
        }
        //推送内容
        newNotification.alertBody = body;
        //应用右上角红色图标数字
        newNotification.applicationIconBadgeNumber += 1;
        if (soundName) {
            newNotification.soundName = soundName;
        }
        //设置按钮
//        newNotification.alertAction = @"关闭";
 
//        newNotification.repeatInterval = NSWeekCalendarUnit;
        
        if (info) {
            newNotification.userInfo = [NSDictionary dictionaryWithDictionary:info];
        }
        
        [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    }
}


 

@end

