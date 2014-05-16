//
//  MyCollectionViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-27.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "Datamanager.h"
#import "DataBaseCenter.h"
#import "MyCollectionCell.h"
#import "FirstDetailViewController.h"
#import "VipDetailViewController.h"

@interface MyCollectionViewController ()

@end

@implementation MyCollectionViewController
@synthesize aryMessage = _aryMessage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customNavigationTitle];
        [self customNavLeftButton];
        self.aryMessage = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (void)customNavigationTitle
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的收藏";
    self.navigationItem.titleView = titleLabel;
}

- (void)customNavLeftButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:@"登录首页-头部-LEFT-ICONS.png"] forState:UIControlStateNormal];
    btn.tag = 10004;
    [btn addTarget:self action:@selector(LeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)LeftBtnClicked:(id)sender
{
    NSLog(@"展开左侧");
    if (JDSideOpenOrNot) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifOpenJDSide object:nil];
        JDSideOpenOrNot = NO;
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifCloseJDSide object:nil];
        JDSideOpenOrNot = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    JDSideOpenOrNot = YES;
    //发送通知-滑动手势-panGestureEnabled=YES
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifPanGestureEnabled object:nil];
    [self addDataFromDB];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //隐藏掉table没有信息的cell
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 1111;
    self.tableview.tableFooterView = view;
}

- (void)addDataFromDB
{
    if (self.aryMessage != nil) {
        [self.aryMessage removeAllObjects];
    }
    
    NSMutableArray *ary = [DataBaseCenter findAllMessage];
    if (ary.count == 0) {
        self.tableview.hidden = YES;
    }
    else
    {
        for (int i = 0; i < [ary count]; i ++) {
            DataBaseCenter *dbCenter = (DataBaseCenter *)[ary objectAtIndex:i];
            [self.aryMessage insertObject:dbCenter atIndex:i];//这里的i有待确定
        }
        [self.tableview reloadData];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryMessage.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCollectionCell" owner:self options:nil]lastObject];
    }
    
    DataBaseCenter *message = (DataBaseCenter *)[self.aryMessage objectAtIndex:indexPath.row];
    cell.lblTitle.text = message.title;
    NSString *stringtemplet = message.templet;
    if ([stringtemplet isEqualToString:@"0"]) {//普通素材（咨询类型）
        NSLog(@"0");
    }
    else if ([stringtemplet isEqualToString:@"1"])//活动类型素材
    {
        NSLog(@"1");
    }
    else if ([stringtemplet isEqualToString:@"2"])//VIP特权类型素材
    {
        NSLog(@"2");
        cell.lblDetailInfo.text = @"特权VIP";
    }
    else if ([stringtemplet isEqualToString:@"3"])//理财产品类型素材
    {
        NSLog(@"3");
        cell.lblDetailInfo.text = @"尊享理财";
    }
    else if ([stringtemplet isEqualToString:@"4"])//信贷类型素材
    {
        
    }
    else if ([stringtemplet isEqualToString:@"5"])//黄金类型素材
    {
        
    }
    [cell.imageInfo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@small",message.imageURL]]placeholderImage:[UIImage imageNamed:@"icon-gear"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataBaseCenter *message = (DataBaseCenter *)[self.aryMessage objectAtIndex:indexPath.row];
    NSString *iii = message.templet;
    NSString *stringMId = message.materialId;
    if ([iii isEqualToString:@"0"]) {//普通素材（咨询类型）
        NSLog(@"0");
    }
    else if ([iii isEqualToString:@"1"])//活动类型素材
    {
        NSLog(@"1");
    }
    else if ([iii isEqualToString:@"2"])//VIP特权类型素材
    {
        NSLog(@"2");
        VipDetailViewController *vvc = [[VipDetailViewController alloc]initWithNibName:@"VipDetailViewController" bundle:nil];
        vvc.strIndex = @"1444";
        vvc.strMaterialId = stringMId;
        [self.navigationController pushViewController:vvc animated:YES];
    }
    else if ([iii isEqualToString:@"3"])//理财产品类型素材
    {
        NSLog(@"3");
        FirstDetailViewController *fvc = [[FirstDetailViewController alloc]initWithNibName:@"FirstDetailViewController" bundle:nil];
        fvc.strIndex = @"1444";
        fvc.strMaterialId = stringMId;
        [self.navigationController pushViewController:fvc animated:YES];
    }
    else if ([iii isEqualToString:@"4"])//信贷类型素材
    {
        
    }
    else if ([iii isEqualToString:@"5"])//黄金类型素材
    {
        
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
