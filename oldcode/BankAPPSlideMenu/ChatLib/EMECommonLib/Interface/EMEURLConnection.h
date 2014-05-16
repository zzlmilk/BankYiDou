#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@protocol EMEURLConnectionDelegate;
@class EMELoadingView;


typedef NS_OPTIONS(NSUInteger, EMEURLConnectionTag) {
	EMEURLConnectionTagDefault	= 0,
	EMEURLConnectionTagFirst ,
	EMEURLConnectionTagSecond,
	EMEURLConnectionTagThird,
	EMEURLConnectionTagForth,
	EMEURLConnectionTagFifth
};

#define EXPIRESECOND 5.0
@interface EMEURLConnection : NSObject {
     MBProgressHUD *t_MBProgressHUD;

    BOOL                hasLoadView;
    int                 totalLength;
    BOOL                showProgress;
    NSString            *contentType;
    NSMutableDictionary *urlparams;
}

@property (nonatomic,assign) NSInteger connectionTag;
@property (nonatomic, strong) NSMutableArray *searchParams;
@property (nonatomic, assign)  id <EMEURLConnectionDelegate> delegate;
@property (nonatomic, copy) NSString *url;
@property (assign)BOOL                showProgress;
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;
@property (nonatomic, strong)  NSMutableData		*buffer;
@property (nonatomic, strong)  NSURLConnection		*connection;

//加载状态显示
@property (nonatomic, assign) BOOL isHiddenLoadingView;
@property (nonatomic, copy) NSString* loadingHintsText;

+ (EMEURLConnection *)connectionWithDelegate:(id<EMEURLConnectionDelegate>)delegate;
+ (EMEURLConnection *)connectionWithDelegate:(id<EMEURLConnectionDelegate>)delegate connectionTag:(NSInteger)tag;
- (id)initWithDelegate:(id<EMEURLConnectionDelegate>)delegate;	// default tag
- (id)initWithDelegate:(id<EMEURLConnectionDelegate>)delegate connectionTag:(NSInteger)tag;

// 
// GET 
// 简单转义
// 
- (void)connectToURL:(NSString *)url;

//
// GET
// 汉字特殊符号转义　注意使用
// 
- (void)connectToURL:(NSString *)url params:(NSDictionary *)params;

//
// POST
//
- (void)connectToURLWithPost:(NSString *)url params:(NSDictionary *)params;


/* NOT implement
- (void)post:(NSString*)aURL body:(NSString*)body;
- (void)post:(NSString*)aURL data:(NSData*)data;
*/

- (void)postData:(NSData *)data url:(NSString *)url;

//
// POST IMAGE
// 
- (void)postImage:(UIImage *)image url:(NSString *)url;

- (void)postImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params;

- (void)postImageArray:(NSArray *)imageArray url:(NSString *)url params:(NSDictionary *)params;

- (void)cancel;
- (void)cancelWithDelegate;

- (void)connectionToConnection:(NSURLConnection *)conn;



@end


@protocol EMEURLConnectionDelegate <NSObject>

@optional

// NEW
- (void)dURLConnectionDidStartLoading:(EMEURLConnection *)connection;

- (void)dURLConnection:(EMEURLConnection *)connection didFinishLoadingJSONValue:(NSDictionary *)json;
- (void)dURLConnection:(EMEURLConnection *)connection didFailWithError:(NSError *)error;

- (void)dURLConnection:(EMEURLConnection *)connection didFinishLoadingJSONValue:(NSDictionary *)json string:(NSString *)content;

- (BOOL)dURLConnectionPopViewControllerWhenFail:(EMEURLConnection *)connection;


- (void)dURLConnection:(EMEURLConnection *)connection  didUploadDataWithPercent:(NSInteger)Percent;
- (void)dURLConnection:(EMEURLConnection *)connection  didReceiveDataWithPercent:(NSInteger)Percent;

@end
