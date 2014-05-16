//
//  BaseMenuViewController.m
//  BankAPP
//
//  Created by junyi.zhu on 14-2-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//22222

#import "leftMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "SettingCell.h"
#import "ZeroViewController.h"
#import "HomePageplateFlag.h"
#import "SettingCell.h"
#import "PrivilegeVIPplateFlag.h"
#import "ExclusiveMoneyplateFlag.h"
#import "FinancialAdvisorplateFlag.h"
#import "CatchBankPlatesPostObj.h"
#import "CatchBankPlatesTask.h"
#import "MBProgressHUD.h"
#import "MyCollectionViewController.h"
#import "MoreViewController.h"
#import "LeftCell.h"

typedef enum
{
    privilegeVIPplateFlag = 2,//特权VIP
    exclusiveMoneyplateFlag = 3,//尊享理财
    
    PersonalInformationplateFlag= 70, //个人信息
    homePageplateFlag = 71,//首页
    FavoritesplateFlag = 72,//收藏夹
    financialAdvisorplateFlag = 73,//我的理财顾问
    ActivityplateFlag = 100,//活动资讯   --开发中
    BankingInstituteplateFlag = 101,//理财学院   --开发中
}PLATE_FLAG;

@interface leftMenuViewController ()
{
    NSString * dispNamex;
    NSString *userType;
}
@end

@implementation leftMenuViewController
@synthesize CustomCell,menuLabelColor,contentView,menuDic,imageURL,array2,array,array3,leftlist,upTime;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self) {
        // Custom initialization
        array = [@[
                   [@{@"dispName" : @"", @"backGroundUrl" : @"" ,@"plateFlag":@"70"} mutableCopy],
                   [@{@"dispName" : @"首页", @"backGroundUrl" : @"左侧菜单-HOEM-ICONS.png" ,@"plateFlag":@"71"} mutableCopy],]
                 mutableCopy];
        
        array3=[@[
                  [@{@"dispName" : @"收藏夹",@"backGroundUrl" : @"左侧菜单-收藏-ICONS.png" ,@"plateFlag":@"72"} mutableCopy],
                  [@{@"dispName" : @"我的理财顾问",@"backGroundUrl" : @"左侧菜单-头像-ICONS.png",@"plateFlag":@"73" } mutableCopy],]
                mutableCopy];
    }
    [self requestCatchBankPlates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0==indexPath.row) {
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        NSString * struserName = [mySettingData objectForKey:@"realName"];
        NSString * struserpictureurl = [mySettingData objectForKey:@"pictureurl"];
//        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:8];
//        cell.imageView.frame = CGRectMake(0, 0, 10, 10);
        if (self.CustomCell == nil) {
            self.CustomCell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil] objectAtIndex:0];
        }
        self.CustomCell.profileview.backgroundColor = [UIColor clearColor];
        self.CustomCell.userName.text = struserName;
        self.CustomCell.userName.textColor= [UIColor whiteColor];
        //            self.CustomCell.profileImage.image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString :struserpictureurl]]];
        [self.CustomCell.profileImage setImageWithURL:[NSURL URLWithString:struserpictureurl] placeholderImage:[UIImage imageNamed:@"rentou.png"]];
        //            self.CustomCell.profileview.layer.cornerRadius = self.CustomCell.profileview.frame.size.width * 0.5f;
        self.CustomCell.profileview.layer.masksToBounds = YES;
        [self.CustomCell.mobutton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.CustomCell.contentView.backgroundColor = [UIColor grayColor];
        self.CustomCell.presentingController = self;
        self.CustomCell.selectionStyle = UITableViewCellSelectionStyleNone; //选中CELL时，无色（不变色）
        return self.CustomCell;
    }
    
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftCell" owner:self options:nil]lastObject];
    }
    
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    cell.LableTitle.text = [dict objectForKey:@"dispName"];
    NSString *strurl = [dict objectForKey:@"backGroundUrl"];
    cell.HeadImage.image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strurl]]];
    int newsCount =[[dict objectForKey:@"newsCount"]intValue];
    cell.unreadCount.text = [NSString stringWithFormat: @"%d",newsCount];
    if (newsCount <=0) {
        [cell.unreadCount setHidden:YES];
    }
    else if(newsCount > 100 ){
        cell.unreadCount.text =@"99+";
    }

    cell.unreadCount.textColor = [UIColor whiteColor];
    cell.unreadCount.textAlignment = NSTextAlignmentCenter;
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"左侧菜单-提示数.png"]];
    [cell.unreadCount setBackgroundColor:color];


    cell.LableTitle.textColor = [UIColor whiteColor];;
    cell.backgroundColor =[UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (1 ==indexPath.row) {
        //        cell.textLabel.text=@"首页";
        NSURL *url =[NSURL URLWithString: @"http://117.79.93.103:8012/upload/finances/image/home.png"];
        cell.HeadImage.image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
    }
    if ( array.count-2==indexPath.row) {
        //        cell.textLabel.text=@"收藏夹";
        NSURL *url = [NSURL URLWithString:@"http://117.79.93.103:8012/upload/finances/image/collect.png"];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
        cell.HeadImage.image = [UIImage imageWithData:urlData]; 
    }
    if (array.count-1==indexPath.row) {
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        userType = [mySettingData objectForKey:@"userType"];
        NSLog(@"%@",userType);
        
        if ([userType isEqualToString:@"1"])  {
            cell.LableTitle.text=nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中CELL时，无色（不变色）
            cell.HeadImage.image =nil;
        }
        else if ([userType isEqualToString:@"0"]){
            cell.LableTitle.text=@"我的理财顾问";
            NSURL *url = [NSURL URLWithString:@"http://117.79.93.103:8012/upload/finances/image/counselor.png"];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            cell.HeadImage.image = [UIImage imageWithData:urlData];
        }
    }
    return cell;
}


