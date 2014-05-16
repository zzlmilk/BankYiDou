//
//  ManageListVController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "ManageListVController.h"
#import "ManageListCell.h"
#import "MBProgressHUD.h"
@interface ManageListVController ()
{
    NSMutableArray *aryList;//所有的数据
    
    NSMutableArray *aryZan;
    NSMutableArray *aryCollect;
    NSMutableArray *aryActivity;
    
    NSMutableArray *arySee;
    NSMutableArray *aryNotSee;
    
    UIButton *btnSee;
    UIButton *btnNotSee;
}
@end

@implementation ManageListVController
@synthesize strmaterialId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customNavigationTitle];
        [self customNavLeftButton];
        aryList = [[NSMutableArray alloc]init];
        
        aryZan = [[NSMutableArray alloc]init];
        aryCollect = [[NSMutableArray alloc]init];
        aryActivity = [[NSMutableArray alloc]init];
        arySee = [[NSMutableArray alloc]init];
        aryNotSee = [[NSMutableArray alloc]init];
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
    titleLabel.text = @"管   理";
    self.navigationItem.titleView = titleLabel;
}

- (void)customNavLeftButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 25);
    [btn setImage:[UIImage imageNamed:@"fanhui11.png"] forState:UIControlStateNormal];
    btn.tag = 10004;
    [btn addTarget:self action:@selector(LeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)LeftBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     *下边这段代码消除tableview上边的一段空白
     */
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self addBasicView];
    
    //隐藏掉table没有信息的cell
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 1111;
    self.tablelist.tableFooterView = view;
    
    [self requestList];
}

- (void)addBasicView
{
    btnSee = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSee.frame = CGRectMake(30+10, 10, 120, 25);
    [btnSee setTitle:@"已查看人" forState:UIControlStateSelected];
    [btnSee setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnSee setTitle:@"已查看人" forState:UIControlStateNormal];
    [btnSee setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSee.tag = 11111;
    btnSee.selected = YES;
    [btnSee setBackgroundImage:[UIImage imageNamed:@"vipthree"] forState:UIControlStateSelected];
    [btnSee setBackgroundImage:[UIImage imageNamed:@"viptwo"] forState:UIControlStateNormal];
    [btnSee addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSee];
    btnNotSee = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNotSee.frame = CGRectMake(150+10, 10, 120, 25);
    [btnNotSee setTitle:@"未查看人" forState:UIControlStateSelected];
    [btnNotSee setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnNotSee setTitle:@"未查看人" forState:UIControlStateNormal];
    [btnNotSee setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnNotSee.tag = 22222;
    btnNotSee.selected = NO;
    [btnNotSee setBackgroundImage:[UIImage imageNamed:@"vipone"] forState:UIControlStateSelected];
    [btnNotSee setBackgroundImage:[UIImage imageNamed:@"vipfour"] forState:UIControlStateNormal];
    [btnNotSee addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNotSee];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ManageListCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    cell.lblName.text = [dict objectForKey:@"realName"];
    [cell.imagePerson setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@small",[dict objectForKey:@"pictureurl"]]] placeholderImage:[UIImage imageNamed:@"icon_btm_client.png"]];
    NSDictionary *dictMaterUser = [dict objectForKey:@"materialUser"];
    if (dictMaterUser != nil) {
        NSString *stringZan = [dictMaterUser objectForKey:@"praiseFlag"];
        NSString *stringCollect = [dictMaterUser objectForKey:@"collectFlag"];
        NSString *stringActivity = [dictMaterUser objectForKey:@"joinFlag"];
        if ([stringZan isEqualToString:@"1"]) {
            cell.imageZan.image = [UIImage imageNamed:@"xin"];
        }
        if ([stringCollect isEqualToString:@"1"]) {
            cell.imageCollect.image = [UIImage imageNamed:@"xing"];
        }
        if ([stringActivity isEqualToString:@""]) {
            cell.imageAct.image = [UIImage imageNamed:@"qi"];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉每行的点击效果
    return cell;
}

#pragma mark - Network
- (void)requestList {
    ListCustomersVipWithOperateStatusPostObj *postData = [[ListCustomersVipWithOperateStatusPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    postData.uid = struid;
    postData.token = strtoken;
    postData.materialId = strmaterialId;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    ListCustomersVipWithOperateStatusTask *task = [[ListCustomersVipWithOperateStatusTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[ListCustomersVipWithOperateStatusTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSArray *ary = [dict objectForKey:@"info"];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *aryL = [ary objectAtIndex:0];
            for (NSDictionary *dic in aryL) {
                NSDictionary *dicMaterialUser = [dic objectForKey:@"materialUser"];
                if (dicMaterialUser == nil) {
                    [aryNotSee addObject:dic];
                }
                else{
                    NSString *strPraiseFlag = [dicMaterialUser objectForKey:@"praiseFlag"];
                    NSString *strCollectFlag = [dicMaterialUser objectForKey:@"collectFlag"];
                    NSString *strJoinFlag = [dicMaterialUser objectForKey:@"joinFlag"];
                    if ([strPraiseFlag isEqualToString:@"1"]) {
                        [aryZan addObject:dic];
                    }
                    if ([strCollectFlag isEqualToString:@"1"]) {
                        [aryCollect addObject:dic];
                    }
                    if ([strJoinFlag isEqualToString:@"1"]) {
                        [aryActivity addObject:dic];
                    }
                    if ([strPraiseFlag isEqualToString:@"1"]||[strCollectFlag isEqualToString:@"1"]||[strJoinFlag isEqualToString:@"1"]) {
                        [arySee addObject:dic];
                    }
                    if ([strPraiseFlag isEqualToString:@"0"]&&[strCollectFlag isEqualToString:@"0"]&&[strJoinFlag isEqualToString:@"0"]) {
                        [aryNotSee addObject:dic];
                    }
                }
            }
            [aryList addObjectsFromArray:arySee];
            //设置头像
            //    [self.imagePerson setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pictureurl"]] placeholderImage:[UIImage imageNamed:@"icon_btm_client.png"]];
            [self.tablelist reloadData];
        }else if ([code isEqualToString:@"9998"]){
            
        }else if ([code isEqualToString:@"9009"]){
            [Utility alert:@"用户无权访问"];
        }
        else{
            [Utility alert:@"用户操作数据失败"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClicked:(id)sender {
    if (aryList != nil) {
        [aryList removeAllObjects];
    }
    UIButton *btn = (id)sender;
    if (btn.tag == 111) {//心 ：zan
        NSLog(@"1");
        [aryList addObjectsFromArray:aryZan];
    }
    else if (btn.tag == 222)//收藏
    {
        NSLog(@"2");
        [aryList addObjectsFromArray:aryCollect];
    }
    else if (btn.tag == 333)//参与
    {
        NSLog(@"3");
        [aryList addObjectsFromArray:aryActivity];
    }
    else if (btn.tag == 11111)
    {
        NSLog(@"已看");
        if (btnSee.selected == YES) {
            
        }
        else
        {
            btnSee.selected = YES;
            btnNotSee.selected = NO;
        }
        [aryList addObjectsFromArray:arySee];
    }
    else if (btn.tag == 22222)
    {
        NSLog(@"未看");
        if (btnNotSee.selected == YES) {
            
        }
        else
        {
            btnNotSee.selected = YES;
            btnSee.selected = NO;
        }
        [aryList addObjectsFromArray:aryNotSee];
    }
    [self.tablelist reloadData];
}
@end
