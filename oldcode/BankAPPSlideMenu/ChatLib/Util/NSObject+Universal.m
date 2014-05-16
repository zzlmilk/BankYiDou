
#import "NSObject+Universal.h"
#import <QuartzCore/QuartzCore.h>


NSString *EMDocumentDirectory(void) {
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

NSString *EMCachesDirectory(void) {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

////////////////////////////////////////////////////////////////////////////////////////

NSString * emptyString(NSString *anMaybeEmptyString) {
    if ([anMaybeEmptyString isKindOfClass:[NSNumber class]]) {
        anMaybeEmptyString = [NSString stringWithFormat:@"%@",anMaybeEmptyString];
    }
	if (!anMaybeEmptyString || [anMaybeEmptyString length] == 0) return @"";
	else return anMaybeEmptyString;
	//	return @"";
}

NSDictionary * paramsFromQueries (NSString *queries) {
    if (!queries) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *pairs = [queries componentsSeparatedByString:@"&"];
    for (NSString *e in pairs) {
        NSArray *pair = [e componentsSeparatedByString:@"="];
        if ([pair count] == 2) {
            [params setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
        }
    }
    return params;
}

NSString *QueriesFromParams (NSDictionary *params) {
    NSString *query = nil;
    if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [[params objectForKey:key] description];
			NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																						  NULL, /* allocator */
																						  (CFStringRef)value,
																						  NULL, /* charactersToLeaveUnescaped */
																						  (CFStringRef)@"!*'();:@&=+$/?%#[]",
																						  kCFStringEncodingUTF8));
			
			[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
 		}
		query = [pairs componentsJoinedByString:@"&"];
    }
    return query;
}


////////////////////////////////////////////////////////////////////////////////////////
@implementation NSUserDefaults (standardUserDefaults)

+ (NSString *)stringOfKeyInStandardDefaults:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (void)setStandardDefaultsObject:(id)object forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end

////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (CachePath)

+ (NSString *)filePathFromURL:(NSString *)url {
    
    url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@":" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"." withString:@""];
  
    return url;
}
-(BOOL)isShowBuyIcon{
    return ([self intValue]==1)||([self intValue]==2)||([self intValue]==4);
}
@end

////////////////////////////////////////////////////////////////////////////////////////

@implementation UIAlertView (Categories)

+ (void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ {
	[self popAlertWithTitle:title_ message:message_ delegate:nil];
}

+ (void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ delegate:aDelegate {
	[self popAlertWithTitle:title_ message:message_ delegate:aDelegate tag:0];
}

+ (void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ delegate:aDelegate tag:(NSInteger)aTag{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title_ message:message_ delegate:aDelegate cancelButtonTitle:@"确定" otherButtonTitles:nil];
	alert.tag = aTag;
	[alert show];
 }

@end

@implementation UIView (RoundCorner)

- (void)needsRoundCorner:(float)radius {
	[self.layer setCornerRadius:radius];
	[self.layer setMasksToBounds:YES];
}

- (void)needShadow:(BOOL)needs {
	if ([self.layer respondsToSelector:@selector(setShadowOffset:)]) {
        self.layer.shadowColor = [UIColor greenColor].CGColor;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 12;
        self.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);
	}	
}

- (void)needsBorder:(UIColor *)borderColor {
	self.layer.borderColor = borderColor.CGColor;
	self.layer.borderWidth = 1.5;
}

- (void)needsBorder:(UIColor *)borderColor width:(NSInteger)width{
	self.layer.borderColor = borderColor.CGColor;
	self.layer.borderWidth = width;
}

@end

@implementation UIImage (Category)

+ (UIImage *)bundleImageName:(NSString *)imageName {
	NSString *path = [[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension] ofType:[imageName pathExtension]];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
	
	return image ;
}

@end

NSUInteger APICallIndex;



@implementation NSMutableURLRequest (Header)
+ (NSDictionary *)getHeader
{
    NIF_ERROR(@"");
    return nil;
}

- (void)setDDHeader {
    [self setDDHeaderMore:nil];
}

- (void)setDDHeaderMore:(NSDictionary *)header {
	NSDictionary *defaultHeader = [NSMutableURLRequest getHeader];
    
    [self setAllHTTPHeaderFields:defaultHeader];
    
    for (NSString *key in header) {
        [self setValue:[header objectForKey:key] forHTTPHeaderField:key];
    }    
}

//- (void)setDDHeaderMore:(NSDictionary *)header avoidStatistics:(BOOL)avoidStatistics {
//    
//    
//    NIF_TRACE(@"NSUInteger APICallIndex : %d",APICallIndex);
//	NSDictionary *defaultHeader = [NSMutableURLRequest getHeader];
//    
//    [self setAllHTTPHeaderFields:defaultHeader];
//    
//    for (NSString *key in header) {
//        [self setValue:[header objectForKey:key] forHTTPHeaderField:key];
//    }
//    
//    //　需要统计
//    if (!avoidStatistics) {
//        APICallIndex++;
//        [self setValue:[NSString stringWithFormat:@"%u",APICallIndex] forHTTPHeaderField:@"apicallindex"];
//        [self setValue:[[DDCacheManager shareCacheManager]dequeuePageRefs] forHTTPHeaderField:@"pageref"];
//    }
//    
//}



+ (NSString *)getAppID
{

    NSString *appId = [[NSUserDefaults standardUserDefaults] stringForKey:@"APPID"];
    if(appId != nil || [appId length]>0)
        return appId;
    
    UIDevice *device = [UIDevice currentDevice];
	NSString *appIDStr = @"";
	
	NSArray *lines = [device.systemVersion componentsSeparatedByString:@"."];
	
	NSString *firstNum;
	NSString *secondNum;
	
	if ([lines count] == 2) {
		if ([[lines objectAtIndex:0] intValue] < 10) {
			firstNum = [NSString stringWithFormat:@"0%@", [lines objectAtIndex:0]];
		} else {
			firstNum = [lines objectAtIndex:0];
		}	
		
		secondNum = [NSString stringWithFormat:@"%@0",[lines objectAtIndex:1]];
		
		
	} else if ([lines count] == 3) {
		if ([[lines objectAtIndex:0] intValue] < 10) {
			firstNum = [NSString stringWithFormat:@"0%@", [lines objectAtIndex:0]];
		} else {
			firstNum = [lines objectAtIndex:0];
		}	
		
		secondNum = [NSString stringWithFormat:@"%@%@", [lines objectAtIndex:1], [lines objectAtIndex:2]];
	} else {
		firstNum = @"00";
		secondNum = @"00";
	}
    //appIDStr = [NSString stringWithFormat:@"I%@%@%@%@", firstNum, secondNum,CURRENT_APP_TYPE,CURRENT_APP_VERSION];
	[[NSUserDefaults standardUserDefaults] setValue:appIDStr forKey:@"APPID"];
	[[NSUserDefaults standardUserDefaults]synchronize];
    return appIDStr;
    
}


@end
