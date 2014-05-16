

#import "EMEImageLoader.h"
#import "EMELoadingView.h"


@interface EMEImageLoader()
{
	NSMutableString			*imageName;
	NSMutableString			*imgPrefix;
    NSMutableData			*requestData;
	NSMutableString			*imgpath;
}

@end

@implementation EMEImageLoader


+ (id)imageLoaderWithPath:(NSString *)imagePath {
	return [[self.class  alloc] initWithName:imagePath WithPrefix:nil];
}


-(id)initWithName:(NSString *)imgName WithPrefix:(NSString *)prefix
{
    
    self = [super init];
    
    if (self) {
        
        imgPrefix = [[NSMutableString alloc] init];
        imageName = [[NSMutableString alloc] init];
        imgpath = [[NSMutableString alloc] init];
        
        if (!imgName || [imgName length] == 0) {
            return self;
        }
        
		if (prefix == nil || prefix.length == 0) {
			[imgPrefix setString:[NSString stringWithFormat:@"%@/",[imgName stringByDeletingLastPathComponent]]];
			[imageName setString:[imgName lastPathComponent]];
			[imgpath setString:imgName];
		}
		else {
			NSArray *nameComponents = [imageName pathComponents];
			if(nameComponents.count >1)
			{
				for (int i = 0; i < nameComponents.count; i++) {
					if(i == nameComponents.count-1)
					{
						imgName = [nameComponents objectAtIndex:i];
					}
					else {
                        [imgPrefix appendFormat:@"/%@",[nameComponents objectAtIndex:i]];
					}
				}
			}
			else {
                [imgPrefix setString:prefix];
                [imageName setString:imgName];
			}
			
            [imgpath setString:[prefix stringByAppendingPathComponent:imgName]];
		}
		
        requestData = [[NSMutableData alloc] init];
//        self.rootDic = ImageCache;
        self.shouldCache = YES;
	}
	return self;
}


//show load view methods end

-(void)loadfinish:(NSObject *)o
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadFinished:withLoader:)]) {
		[self.delegate loadFinished:(NSString *)o  withLoader:self];
	}
}

-(void)loadFinishWithImage:(UIImage *)image path:(NSString *)path
{
    _imagePath = [path copy];
    
    if (_delegate && [_delegate respondsToSelector:@selector(loadFinishedWithImage:withLoader:)]) {
		[_delegate loadFinishedWithImage:image withLoader:self];
	}
}


-(void)loadFailedwithError:(NSObject *)obj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadFailedwithError:withLoader:)]) {
		[self.delegate loadFailedwithError:nil withLoader:self];
	}
}

