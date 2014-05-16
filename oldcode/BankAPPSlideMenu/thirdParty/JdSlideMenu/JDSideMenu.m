//
//  JDSideMenu.m
//  StatusBarTest
//
//  Created by Markus Emrich on 11/11/13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//   111

#import "JDSideMenu.h"
#import "PrivilegeVIPplateFlag.h"
#import "ChatViewController.h"
#import "ClientListViewController.h"

#import "CatchConsultantInfoPostObj.h"
#import "CatchConsultantInfoTask.h"
#import "UIViewController+JDSideMenu.h"
#import "leftMenuViewController.h"


// constants
const CGFloat JDSideMenuMinimumRelativePanDistanceToOpen = 0.33;
const CGFloat JDSideMenuDefaultMenuWidth = 210.0;
const CGFloat JDSideMenuDefaultDamping = 0.5;

// animation times
const CGFloat JDSideMenuDefaultOpenAnimationTime = 1.2;
const CGFloat JDSideMenuDefaultCloseAnimationTime = 0.4;

@interface JDSideMenu ()
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end

@implementation JDSideMenu
{
    NSString *ConsultantUid;
    NSString *ConsultantName;
    NSString *Consultanturl;
    DockView *dockV;
}

- (id)initWithContentController:(UIViewController*)contentController
                 menuController:(UIViewController*)menuController
                    rootController:(UIViewController*)rootController;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _contentController = contentController;
        _menuController = menuController;
        _rootController = rootController;
        _menuWidth = JDSideMenuDefaultMenuWidth;
        _tapGestureEnabled = YES;//junyi.zhu 拍击手势
        _panGestureEnabled = YES;//junyi.zhu 拖动手势
        
        
    /*
     *以通知的方式来取消滑动和打开滑动手势
     */
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isPanGestureEnabled:) name:kNotifPanGestureEnabled object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isNotPanGestureEnabled:) name:kNotifNotpanGestureEnabled object:nil];
        
    /*
     *以通知的方式来响应点击按钮，打开或者是关闭侧边栏
     */
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openJDSide:) name:kNotifOpenJDSide object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeJDSide:) name:kNotifCloseJDSide object:nil];
    }

    return self;
}

- (void)isPanGestureEnabled:(id)sender
{
    self.panGestureEnabled = YES;
}

- (void)isNotPanGestureEnabled:(id)sender
{
    self.panGestureEnabled = NO;
}

- (void)openJDSide:(id)sender
{
    [self showMenuAnimated:YES];
}

- (void)closeJDSide:(id)sender
{
    [self hideMenuAnimated:YES];
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageCount) name:ChatSocketRequestResponseNoticeForMessage object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageCount) name:ChatSocketRequestResponseNoticeForList object:nil];

//    dockV =nil;
    // add childcontroller
    [self addChildViewController:self.menuController];
    [self.menuController didMoveToParentViewController:self];
    [self addChildViewController:self.contentController];
    [self.contentController didMoveToParentViewController:self];
    
    // add subviews
    
    CGRect tmpFrame = self.view.bounds;
    tmpFrame.size.height -= 57.5f;
    
//    _containerView = [[UIView alloc] initWithFrame:tmpFrame];

    _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    
//    self.view.backgroundColor = [UIColor redColor];
    
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:self.contentController.view];
    self.contentController.view.frame = self.containerView.bounds;
    self.contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_containerView];

    // setup gesture recognizers
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    self.tapRecognizer.delegate = self;
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)]; //  移动展开注掉
    [self.containerView addGestureRecognizer:self.tapRecognizer];
    [self.containerView addGestureRecognizer:self.panRecognizer];
    [self addBottomView];
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *userType = [mySettingData objectForKey:@"userType"];//userType  0为VIP，  1为理财顾问
    if ([userType isEqualToString:@"0"]) {
        [self requestCatchConsultant];}

}
-(void)changeMessageCount
{
    if (dockV) {
        [dockV resetLabelunread];
    }
   }
