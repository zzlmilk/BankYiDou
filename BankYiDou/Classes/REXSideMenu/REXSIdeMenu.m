//
//  REXSIdeMenu.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-23.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "REXSIdeMenu.h"

@interface REXSIdeMenu ()


@property (assign, readwrite, nonatomic) BOOL leftMenuVisible;
@property (strong, readwrite, nonatomic) UIView *menuViewContainer;
@property (strong, readwrite, nonatomic) UIView *contentViewContainer;

@property (strong, readwrite, nonatomic) UIButton *contentButton;



-(void)_commonInit;
@end

@implementation REXSIdeMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self _commonInit];
  }
    return self;
}



//xib init
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

-(void)_commonInit{
    _contentViewContainer = [[UIView alloc]init];
    _menuViewContainer = [[UIView alloc]init];
    
    _animationDuration =  0.35f;
    
    _menuViewControllerTransformation = CGAffineTransformMakeScale(1.5f, 1.5f);
    
     _contentViewInPortraitOffsetCenterX = 30.f;
    
    
}

#pragma mark Public methods
-(instancetype)initWithContentViewController:(UIViewController *)contentViewController leftMenuViewController:(UIViewController *)leftMenuViewController rightMenuViewController:(UIViewController *)rightMenuViewController{
    self = [super init];
    if (self) {
        _contentViewController = contentViewController;
        _leftMenuViewController = leftMenuViewController;
        _rightMenuViewController = rightMenuViewController;
    }
    return self;
}

-(void)presentLeftMenuViewController{
    [self __presentMenuViewContainerWithMenuViewController:self.leftMenuViewController];
    [self __showLeftMenuViewController];
}

-(void)presentRightMenuViewController{
    
}

-(void)hideMenuViewController
{
     [self __hideMenuViewControllerAnimated:YES];
}


#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.menuViewContainer];
    [self.view addSubview:self.contentViewContainer];
    
    self.menuViewContainer.frame = self.view.bounds;
    
    if (self.leftMenuViewController) {
        [self addChildViewController:self.leftMenuViewController];
        self.leftMenuViewController.view.frame = self.view.bounds;
        [self.menuViewContainer addSubview:self.leftMenuViewController.view];
        
        
        [self.leftMenuViewController didMoveToParentViewController:self];
    }
    
    
    self.contentViewContainer.frame = self.view.bounds;
    
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.view.bounds;
    [self.contentViewContainer addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    

}
#pragma mark -
#pragma mark Private methods
- (void)__presentMenuViewContainerWithMenuViewController:(UIViewController *)menuViewController{
    self.menuViewContainer.transform = CGAffineTransformIdentity;
    
    self.menuViewContainer.frame = self.view.bounds;
    if (self.scaleMenuView) {
        self.menuViewContainer.transform = self.menuViewControllerTransformation;
    }
    
    

}

-(void)__showLeftMenuViewController{
    if (!self.leftMenuViewController) {
        return;
    }
    self.leftMenuViewController.view.hidden = NO;
    [self.view.window endEditing:YES];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
       self.contentViewContainer.center = CGPointMake(self.contentViewInPortraitOffsetCenterX + CGRectGetWidth(self.view.frame), self.contentViewContainer.center.y);
        
    } completion:^(BOOL finished){
        self.leftMenuVisible = YES;
    }];
    
}


- (void)__hideMenuViewControllerAnimated:(BOOL)animated
{
    
}



- (void)__addContentButton
{
    if (self.contentButton.superview)
        return;
    
    self.contentButton.autoresizingMask = UIViewAutoresizingNone;
    self.contentButton.frame = self.contentViewContainer.bounds;
    self.contentButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentViewContainer addSubview:self.contentButton];
}




#pragma mark -
#pragma mark iOS 7 Motion Effects (Private)




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
