

#import "EMEURLConnection.h"
#import "Reachability.h"
#import "EMEMacAddress.h"
#import "NSDate+Categories.h"
#import "NSString+Category.h"
#import "GTMBase64.h"
#import "NIFLog.h"
#import "EMENoNetworkTipView.h"
#import "EMELoadingView.h"
#import "EMEConfigManager.h"
#import "NSObject+Universal.h"

 //static NSInteger SortParameter(NSString *key1, NSString *key2, void *context) {
//	NSComparisonResult r = [key1 compare:key2];
//	if(r == NSOrderedSame) { // compare by value in this case
//		NSDictionary *dict = (__bridge NSDictionary *)context;
//		NSString *value1 = [dict objectForKey:key1];
//		NSString *value2 = [dict objectForKey:key2];
//		return [value1 compare:value2];
//	}
//	return r;
//}

static NSString *boundary = @"--------------------------------------fdsfdsffvvf3v";

@interface EMEURLConnection (Amination)<NSURLConnectionDelegate>


- (void)didStopSelector;
- (void)removeLoadingView;

@end

@implementation EMEURLConnection

@synthesize buffer;
@synthesize connection;
@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize showProgress;
@synthesize urlRequest;
@synthesize isHiddenLoadingView;
static EMELoadingView *loadView = nil;


- (void)dealloc {
    [self removeLoadingView];
    t_MBProgressHUD = nil;
 	self.delegate = nil;
	self.buffer = nil;
	self.connection = nil;
    _url = nil;
    
}


+ (EMEURLConnection *)connectionWithDelegate:(id<EMEURLConnectionDelegate>)delegate {
	EMEURLConnection *aConnection = [[EMEURLConnection alloc] initWithDelegate:delegate connectionTag:EMEURLConnectionTagDefault];
	return aConnection;
}

+ (EMEURLConnection *)connectionWithDelegate:(id<EMEURLConnectionDelegate>)delegate connectionTag:(NSInteger)tag {
	EMEURLConnection *aConnection = [[EMEURLConnection alloc] initWithDelegate:delegate connectionTag:tag];
	return aConnection ;
}

- (id)initWithDelegate:(id <EMEURLConnectionDelegate>)delegate {
	return [self initWithDelegate:delegate connectionTag:EMEURLConnectionTagDefault];
}

// DI 
- (id)initWithDelegate:(id<EMEURLConnectionDelegate>)delegate connectionTag:(NSInteger)tag {
	if (self = [super init]) {
//        hasLoadView = NO;
        showProgress = NO;
		self.delegate = delegate;
		self.connectionTag = tag;
	}
	return self;
}

- (void)connectToURL:(NSString *)url {
	NSString *tempURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self connectToURL:tempURL params:nil];
}

-(NSDictionary *)getHeaderParams{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[dat timeIntervalSince1970]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[NSString getRandomNumber:1 to:99999999]],@"id",
                         @"request",@"ack",
                         [EMEMacAddress getMacAddress],@"sender",
                         timeString,@"datetime",
                         [[EMEConfigManager shareConfigManager] getCid],@"cid",
                         [[EMEConfigManager shareConfigManager] getAppFileVersion],@"version",
                         [NSString getModel],@"device",
                         @"ios",@"os",
                         nil];
    return dic;
}

- (void)connectToURL:(NSString *)anUrl params:(NSDictionary *)params {
    [self cancel];
     contentType = nil;
   
    NSString *query = nil; 
    if (params && [params count] > 0) {
        if (params != urlparams) {
             urlparams = [params copy];
        }
       
        query =  [NSString stringWithFormat:@"?key=%@",[NSString getHttpBody:params header:[self getHeaderParams]]];
        anUrl = [anUrl stringByAppendingFormat:@"%@",query];
        NIF_TRACE(@"URL:-----> %@",anUrl);
        anUrl = [anUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    self.url = anUrl;
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
        [[EMENoNetworkTipView sharedStatusView] performSelector:@selector(show) withObject:nil afterDelay:0.f];
        [self removeLoadingView];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络无连接" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1001 userInfo:userInfo];
        
        if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
            [_delegate dURLConnection:self didFailWithError:error];
        }
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40.f];
    
    self.urlRequest=nil;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
    [self.connection start];
    
    if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
        [_delegate dURLConnectionDidStartLoading:self];
    }
}


