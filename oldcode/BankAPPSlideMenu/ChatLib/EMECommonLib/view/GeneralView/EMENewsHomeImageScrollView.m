//
//  EMEImageScrollViewEC.m
//  UiComponentDemo
//
//  Created by junyi.zhu on 14-2-25.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//

#import "EMENewsHomeImageScrollView.h"
#import "EMEFactroyManger.h"


@interface EMENewsHomeImageScrollView (){
    int selIndex;
}

@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UILabel *playlabel; 
@property(nonatomic,strong)NSArray *dataList;
@property(nonatomic,readonly)DTGridView*theGridView;

@end

@implementation EMENewsHomeImageScrollView


- (id)initWithFrame:(CGRect)frame data:(NSArray *)data showPageControl:(BOOL)pageControl
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=YES;
        _dataList = [NSMutableArray arrayWithArray:data];
        _theGridView = [[DTGridView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 160.0f)];
        _theGridView.backgroundColor = [UIColor clearColor];
        _theGridView.delegate = self;
        _theGridView.dataSource = self;
        _theGridView.pagingEnabled = YES;
        [self addSubview:_theGridView];
        NSLog(@"_dataList.count = %d",(int)_dataList.count);
        
        if ((pageControl)&&(_dataList.count>1)) {
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(110, 115, 100, 5)];
            _pageControl.numberOfPages = _dataList.count;
            _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
            [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:_pageControl];
        }
        
        UIView  *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(_theGridView.frame.origin.x, _theGridView.frame.size.height - 30.0f, _theGridView.frame.size.width, 30.0f)];
        [backgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [self addSubview:backgroundView];
        
        _playlabel = [[UILabel alloc]initWithFrame:CGRectMake(backgroundView.frame.origin.x + 12.0f, backgroundView.frame.origin.y, backgroundView.frame.size.width - 12.0f, backgroundView.frame.size.height)];
        [_playlabel setText:[[data objectAtIndex:0] objectForKey:@"imgTitle"]];
        [_playlabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_playlabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_playlabel];
//        
//        if (emptyString([[data objectAtIndex:0] objectForKey:@"imgTitle"]).length ==0) {
//            backgroundView.alpha = 0;
//            _pageControl.frame =  CGRectMake(110, 140, 100, 5);
//        }
//        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data showPageControl:(BOOL)pageControl withBorderImage:(UIImageView*)borderImageView
{
    self = [self initWithFrame:frame data:data showPageControl:pageControl];
    //    [borderImageView setFrame:CGRectMake(20, 165, 200, 20)];
    [self addSubview:borderImageView];
    return self;
}

//根据分页控制跳转页面
-(void)changePage:(id)sender{
	NSInteger page = _pageControl.currentPage;
	CGRect frame = [self bounds];
	frame.origin.x = frame.size.width*page;
	frame.origin.y = 0;
    [_theGridView setContentOffset:CGPointMake(page *320.0, 0)];
    NSDictionary *dic = [_dataList objectAtIndex:page];
    _playlabel.text = [dic objectForKey:@"imgTitle"];
}

-(void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    if (_scrollDelegate&&[_scrollDelegate respondsToSelector:@selector(epViewDidSelectedIdnex:)]) {
        [_scrollDelegate epViewDidSelectedIdnex:gridView.isVertical?rowIndex:columnIndex];
    }
}

- (void)pagedGridView:(DTGridView *)gridView didScrollToRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    if (_scrollDelegate&&[_scrollDelegate respondsToSelector:@selector(epViewDidScrolltoIndex:)]) {
        [_scrollDelegate epViewDidScrolltoIndex:gridView.isVertical?rowIndex:columnIndex];
    }
    
}
- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return (gridView.isVertical?_dataList.count:1);
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)theIndex {
	return (gridView.isVertical?1:_dataList.count);
}
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
    return gridView.frame.size.height;
}
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
    return gridView.frame.size.width;
}
- (EMECustomCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	EMECustomCell *cell = (EMECustomCell *)[gridView dequeueReusableCellWithIdentifier:@"cell1"];
	if (!cell) {
        cell = [[EMECustomCell alloc] initWithReuseIdentifier:@"cell1" with:self];
	}
    NSInteger number = columnIndex;
    NSDictionary *dic = [_dataList objectAtIndex:number];
    @try {
        cell.theImgUrl = IMAGE_URL([dic objectForKey:@"imgurl"]);
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
    
    int page=(theX*2+_theGridView.frame.size.width)/_theGridView.frame.size.width/2;
    if (page>-1&&page!=selIndex) {
        selIndex=page;
    }
    _pageControl.currentPage = page;
    NSDictionary *dic = [_dataList objectAtIndex:page];
    _playlabel.text = [dic objectForKey:@"imgTitle"];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _theGridView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        _pageControl.currentPage = page;
    }
}



@end
