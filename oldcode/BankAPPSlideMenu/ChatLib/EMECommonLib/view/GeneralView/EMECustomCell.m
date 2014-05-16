

#import "EMECustomCell.h"
#import "EMEScrollView.h"
#import <QuartzCore/QuartzCore.h>
@interface EMECustomCell()
-(void)loadTheView;
@end

@implementation EMECustomCell
@synthesize theImgUrl=_theImgUrl,theLoading,indexLbl,frontMaskView;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeTheProgress" object:nil];
    EMEImageLoader *imageLoader =[GETIMAGELOADERS objectForKey:_theImgUrl];
    if (imageLoader) {
        imageLoader.delegate = nil;
    }

}
-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        loaderLock=[[NSLock alloc]init];
        [self loadTheView];
    }
    return self;
}
- (id)initWithReuseIdentifier:(NSString *)anIdentifier {
	self=[super initWithReuseIdentifier:anIdentifier];
	if (self){
        loaderLock=[[NSLock alloc]init];
        [self loadTheView];
    }
	return self;
}

- (id)initWithReuseIdentifier:(NSString *)anIdentifier with:(UIView *)forView{
	self=[super initWithReuseIdentifier:anIdentifier];
    _needFix = NO;
	if (self){
        loaderLock=[[NSLock alloc]init];
        if ([forView isKindOfClass:NSClassFromString(@"EMEImageScrollView")]) {
            [self loadTheImageScrollView];
        }
        else if([forView isKindOfClass:NSClassFromString(@"EMEImageScrollViewExt")]) {
            [self loadTheImageScrollViewExt];
        }
        else if([forView isKindOfClass:NSClassFromString(@"EMENewsHomeImageScrollView")]) {
            [self loadTheNewsHomeImageScrollView];
        }
        else if([forView isKindOfClass:NSClassFromString(@"EMENewsImageDetailScrollView")]) {
            [self loadTheNewsImageDetailScrollView];
            _needFix = YES;
        }
        else if ([forView isKindOfClass:NSClassFromString(@"EMEStaffMienCellView")]){
            [self loadTheStaffMienCellView];
        }
        else if ([forView isKindOfClass:NSClassFromString(@"EMECasesCellView")]){
            [self loadTheCasesCellView];
        }
        else if ([forView isKindOfClass:NSClassFromString(@"EMETalentView")]){
            [self loadTheTalentView];
        }else if ([forView isKindOfClass:NSClassFromString(@"EMECompanyView")]){
            [self loadTheTalentView];
        }else if ([forView isKindOfClass:NSClassFromString(@"EMEFourImageView")]){
            [self loadTheTalentView];
        }else{
            [self loadTheView];
        }
    }
	return self;
}

-(void)loadTheView{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(66, 76, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
    
}

-(void)loadTheTalentView{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(17, 10, 130, 130)];
    theImage.layer.masksToBounds = YES;
    theImage.layer.cornerRadius = 5.0;
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(10, 10, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
    
}

-(void)loadFourImageView{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(18, 10, 64, 64)];
    theImage.layer.masksToBounds = YES;
    theImage.layer.cornerRadius = 5.0;
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(10, 10, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
    
}

-(void)loadTheImageScrollView{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 160)];
    theImage.layer.masksToBounds = YES;
    theImage.layer.cornerRadius = 0.0;
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(150, 30, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
    
}

-(void)loadTheImageScrollViewExt{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 292, 125)];
    theImage.layer.masksToBounds = YES;
    theImage.layer.cornerRadius = 20.0;
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(150, 30, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
    
}

-(void)loadTheNewsHomeImageScrollView{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320.0f, 214.0f)];
//    theImage.layer.masksToBounds = YES;
//    theImage.layer.cornerRadius = 20.0;
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(150, 30, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
    
}

-(void)loadTheNewsImageDetailScrollView{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320.0f, 455.0f)];
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(150, 30, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
}

-(void)loadTheStaffMienCellView{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(11.0f, 9.0f, 121.0f, 121.0f)];
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(150, 30, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
}

-(void)loadTheCasesCellView{
    theImage=[[UIImageView alloc]initWithFrame:CGRectMake(11.0f, 9.0f, 121.0f, 121.0f)];
    [self addSubview:theImage];
    
    theLoading=[[EMELoadingView alloc]initWithFrame:CGRectMake(150, 30, 60, 80)withStyle:LOADINGSTYLE_BLACKBG withTitle:@"0%"];
    theLoading.center=theImage.center;
    [self addSubview:theLoading];
}