- (void)connectToURLWithPost:(NSString *)anUrl params:(NSDictionary *)params{
    [self cancel];
     contentType = nil;
    
    NSString *bodyStr = @"";
    if (params && [params count] > 0) {
        if (params != urlparams) {
             urlparams = [params copy];
        }
        NSString *query = QueriesFromParams(params);
        bodyStr = [bodyStr stringByAppendingFormat:@"%@",query];
    }

    NIF_TRACE(@"URL:-----> %@",anUrl);
    
    self.url = anUrl;

    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
        [[EMENoNetworkTipView sharedStatusView] performSelector:@selector(show) withObject:nil afterDelay:0.f];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络无连接" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1001 userInfo:userInfo];
        
        if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
            [self removeLoadingView];
            [_delegate dURLConnection:self didFailWithError:error];
        }
        
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSASCIIStringEncoding]];
    
    self.urlRequest=request;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
     [self.connection start];
    if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
        [_delegate dURLConnectionDidStartLoading:self];
    }
}


- (void)postData:(NSData *)data url:(NSString *)url {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
		
		[[EMENoNetworkTipView sharedStatusView] performSelector:@selector(show) withObject:nil afterDelay:0.f];
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络无连接" forKey:NSLocalizedDescriptionKey];
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1001 userInfo:userInfo];
		
		if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
			[self removeLoadingView];
			[_delegate dURLConnection:self didFailWithError:error];
		}
		return;
	}
    
    NSString *tempURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *URL = [NSURL URLWithString:tempURL];

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40.f];

    // Body 
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    self.urlRequest=nil;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
 	[self.connection start];
	
	if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
		[_delegate dURLConnectionDidStartLoading:self];
	}
}



- (void)postImage:(UIImage *)image url:(NSString *)url {

	if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
		
		[[EMENoNetworkTipView sharedStatusView] performSelector:@selector(show) withObject:nil afterDelay:0.f];
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络无连接" forKey:NSLocalizedDescriptionKey];
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1001 userInfo:userInfo];
		
		if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
			[self removeLoadingView];
			[_delegate dURLConnection:self didFailWithError:error];
		}
		return;
	}
	 
	NSString *tempURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.url = tempURL;
	
	NSURL *URL = [NSURL URLWithString:tempURL];
	
	NSAssert(url,@"url shouldn't be nil!");
	NSAssert(URL,@"can't convert to NSURL");

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40.f];

    //NSMutableDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forKey:@"Content-Type"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:[request allHTTPHeaderFields]];
    [dic setObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forKey:@"Content-Type"];
    [request setAllHTTPHeaderFields:dic];
     // Body 
	
	NSData *imageData = nil;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == ReachableViaWiFi) {
		imageData = UIImageJPEGRepresentation(image, 0.3);
	} else {
		imageData = UIImageJPEGRepresentation(image, 0.1);
	}
    //NSData *imageData = UIImageJPEGRepresentation(image, 1);
	
	NSString *name = [[NSDate date] description];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",name,name] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
	self.urlRequest=nil;
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
 	[self.connection start];
	
	if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
		[_delegate dURLConnectionDidStartLoading:self];
	}
}

