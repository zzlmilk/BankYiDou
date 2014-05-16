
#import "NSString+Category.h"
#import "sys/utsname.h" 
#import "sys/sysctl.h"
#import "GTMBase64.h"
@implementation  NSString (Category)

- (NSString *)dd_cityNameWithFormat {
	NSRange range = [self rangeOfString:@"市"];
	if (range.location != NSNotFound) {
		return [self substringToIndex:range.location];
	} else {
		return self;
	}
}

-(NSString *) dd_stringOutOfBrackets {
	
	NSRange range = [self rangeOfString:@"]"];
	NSInteger index = 0;
	if (range.location != NSNotFound) {
		index = range.location + 1;
		return [self substringFromIndex:index];
	} 
	
	return self;
	
	
}

-(NSString *) dd_stringInBrackets {
	
	NSRange end = [self rangeOfString:@"]"];
	
	if (end.location != NSNotFound) {
		NSString *theString = [self substringToIndex:end.location];
		NSRange start = [theString rangeOfString:@"["];
		
		if (start.location != NSNotFound) {
			return [theString substringFromIndex:start.location + 1];
		}
	} 
	
	return self;
}

- (NSString*)encodeURL
{
 
//     NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self, nil,  CFSTR("?#@!$ &'()*+;\"<>%{}|\\^~`") ,kCFStringEncodingUTF8));
    NSString *newString = [self stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    if (newString) {
        return newString;
    }
    return @"";
}

- (NSString *) dd_stringBeforeColon{
    NSRange range = [self rangeOfString:@":"];
	NSInteger index = self.length-1;
	if (range.location != NSNotFound) {
		index = range.location;
		return [self substringToIndex:index];
	}
	
	return self;
}

- (NSString *) dd_stringAfterColon{
    NSRange range = [self rangeOfString:@":"];
	NSInteger index = 0;
	if (range.location != NSNotFound) {
		index = range.location + 1;
		return [self substringFromIndex:index];
	}
	
	return self;
}


// Encode Chinese to ISO8859-1 in URL
//+ (NSString *)stringToUTF8:(NSString *)aString {
//	CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");        
//	NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)aString, CFSTR(""), kCFStringEncodingUTF8);        
//	NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8) autorelease];
//	[preprocessedString release];
//	return newStr; 
//}

+ (NSString *)stringToUTF8:(NSString *)aString {
//	CFStringRef nonAlphaNumValidChars = (CFStringRef)@"!*'();:@&=+$,/?%#[]";//CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");        
//	NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)aString, CFSTR(""), kCFStringEncodingUTF8);        
//	NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8) autorelease];
//	[preprocessedString release];
//	return newStr; 
	NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																				  NULL, /* allocator */
																				  (CFStringRef)aString,
																				  NULL, /* charactersToLeaveUnescaped */
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8));
	return escaped_value ;
}

// Encode Chinese to GB2312 in URL
+ (NSString *)stringToGb2312:(NSString *)aString {
	CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");        
	NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)aString, CFSTR(""), kCFStringEncodingGB_18030_2000));        
	NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000))  ;
 	return newStr;
}

+(NSString *)convertDistance2Str:(int)cc
{
	NSString *intstr = [NSString stringWithFormat:@"%i",cc];
	NSString *resultStr;
	int length = intstr.length;
	if(length >3)
	{
		NSString *tmpStr = [intstr substringToIndex:length-2];
		resultStr = [NSString stringWithFormat:@"%@.%@公里",[tmpStr substringToIndex:tmpStr.length-1],[tmpStr substringFromIndex:tmpStr.length-1]];
	}
	else {
		resultStr = [NSString stringWithFormat:@"%@米",intstr];
	}
	return resultStr;
	
}

