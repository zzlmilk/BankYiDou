
#import <UIKit/UIKit.h>
#import "EMEImageLoader.h"

@protocol EMENetImageViewDelegate;

@interface EMENetImageView : UIButton <EMEImageLoaderDelegate>{
    EMEImageLoader *imgLoader;
    NSString *imgUrl;
    UIActivityIndicatorView *activityV;
}

@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, assign) int tag2;
@property(nonatomic, assign) id<EMENetImageViewDelegate> delegate;
@property(nonatomic, assign) BOOL isShowLoadIng;

- (void)setDownloadImage:(UIImage*)aImage;

@end

@protocol EMENetImageViewDelegate <NSObject>
@optional
- (void)EMENetImageView:(EMENetImageView*)aImageV loadFinishedWithImage:(UIImage*)aImage;
- (void)EMENetImageView:(EMENetImageView*)aImageV loadError:(NSError *)error;
@end
