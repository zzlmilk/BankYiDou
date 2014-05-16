
#import "EMELoadingView.h"
#import <QuartzCore/QuartzCore.h>

@interface EMELoadingView ()

@property (nonatomic, strong)  UILabel *textLabel;

@end



@implementation EMELoadingView

@synthesize isLoading;
@synthesize textLabel;
@synthesize progressLabel;

-(id)initWithFrame:(CGRect)frame withStyle:(LOADINGSTYLE)style  withTitle:(NSString *)t
{
	if (self = [super initWithFrame:frame]) {
		loadingStyle = style;
		self.opaque = NO;
		self.exclusiveTouch = YES;
		self.userInteractionEnabled = YES;
		self.alpha = 0;
        self.layer.cornerRadius = 2;
        UIImageView *backV = [[UIImageView alloc] initWithFrame: CGRectZero];
        backV.image = [UIImage imageNamed: @"loading_bg.png"];
        [self addSubview: backV];
		if(style == LOADINGSTYLE_BLACKBG)
		{
			context = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-27, self.bounds.size.height/2-37, 54, 74)];
			context.layer.borderColor = [UIColor whiteColor].CGColor;
			progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, context.frame.size.height-20, 74, 20)];
			progressLabel.textColor = [UIColor blackColor];
			progressLabel.backgroundColor = [UIColor clearColor];
			progressLabel.textAlignment = NSTextAlignmentCenter;
			progressLabel.opaque = NO;
			progressLabel.text = t;
			progressLabel.font = [UIFont boldSystemFontOfSize:12];
			
			self.textLabel = progressLabel;
			[context addSubview:progressLabel];
			[self addSubview:context];
			
		}
        backV.frame = CGRectMake((self.bounds.size.width-backV.image.size.width)/2, (self.bounds.size.height-backV.image.size.height)/2 - 2, backV.image.size.width, backV.image.size.height);
    }
    return self;
	
}


- (void)setText:(NSString *)aText {
	text = aText;
	textLabel.text = text;
}

-(void)beginAnimationLoading{
    if(isLoading)
        return;
	isLoading = YES;
	self.alpha = 1;
}

-(void)stopAnimationLoading{
	isLoading = NO;
   	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	self.alpha = 0;
	[UIView commitAnimations];
}



@end