- (void)postImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
		
		[[EMENoNetworkTipView sharedStatusView] performSelector:@selector(show) withObject:nil afterDelay:0.f];
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络无连接" forKey:NSLocalizedDescriptionKey];
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1001 userInfo:userInfo];
		
		if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
			[self removeLoadingView];
			[_delegate dURLConnection:self didFailWithError:error];
		}
		return;
	}
   
    NIF_TRACE(@"URL:-----> %@",url);
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *URL = [NSURL URLWithString:self.url];
	
	NSAssert(url,@"url shouldn't be nil!");
	NSAssert(URL,@"can't convert to NSURL");
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40.f];
    NSString *query = nil;
    if (params && [params count] > 0) {
        if (params != urlparams) {
            urlparams = [params copy];
        }
        query =  [NSString stringWithFormat:@"%@",[NSString getHttpBody:params header:[self getHeaderParams]]];
    }
    
    //NSMutableDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forKey:@"Content-Type"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:[request allHTTPHeaderFields]];
    [dic setObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forKey:@"Content-Type"];
    //[dic setObject:[NSString stringWithFormat:@"%@",query] forKey:@"key"];
    [request setAllHTTPHeaderFields:dic];
    // Body
	
	NSData *imageData = nil;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == ReachableViaWiFi) {
		imageData = UIImageJPEGRepresentation(image, 0.3);
	} else {
		imageData = UIImageJPEGRepresentation(image, 0.1);
	}
  
	NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";",@"key"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n%@",query] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"file",@"filename"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	NSString *str = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    NIF_TRACE(@"%@",str);
	self.urlRequest=nil;
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
 	[self.connection start];
	
	if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
		[_delegate dURLConnectionDidStartLoading:self];
	}
}

- (void)postImageArray:(NSArray *)imageArray url:(NSString *)url params:(NSDictionary *)params{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
		
		[[EMENoNetworkTipView sharedStatusView] performSelector:@selector(show) withObject:nil afterDelay:0.f];
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络无连接" forKey:NSLocalizedDescriptionKey];
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1001 userInfo:userInfo];
		
		if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
			[self removeLoadingView];
			[_delegate dURLConnection:self didFailWithError:error];
		}
		return;
	}
    
    NIF_TRACE(@"URL:-----> %@",url);
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *URL = [NSURL URLWithString:self.url];
	
	NSAssert(url,@"url shouldn't be nil!");
	NSAssert(URL,@"can't convert to NSURL");
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40.f];
    NSString *query = nil;
    if (params && [params count] > 0) {
        if (params != urlparams) {
            urlparams = [params copy];
        }
        query =  [NSString stringWithFormat:@"%@",[NSString getHttpBody:params header:[self getHeaderParams]]];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:[request allHTTPHeaderFields]];
    [dic setObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forKey:@"Content-Type"];
    [request setAllHTTPHeaderFields:dic];

	NSData *imageData = nil;
    
	NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";",@"key"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n%@",query] dataUsingEncoding:NSUTF8StringEncoding]];
    for (int i=0; i<imageArray.count; i++) {
        UIImage *tmpImage = [imageArray objectAtIndex:i];
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == ReachableViaWiFi) {
            imageData = UIImageJPEGRepresentation(tmpImage, 0.3);
        } else {
            imageData = UIImageJPEGRepresentation(tmpImage, 0.1);
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"file",[NSString stringWithFormat:@"filename%d",i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
    }
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];

	self.urlRequest=nil;
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
 	[self.connection start];
	
	if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
		[_delegate dURLConnectionDidStartLoading:self];
	}
}


/////////////////////////////////////////////////////////////
// Ignore it if you don't know
- (void)connectionToConnection:(NSURLConnection *)conn {
	self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
	[self.connection start];
	
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NIF_ALLINFO(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
 
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
        
    }
}
 
