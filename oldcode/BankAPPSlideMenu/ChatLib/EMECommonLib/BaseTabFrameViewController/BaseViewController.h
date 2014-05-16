//
//  BaseViewController.h
//  UiComponentDemo
///Users/imac/Documents/IAC/projects/tech/ios/UiComponent/EMECommon/BaseTabFrameViewController/BaseViewController.h
//  Created by Sean Li on 14-2-18.
//  Copyright (c) 2014年 junyi.zhu All rights reserved.
//


#import <UIKit/UIKit.h>


typedef enum  {
    NavBackButtonType = 0,//返回按钮
    NavLeftButtonType,
    NavRightMenuType,
    NavRightMoreButtonsListType//导航上右边显示
} NavButtonType;


typedef void (^EMENavButtonClickBlock)(NavButtonType navButtonType, NSInteger currentTabIndex);

/**
 * @discussion 每一个ViewController 类必须是BaseViewController 的子类
 */

@interface BaseViewController : UIViewController


//可选属性
@property(nonatomic,strong)UIImage *evBackgroundImage;//默认背景图片,注意使用该方法，整个App的背景将会都将会被改变

@property(nonatomic,assign)BOOL evHiddenBackButton;//是否隐藏返回按钮，默认不隐藏
@property(nonatomic,assign)BOOL evHiddenBackMenuButton;//是否隐藏返回菜单页面按钮，默认不隐藏

//控制是否需要显示子菜单，注意必须设置NavRightMoreButtonsListType，该属性才有用
@property(nonatomic,assign)BOOL evNavSubViewShow;

@property(nonatomic,readonly)UIView   *evNavSubMenuView;

/**
 *   设置背景
 *
 *  @param backgroudImage 视图背景图片
 *  @param isGlobal       是否是全局的，如果是则整个App的背景图片将会被替换
 */
-(void)efSetBackgroudImage:(UIImage*)backgroudImage  IsGlobal:(BOOL)isGlobal;
-(void)efSetBackgroudColor:(UIColor*)backgroudColor  IsGlobal:(BOOL)isGlobal;


/**
 *   设置导航背景
 *
 *  @param backgroudImage 设置导航背景
 */
-(void)efSetNavBarImage:(NSString *)imageName;


/**
 *  隐藏tabbar
 *
 *  @param isHidden 是否隐藏，不隐藏则显示
 */
-(void)efHiddenTabbar:(BOOL)isHidden;


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
            NavButtonClickBlock:(EMENavButtonClickBlock)navButtonClickBlock;

-(void)efSetNavButtonWithNavButtonType:(NavButtonType)buttonType
                  MoreButtonsListArray:(NSArray *)buttonsListArray
                   NavButtonClickBlock:(EMENavButtonClickBlock)navButtonClickBlock;


/**
 *  导航相应事件  子类可重写  如果子类不重写，则表示使用默认的操作方法
 */

-(void)efNavleftButtonClick:(id)sender;
-(void)efNavrightButtonClick:(id)sender;

/**
 * 弹出并显示more子菜单
 */
-(void)efShowNavSubMenuView:(BOOL)animated;
-(void)efHiddenNavSubMenuView:(BOOL)animated;

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

-(void)efViewAutoToUpBaseOnIphone4s:(CGFloat)VIEW_UP;//相对于iPhone4s 之前的 960 尺寸的屏幕来自动的处理兼容  1136 的尺寸
-(void)efViewToUp:(CGFloat)VIEW_UP;
/**
 *  视图还原到对应的位置
 */
-(void)efViewToDown;


#pragma mark - 屏幕尺寸，为了解决3.5 英寸 和  4.英寸屏幕问题
#pragma mark   注意，必须在[super viewDidLoad] 之后调用有效
/**
 *  获取正文内容尺寸
 *  @param  isIncludeTabBar  是否包含tabBar导航，如果包含tabbar（值为YES），
                             则对应的内容尺寸需要减去tabBar所占用的高度
 *  @return 返回正文内容尺寸
 */
-(CGRect)efGetContentFrameIncludeTabBar:(BOOL)isIncludeTabBar;
/**
 *  系统会自动处理获取正确的尺寸
 *  @return 返回正文内容尺寸
 */
-(CGRect)efGetContentFrame;
/**
 *  获取TabBar的尺寸
 *  @return 返回TabBar的尺寸
 */
-(CGRect)efGetTabBarFrame;
/**
 *  获取获取NavBar的尺寸
 *  @return 返回NavBar的尺寸
 */
-(CGRect)efgetNavBarFrame;

@end
