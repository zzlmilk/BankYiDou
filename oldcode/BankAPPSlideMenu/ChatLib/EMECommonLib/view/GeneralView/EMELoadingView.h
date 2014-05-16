
#import <UIKit/UIKit.h>
typedef enum
{
	LOADINGSTYLE_DEFAULT = 1,
	LOADINGSTYLE_BLACKBG=2
}LOADINGSTYLE;

@interface EMELoadingView : UIImageView {
	UIActivityIndicatorView *activityView;
	BOOL isLoading;
	LOADINGSTYLE loadingStyle;
	UIView *context;
	UILabel  *textLabel;
	NSString  *text;
    UILabel *progressLabel;
}
@property(readonly) BOOL isLoading;
@property(readonly)UILabel *progressLabel;

-(void)beginAnimationLoading;
-(void)stopAnimationLoading;

- (void)setText:(NSString *)aText;

-(id)initWithFrame:(CGRect)frame withStyle:(LOADINGSTYLE)style withTitle:(NSString *)t;
@end