#pragma  mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
 	self.buffer = nil;


    if (error.code ==  NSURLErrorUserCancelledAuthentication) {
        assert(@"NSURLErrorUserCancelledAuthentication");
    }else{
        if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
            [_delegate dURLConnection:self didFailWithError:error];
        }
    }
    
    [self removeLoadingView];
    self.urlRequest=nil;
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response {
	self.buffer = [NSMutableData data];
    NSDictionary *headers;
    if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
        headers = [(NSHTTPURLResponse *)response allHeaderFields]; 
        NSString  *type = [NSString stringWithFormat:@"%@", [headers objectForKey:@"Type"]];
       if ([type rangeOfString: @"json"].location != NSNotFound) {
             contentType = [NSString stringWithFormat:@"json"];
        }
    }
   
    NSUInteger length = [[headers objectForKey:@"Content-Length"] intValue];
    totalLength = length;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
	[self.buffer appendData:data];
    NSInteger newPercent = 0;
    if (totalLength>0) {
        newPercent = [self.buffer length]/(float)totalLength *100;
        if (newPercent>100) newPercent = 100;
    }
    if(showProgress)
    {
        NSInteger oldPercent = [loadView.progressLabel.text intValue];
        loadView.progressLabel.textColor = [UIColor blackColor];
        loadView.progressLabel.text = [NSString stringWithFormat:@"%d%%",oldPercent>=newPercent?oldPercent:newPercent];
    }
    if ([_delegate respondsToSelector: @selector(dURLConnection:didReceiveDataWithPercent:)]) {
        [_delegate dURLConnection: self didReceiveDataWithPercent: newPercent];
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
                totalBytesWritten:(NSInteger)totalBytesWritten
                totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    NSInteger newPercent = totalBytesWritten/(float)totalBytesExpectedToWrite *100;
    if ([_delegate respondsToSelector: @selector(dURLConnection:didUploadDataWithPercent:)]) {
        [_delegate dURLConnection: self didUploadDataWithPercent: newPercent];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
	//[self pauseLoadingView];
    
	NSDictionary *jsonValue = nil;
    @autoreleasepool {
        
     @try {
        //jsonValue = [self.buffer yajl_JSON]; 
         NSDictionary *tempDic = nil;
         if (IS_UTF16ENCODE) {
             NSString *str = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
             NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
             tempDic = [NSJSONSerialization JSONObjectWithData:[GTMBase64 decodeData:data] options:NSJSONReadingMutableContainers error:nil];
         }else{
             tempDic = [NSJSONSerialization JSONObjectWithData:self.buffer options:NSJSONReadingMutableContainers error:nil];
         }
        if (tempDic) {
            NSDictionary *dic = [tempDic valueForKeyPath:@"body"];
            jsonValue= [dic objectForKey:@"param"];
        }
    }
    @catch (NSException * e) {
        NIF_ERROR(@"%@",e);
        if (e) {
//            if ([[self.url lowercaseString] hasPrefix: @"https"]) {
//                [self showLoadingView];
//                NSString *httpurl = [self.url stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
//                if ([self.urlRequest.HTTPMethod.uppercaseString isEqualToString:@"POST"]) {
//                    [self connectToURLWithPost:httpurl params: urlparams];
//                }
//                else {
//                    [self connectToURL:httpurl params: urlparams];
//                }
//                 return;
//            }
//            else {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"服务器错误，请稍后重试" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1000 userInfo:userInfo];
                if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
                    [_delegate dURLConnection:self didFailWithError:error];
                }
            }
//        }
    }
    @finally {
        if (jsonValue) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dURLConnection:didFinishLoadingJSONValue:)]) {
                [self.delegate dURLConnection:self didFinishLoadingJSONValue:jsonValue];
            } 
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(dURLConnection:didFinishLoadingJSONValue:string:)]) {
                NSString *string = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
                [self.delegate dURLConnection:self didFinishLoadingJSONValue:jsonValue string:string];
             }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dURLConnection:didFinishLoadingJSONValue:string:)]) {
                NSString *string = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
                [self.delegate dURLConnection:self didFinishLoadingJSONValue:nil string:string];
             }
        }
    }

        [self removeLoadingView];
        self.connection = nil;
    }
}

- (void)cancel {
    @synchronized(self) {
        NIF_TRACE(@"cancelled");
        [self removeLoadingView];
        [self.connection cancel];
        self.connection = nil;
        self.buffer = nil;
    }
}

- (void)cancelWithDelegate {
    [self cancel];
    self.delegate = nil;  
}


