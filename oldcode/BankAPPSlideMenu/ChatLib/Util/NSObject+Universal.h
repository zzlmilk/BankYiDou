
#import <Foundation/Foundation.h>

#define SAFELY_RELEASE(__POINTER) { [__POINTER release]; __POINTER = nil; }

NSString *EMDocumentDirectory(void);
NSString *EMCachesDirectory(void);

////////////////////////////////////////////////////////////////////////////////////////

NSString * emptyString(NSString *anMaybeEmptyString);
NSDictionary * paramsFromQueries (NSString *queries);
NSString *QueriesFromParams (NSDictionary *params);

////////////////////////////////////////////////////////////////////////////////////////
@interface NSString (CachePath)

+ (NSString *)filePathFromURL:(NSString *)url;
-(BOOL)isShowBuyIcon;
@end

////////////////////////////////////////////////////////////////////////////////////////


@interface NSUserDefaults (standardUserDefaults)

+ (NSString *)stringOfKeyInStandardDefaults:(NSString *)key;
+ (void)setStandardDefaultsObject:(id)object forKey:(NSString *)key;

@end

////////////////////////////////////////////////////////////////////////////////////////

@interface UIAlertView (Categories)

+ (void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_;
+ (void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ delegate:aDelegate;
+ (void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ delegate:aDelegate tag:(NSInteger)aTag;

@end

@interface UIImage (Category)

+ (UIImage *)bundleImageName:(NSString *)imageName;

@end



@interface UIView (RoundCorner)

- (void)needsRoundCorner:(float)radius;
- (void)needShadow:(BOOL)needs;
- (void)needsBorder:(UIColor *)borderColor;
- (void)needsBorder:(UIColor *)borderColor width:(NSInteger)width;

@end	

@interface NSMutableURLRequest (Header)

+ (NSDictionary *)getHeader;
- (void)setDDHeader;
- (void)setDDHeaderMore:(NSDictionary *)header;

//- (void)setDDHeaderMore:(NSDictionary *)header avoidStatistics:(BOOL)avoidStatistics;

+ (NSString *) getAppID;

@end
 