+ (NSString *)formattedDistance:(int)distance {
    if (distance / 1000.0 > 1 && distance / 1000.0 <=100) {
        return [NSString stringWithFormat:@"%2.1fkm",distance / 1000.0];
    } else if(distance <= 1000){
        return [NSString stringWithFormat:@"%0.0dm",distance];
    }else if (distance / 1000.0 > 100){
        NSString *s = [NSString stringWithFormat:@"%f",distance / 1000.0];
        return [NSString stringWithFormat:@"%dkm",[s intValue]];
    }else {
        return @"";
    }
}

 
+ (NSString *)formattedTime:(int)time{
    return [NSString stringWithFormat:@"%d秒钟",time];
    NSMutableString *str = [[NSMutableString alloc] init];
    int hour =0;
    int minute=0;
    hour = time/3600;
    minute = time/60;
    
    if (hour > 0) {
        [str appendFormat:@"%d小时",hour];
        if ((time-(3600 * hour))/3600 > 0) {
            [str appendFormat:@"%d分钟",minute];
        }else if (minute > 0){
            [str appendFormat:@"%d分钟",minute];
        }
        return str;
    }
    if (minute > 0) {
        [str appendFormat:@"%d分钟",minute];
    }else{
        [str appendFormat:@"%d秒钟",time];
    }
  
    return str;
}

+ (NSString *)formattedClicks:(NSString *)clicks {
    NSInteger clickNumber = [clicks intValue];
    if (clickNumber / 10000.0 > 1) {
        return [NSString stringWithFormat:@"%2.1f万",clickNumber / 10000.0];
    } else if(clickNumber > 0){
        return [NSString stringWithFormat:@"%d",clickNumber];
    } else {
        return @"0";        
    }
}

+ (NSString *)formattedTelNumber:(NSString *)tel{
    NSString *aStr;
    NSString *blankStr;
    for (int i= 0; i<tel.length;i++) {
        aStr = [tel substringWithRange:NSMakeRange(i, 1)];
        if ([aStr isEqualToString:@" "] || [aStr isEqualToString:@","] || [aStr isEqualToString:@";"]) {
            blankStr = aStr;
        }
        //NIF_TRACE(@"aStr:%@",aStr);
    }
    return aStr;
}

+ (BOOL)validateEmail: (NSString *) email{
    NSString * regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:email];
}

+ (BOOL)validateTelPhone: (NSString *) phone{
        NSString * MOBILE = @"^[0-9]{10,11}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        
        if ([regextestmobile evaluateWithObject:phone] == YES)
        {
            return YES;
        }
        else 
        {
            return NO;
        }
}

+ (BOOL)validateDDNickName: (NSString *)nickName{
    NSString * regex = @"^[A-Z0-9a-z_\u4e00-\u9fa5]+$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:nickName];
}
 

#define CHAR64(c) (index_64[(unsigned char)(c)])

#define BASE64_GETC (length > 0 ? (length--, bytes++, (unsigned int)(bytes[-1])) : (unsigned int)EOF)
#define BASE64_PUTC(c) [buffer appendBytes: &c length: 1]