- (void)btnClicked:(id)sender
{
    NSLog(@"gengduo dianji ");
    MoreViewController * moVC =[[MoreViewController alloc]initWithNibName:@"MoreViewController" bundle:nil];
    
    UIViewController *contentController = [[UINavigationController alloc]
                                           initWithRootViewController:moVC];
    [self.sideMenuController setContentController:contentController rootController:vc animted:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选消失，以动画的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //去掉列表的分割行（Line Separator）
    //    [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    LeftCell *cell = (LeftCell *)[self.leftlist cellForRowAtIndexPath:indexPath];
    
    
    vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    NSBundle *bundle = [NSBundle mainBundle];
    self.menuDic = [array objectAtIndex:indexPath.row];
    
    int plateId = [[self.menuDic objectForKey:@"plateFlag"] intValue];
    
    switch (plateId) {
            
        case 70://
        {
            return;
        }
            break;
        case 71://首页
        {
            vc= [[HomePageplateFlag  alloc] initWithNibName:@"HomePageplateFlag" bundle:bundle];
        }
            break;
        case 2://vip
        {
            [cell.unreadCount setHidden:YES];
            vc = [[PrivilegeVIPplateFlag alloc] initWithNibName:@"PrivilegeVIPplateFlag" bundle:bundle];
        }
            break;
        case 3://尊享理财
        {
            [cell.unreadCount setHidden:YES];
            vc = [[ExclusiveMoneyplateFlag alloc] initWithNibName:@"ExclusiveMoneyplateFlag" bundle:bundle];
        }
            break;
        case 72://收藏页
        {
            vc = [[MyCollectionViewController alloc] initWithNibName:@"MyCollectionViewController" bundle:bundle];
        }
            break;
        case 73://我的理财顾问
        {
            if ([userType isEqualToString: @"1"]) {
                return;
            }
            vc = [[FinancialAdvisorplateFlag alloc] initWithNibName:@"FinancialAdvisorplateFlag" bundle:bundle];
        }
            break;
    }
        UIViewController *contentController = [[UINavigationController alloc]
                                           initWithRootViewController:vc];
//    [self.sideMenuController setContentController:contentController animted:YES];
    [self.sideMenuController setContentController:contentController rootController:vc animted:YES];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(0==indexPath.row)
    {
        //        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil];
        //        self.CustomCell = [nib objectAtIndex:0];
        //        CGFloat cellHeight = self.CustomCell.frame.size.height;
        //        return cellHeight;
        return 44;
    }
    else{
        return 50.0;
    }
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didTaskStarted:(Task *)aTask
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)requestCatchBankPlates
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    NSString * lastuptime = [mySettingData objectForKey:@"leftUpTime"];
    NSLog(@"获取左侧时间====================%@",lastuptime);
    CatchBankPlatesPostObj *postData = [[CatchBankPlatesPostObj alloc] init];
    postData.uid = struid;
    postData.token = strtoken;
    
    if (lastuptime==nil) {
        postData.lastTime=@"";
    }
    else{
        postData.lastTime =lastuptime;
    }
    
//    postData.lastTime =[[NSString alloc] initWithData:[NSDate date] encoding:NSUTF8StringEncoding];//上次打开时间
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    CatchBankPlatesTask *task = [[CatchBankPlatesTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)didTaskFinished:(Task *)aTask
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[CatchBankPlatesTask class] ]){
        
        NSDictionary * catchBankDict = aTask.responseDict;
        NSString *leftUpTime =[catchBankDict objectForKey:@"time"];
        [[NSUserDefaults standardUserDefaults] setObject:leftUpTime forKey:@"leftUpTime"];

        NSArray * arr =[catchBankDict objectForKey:@"info"];
        array2 = [arr objectAtIndex:0];
        [array addObjectsFromArray:array2];
        [array addObjectsFromArray:array3];
        NSString *code = [catchBankDict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]){
            
            /*
             *下边这段代码消除tableview上边的一段空白
             */
            int i = ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?20:0;
            
            self.leftlist = [[UITableView alloc]initWithFrame:CGRectMake(0,i, 320, self.view.bounds.size.height) style:UITableViewStylePlain];
            self.leftlist.dataSource = self;
            self.leftlist.delegate = self;
            self.view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.leftlist];
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                [self.leftlist setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
            }
            self.leftlist.backgroundColor = UIColorFromRGB(0x313237);
            NSLog(@"%f",self.leftlist.frame.origin.y);
            [leftlist setSeparatorColor:UIColorFromRGB(0x2a2b30)];
            [self setExtraCellLineHidden:self.leftlist];//清除多余分割线
            }
        else if ([code isEqualToString:@"9999"]) {
            [Utility alert:@"银行板块信息获取失败"];
            return;
        }
        else if ([code isEqualToString:@"9998"]) {
            [Utility alert:@"登录信息验证失败，请重新登陆"];
            return;
        }
        else if ([code isEqualToString:@"9001"]) {
            [Utility alert:@"用户不存在"];
            return;
        }
    }
    
}
@end