-(void)requestCatchConsultant
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    CatchConsultantInfoPostObj *postData = [[CatchConsultantInfoPostObj alloc] init];
    postData.token = strtoken;
    postData.uid = struid;
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    CatchConsultantInfoTask *task = [[CatchConsultantInfoTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}
    
#pragma - dock view delegate(bottom)
- (void)dockViewDidSelectIndex:(NSInteger)index
{
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strid = [mySettingData objectForKey:@"userType"];
    
    
    if (index == 0) {
        PrivilegeVIPplateFlag *secondvc = [[PrivilegeVIPplateFlag alloc]initWithNibName:@"PrivilegeVIPplateFlag" bundle:nil];
//
//        UIViewController *contentController = [[UINavigationController alloc]
//                                               initWithRootViewController:secondvc];
//        [self.sideMenuController setContentController:contentController animted:YES];
        
//        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
//        [self.navigationController pushViewController:controller animated:YES];



        [self.rootController.navigationController pushViewController:secondvc animated:YES];

        
//        [self.navigationController pushViewController:secondvc animated:YES];
//        [self presentViewController:secondvc animated:YES completion:nil];
    }
    else if (index == 1)
    {
//        dockV.hidden = YES;
//        dockV.userInteractionEnabled = NO;
        
        if ([strid isEqualToString:@"0"]) {//客户
            [self performSelectorOnMainThread:@selector(presentlpDialogVC) withObject:nil waitUntilDone:[NSThread isMainThread]];
        }
        else if ([strid isEqualToString:@"1"])//理财顾问
        {
            ChatViewController * chatVC = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
            [self.rootController.navigationController pushViewController:chatVC animated:YES];
        }
    }
    else if (index == 2)
    {
        if ([strid isEqualToString:@"0"]) {//客户
            [self addClearView];
        }
        else if ([strid isEqualToString:@"1"])//理财顾问
        {
            ClientListViewController *clientlist = [[ClientListViewController alloc]initWithNibName:@"ClientListViewController" bundle:nil];
            [self.rootController.navigationController pushViewController:clientlist animated:YES];
            
        }
    }
}
- (void)addClearView
{
    clearView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    clearView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, clearView.frame.size.height- 230+75, clearView.frame.size.width, 30);
    btn.tag = 10001;
    [btn setBackgroundColor:[UIColor darkGrayColor]];
    [btn setTitle:@"手机 : 12312341234" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, clearView.frame.size.height- 230+30+75, clearView.frame.size.width, 30);
    btn1.tag = 10002;
    [btn1 setBackgroundColor:[UIColor darkGrayColor]];
    [btn1 setTitle:@"手机 : 12312341234" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, clearView.frame.size.height - 230+30+30+30+45, clearView.frame.size.width,30);
    btn2.tag = 10003;
    [btn2 setBackgroundColor:[UIColor darkGrayColor]];
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:btn2];
    
}

- (void)presentlpDialogVC
{
    EMELPDialogVC *lpDialogVC = [[EMELPDialogVC alloc] init];
    EMELPFamily *lpFamliy = [[EMELPFamily alloc] init];
    [lpFamliy setAttributeWithUserId:[NSString stringWithFormat:@"%@",ConsultantUid]
                            UserName:ConsultantName
                        UserNickName:ConsultantName
                         UserHeadURL:Consultanturl
                             UserSex:UserSexTypeForFemale
                         UserAddress:nil
                       UserSignature:nil
                        UserTeamName:nil
                        UserIndustry:nil
                         UserJobName:nil
                    UserRegisterDate:nil
                      UserAlbumArray:nil
                            isOnline:YES
                          FriendType:FriendTypeForFriend];
    [lpDialogVC setAttributeFamilyMember:lpFamliy
                                   Group:nil];
    [self.rootController.navigationController pushViewController:lpDialogVC animated:YES];
    
}

