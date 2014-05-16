//
//  BaseViewController.m
//  UiComponentDemo
//
//  Created by Sean Li on 14-2-18.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTabBarViewController.h"

static UIColor* s_BackgroudColor = nil;
#define  NavSubMenuViewTag 200
#define NavSubMenuItemButtonBaseTag 100
@interface BaseViewController ()
{
    UIButton *_egtNavLeftButton;
    UIButton *_egtNavRightButton;
}

@property(nonatomic,assign)BOOL evIsCompatiWithIOS7;//暂时不公开兼容iOS7的方法
@property(nonatomic,strong) NSMutableArray        *evNavMoreButtonsArray;
@property(nonatomic,copy)   EMENavButtonClickBlock evNavButtonClickBlock;
@property(nonatomic,assign) NavButtonType          evNavRightButtonType;//默认为Menu
@property(nonatomic,strong)UIView   *evNavSubMenuView;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //防止VC push 操作之后，会显示默认的tab
    self.hidesBottomBarWhenPushed = YES;
    self.evIsCompatiWithIOS7 = YES;
    if (s_BackgroudColor) {
        self.view.backgroundColor = s_BackgroudColor;
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    //返回按钮
    if (!_evHiddenBackButton) {
        [self efSetNavButtonWithNavButtonType:NavBackButtonType
                         MoreButtonsListArray:nil
                          NavButtonClickBlock:_evNavButtonClickBlock];
    }
    //返回菜单
    if (!_evHiddenBackMenuButton) {
        [self efSetNavButtonWithNavButtonType:NavRightMenuType
                         MoreButtonsListArray:nil
                          NavButtonClickBlock:_evNavButtonClickBlock];
        [self efHiddenTabbar:YES];
    }
    
    [self showNavigationBarWithImage:@"g_nav_backgroud"];
    
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)efSetNavBarImage:(NSString *)imageName{
    [self showNavigationBarWithImage:imageName];
}

#pragma mark - define

/**
 *  设置导航
 */
- (void) showNavigationBarWithImage:(NSString *)imageName
{
    UIImage* image = [CommonUtils ImageWithImageName:imageName EdgeInsets:UIEdgeInsetsMake(4, 0.2, 4, 0.2)];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)]) {//For iOS 7
        [self.navigationController.navigationBar setBackgroundImage:image forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }else if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])//For iOS 5 +
    {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else{
        self.navigationController.navigationBar.layer.contents = (id)image.CGImage;
    }
    
    NSDictionary *titleAttributes=[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor whiteColor],UITextAttributeTextColor,
                                   [UIFont boldSystemFontOfSize:18],UITextAttributeFont,
                                   nil];
    self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
    //    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    //    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    //    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    //    self.navigationController.navigationBar.layer.shadowRadius = 2;
}

/**
 * @breif  初始化导航more 菜单的子菜单
 * @discussion  该方法只能在设置导航菜单的时候调用
 */
