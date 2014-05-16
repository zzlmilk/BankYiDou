
#import <UIKit/UIKit.h>
#import "EMECustomCell.h"
#import "DTGridView.h"
#define GETIMAGELOADERS [EMEScrollView getImageLoaders]
@protocol EMEScrollViewDelegate;
@interface EMEScrollView : UIView<DTGridViewDelegate,DTGridViewDataSource>{
    NSArray*dataList; 
    DTGridView*theGridView;
    int selIndex;
}

+(NSMutableDictionary*)getImageLoaders; 
- (id)initWithFrame:(CGRect)frame isVertical:(BOOL)vertical data:(NSArray *)data;

@property(nonatomic,readonly)DTGridView*theGridView;
@property(nonatomic,strong)NSArray*dataList;
@property(nonatomic,assign)id<EMEScrollViewDelegate>delegate;
@property(nonatomic,assign)BOOL isVertical;
@end
@protocol EMEScrollViewDelegate <NSObject>
@optional
-(void)viewDidSelectedIdnex:(NSInteger)index;  
@end