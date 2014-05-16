
#import <Foundation/Foundation.h>


@interface NSDate (Categories)

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format; 
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
- (NSString *)normalizeDateString;
+ (NSDate *)dateForTodayInClock:(NSInteger)clock;

@end
