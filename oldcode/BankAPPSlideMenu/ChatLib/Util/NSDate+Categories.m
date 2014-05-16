
#import "NSDate+Categories.h"

#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy/MM/dd")

@implementation NSDate(Categories)

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
  //  [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
	[formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
   
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    
	return dateString;
}

- (NSString *)normalizeDateString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    if ([components day] >= 3) {
        return [NSDate stringFromDate:self format:@"yyyy-MM-dd"];
    } else if ([components day] >= 2) {
        return @"前天";
    } else if ([components day] >= 1) {
        return @"昨天";
    } else if ([components hour] > 0) {
        return [NSString stringWithFormat:@"%d小时前", [components hour]];
    } else if ([components minute] > 0) {
        return [NSString stringWithFormat:@"%d分钟前", [components minute]];
    } else if ([components second] > 0) {
        return [NSString stringWithFormat:@"%d秒前", [components second]];
    } else {
        return @"刚刚";
    }
}

+ (NSDate *)dateForTodayInClock:(NSInteger)clock
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit) fromDate:[NSDate date]];
    [todayComponents setHour:clock];
    NSDate *theDate = [gregorian dateFromComponents:todayComponents];
    return theDate;
}

@end
