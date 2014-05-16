
#import "EMENetImageView.h"


@implementation EMENetImageView
@synthesize imgUrl, delegate,isShowLoadIng;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        activityV = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake((frame.size.width - 24)/2, (frame.size.height - 24)/2, 24, 24)];
        activityV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        activityV.center=self.center;
        activityV.hidesWhenStopped = YES;
        [self addSubview: activityV];
    }
    return self;
}

- (void)dealloc
{
    delegate = nil;
    [imgLoader cancelWithDelegate];
   
}


-(void)setImgUrl:(NSString *)imgurl
{
     imgUrl = [imgurl copy];
    if (imgurl) {
        [imgLoader cancel];
         imgLoader = [[EMEImageLoader alloc] initWithName:imgurl WithPrefix:nil];
        imgLoader.delegate = self;
        [activityV startAnimating];
        [imgLoader startLoad];
    }
    activityV.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

-(void)setIsShowLoadIng:(BOOL)isShowLoadIngTmp{
    isShowLoadIng=isShowLoadIngTmp;
    if (!isShowLoadIng) {
        [activityV stopAnimating];
    }
}
-(void)loadFinished:(NSString *)path  withLoader:(id)loader
{
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    [self loadFinishedWithImage:img withLoader: loader];
}

-(void)loadFinishedWithImage:(UIImage *)aImage  withLoader:(id)loader
{
    [activityV stopAnimating];
    if (loader == imgLoader) {
        UIImage *img = aImage;
        if (img) {
            
            if (UIViewContentModeScaleAspectFit == self.contentMode) {
                CGRect frame = self.frame;
                //small
                if (img.size.width < frame.size.width && img.size.height < frame.size.height) {
                    CGRect tmpFrame = CGRectMake(frame.origin.x + (frame.size.width - img.size.width)/2, frame.origin.y + (frame.size.height - img.size.height)/2, img.size.width, img.size.height);
                    frame = tmpFrame;
                }
                //big
                else if (img.size.width/img.size.height < frame.size.width/frame.size.height) {
                    int w = img.size.width * frame.size.height/img.size.height;
                    frame.origin.x = frame.origin.x + (frame.size.width - w)/2;
                    frame.size.width = w;
                }
                else {
                    int h = img.size.height * frame.size.width/img.size.width;
                    frame.origin.y = frame.origin.y + (frame.size.height - h)/2;
                    frame.size.height = h;
                }
                self.frame = frame;
            }
            else if (UIViewContentModeScaleAspectFill == self.contentMode) {
                CGRect frame = self.frame;
                if (img.size.width/img.size.height < frame.size.width/frame.size.height) {
                    int w = img.size.width * frame.size.height/img.size.height;
                    frame.origin.x = frame.origin.x + (frame.size.width - w)/2;
                    frame.size.width = w;
                }
                else {
                    int h = img.size.height * frame.size.width/img.size.width;
                    frame.origin.y = frame.origin.y + (frame.size.height - h)/2;
                    frame.size.height = h;
                }
                self.frame = frame;
            }
            
            [self setBackgroundImage: img forState: UIControlStateNormal];
            [self setBackgroundImage: img forState: UIControlStateHighlighted];
			[self setNeedsDisplay];
            
            if (delegate && [delegate respondsToSelector:@selector(EMENetImageView:loadFinishedWithImage:)]) {
                [delegate EMENetImageView:self loadFinishedWithImage: img];
            }
        }
         imgLoader = nil;
    }
    else {
     }
}


-(void)loadFailedwithError:(NSError *)e  withLoader:(id)loader
{
    [activityV stopAnimating];
	if (loader == imgLoader) {
         imgLoader = nil;
    }
  
    
    if (delegate && [delegate respondsToSelector:@selector(EMENetImageView:loadError:)]) {
        [delegate EMENetImageView:self loadError:nil];
    }
}

- (void)setDownloadImage:(UIImage*)aImage
{
    [self setBackgroundImage: aImage forState: UIControlStateNormal];
    [self setBackgroundImage: aImage forState: UIControlStateHighlighted];
}


@end