static char basis_64[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static inline void output64Chunk( int c1, int c2, int c3, int pads, NSMutableData * buffer )
{
	char pad = '=';
	BASE64_PUTC(basis_64[c1 >> 2]);
	BASE64_PUTC(basis_64[((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4)]);
	
	switch ( pads )
	{
		case 2:
			BASE64_PUTC(pad);
			BASE64_PUTC(pad);
			break;
			
		case 1:
			BASE64_PUTC(basis_64[((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6)]);
			BASE64_PUTC(pad);
			break;
			
		default:
		case 0:
			BASE64_PUTC(basis_64[((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6)]);
			BASE64_PUTC(basis_64[c3 & 0x3F]);
			break;
	}
}



+ (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to -from + 1)));
}

+ (NSString *)getModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    if ([sDeviceModel isEqual:@"i386"])      return @"Simulator";  //iPhone Simulator
    if ([sDeviceModel isEqual:@"iPhone1,1"]) return @"iPhone1G";   //iPhone 1G
    if ([sDeviceModel isEqual:@"iPhone1,2"]) return @"iPhone3G";   //iPhone 3G
    if ([sDeviceModel isEqual:@"iPhone2,1"]) return @"iPhone3GS";  //iPhone 3GS
    if ([sDeviceModel isEqual:@"iPhone3,1"]) return @"iPhone4 AT&T";  //iPhone 4 - AT&T
    if ([sDeviceModel isEqual:@"iPhone3,2"]) return @"iPhone4 Other";  //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone3,3"]) return @"iPhone4";    //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone4,1"]) return @"iPhone4S";   //iPhone 4S
    if ([sDeviceModel isEqual:@"iPhone5,1"]) return @"iPhone5";    //iPhone 5 (GSM)
    if ([sDeviceModel isEqual:@"iPhone5,3"]||[sDeviceModel isEqual:@"iPhone5,4"]) return @"iPhone 5C"; //iPhone 5C
    if ([sDeviceModel isEqual:@"iPhone6,1"]||[sDeviceModel isEqual:@"iPhone6,2"]) return @"iPhone 5S"; //iPhone 5S

    if ([sDeviceModel isEqual:@"iPod1,1"])   return @"iPod1stGen"; //iPod Touch 1G
    if ([sDeviceModel isEqual:@"iPod2,1"])   return @"iPod2ndGen"; //iPod Touch 2G
    if ([sDeviceModel isEqual:@"iPod3,1"])   return @"iPod3rdGen"; //iPod Touch 3G
    if ([sDeviceModel isEqual:@"iPod4,1"])   return @"iPod4thGen"; //iPod Touch 4G
    if ([sDeviceModel isEqual:@"iPad1,1"])   return @"iPadWiFi";   //iPad Wifi
    if ([sDeviceModel isEqual:@"iPad1,2"])   return @"iPad3G";     //iPad 3G
    if ([sDeviceModel isEqual:@"iPad2,1"])   return @"iPad2";      //iPad 2 (WiFi)
    if ([sDeviceModel isEqual:@"iPad2,2"])   return @"iPad2";      //iPad 2 (GSM)
    if ([sDeviceModel isEqual:@"iPad2,3"])   return @"iPad2";      //iPad 2 (CDMA)
    NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    //If a newer version exist
    if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
        if (version == 3) return @"iPhone4";
            else if (version >= 4 && version < 5)
                return @"iPhone4s";
            else if (version >= 5)
                return @"iPhone5";
            }
    if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
        if (version >=4 && version < 5) return @"iPod4thGen"; else if (version >=5) return @"iPod5thGen";
    }
    if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
        if (version ==1) return @"iPad3G";
        if (version >=2 && version < 3) return @"iPad2"; else if (version >= 3)return @"new iPad";
    }
    //If none was found, send the original string
    return sDeviceModel;
}


+ (NSString *)getHttpBody:(NSDictionary *)body header:(NSDictionary *)header{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:header,@"header",body,@"body", nil];
    NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:dic,@"root", nil];
    NSString *str = [[NSString alloc] initWithData:[self.class convertToJSONDateWithDicOrArray:resultDic] encoding:NSUTF8StringEncoding];
    NSString *strJson = @"";
//    if (IS_UTF16ENCODE) {
        NSData *endata = [GTMBase64 encodeData:[str dataUsingEncoding:NSUTF16StringEncoding]];
        //NSData *dedata = [GTMBase64 decodeData:endata];
        NSString *str2 = [[NSString alloc] initWithData:endata encoding:NSUTF8StringEncoding];
        strJson = str2;
//    }else{
//        strJson = str;
//    }
   
    return strJson;
}



+(NSData*)convertToJSONDateWithDicOrArray:(id)dicOrArray
{
    if (dicOrArray ==nil) {
        return nil;
    }
    if ([dicOrArray isKindOfClass:[NSDictionary class]] || [dicOrArray isKindOfClass:[NSArray class]]) {
        NSError *error = nil;
        return  [NSJSONSerialization dataWithJSONObject:dicOrArray
                                                options:NSJSONWritingPrettyPrinted
                                                  error:&error];
    }else{
        return nil;
    }
}

+(id)parseJSONData:(NSData*)jsonData
{
    if (jsonData ==nil) {
        return nil;
    }else if ([jsonData isKindOfClass:[NSDictionary class]] || [jsonData isKindOfClass:[NSArray class]]){
        return jsonData;
    }
    
    if ( [jsonData length] > 0  ) {
        NSError *error = nil;
        if ([jsonData length] == 0) {
            return   nil;
        } else {
            return  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        }
        
        return error;
    }
    return   nil;
}

//+(NSString *)getCommentType:(EMEServiceType)type{
//    NSString *str= @"";
//    switch (type) {
//        case EMEServiceTypeForActivity:
//            str = @"活动评论";
//            break;
//        case EMEServiceTypeForTrade:
//            str = @"商品评价";
//            break;
//        case EMEServiceTypeForGroupMien:
//            str = @"团队评论";
//            break;
//        case EMEServiceTypeForClinic:
//            str = @"全部评论";
//            break;
//        default:
//            break;
//    }
//    return str;
//}

@end
