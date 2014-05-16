
#import "EMENoNetworkTipView.h"
#import "NSObject+Universal.h"


#define STATUS_VIEW_WIDTH	260
#define STATUS_VIEW_CENTER	CGPointMake(160, 240)

static EMENoNetworkTipView *sharedStatusView = nil;

@implementation EMENoNetworkTipView

@synthesize delegate = _delegate;
@synthesize isShown;

+ (EMENoNetworkTipView *)sharedStatusView {
	@synchronized(self) {
		if (sharedStatusView == nil) {
			sharedStatusView = [[self alloc] initWithImage:[UIImage bundleImageName:@"nowifi.png"]];
		}
		return sharedStatusView;
	}
}

- (id)initWithImage:(UIImage *)image {
	if (self = [super initWithImage:image]) {
		self.center = STATUS_VIEW_CENTER;
		isShown = NO;
	}
	return self;
}



- (void)drawRect:(CGRect)rect {
	
}

- (void)show {
	
//	UIWindow *keyWindow = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;//[UIApplication sharedApplication].keyWindow;		
//	if (!self.superview) {
//		[keyWindow addSubview:self];	
//	}
//	[keyWindow bringSubviewToFront:self];
//
//	
//	if (isShown) {
//		return;
//	}
//    
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.8];
//	self.alpha = 1;
//	[UIView commitAnimations];
//	[self performSelector:@selector(dismiss) withObject:nil afterDelay:5];
//	isShown = YES;
	
	
}

- (void)dismiss {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	self.alpha = 0;
	[UIView commitAnimations];
	isShown = NO;
}



- (void)dealloc {
//	[_image release];
	self.delegate = nil;
}


@end