-(void)reloadTheImageView{
    if (_needFix==NO) {
        return;
    }
    if ((theImage.image.size.height==0)||(theImage.frame.size.height==0)) {
        return;
    }
    CGFloat imageScale =  theImage.image.size.width/theImage.image.size.height;
    CGFloat frameScale = theImage.frame.size.width/theImage.frame.size.height;
    if (imageScale==frameScale) {
        return;
    }
    else if (imageScale>frameScale)
    {
        theImage.frame = CGRectMake(theImage.frame.origin.x, theImage.frame.origin.y+theImage.frame.size.height/2.0f-theImage.frame.size.width/imageScale/2.0f, theImage.frame.size.width, theImage.frame.size.width/imageScale);
    }
    else
    {
        theImage.frame = CGRectMake(theImage.frame.origin.x+theImage.frame.size.width/2.0f-theImage.frame.size.height*imageScale/2.0f, theImage.frame.origin.y, theImage.frame.size.height*imageScale, theImage.frame.size.height);
    }
}

static int download_imagecount = 0;
-(void)setTheImgUrl:(NSString *)theImgUrl{
    if (![_theImgUrl isEqualToString:theImgUrl]) {
         _theImgUrl =[theImgUrl copy];
    }
    theImage.hidden=NO;
    [errView removeFromSuperview];
    UIImage*theImg=[EMEImageLoader imageFromCacheForUrl:theImgUrl];
    NSLog(@"theImg size:%f,%f",theImg.size.width,theImg.size.height);

    if (theImg) {
        theImage.image=theImg;
        [self reloadTheImageView];
        frontMaskView.hidden=NO;
        [theLoading stopAnimationLoading];
        [actView stopAnimating];
    }else{
        [theLoading beginAnimationLoading];
        [actView startAnimating];
        theImage.backgroundColor=[UIColor clearColor];
        theImage.image=nil;
        EMEImageLoader *imageLoader =[GETIMAGELOADERS objectForKey:theImgUrl];
        [theLoading setText:[NSString stringWithFormat:@"%d%%",imageLoader.progress]];
        if (!imageLoader) {
            imageLoader= [EMEImageLoader imageLoaderWithPath:theImgUrl];
            [loaderLock lock];
            [GETIMAGELOADERS setObject:imageLoader forKey:theImgUrl];
            [loaderLock unlock];
            [imageLoader startLoad];
            download_imagecount++;
        }
        imageLoader.delegate = self;
    }
    
}

-(void)hideImg{
    theImage.hidden=YES;
}
 
#pragma EMImageLoaderDelegate
- (void)loadPercentWithNumber:(NSInteger)percentStr withLoader:(EMEImageLoader *)loader{
    if ([[GETIMAGELOADERS objectForKey:_theImgUrl] isEqual:loader]) {
        theLoading.hidden=NO;
        theLoading.alpha=1;
        [theLoading setText:[NSString stringWithFormat:@"%d%%",percentStr]];
    }
}

- (void)loadFinishedWithImage:(UIImage *)image withLoader:(EMEImageLoader*)loader{
    if ([[GETIMAGELOADERS objectForKey:_theImgUrl] isEqual:loader]) {
        NSLog(@"theImg size:%f,%f",image.size.width,image.size.height);
        theImage.image=image;
        [self reloadTheImageView];
        frontMaskView.hidden=NO;
        [theLoading stopAnimationLoading];
        [actView stopAnimating];
    }
    [loaderLock lock];
    [GETIMAGELOADERS removeObjectsForKeys:[GETIMAGELOADERS allKeysForObject:loader]];
    [loaderLock unlock];
    
}
- (void)loadFailedwithError:(NSError *)e  withLoader:(EMEImageLoader*)loader{
    if ([[GETIMAGELOADERS objectForKey:_theImgUrl] isEqual:loader]) {
        [theLoading setText:@"图片加载失败"];
        [theLoading stopAnimationLoading];
        [actView stopAnimating];
        
        if (!errView) {
            errView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"category_logo.png"]];
            errView.transform=CGAffineTransformMakeScale(0.7, 0.7);
        }
        errView.center=CGPointMake(theImage.bounds.size.width/2, theImage.bounds.size.height/2);
        [theImage addSubview:errView];
        }

    [loaderLock lock];
    [GETIMAGELOADERS removeObjectsForKeys:[GETIMAGELOADERS allKeysForObject:loader]];
    [loaderLock unlock];
}
@end
