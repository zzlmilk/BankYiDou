
#import <UIKit/UIKit.h>
#import"DTGridViewCell.h"
#import"EMEImageLoader.h"
#import "EMELoadingView.h"
@interface EMECustomCell : DTGridViewCell<EMEImageLoaderDelegate>{
    NSString*_theImgUrl;
    UIImageView*theImage;
    EMELoadingView*theLoading;
    NSLock*loaderLock; 
    UIActivityIndicatorView*actView;
    UIImageView*errView;
}
@property(nonatomic,strong)NSString*theImgUrl;
@property(nonatomic,readonly) EMELoadingView*theLoading;
@property(nonatomic,readonly)UILabel *indexLbl;
@property(nonatomic,readonly)UIImageView *frontMaskView;
@property(nonatomic,readonly)bool needFix;
- (id)initWithReuseIdentifier:(NSString *)anIdentifier with:(UIView *)forView;
- (id)initWithReuseIdentifier:(NSString *)anIdentifier;
-(void)hideImg;


@end