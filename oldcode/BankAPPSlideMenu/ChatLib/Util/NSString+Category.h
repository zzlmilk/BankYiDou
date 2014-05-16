
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Category) 

- (NSString *)dd_cityNameWithFormat;

- (NSString *) dd_stringOutOfBrackets;
- (NSString *) dd_stringInBrackets;

- (NSString *) dd_stringBeforeColon;
- (NSString *) dd_stringAfterColon;

-(NSString*)encodeURL;


+ (NSString *)stringToUTF8:(NSString *)aString;
+ (NSString *)stringToGb2312:(NSString *)aString;

+ (NSString *)formattedDistance:(int)distance;
 
+ (NSString *)formattedTime:(int)time;

+ (NSString *)convertDistance2Str:(int)cc;

+ (NSString *)formattedClicks:(NSString *)clicks;

+ (NSString *)formattedTelNumber:(NSString *)tel;

+ (BOOL)validateEmail: (NSString *) email;

+ (BOOL)validateTelPhone: (NSString *) phone;

+ (BOOL)validateDDNickName: (NSString *)nickName;

+ (int)getRandomNumber:(int)from to:(int)to;
 
+ (NSString *)getModel;

+ (NSString *)getHttpBody:(NSDictionary *)body header:(NSDictionary *)header;

+(NSData*)convertToJSONDateWithDicOrArray:(id)dicOrArray;

+(id)parseJSONData:(NSData*)jsonData;

//+(NSString *)getCommentType:(EMEServiceType)type;
@end
