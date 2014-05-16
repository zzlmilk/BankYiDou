

#import <UIKit/UIKit.h>


@interface EMENoNetworkTipView : UIImageView {
	
@private
	BOOL		isShown;
	
}

@property (nonatomic, assign)  id delegate;
@property (assign)  BOOL isShown;

+ (EMENoNetworkTipView *)sharedStatusView;

- (void)show;



@end
