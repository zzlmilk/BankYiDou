//
//  HomeTestViewController.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-29.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "HomeTestViewController.h"

@interface HomeTestViewController ()

@end

@implementation HomeTestViewController

-(void)awakeFromNib{
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    
    self.leftMenuViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self presentLeftMenuViewController];
}


@end
