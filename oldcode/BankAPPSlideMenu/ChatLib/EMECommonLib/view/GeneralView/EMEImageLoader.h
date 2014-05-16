

#import <Foundation/Foundation.h>

typedef enum {
	EMEImageLoaderTagDefault,
	EMEImageLoaderTagFirst,
	EMEImageLoaderTagSecond,
	EMEImageLoaderTagThird,
	EMEImageLoaderTagForth,
	EMEImageLoaderTagFifth
}EMEImageLoaderTag;

@class EMEImageLoader;

@protocol EMEImageLoaderDelegate<NSObject>

@optional

- (void)loadFinished:(NSString *)path  withLoader:(EMEImageLoader*)loader;   //__OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0);

- (void)loadFinishedWithImage:(UIImage *)image withLoader:(EMEImageLoader*)loader;
- (void)loadFailedwithError:(NSError *)e  withLoader:(EMEImageLoader*)loader;

- (void)loadPercentWithNumber:(NSInteger)percentStr withLoader:(EMEImageLoader *)loader;

@end


@interface EMEImageLoader : NSObject

@property (nonatomic, assign)id<EMEImageLoaderDelegate> delegate;
@property (nonatomic, strong) id obj;
@property (readonly, copy) NSString *imagePath;
@property (nonatomic,assign) EMEImageLoaderTag tag;
@property (nonatomic, copy)  NSString *rootDic;
@property (nonatomic, assign) id showObject;
@property (nonatomic, assign) BOOL              shouldCache;
@property (nonatomic, strong) NSURLConnection	*currentConn;
@property (nonatomic, assign) long long	 expectedContentLength;	// Check
@property (nonatomic, assign) NSInteger  totalLength;
@property (nonatomic, assign) BOOL       showProgress;
@property (nonatomic, assign) NSInteger  progress;

+(id)imageLoaderWithPath:(NSString *)imgName;

-(id)initWithName:(NSString *)imgName WithPrefix:(NSString *)prefix;

-(void)startLoad;
-(void)cancel;
- (void)cancelWithDelegate;
+(UIImage*)imageFromCacheForUrl:(NSString*)url;

@end
