

#import "EMEScrollView.h"


@implementation EMEScrollView
@synthesize dataList,delegate,theGridView,isVertical;

NSMutableDictionary*imageLoaders;
+(NSMutableDictionary*)getImageLoaders{
    @synchronized(self) {
        if (!imageLoaders) {
            imageLoaders=[[NSMutableDictionary alloc] init];
        }
    }
    return imageLoaders;
    
}


- (id)initWithFrame:(CGRect)frame isVertical:(BOOL)vertical data:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=YES;
        self.isVertical=vertical;
        self.dataList = [NSMutableArray arrayWithArray:data];
        theGridView = [[DTGridView alloc] initWithFrame:CGRectMake(60, 0, 201, 180)];
        theGridView.backgroundColor=[UIColor clearColor];
        theGridView.delegate = self;
        theGridView.dataSource=self;
        theGridView.pagingEnabled=YES;
        theGridView.clipsToBounds=NO;
    
        theGridView.isVertical=isVertical;
   
        [self addSubview:theGridView];
        
    }
    return self;
}
 
-(void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    if (self.delegate&&[delegate respondsToSelector:@selector(viewDidSelectedIdnex:)]) {
        [self.delegate viewDidSelectedIdnex:gridView.isVertical?rowIndex:columnIndex];
    }
    
}
- (void)pagedGridView:(DTGridView *)gridView didScrollToRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    //int number=gridView.isVertical?rowIndex:columnIndex;
    
}
- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return (gridView.isVertical?dataList.count:1);
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)theIndex {
	return (gridView.isVertical?1:dataList.count);
}
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
    return gridView.frame.size.height;
}
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
    return gridView.frame.size.width;
}
- (EMECustomCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	EMECustomCell *cell = (EMECustomCell *)[gridView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
        cell = [[EMECustomCell alloc] initWithReuseIdentifier:@"cell"];
	}
    int number=gridView.isVertical?rowIndex:columnIndex;
 
    @try { 
        cell.theImgUrl = IMAGE_URL([((NSDictionary *)[self.dataList objectAtIndex:number]) objectForKey:@"url"]);//[((NSDictionary *)[self.dataList objectAtIndex:number]) objectForKey:@"url"]
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
 
	return cell;
}
-(void)gridViewDidLoad:(DTGridView *)gridView{
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float theX=scrollView.contentOffset.x;
  
    int page=(theX*2+theGridView.frame.size.width)/theGridView.frame.size.width/2;
    if (page>-1&&page!=selIndex) {
 
        selIndex=page;

    }
}
 
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}
 
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;
{

    UIView *view = [super hitTest:point withEvent:event];
    if (self.userInteractionEnabled) {
        if(view != nil && [view  isKindOfClass: [EMECustomCell class]])
            return  view;
        if (CGRectContainsPoint(theGridView.superview.bounds, point)) {
            return theGridView;
        }
    }else
        return nil;
    return view;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
