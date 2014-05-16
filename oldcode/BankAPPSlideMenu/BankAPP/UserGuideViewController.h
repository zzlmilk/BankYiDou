//
//  UserGuideViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-4-8.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserGuideViewController : UIViewController<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
}
/*
 *却分是首次进入还是由更多进入
 * 10001 首次进入app
 * 10002 更多进入指导页
 */
@property (nonatomic, strong) NSString *stringDif;

@end