//#pragma mark - LoadingView
//- (void)showLoadingViewOnKeyWindowWithText:(NSString *)text {
//	[self showLoadingViewText:text onWindow:[UIApplication sharedApplication].keyWindow];
//}
//
//
//- (void)showLoadingViewText:(NSString *)text onWindow:(UIView *)aView {
//    if (loadView) {
//        [loadView removeFromSuperview];
//    }
//    if ([text isEqualToString:@""]) {
//        text = @"0%";
//    }
//	if (loadView == nil) {
//		loadView = [[EMELoadingView alloc] initWithFrame:aView.frame withStyle:LOADINGSTYLE_BLACKBG  withTitle:text];		
//	}
//    @synchronized (self)
//    {
//        
//        hasLoadView = YES;
//        ++loadViewRefCount;
//    }
//    //loadView.frame = aView.frame;
//    loadView.frame = aView.bounds;
//    if (aView == nil) {
//        loadView.frame = CGRectMake(0, 0, 320, GETSCREENHEIGHT-44);
//    }
//    loadView.frame = CGRectMake(100, EME_TOP_DEFAULT-100, 320, GETSCREENHEIGHT-100);
//    loadView.backgroundColor = [UIColor clearColor];
//    [loadView setText:text];
//	[aView addSubview:loadView];
//    [aView bringSubviewToFront:loadView];
//	[loadView beginAnimationLoading];
//
//}
//
//- (void)refreshLoadingStatus:(NSString *)text {
//	[loadView setText:text];
//}
//
//- (void)pauseLoadingView {
//	if (hasLoadView && loadView) {
//		[loadView stopAnimationLoading];
//		[loadView setAlpha:0];
//	}
//}
//
//- (void)resumeLoadingView {
//	if (hasLoadView && loadView) {
//		[loadView beginAnimationLoading];
//		[loadView setAlpha: 1.0];
//	}
//}
//
//- (void)removeLoadingView {
//	if (hasLoadView && loadView) {
//        
//		[UIView beginAnimations:nil context:NULL];		
//		[loadView stopAnimationLoading];
//		[loadView setAlpha:0];
//		[UIView setAnimationDelegate:self];
//		[UIView setAnimationDidStopSelector:@selector(didStopSelector)];
//		[UIView commitAnimations];
//	}
//} 
//
//- (void)didStopSelector {
//    @synchronized (self)
//    {
//        if(--loadViewRefCount == 0)
//        {
//            [loadView removeFromSuperview];
//        }
//    }
//}


//#warning 网络加载状态
#pragma mark - 网络加载状态
-(void)showLoadingView
{
//
//    NIF_ALLINFO(@"添加网络加载状态...");
//    if (!isHiddenLoadingView && [EMEAppDelegate visibleViewController] ) {
//        if (!self.loadingHintsText) {
//            self.loadingHintsText = @"正在加载...";
//        }
//     [self removeLoadingView];
//        
//        if (!t_MBProgressHUD ) {
//            t_MBProgressHUD = [[EMEAppDelegate visibleViewController].view addHUDActivityViewToView:nil
//                                                                                          HintsText:self.loadingHintsText
//                                                                                              Image:nil
//                                                                                     hideAfterDelay:0
//                                                                                            HaveDim:NO];
//            t_MBProgressHUD.mode = MBProgressHUDModeIndeterminate;//显示菊花
//
//        }else{
//            t_MBProgressHUD.labelText = self.loadingHintsText;
//            [t_MBProgressHUD show:YES];
//            [[EMEAppDelegate visibleViewController].view addSubview:t_MBProgressHUD];
//
//        }
//
//        
//        if ([[NetWorkWatchDogManager shareInstance] isHaveNetWork]) {
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        }else{
//            
//            t_MBProgressHUD = [[EMEAppDelegate visibleViewController].view addHUDActivityViewToView:nil
//                                                                                          HintsText:@"没有网络，请检查"
//                                                                                              Image:nil
//                                                                                     hideAfterDelay:3
//                                                                                            HaveDim:NO];
//         }
//
//    }
}

-(void)removeLoadingView
{
    NIF_ALLINFO(@"移除网络加载状态...");
    if (t_MBProgressHUD ) {
        [t_MBProgressHUD removeFromSuperview];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 }


#pragma mark - setter

-(void)setUrl:(NSString *)url
{
    _url = [url encodeURL];
}

@end
