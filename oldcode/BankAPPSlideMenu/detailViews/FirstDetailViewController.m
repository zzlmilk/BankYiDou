//
//  FirstDetailViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "FirstDetailViewController.h"
#import "MBProgressHUD.h"
#import "RecordUserOperateLogTask.h"
#import "RecordUserStatusLogObj.h"
#import "UIImageView+WebCache.h"

#import "HomePageplateFlag.h"
#import "ExclusiveMoneyplateFlag.h"
#import "ClientSeeViewController.h"//如果是理财顾问由客户列表进来的，就不进行读操作
#import "ManageListVController.h"

#import "DataBaseCenter.h"
/*
 * operateType
 *  读    1 -读
 *  赞    1 -点  0 - 取消
 *  收藏  1 -点  0 - 取消
 *  参加  1 -点  0 - 取消（暂时取消）
 *
 */
#define kRead    @"read"
#define kPraise  @"praise"
#define kCollect @"collect"
#define kjoin    @"join"

#define khuoqilixi @"0.35%"

@interface FirstDetailViewController ()
{
    NSString *stringFour;//四种不同状态
    NSString *OneOrZero;//1或0
    NSString *readOneOrZero;
    NSString *praiseOneOrZero;
    NSString *collectOneOrZero;
    
//    UIButton *btnOne;//活动
    UIButton *btnTwo;//收藏
    UIButton *btnThree;//赞
    UIButton *btnManage;//管理（理财顾问登进来才显示）
}
@end

@implementation FirstDetailViewController
@synthesize strMaterialId,dictAll,strIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //发送通知取消滑动手势
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifNotpanGestureEnabled object:nil];
        [self customNavLeftButton];
    }
    return self;
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

- (NSString *)fabuTime:(long long)num
{
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:num/1000];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    NSString *str = [dateformatter stringFromDate:d];
    return str;
}

- (NSString *)time:(long long)num
{
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:num/1000];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY.MM.dd"];
    NSString *str = [dateformatter stringFromDate:d];
    return str;
}

- (NSString *)valueFromTime:(long long)fromeT withToTime:(long long)ToT
{
    long long aFromT = fromeT/1000;
    long long aToT = ToT/1000;
    long long aQX = aToT - aFromT;
    NSString *string = [NSString stringWithFormat:@"%lld天",aQX/(60*60*24)];
    return string;
}

