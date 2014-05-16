//
//  VipDetailViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-15.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "VipDetailViewController.h"
#import "ManageListVController.h"
#import "MBProgressHUD.h"
#import "DataBaseCenter.h"
#import "EnlargePicture.h"
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


@interface VipDetailViewController ()
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

@implementation VipDetailViewController
@synthesize dictList,strIndex,strMaterialId;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (IS_IPHONE5) {
        self.scrollview.frame = CGRectMake(0, -20, self.view.frame.size.width, 568-64-56);
    }
    [self.scrollview setContentSize:CGSizeMake(320, 480)];
    self.scrollview.alwaysBounceVertical = YES;//加上就可以上下移动
    self.scrollview.scrollEnabled = YES;
    
    NSLog(@"dictList....%@",dictList);
    
    if ([strIndex isEqualToString:@"1111"]) {
        [self addBasicData];
        NSLog(@"1111");
        stringFour = kRead;//详情由前边dictAll传进来，但是要进来调用日志接口
        OneOrZero = @"1";
        [self requestData];
    }
    else if ([strIndex isEqualToString:@"1222"])
    {
        [self addBasicData];
        NSLog(@"1222");
        stringFour = kRead;//详情由前边dictAll传进来，但是要进来调用日志接口
        OneOrZero = @"1";
        [self requestData];
    }
    else if ([strIndex isEqualToString:@"1333"])
    {
        [self requestData22];
        NSLog(@"1333");
    }
    else if ([strIndex isEqualToString:@"1444"])
    {
        //从数据库读得时候因为存得只有id，所以必须再次去调用接口，请求数据，而不能从上一级传值过来
        NSLog(@"1444");
        [self requestData22];
    }
    
    [self navAddbtnitems];//添加右上角3个按钮
    self.imagePicture.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(magnifyImage)];
    [self.imagePicture addGestureRecognizer:tap];
}

- (void)magnifyImage{
    [EnlargePicture showImage:self.imagePicture];
}

- (NSString *)fabuTime:(long long)num
{
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:num/1000];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    NSString *str = [dateformatter stringFromDate:d];
    return str;
}

- (void)addBasicData
{
    long long strTime = [[dictList objectForKey:@"verifyTime"]longLongValue];
    self.lblFBTime.text = [self fabuTime:strTime];
    self.lblTitle.text = [dictList objectForKey:@"title"];
    self.lblphone.text = [[dictList objectForKey:@"promissoryShop"]objectForKey:@"telephone"];
    self.lblAdress.text = [[dictList objectForKey:@"promissoryShop"]objectForKey:@"address"];
    NSString *strInfo = [[dictList objectForKey:@"promissoryShop"]objectForKey:@"saleDescript"];
    if ([strInfo isEqualToString:@""]||strInfo == nil) {
        strInfo = @"无";
    }
    self.lblInfo.text = strInfo;
    [self.imagePicture setImageWithURL:[NSURL URLWithString:[dictList objectForKey:@"pictureurl"]] placeholderImage:[UIImage imageNamed:@"icon-gear.png"]];
    NSString *strWebView = [dictList objectForKey:@"content"];
    [self.webview_vip loadHTMLString:strWebView baseURL:nil];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    CGRect frame = webView.frame;
//    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    self.webview_vip.frame = frame;
//}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    self.webview_vip.frame = newFrame;
    
    CGFloat height = actualSize.height;
    self.scrollview.contentSize = CGSizeMake(320, height +360);
}

- (void)navAddbtnitems
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *string = [mySettingData objectForKey:@"userType"];
    
    NSDictionary *dictionary = [dictList objectForKey:@"materialUser"];
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
    btnTwo.tag = 222222;
    [btnTwo setImage:[UIImage imageNamed:@"理财产品详情-收藏.png"] forState:UIControlStateNormal];
    [btnTwo setImage:[UIImage imageNamed:@"icon_collection_pressed.png"] forState:UIControlStateSelected];
    if ([strBtntwo isEqualToString:@"1"]) {
        btnTwo.selected = YES;
    }
    else
    {
        btnTwo.selected = NO;
    }
    [btnTwo addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btntwoitem = [[UIBarButtonItem alloc]initWithCustomView:btnTwo];
    
    btnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    btnThree.frame = CGRectMake(0, 0, 20, 20);
    btnThree.tag = 333333;
    [btnThree setBackgroundImage:[UIImage imageNamed:@"理财产品详情-手.png"] forState:UIControlStateNormal];
    [btnThree setBackgroundImage:[UIImage imageNamed:@"icon_praise_press.png"] forState:UIControlStateSelected];
    if ([strBtnthree isEqualToString:@"1"]) {
        btnThree.selected = YES;
        btnThree.enabled = NO;
    }
    else
    {
        btnThree.selected = NO;
    }
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
    else if ([string isEqualToString:@"0"])//客户
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
        
        NSString *stringMaterialId = [[dictList objectForKey:@"materialId"]stringValue];
        stringFour = kCollect;
        if (btnTwo.selected == YES) {
            btnTwo.selected = NO;
            collectOneOrZero = @"0";
            OneOrZero = collectOneOrZero;
            [self requestData];
            
            [DataBaseCenter deletePalceID:stringMaterialId];
        }
        else
        {
            btnTwo.selected = YES;
            collectOneOrZero = @"1";
            OneOrZero = collectOneOrZero;
            [self requestData];
            
            NSString *stringurl = [dictList objectForKey:@"pictureurl"];
            NSString *stringtitle = [dictList objectForKey:@"title"];
            NSString *stringtemplet = [dictList objectForKey:@"templet"];
            [DataBaseCenter saveCollectionWithmaterialId:stringMaterialId withImageDataURL:stringurl withTitle:stringtitle withModuleName:@"4444" withTemplet:stringtemplet];
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
    postData.operateTime = @"";// 暂时不传，以接口调用时间为准，后边再添加
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
        NSArray *aryl = [dict objectForKey:@"info"];
        dictList = [aryl lastObject];
        [self addBasicData];
        [self navAddbtnitems];
    }
    else if ([aTask isKindOfClass:[RecordUserOperateLogTask class]]){
        NSDictionary *dict = aTask.responseDict;
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]) {
//            [Utility alert:@"用户操作成功"];
        }else if ([code isEqualToString:@"9998"]){
//            NSLog(@"登录信息验证失败");
        }else{
            [Utility alert:@"用户操作失败"];
        }
    }
    //    NSDictionary *dic = [ary lastObject];
    //    strMaxTime = [dic objectForKey:@"verifyTime"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)mobile:(id)sender {
    UIButton *btn = (id)sender;
    if (btn.tag == 0) {//打电话，同时返回应用
//        UIWebView *callWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
//        NSURL *telURL = [NSURL URLWithString:@"tel:10086"];
//        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",self.lblphone.text]]];
    }
}
@end