#pragma mark - 
#pragma mark NSURLConnection Delegate
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
    [requestData appendData:data];
    if(self.showProgress)
    {
        self.progress = (NSInteger)([requestData length]/(float)self.totalLength *100);
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadPercentWithNumber:withLoader:)]) {
            [self.delegate loadPercentWithNumber:self.progress withLoader:self];
        }
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	if (response) {
		self.expectedContentLength = [response expectedContentLength];
	} else {
		self.expectedContentLength = -1;
	}
    
    if(self.showProgress)
    {
        NSDictionary *headers;
        if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
            headers = [(NSHTTPURLResponse *)response allHeaderFields]; 
        }
        NSUInteger length = [[headers objectForKey:@"Content-Length"] intValue];
        self.totalLength = length;
    }
    
	[requestData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection{ 
	long long contentLength = [requestData length];
	if (self.expectedContentLength != contentLength && self.expectedContentLength != -1) {
		NIF_ERROR(@"-- expectedContentLength: %lld",self.expectedContentLength);
		NIF_ERROR(@"-- 实际ContentLength: %lld",contentLength);
		NSError *error = [[NSError alloc] initWithDomain:@"Image Download Error" code:1111 userInfo:nil];
		[self loadFailedwithError:error];
		
		return;
	}
	
	UIImage *image = [UIImage imageWithData:requestData];  
	
	if(image != nil)
	{
        if (self.shouldCache) {
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            docDir = [docDir stringByAppendingPathComponent:self.rootDic];
            
            NSString *pathStr = [imgPrefix stringByReplacingOccurrencesOfString:@"http:/" withString:@""];
            NSArray *pathComponents = [pathStr pathComponents];
            for (NSString *str in pathComponents) {
                NSString* t_str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
                t_str = [t_str stringByReplacingOccurrencesOfString:@"." withString:@""];
                [[NSFileManager defaultManager]createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:nil];
                docDir = [docDir stringByAppendingPathComponent:t_str];
            }
            NSString *jpegFilePath;
            jpegFilePath = [docDir stringByAppendingPathComponent:[imageName stringByReplacingOccurrencesOfString:@"/" withString:@""]];

            if(requestData != nil)
            {
                [requestData writeToFile:jpegFilePath atomically:YES];
                [self loadFinishWithImage:[UIImage imageWithData:requestData] path:jpegFilePath];
            }
            else {
                [self loadFailedwithError:nil];
            }
            
		} else {
            [self loadFinishWithImage:image path:nil];
        }
	}
	else {
		[self loadFailedwithError:nil];
	}

}

- (void)connection:(NSURLConnection *) inConnection didFailWithError:(NSError *)error{
	[requestData setLength:0]; 

	self.currentConn = nil;
    [self loadFailedwithError:nil];
}

-(void)startLoad
{
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	docDir = [docDir stringByAppendingPathComponent:self.rootDic];
	
	NSArray *pathComponents = [[imgPrefix stringByReplacingOccurrencesOfString:@"http:/" withString:@""] pathComponents];
	for (NSString *str in pathComponents) {
		NSString* t_str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
		t_str = [t_str stringByReplacingOccurrencesOfString:@"." withString:@""];
		docDir = [docDir stringByAppendingPathComponent:t_str];
		
	}
	NSString *jpegFilePath;
    jpegFilePath = [docDir stringByAppendingPathComponent:[imageName stringByReplacingOccurrencesOfString:@"/" withString:@""]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:jpegFilePath];
    if (self.shouldCache && image){
        [self loadFinishWithImage:image path:jpegFilePath];   
    } else {
		NSURL* imageURL =nil;
		imageURL = [NSURL URLWithString:imgpath];
		NSMutableURLRequest * myRequest = [NSMutableURLRequest requestWithURL:imageURL];
 
        [self.currentConn cancel];
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
		self.currentConn = connection;
	}
}

+(UIImage*)imageFromCacheForUrl:(NSString*)url
{
    NSMutableString *imgPrefix = [[NSMutableString alloc] init];
    NSMutableString *imageName = [[NSMutableString alloc] init];
    NSMutableString *imgpath = [[NSMutableString alloc] init];
    
    [imgPrefix setString:[NSString stringWithFormat:@"%@/",[url stringByDeletingLastPathComponent]]];
    [imageName setString:[url lastPathComponent]];
    [imgpath setString:url];

    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//	docDir = [docDir stringByAppendingPathComponent: ImageCache];
    
	NSArray *pathComponents = [[imgPrefix stringByReplacingOccurrencesOfString:@"http:/" withString:@""] pathComponents];
	for (NSString *str in pathComponents) {
	NSString*	t_str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
		t_str = [t_str stringByReplacingOccurrencesOfString:@"." withString:@""];
		docDir = [docDir stringByAppendingPathComponent:t_str];
	}
	NSString *jpegFilePath = [docDir stringByAppendingPathComponent:[imageName stringByReplacingOccurrencesOfString:@"/" withString:@""]];
    


    UIImage *image = [UIImage imageWithContentsOfFile:jpegFilePath];
    if (image){
        return image;
    }
    else {
        return nil;
    }
}

-(void)cancel{
	[self.currentConn cancel];
	self.currentConn = nil;
}

- (void)cancelWithDelegate {
    [self cancel];
    self.delegate = nil;
}

-(void)dealloc{ 
    [self cancelWithDelegate];
}

@end