- (void)addBaseInfo
{
    NSDictionary *dict = [dictAll objectForKey:@"financialProduct"];
    self.lbltitle.text = [dictAll objectForKey:@"title"];
    self.lblStyle.text = [dict objectForKey:@"productCode"];
    long long numTime = [[dictAll objectForKey:@"verifyTime"]longLongValue];
    self.lblTime.text = [self fabuTime:numTime];
    
    NSString *strSYL = [NSString stringWithFormat:@"%@%%",[[dict objectForKey:@"expectedRite"]stringValue]];
    self.lbl_shouyilv.text = strSYL;
    double aa = [[dict objectForKey:@"expectedRite"]integerValue]/0.35;
    float ab = floor(aa*10)/10;
    self.lbl_beishu.text = [NSString stringWithFormat:@"%.1f",ab];
    self.lbl_qigou.text = [NSString stringWithFormat:@"%@元",[[dict objectForKey:@"minAmount"]stringValue]];
    NSString *strFengxian = [dict objectForKey:@"riskLevel"];
    if ([strFengxian isEqualToString:@"0"]) {
        self.lbl_fengxian.text = @"低风险";
    }
    else if ([strFengxian isEqualToString:@"1"]){
        self.lbl_fengxian.text = @"中风险";
    }else{
        self.lbl_fengxian.text = @"高风险";
    }
    NSString *strSXF = [[dict objectForKey:@"managerRite"]stringValue];
    if ([strSXF isEqualToString:@""]||strSXF == nil) {
        self.lbl_shouxufei.text = @"无";
    }
    else
    {
        self.lbl_shouxufei.text = [NSString stringWithFormat:@"%@%%",strSXF];
    }
    NSString *strDZSJ = [dict objectForKey:@"receiptTime"];
    if ([strDZSJ isEqualToString:@"1"]) {
        self.lbl_other_time.text = @"当天到账";
    }
    else if ([strDZSJ isEqualToString:@"2"]){
        self.lbl_other_time.text = [NSString stringWithFormat:@"t+2或者t+3"];
    }
    self.lbl_other_time.font = [UIFont systemFontOfSize:14];
    self.lbl_other_Mahager.text = [dict objectForKey:@"assetManager"];
    self.lbl_other_Mahager.font = [UIFont systemFontOfSize:14];
    long long rengou_start = [[dict objectForKey:@"subscribeStart"]longLongValue];
    long long rengou_end = [[dict objectForKey:@"subscribeEnd"]longLongValue];
    self.lbl_rengouTime.text = [NSString stringWithFormat:@"%@ 至 %@",[self time:rengou_start],[self time:rengou_end]];
    long long shouyi_start = [[dict objectForKey:@"valueDateFrom"]longLongValue];
    long long shouyi_end = [[dict objectForKey:@"valueDateTo"]longLongValue];
    self.lbl_shouyiTime.text = [NSString stringWithFormat:@"%@ 至 %@",[self time:shouyi_start],[self time:shouyi_end]];
    self.lbl_qixian.text = [self valueFromTime:shouyi_start withToTime:shouyi_end];
    NSString *strHTML = [dictAll objectForKey:@"content"];
    [self.webView_html loadHTMLString:strHTML baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    self.webView_html.frame = newFrame;
    
    CGFloat height = actualSize.height;
    self.scrollview.contentSize = CGSizeMake(320, height +360);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (IS_IPHONE5) {
        self.scrollview.frame = CGRectMake(0, -20, self.view.frame.size.width, 568-64-56);
    }
    [self.scrollview setContentSize:CGSizeMake(320, 480)];
    self.scrollview.alwaysBounceVertical = YES;//加上就可以上下移动
    self.scrollview.scrollEnabled = YES;
    
    NSLog(@"dic == %@",dictAll);
    
    if ([strIndex isEqualToString:@"1111"]) {
        [self addBaseInfo];
        [self navAddbtnitems];//添加右上角3个按钮
        NSLog(@"1111");
        stringFour = kRead;//详情由前边dictAll传进来，但是要进来调用日志接口
        readOneOrZero = @"1";
        OneOrZero = readOneOrZero;
        [self requestData];
    }
    else if ([strIndex isEqualToString:@"1222"])
    {
        [self addBaseInfo];
        [self navAddbtnitems];//添加右上角3个按钮
        NSLog(@"1222");
        stringFour = kRead;//详情由前边dictAll传进来，但是要进来调用日志接口
        readOneOrZero = @"1";
        OneOrZero = readOneOrZero;
        [self requestData];
    }
    else if ([strIndex isEqualToString:@"1333"])
    {
        [self requestData22];
        NSLog(@"1333");
    }
    else if ([strIndex isEqualToString:@"1444"])
    {
        [self requestData22];
        NSLog(@"1444");
    }
}

- (void)navAddbtnitems
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *string = [mySettingData objectForKey:@"userType"];
    
    NSDictionary *dictionary = [dictAll objectForKey:@"materialUser"];
    NSString *strBtntwo = [dictionary objectForKey:@"collectFlag"];
    NSString *strBtnthree = [dictionary objectForKey:@"praiseFlag"];

//    btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnOne.frame = CGRectMake(0, 0, 30, 30);
//    btnOne.selected = YES;
//    btnOne.tag = 111111;
//    [btnOne setImage:[UIImage imageNamed:@"sadsad.png"] forState:UIControlStateNormal];
//    [btnOne setImage:[UIImage imageNamed:@"理财产品详情-双人.png"] forState:UIControlStateSelected];
//    [btnOne addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *btnoneitem = [[UIBarButtonItem alloc]initWithCustomView:btnOne];
    
    btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTwo.frame = CGRectMake(0, 0, 20, 20);
    if ([strBtntwo isEqualToString:@"1"]) {
        btnTwo.selected = YES;
    }
    else
    {
        btnTwo.selected = NO;
    }
    btnTwo.tag = 222222;
    [btnTwo setImage:[UIImage imageNamed:@"理财产品详情-收藏.png"] forState:UIControlStateNormal];
    [btnTwo setImage:[UIImage imageNamed:@"icon_collection_pressed.png"] forState:UIControlStateSelected];
    [btnTwo addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btntwoitem = [[UIBarButtonItem alloc]initWithCustomView:btnTwo];

    btnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    btnThree.frame = CGRectMake(0, 0, 20, 20);
    if ([strBtnthree isEqualToString:@"1"]) {
        btnThree.selected = YES;
        btnThree.enabled = NO;
    }
    else
    {
        btnThree.selected = NO;
    }
    btnThree.tag = 333333;
    [btnThree setImage:[UIImage imageNamed:@"理财产品详情-手.png"] forState:UIControlStateNormal];
    [btnThree setImage:[UIImage imageNamed:@"icon_praise_press.png"] forState:UIControlStateSelected];
    [btnThree addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnthreeitem = [[UIBarButtonItem alloc]initWithCustomView:btnThree];
    
    btnManage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnManage.frame = CGRectMake(0, 0, 20, 20);
    btnManage.tag = 444444;
    [btnManage setImage:[UIImage imageNamed:@"理财产品详情-双人.png"] forState:UIControlStateNormal];
    [btnManage addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ([string isEqualToString:@"1"]) {
        btnManage.hidden = NO;
    }
    else if ([string isEqualToString:@"0"])
    {
        btnManage.hidden = YES;
    }
    UIBarButtonItem *btnManageitem = [[UIBarButtonItem alloc]initWithCustomView:btnManage];
    
    NSArray *aryBtns = [NSArray array];
    if ([string isEqualToString:@"1"]) {
        aryBtns = @[btnManageitem,btntwoitem,btnthreeitem];
    }
    else if ([string isEqualToString:@"0"]){
        aryBtns = @[btntwoitem,btnthreeitem];
    }
    self.navigationItem.rightBarButtonItems = aryBtns;
}

- (void)btnClicked:(UIButton *)button
{
    UIButton *btn = (UIButton *)button;
    if (btn.tag == 333333) {
        NSLog(@"赞");
        stringFour = kPraise;
        if (btnThree.selected == YES) {
            NSLog(@"点过赞之后就不能再修改");
        }
        else
        {
            btnThree.selected = YES;
            btnThree.enabled = NO;
            praiseOneOrZero = @"1";
            OneOrZero = praiseOneOrZero;
            [self requestData];
        }
    }
    else if (btn.tag == 222222)
    {
        NSLog(@"收藏");
        stringFour = kCollect;
        NSString *stringmaterialId = [[dictAll objectForKey:@"materialId"]stringValue];
        if (btnTwo.selected == YES) {
            btnTwo.selected = NO;
            collectOneOrZero = @"0";
            OneOrZero = collectOneOrZero;
            [self requestData];
            //根据materialId去删除数据库中得信息
            [DataBaseCenter deletePalceID:stringmaterialId];
        }
        else
        {
            btnTwo.selected = YES;
            collectOneOrZero = @"1";
            OneOrZero = collectOneOrZero;
            [self requestData];
            
            NSString *stringmaterialId = [[dictAll objectForKey:@"materialId"]stringValue];
            NSString *stringtitle = [dictAll objectForKey:@"title"];
            NSString *stringurl = [dictAll objectForKey:@"pictureurl"];
            NSString *stringtemplet = [dictAll objectForKey:@"templet"];
            //把信息存入数据库
            [DataBaseCenter saveCollectionWithmaterialId:stringmaterialId withImageDataURL:stringurl withTitle:stringtitle withModuleName:@"333333" withTemplet:stringtemplet];
 
        }
    }
    else if (btn.tag == 111111)
    {
//        NSLog(@"参加");
//        stringFour = kjoin;
//        if (btnOne.selected == YES) {
//            btnOne.selected = NO;
//        }
//        else
//        {
//            btnOne.selected = YES;
//        }
    }
    else if (btn.tag == 444444)
    {
        NSLog(@"浏览此页面的客户信息");
        ManageListVController *managevc = [[ManageListVController alloc]initWithNibName:@"ManageListVController" bundle:nil];
        managevc.strmaterialId = strMaterialId;
        [self.navigationController pushViewController:managevc animated:YES];
        return;
    }
}


#pragma mark - Network
- (void)requestData {
    RecordUserStatusLogObj *postData = [[RecordUserStatusLogObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    postData.materialId = strMaterialId;
    postData.operateType = stringFour;
    postData.operateValue = OneOrZero;
    postData.operateTime = @"";// 暂时先不传，以接口调用时间为准，后边再添加
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    RecordUserOperateLogTask *task = [[RecordUserOperateLogTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - Network
- (void)requestData22 {
    CatchMaterialDetailPostObj *postData = [[CatchMaterialDetailPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    postData.materialId = strMaterialId;
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    CatchMaterialDetailTask *task = [[CatchMaterialDetailTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}


#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[CatchMaterialDetailTask class]]) {
        NSDictionary *dict = aTask.responseDict;
        NSLog(@"CatchMaterialDetailTask == %@",dict);
        dictAll = [[dict objectForKey:@"info"]lastObject];
        [self addBaseInfo];
        [self navAddbtnitems];//添加右上角3个按钮
    }
    else if ([aTask isKindOfClass:[RecordUserOperateLogTask class]]){
        NSDictionary *dict = aTask.responseDict;
        NSLog(@"RecordUserStatusLogObj == %@",dict);
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
            //            [Utility alert:@"用户操作成功"];
        }else if ([code isEqualToString:@"9998"]){
//            NSLog(@"登录信息验证失败");
        }else{
            [Utility alert:@"用户操作失败"];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