-(void)initNavSubMenuView
{
    //0. 判断当前右边菜单的状态
    if (self.evNavRightButtonType !=  NavRightMoreButtonsListType) {
        return;
    }
    
    //1. 清理所有菜单中的内容
    for (UIView *tempView in self.evNavSubMenuView.subviews ) {
        [tempView removeFromSuperview];
    }
    
    //2. 检查子菜单的个数,如果不存在则设置默认值
    if (!_evNavMoreButtonsArray ||  [_evNavMoreButtonsArray count] == 0 ) {
        [self.evNavMoreButtonsArray addObject:@"菜单"];
        [self.evNavMoreButtonsArray addObject:@"收藏"];
        [self.evNavMoreButtonsArray addObject:@"分享"];

    }
     //3. 添加子菜单点击按钮
    CGRect subMenuTempFrame = CGRectMake(0, 0, 44, 34);
    
    for (NSInteger i=0 ; i< [self.evNavMoreButtonsArray count]; i++) {
        
        subMenuTempFrame.origin.y = i*subMenuTempFrame.size.height;

        //添加Button的分割线
        UIImageView *splitIimageView = [[UIImageView alloc] init];
        splitIimageView.backgroundColor = [UIColor clearColor];
        splitIimageView.image = [UIImage imageNamed:@"g_tabbarTopSplit"];
        splitIimageView.frame = CGRectMake(0, subMenuTempFrame.origin.y , subMenuTempFrame.size.width, 1);
        [self.evNavSubMenuView addSubview:splitIimageView];

        //添加button
        UIButton *subMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        subMenuButton.backgroundColor  = [UIColor clearColor];
        [subMenuButton setBackgroundImage:[UIImage imageNamed:@"g_nav_menuItemBackgroud"] forState:UIControlStateNormal];
        [subMenuButton setBackgroundImage:[UIImage imageNamed:@"g_nav_menuItemSelectedBackgroud"] forState:UIControlStateSelected];
        [subMenuButton setBackgroundImage:[UIImage imageNamed:@"g_nav_menuItemSelectedBackgroud"] forState:UIControlStateHighlighted];

        [subMenuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        subMenuButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        subMenuButton.frame = subMenuTempFrame;
        [subMenuButton setTitle:[self.evNavMoreButtonsArray objectAtIndex:i] forState:UIControlStateNormal];
        subMenuButton.tag = NavSubMenuItemButtonBaseTag +i;
        [subMenuButton addTarget:self action:@selector(efNavrightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.evNavSubMenuView addSubview:subMenuButton];
    }
    
    //4. 设置尺寸
    subMenuTempFrame.origin.y = 0;
    subMenuTempFrame.origin.x = 320 - subMenuTempFrame.size.width;
    subMenuTempFrame.size.height *= [self.evNavMoreButtonsArray count];
    self.evNavSubMenuView.frame =  subMenuTempFrame;
    
}

#pragma mark - public

/**
 *   设置背景
 *
 *  @param backgroudImage 视图背景图片
 *  @param isGlobal       是否是全局的，如果是则整个App的背景图片将会被替换
 */
-(void)efSetBackgroudImage:(UIImage*)backgroudImage  IsGlobal:(BOOL)isGlobal
{
    if (backgroudImage) {
        _evBackgroundImage = backgroudImage;
        UIColor *backgroudColor =   [UIColor colorWithPatternImage:_evBackgroundImage];
        [self efSetBackgroudColor:backgroudColor IsGlobal:isGlobal];
    }else{
        NIF_ERROR(@"设置背景参数为nil");
    }
    
}

-(void)efSetBackgroudColor:(UIColor*)backgroudColor  IsGlobal:(BOOL)isGlobal
{
    self.view.backgroundColor = backgroudColor;
    
    if (isGlobal) {
        s_BackgroudColor = nil;
        s_BackgroudColor =  backgroudColor;
    }
}

/**
 *  隐藏tabbar
 *
 *  @param isHidden 是否隐藏，不隐藏则显示
 */
-(void)efHiddenTabbar:(BOOL)isHidden
{
    if ([self.tabBarController isKindOfClass:[BaseTabBarViewController class]]) {
        ((BaseTabBarViewController*)self.tabBarController).evTabBarView.hidden = isHidden;
    }
}


#pragma mark - 导航按钮设置

/**
 *  设置导航
 *
 *  @param title               导航按钮的标题
 *  @param iconImageName       按钮图标
 *  @param selectedIconImageName    按钮选中时的图标
 *  @param buttonType          导航按钮类型
 *  @param buttonsListArray    导航多个
 *  @param navButtonClickBlock 点击响应 如果子类实现了，父类方法失效，直接使用子类
 */
- (void)efSetNavButtonWithTitle:(NSString *)title
                  IconImageName:(NSString *)iconImageName
          SelectedIconImageName:(NSString *)selectedIconImageName
                  NavButtonType:(NavButtonType)buttonType
           MoreButtonsListArray:(NSArray*)buttonsListArray
            NavButtonClickBlock:(EMENavButtonClickBlock)navButtonClickBlock
{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    
    //标题
    if (title == nil) {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.textColor = [UIColor whiteColor];
    }
    
    
    //图标
    if (iconImageName) {
        [button setImage:[UIImage imageNamed:iconImageName] forState:UIControlStateNormal];
    }
    
    if (selectedIconImageName) {
        [button setImage:[UIImage imageNamed:iconImageName] forState:UIControlStateSelected];
    }
//    else{
//        [button setBackgroundImage:[UIImage imageNamed:@"g_nav_menuItemBackgroud"] forState:UIControlStateSelected];
//        [button setBackgroundImage:[UIImage imageNamed:@"g_nav_menuItemBackgroud"] forState:UIControlStateHighlighted];
//    }
    
    //图标 - 返回按钮
    if (!iconImageName ) {
        if (buttonType == NavBackButtonType) {
            [button setImage:[UIImage imageNamed:@"g_nav_backButton"] forState:UIControlStateNormal];
        }else if(buttonType == NavRightMoreButtonsListType ){
                 [button setImage:[UIImage imageNamed:@"g_nav_more"] forState:UIControlStateNormal];
        }else if(buttonType == NavRightMenuType){
            [button setImage:[UIImage imageNamed:@"g_nav_menu"] forState:UIControlStateNormal];
        }else{
            NIF_ERROR(@"必须设置一个图标，使用NavLeftButtonType 类型的button");
        }
    }
    
    
    //位置
    if (EME_SYSTEMVERSION >= 7.0) {
        button.frame = CGRectMake(0.0,0.0, 38, 38);//back 按钮的尺寸
        if (buttonType == NavRightMoreButtonsListType  || buttonType == NavRightMenuType) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, -6, -32)];
        }else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, -6, 0)];
        }
    }
    else {
        button.frame = CGRectMake(0.0,0.0, 38, 38);//back 按钮的尺寸
        if (buttonType == NavRightMoreButtonsListType  || buttonType == NavRightMenuType ) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, -6, -10)];
        }else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, -6, 0)];
        }
    }
    
    //添加Button 事件
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (buttonType == NavBackButtonType || buttonType == NavLeftButtonType) {
        [button addTarget:self action:@selector(efNavleftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = menuButton;
        _egtNavLeftButton = button;
    } else {
        _egtNavRightButton = button;

        [button addTarget:self action:@selector(efNavrightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = menuButton;
        
        //存储Button类型
        _evNavRightButtonType = buttonType;
        
        //存储子菜单选项
        if (buttonsListArray && [buttonsListArray count] >0) {
            [self.evNavMoreButtonsArray removeAllObjects];
            [self.evNavMoreButtonsArray addObjectsFromArray:buttonsListArray];
        }
        
        //初始化子菜单
        [self initNavSubMenuView];
    }
    
    //存储Button 响应事件
    if (navButtonClickBlock) {
        self.evNavButtonClickBlock  = navButtonClickBlock;
    }

}

-(void)efSetNavButtonWithNavButtonType:(NavButtonType)buttonType
                  MoreButtonsListArray:(NSArray *)buttonsListArray
                   NavButtonClickBlock:(EMENavButtonClickBlock)navButtonClickBlock
{
    
    [self efSetNavButtonWithTitle:nil
                    IconImageName:nil
            SelectedIconImageName:nil
                    NavButtonType:buttonType
             MoreButtonsListArray:nil
              NavButtonClickBlock:navButtonClickBlock];
    
}


/**
 *  导航相应事件  子类可重写  如果子类不重写，则表示使用默认的操作方法
 */

-(void)efNavleftButtonClick:(id)sender
{
    if (self.evNavButtonClickBlock) {
        self.evNavButtonClickBlock(NavBackButtonType,0);
    }else{
        NIF_INFO(@"左边按钮默认被视为返回按钮,子类可以重新,默认点击行为是直接返回");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)efNavrightButtonClick:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    NIF_INFO(@"右边按钮默认被视为菜单,子类可以重新,默认点击行为是直接返回");
    if (self.evNavButtonClickBlock) {
        /**
         *  button.tag == 0
         *  表示菜单more 选项
         */
        self.evNavButtonClickBlock(self.evNavRightButtonType,button.tag);
        
    }else{
        if (!_evNavMoreButtonsArray  && [_evNavMoreButtonsArray count] <=1) { //表示只有一项，则默认是返回菜单
            [self.navigationController popToRootViewControllerAnimated:NO];
            if ([self.tabBarController isKindOfClass:[BaseTabBarViewController class]]) {
                [(BaseTabBarViewController*)self.tabBarController   gotoTabViewControllerWithTabVCClassName:nil
                                                                                               orTabVCIndex:0];
            }
        }else{
            NIF_INFO(@"需要处理子菜单弹出");
            [self efShowNavSubMenuView:YES];
        }
    }
}


/**
 * 弹出并显示more子菜单
 */
-(void)efShowNavSubMenuView:(BOOL)animated
{
    [self efHiddenNavSubMenuView:NO];
    
    if (_egtNavRightButton) {
        _egtNavRightButton.selected = YES;
    }
    
    _evNavSubViewShow = YES;
    _evNavSubMenuView.hidden = NO;
    [self.view addSubview:self.evNavSubMenuView];
}

-(void)efHiddenNavSubMenuView:(BOOL)animated
{
    _evNavSubViewShow = NO;

    if (_egtNavRightButton) {
        _egtNavRightButton.selected = NO;
    }
    
    
    UIView *subMenuView = [self.view viewWithTag:NavSubMenuViewTag];
    if (subMenuView) {
        [subMenuView removeFromSuperview];
    }
    _evNavSubMenuView.hidden = YES;

}

#pragma mark - 解决键盘挡住输入框问题
/**
 *  整个视图移动
 *
 *  @param VIEW_UP 移动的多少
 *  @discussion   VIEW_UP取值说明
 1. 正值  视图向上移动
 2. 负值  视图向下移动
 3. 零    视图还原到对应的位置
 */
-(void)efViewAutoToUpBaseOnIphone4s:(CGFloat)VIEW_UP
{
    
    if (IS_IPHONE5) {
        VIEW_UP += 88;
    }
    if (EME_SYSTEMVERSION < 7.0) {
        VIEW_UP -= 64.0;
    }
    [self efViewToUp:VIEW_UP];

}

-(void)efViewToUp:(CGFloat)VIEW_UP
{
	NSTimeInterval animationDuration = 0.30f;
	[UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
    
    //	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
    CGRect rect = CGRectMake(0.0f,VIEW_UP,width,height);
    self.view.frame = rect;
    [UIView commitAnimations];
    //	}else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
    //		CGRect rect = CGRectMake(0.0f,VIEW_UP*1.1,width,height);
    //        self.view.frame = rect;
    //		[UIView commitAnimations];
    //	}
}
/**
 *  视图还原到对应的位置
 */
-(void)efViewToDown
{
	NSTimeInterval animationDuration = 0.20f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
    float VIEW_UP =0.0;
    //兼容iOS7 做法
    if (EME_SYSTEMVERSION >= 7.0) {
        VIEW_UP = 64.0;
    }
    
	CGRect rect = CGRectMake(0.0f, VIEW_UP, self.view.frame.size.width, self.view.frame.size.height);
	self.view.frame = rect;
	
    [UIView commitAnimations];
    
    
}


#pragma mark - 屏幕尺寸，为了解决3.5 英寸 和  4.英寸屏幕问题
/**
 *  获取正文内容尺寸
 *  @param  isIncludeTabBar  是否包含tabBar导航， 默认系统会自动判断
 *  @return 返回正文内容尺寸
 */
-(CGRect)efGetContentFrameIncludeTabBar:(BOOL)isIncludeTabBar
{
    //0. 3.5英寸 480
    //1. 4英寸   568
    CGRect etContentFrame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
    
    //导航的高度。@warning 注意:iOS7的导航高度默认值是20
    etContentFrame.size.height -= [self efgetNavBarFrame].size.height + [self efgetNavBarFrame].origin.y;
    
    //表示显示TabBar，所以高度需要减去tabbar
    if (!isIncludeTabBar) {
        etContentFrame.size.height -= [self efGetTabBarFrame].size.height;
    }
    
    return etContentFrame;
}

-(CGRect)efGetContentFrame
{
    //注意隐藏tabBar 就是不包含的tabBar的意思
    return [self efGetContentFrameIncludeTabBar:!self.evHiddenBackMenuButton];
}

/**
 *  获取TabBar的尺寸
 *  @return 返回TabBar的尺寸
 */
-(CGRect)efGetTabBarFrame
{
    //    NIF_INFO(@"TabBarFrame :%@",NSStringFromCGRect(self.tabBarController.tabBar.frame));
    return self.tabBarController.tabBar.frame;
}

/**
 *  获取获取NavBar的尺寸
 *  @return 返回NavBar的尺寸
 */
-(CGRect)efgetNavBarFrame
{
    //   NIF_INFO(@"NavBarFrame :%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
    return   self.navigationController.navigationBar.frame;
    
}


#pragma mark - getter

-(UIView*)evNavSubMenuView
{
    if (_evNavSubMenuView == nil) {
        _evNavSubMenuView = [[UIView alloc] init];
        _evNavSubMenuView.backgroundColor = [UIColor clearColor];
        _evNavSubMenuView.tag = NavSubMenuViewTag;
        _evNavSubMenuView.layer.zPosition = 999;
    }
    return _evNavSubMenuView;
}

-(NSMutableArray*)evNavMoreButtonsArray
{
    if (_evNavMoreButtonsArray == nil) {
        _evNavMoreButtonsArray = [[NSMutableArray alloc] init];
    }
    return _evNavMoreButtonsArray;
}

#pragma mark - setter
/**
 *  @abstract  兼容iOS 7 方法
 *  @see http://www.cnblogs.com/mgbert/archive/2013/12/25/3490569.html
 *  @param isCompatiWithIOS7 是否兼容iOS7
 */
-(void)setEvIsCompatiWithIOS7:(BOOL)evIsCompatiWithIOS7

{
    if (evIsCompatiWithIOS7 != _evIsCompatiWithIOS7 ) {
        _evIsCompatiWithIOS7 = evIsCompatiWithIOS7;
        
        if(  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = _evIsCompatiWithIOS7 ? UIRectEdgeNone : UIRectEdgeAll;
            [self setAutomaticallyAdjustsScrollViewInsets:!_evIsCompatiWithIOS7];
            //          self.extendedLayoutIncludesOpaqueBars = NO;
            //            self.modalPresentationCapturesStatusBarAppearance = NO;
            //            self.navigationController.navigationBar.barTintColor =[UIColor grayColor];
            //            self.tabBarController.tabBar.barTintColor =[UIColor grayColor];
            
            /**
             *  解决问题 :自动进入到tabBar对应的第一个页面时，navigationBar和tabBar会出现黑色的背景，
             一小会会消失，才变成自己设置的背景色。
             */
            //            self.navigationController.navigationBar.translucent = NO;
            //            self.tabBarController.tabBar.translucent = NO;
        }
        //        [self.view setNeedsDisplay];
    }
    
    
}

-(void)setEvBackgroundImage:(UIImage *)evBackgroundImage
{
    [self efSetBackgroudImage:evBackgroundImage IsGlobal:NO];
}

-(void)setEvNavSubViewShow:(BOOL)evNavSubViewShow
{
    if (evNavSubViewShow) {
        [self efShowNavSubMenuView:NO];
    }else{
        [self efHiddenNavSubMenuView:NO];
    }
}

-(void)setAutomaticallyAdjustsScrollViewInsets:(BOOL)automaticallyAdjustsScrollViewInsets

{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        
        [super setAutomaticallyAdjustsScrollViewInsets:automaticallyAdjustsScrollViewInsets];
        
    }
    
}

#pragma mark - 旋转
-(BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationPortrait;
}

@end