- (void)addBottomView
{
    dockV = [DockView sharedDockView];
    
    if (IS_IPHONE5) {
        dockV.frame = CGRectMake(0, self.view.bounds.size.height-56, 320, 56);
    }
    else
    {
        dockV.frame = CGRectMake(0, 406, 320, 56);
    }
    
    dockV.dockDelegate = self;
    dockV.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:dockV];

}

#pragma mark -UITapGestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![self isMenuVisible]) {
        if ([touch.view isKindOfClass:[self.containerView class]]) {
            
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
    return YES;
}

- (void)setBackgroundImage:(UIImage*)image;
{
    if (!self.backgroundView && image) {
        self.backgroundView = [[UIImageView alloc] initWithImage:image];
        self.backgroundView.frame = self.view.bounds;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:self.backgroundView atIndex:0];
    } else if (image == nil) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
    } else {
        self.backgroundView.image = image;
    }
}

#pragma mark controller replacement

- (void)setContentController:(UIViewController*)contentController
                     animted:(BOOL)animated
{

}


- (void)setContentController:(UIViewController*)contentController rootController:(UIViewController*)rootController
                     animted:(BOOL)animated;
{
    if (contentController == nil) return;
    UIViewController *previousController = self.contentController;
    _contentController = contentController;
    _rootController = rootController;
    // add childcontroller
    [self addChildViewController:self.contentController];
    
    // add subview
    self.contentController.view.frame = self.containerView.bounds;
    self.contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // animate in
    __weak typeof(self) blockSelf = self;
    CGFloat offset = JDSideMenuDefaultMenuWidth + (self.view.frame.size.width-JDSideMenuDefaultMenuWidth)/2.0;
    [UIView animateWithDuration:JDSideMenuDefaultCloseAnimationTime/2.0 animations:^{
        blockSelf.containerView.transform = CGAffineTransformMakeTranslation(offset, 0);
        [blockSelf statusBarView].transform = blockSelf.containerView.transform;
    } completion:^(BOOL finished) {
        // move to container view

        [blockSelf.containerView addSubview:self.contentController.view];
        [blockSelf.containerView bringSubviewToFront:dockV];

        [blockSelf.contentController didMoveToParentViewController:blockSelf];
        
        // remove old controller
        [previousController willMoveToParentViewController:nil];
        [previousController removeFromParentViewController];
        [previousController.view removeFromSuperview];
        
        [blockSelf hideMenuAnimated:YES];
    }];
    
}

#pragma mark Animation

- (void)tapRecognized:(UITapGestureRecognizer*)recognizer
{
    if (!self.tapGestureEnabled) return;
    
    if (![self isMenuVisible]) {
//        [self showMenuAnimated:YES];
    } else {
//        [self hideMenuAnimated:YES];
    }
}


- (void)panRecognized:(UIPanGestureRecognizer*)recognizer
{
    if (!self.panGestureEnabled) return;
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self addMenuControllerView];
            
            [recognizer setTranslation:CGPointMake(recognizer.view.frame.origin.x, 0) inView:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [recognizer.view setTransform:CGAffineTransformMakeTranslation(MAX(0,translation.x), 0)];
            [self statusBarView].transform = recognizer.view.transform;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (velocity.x > 5.0 || (velocity.x >= -1.0 && translation.x > JDSideMenuMinimumRelativePanDistanceToOpen*self.menuWidth)) {
                CGFloat transformedVelocity = velocity.x/ABS(self.menuWidth - translation.x);
                CGFloat duration = JDSideMenuDefaultOpenAnimationTime * 0.66;
                [self showMenuAnimated:YES duration:duration initialVelocity:transformedVelocity];
            } else {
                [self hideMenuAnimated:YES];
            }
        }
        default:
            break;
    }
}

- (void)addMenuControllerView;
{
    if (self.menuController.view.superview == nil) {
        CGRect menuFrame, restFrame;
        CGRectDivide(self.view.bounds, &menuFrame, &restFrame, self.menuWidth, CGRectMinXEdge);
        self.menuController.view.frame = menuFrame;
        self.menuController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
//        self.view.backgroundColor = self.menuController.view.backgroundColor;
//        return;

//        [self.view addSubview:self.menuController.view];
//        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//        btn.backgroundColor = [UIColor redColor];
//        [self.view addSubview:btn];
//        if (self.backgroundView) {
//            [self.view insertSubview:self.menuController.view aboveSubview:self.backgroundView];
//        }
//        else
//        {
            [self.view insertSubview:self.menuController.view atIndex:0];
//        }

    }
}

- (void)showMenuAnimated:(BOOL)animated;
{
    [self showMenuAnimated:animated duration:JDSideMenuDefaultOpenAnimationTime
           initialVelocity:1.0];
}

- (void)showMenuAnimated:(BOOL)animated duration:(CGFloat)duration
         initialVelocity:(CGFloat)velocity;
{
    // add menu view
    [self addMenuControllerView];
    
    // animate
    __weak typeof(self) blockSelf = self;
//    [UIView animateWithDuration:animated ? duration : 0.0 delay:0
//         usingSpringWithDamping:JDSideMenuDefaultDamping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
//             blockSelf.containerView.transform = CGAffineTransformMakeTranslation(self.menuWidth, 0);
//             [self statusBarView].transform = blockSelf.containerView.transform;
//         } completion:nil];//junyi.zhu  4.8
    [UIView animateWithDuration:animated ? duration : 0.0 delay:0
          options:UIViewAnimationOptionAllowUserInteraction animations:^{
             blockSelf.containerView.transform = CGAffineTransformMakeTranslation(self.menuWidth, 0);
             [self statusBarView].transform = blockSelf.containerView.transform;
         } completion:nil];
}

- (void)hideMenuAnimated:(BOOL)animated;
{
    __weak typeof(self) blockSelf = self;
    [UIView animateWithDuration:JDSideMenuDefaultCloseAnimationTime animations:^{
        blockSelf.containerView.transform = CGAffineTransformIdentity;
        [self statusBarView].transform = blockSelf.containerView.transform;
    } completion:^(BOOL finished) {
        [blockSelf.menuController.view removeFromSuperview];
    }];
}

- (void)didTaskFinished:(Task *)aTask {
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([aTask isKindOfClass:[CatchConsultantInfoTask class] ]){
        NSDictionary * catchConsultantDict = aTask.responseDict;
        NSString * code = [catchConsultantDict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray * array = [catchConsultantDict objectForKey:@"info"];
            NSDictionary * result = [array objectAtIndex:0];
            ConsultantName = [result objectForKey:@"realName"];
            Consultanturl = [result objectForKey:@"pictureurl"];
            ConsultantUid = [result objectForKey:@"userId"];
        }
        else if([code isEqualToString:@"9999"]) {
            [Utility alert:@"设置理财顾问失败"];
            return;
        }
        else if([code isEqualToString:@"9998"]) {
            [Utility alert:@"理财顾问信息获取失败"];
            return;
        }
        else if([code isEqualToString:@"9001"]) {
            [Utility alert:@"用户不存在"];
            return;
        }
        else if([code isEqualToString:@"9010"]) {
            [Utility alert:@"VIP功能，理财顾问无权访问"];
            return;
        }
        else if([code isEqualToString:@"9016"]) {
            [Utility alert:@"VIP用户没有设置理财顾问"];
            return;
        }
        else if([code isEqualToString:@"9017"]) {
            [Utility alert:@"理财顾问信息错误"];
            return;
        }
    }
}
#pragma mark State

- (BOOL)isMenuVisible;
{
    return !CGAffineTransformEqualToTransform(self.containerView.transform,
                                              CGAffineTransformIdentity);
}

#pragma mark Statusbar

- (UIView*)statusBarView;
{
    UIView *statusBar = nil;

    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61 ,0x72} length:9];
    NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)]) statusBar = [object valueForKey:key];
//    return statusBar;  //动态移动
    return nil;
}

#pragma mark - pan移除和添加


@end
