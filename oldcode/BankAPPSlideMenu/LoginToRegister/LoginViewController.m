    //
//  LoginViewController.m
//  BankVip2
//
//  Created by kevin on 14-2-16.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomePageplateFlag.h"
#import "RegisterViewController.h"
#import "FindPWViewController.h"
#import "MBProgressHUD.h"
#import "JDSideMenu.h"
#import "leftMenuViewController.h"
#import "LoginPostObj.h"
#import "LoginTask.h"
#import "VerificationCodePostObj.h"
#import "VerificationCodeTask.h"//验证
#import "catchBankRegistTypeTask.h"
#import <CommonCrypto/CommonHMAC.h> //MD5加密
#import "ChangeInvestmentViewController.h"
#import "EMELPSocketManager.h"
#import "MessageCodec.h"
#import "Message.h"
#import "NSObject+Message_Dialog.h"
#import "EMEDialogEntity.h"
#import "SocketConn.h"
#import "GCDAsyncSocket.h"
#import "SocketConn.h"
#import "GCDAsyncUdpSocket.h"
#import "EMELPDialogVC.h"
#import "ChatViewController.h"
#import "UrlucrecordUserStatusLogPostObj.h"
#import "UrlucrecordUserStatusLogTask.h"
#import "CheckTokenPostObj.h"
#import "CheckTokenTask.h"
#import "PhoneUtil.h"
#import "LogoutPostObj.h"
#import "LogoutTask.h"
#import "ZeroViewController.h"
#import "NetWorkWatchDogManager.h"

@interface LoginViewController ()
{
    EMELPSocketManager * socketVC;
    NSString *catchType;
    NSString * userloginName;
    NSString * userpictureurl;
}
@property (nonatomic, strong) GCDAsyncSocket *socket;

@property (nonatomic) CGRect scrollOriginalRect;
@property(nonatomic,strong) NSArray * array;
@property (nonatomic) BOOL canModalVC;
@property (strong,nonatomic) HomePageplateFlag *firstViewController;
@property (nonatomic,strong)RegisterViewController *registerViewController;
@property (nonatomic,strong)LoginViewController *loginVC;
@end

@implementation LoginViewController
@synthesize passWordText,usePhoneText,firstViewController,imageView,thelastTime,thetoken,theuid,theuserType,menuController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)viewWillAppear
{
}

- (void)viewDidLoad
{
    self.canModalVC = NO;
    [super viewDidLoad];
    [self requestCheckToken];
    self.navigationController.navigationBar.hidden = YES;
    
    if (IS_IPHONE5) {
        CGRect rect = self.imageView.frame;
        rect.size.height += 88;
        self.imageView.frame = rect;
    }
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *themobile = [mySettingData objectForKey:@"mobile"];
    if (themobile) {
        usePhoneText.text = themobile;
    }
//    usePhoneText.text = @"13611110000";
//    usePhoneText.text = @"13966666677";
//    passWordText.text = @"admin1";
}

//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

#pragma mark - Network Request
- (void)requestLogin
{
    LoginPostObj *postData = [[LoginPostObj alloc] init];
    postData.mobile = self.usePhoneText.text;
    postData.password = [self getMd5_32Bit_String:self.passWordText.text];

    [[NSUserDefaults standardUserDefaults] setObject:passWordText.text forKey:@"password"];

    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    LoginTask *task = [[LoginTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)requestLogout
{
    LogoutPostObj * postData =[[LogoutPostObj alloc]init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *usertoken = [mySettingData objectForKey:@"token"];
    int useuid = [[mySettingData objectForKey:@"uid"]intValue];
    NSString* useruseruid = [NSString stringWithFormat:@"%d",useuid];
    postData.uid = useruseruid;
    postData.token =usertoken;
    postData.clientInfo =@"[ios][理财VIP][1.0][]";
    postData.deviceInfo = [NSString stringWithFormat:@"[%@][%@][%@][%@][%@]",[PhoneUtil getName],[PhoneUtil getMobile],[PhoneUtil getUuid],[PhoneUtil getDeviceType],[PhoneUtil getOSVersion]];//客户端设备信息，格式与clientInfo格式相同，每个字段用"[]"框起来接在后面。
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    LogoutTask *task = [[LogoutTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

- (void)requestCheckToken
{
    CheckTokenPostObj *postData = [[CheckTokenPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *usertoken = [mySettingData objectForKey:@"token"];
    int useuid = [[mySettingData objectForKey:@"uid"]intValue];
    NSString* useruseruid = [NSString stringWithFormat:@"%d",useuid];
    if ([useruseruid isEqualToString:@"0"]) {
        return;
    }
    else{
        postData.uid = useruseruid;}
    if (![usertoken isEqualToString:@""]) {
        postData.token = usertoken;
    }
    else{
        return;}
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    CheckTokenTask *task = [[CheckTokenTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];
}

-(void)requestucrecord
{
    UrlucrecordUserStatusLogPostObj * postData =[[UrlucrecordUserStatusLogPostObj alloc]init];
    postData.uid =theuid;
    postData.token = thetoken;
    postData.clientInfo =@"[ios][理财VIP][1.0][]";
    //必填，客户端信息，以“[android]”或"[ios]"开头，每个字段用"[]"框起来接在后面，以后新增的字段信息直接加在最后，不修改之前数据的顺序，确定字段后哪怕该字段获取不到也需要加入一个空的“[]”占位，便于后期需要的时候做数据分析。
	/*Android：
     [android][理财VIP][1.0.12][]
     IOS：
     [ios][理财VIP][1.0][]*/
    postData.actionType =@"1";//1-登录，2-退出，3-休眠，4-恢复
//    self.name = [PhoneUtil getName];
//    self.mobile = [PhoneUtil getMobile];
//    self.uuid = [PhoneUtil getUuid];
//    self.deviceType = [PhoneUtil getDeviceType];
//    self.osVersion = [PhoneUtil getOSVersion];
    
    
//    self.height = [NSString stringWithFormat:@"%.0f", [PhoneUtil getScreenSize].height];
//    self.width = [NSString stringWithFormat:@"%.0f", [PhoneUtil getScreenSize].width];
//    self.horizontalpixels = [NSString stringWithFormat:@"%.0f", [PhoneUtil getScreenResolution].width];
//    self.verticalpixels = [NSString stringWithFormat:@"%.0f", [PhoneUtil getScreenResolution].height];
    postData.deviceInfo = [NSString stringWithFormat:@"[%@][%@][%@][%@][%@]",[PhoneUtil getName],[PhoneUtil getMobile],[PhoneUtil getUuid],[PhoneUtil getDeviceType],[PhoneUtil getOSVersion]];//客户端设备信息，格式与clientInfo格式相同，每个字段用"[]"框起来接在后面。
    
    NSArray *aryk = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    UrlucrecordUserStatusLogTask *task = [[UrlucrecordUserStatusLogTask alloc]initWithpostAryKey:aryk withAryValue:aryV withDelegate:self];
    [task run];

}

-(IBAction)loginAction:(id)sender
{
    
//    ChatViewController * chatVC = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
//    [self.navigationController pushViewController:chatVC animated:YES];
//    return;
    
    [usePhoneText resignFirstResponder];
    [passWordText resignFirstResponder];
    
    if (usePhoneText.text.length!=11) {
        [Utility alert:@"请填写11位手机号码"];
        return;
    }
//    if ([usePhoneText.text isEqual:@""]) {
//        [Utility alert:@"手机号码不能为空，请重新输入"];
//        return;
//    }
    if (passWordText.text.length==0) {
        [Utility alert:@"密码不能为空，请重新输入"];
        return;
    }
//    if ([passWordText.text isEqual:@""]) {
//        [Utility alert:@"密码不能为空，请重新输入"];
//        return;
//    }
   [self requestLogin];
//   [self presentViewController];
}

-(void) requstNetWork
{
    [[EMEChatConfManager sharedManager] registerCurrentUserChatId:^NSString *(NSString *key) {
        if ( ![[UserManager shareInstance] can_auto_login]) {
            NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
            NSString *strtheName = [mySettingData objectForKey:@"realName"];
            NSString *strtheuid = [mySettingData objectForKey:@"uid"];
            NSString *strthePicUrl =[mySettingData objectForKey:@"pictureurl"];
            [UserManager shareInstance].user.userId = strtheuid;
            [UserManager shareInstance].user.userName = strtheName;
            [UserManager shareInstance].user.userHeadURL =  strthePicUrl;
            
            //                        [UserManager shareInstance].user.userHeadURL =  [userpictureurl absoluteString];
        }
        return    [UserManager shareInstance].user.userId;
    }];
    //                [EMEChatConfManager registerChatServerHost:@"172.16.204.228" ChatServerPort:6666];
    [EMEChatConfManager registerChatServerHost:@"117.79.93.103" ChatServerPort:6666];
    
    [self checkNetWorkStatus];
    
}


-(BOOL)checkNetWorkStatus
{
    if (![NetWorkWatchDogManager  isConnectNetWork]) {
        [CommonUtils AlertWithMsg:@"网络连接失败，请检查你的网络。"];
        return NO;
    }else if (![[EMELPSocketManager shareInstance]  isSocketConnect]){
        [[EMELPSocketManager shareInstance]  reStartSocketConnect];//断开连接之后，系统会自动重新尝试连接
//        [self.view addHUDActivityViewWithHintsText:@"正在连接服务端..." hideAfterDelay:1.5];
        return NO;
    }else{
        return YES;
    }
}



-(void)presentViewController
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    menuController = [[leftMenuViewController alloc]init];
    HomePageplateFlag *contentController = [[HomePageplateFlag alloc]initWithNibName:@"HomePageplateFlag" bundle:nil];
    UIViewController *navController = [[UINavigationController alloc] initWithRootViewController:contentController];

    JDSideMenu *sideMenu = [[JDSideMenu alloc] initWithContentController:navController
                                                          menuController:menuController
                                                          rootController:contentController];
//    [sideMenu setBackgroundImage:[UIImage imageNamed:@"头像2.jpg"]];//junyi debug
    [self presentViewController:sideMenu animated:NO completion:nil];
    
//       //去掉列表的分割行（Line Separator）
//       [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//       //设置 UITableViewCell 与导航条间距
//        menuTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    
}

//获取应用委托
- (AppDelegate *)getAppDelegate
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate;
}

- (IBAction)hideKeyboardAction:(id)sender
{
    [usePhoneText resignFirstResponder];
    [passWordText resignFirstResponder];

}

-(IBAction)Register:(id)sender
{
    
    [self requestRegisterStyle];
    
    //    [self.view removeFromSuperview];
}

- (void)requestRegisterStyle
{
    catchBankRegistTypeTask *task = [[catchBankRegistTypeTask alloc] initWithPostDict:nil withDelegate:self];
    [task run];
}

-(IBAction)findBack:(id)sender
{
    FindPWViewController *findC = [[FindPWViewController alloc] initWithNibName:@"FindPWViewController" bundle:nil];
    [self presentViewController:findC animated:NO completion:nil];  //7.0用法
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Task Delegate
- (void)didTaskStarted:(Task *)aTask
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didTaskFinished:(Task *)aTask
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([aTask isKindOfClass:[UrlucrecordUserStatusLogTask class]]) {
        return;
    }
    
    if ([aTask isKindOfClass:[LogoutTask class] ]) {
        NSDictionary * logoutDict = aTask.responseDict;
        NSString *code = [logoutDict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]){
            [Utility alert:@"登出成功"];
            
        }
        else if([code isEqualToString:@"9999"]) {
            [Utility alert:@"登出失败"];
            return;
        }
        else if([code isEqualToString:@"9998"]) {
            [Utility alert:@"登陆信息验证失败"];
            return;
        }
        
    }
    
    if ([aTask isKindOfClass:[CheckTokenTask class] ]) {
        NSDictionary * checkTokenDict = aTask.responseDict;
        NSString *code = [checkTokenDict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]){
            [self requstNetWork];
            self.canModalVC = YES;
            //            [self requestLogout];
            
        }
        else if([code isEqualToString:@"9999"]) {
            [Utility alert:@"验证失败"];
            return;
        }
        else if([code isEqualToString:@"9998"]) {
            [Utility alert:@"已登出"];
            return;
        }
        else if([code isEqualToString:@"9013"]) {
            [Utility alert:@"用户未激活"];
            return;
        }
        else if([code isEqualToString:@"9001"]) {
            [Utility alert:@"用户不存在"];
            return;
        }
        else if([code isEqualToString:@"9020"]) {
            [Utility alert:@"用户已被冻结"];
            return;
        }
    }
    
    if ([aTask isKindOfClass:[LoginTask class] ]){
        NSDictionary * loginDict = aTask.responseDict;
        NSArray * array =[loginDict objectForKey:@"info"];
        NSDictionary *result = [array objectAtIndex:0];
        NSString *uid = [loginDict objectForKey:@"uid"];
        NSLog(@"uid=%@",uid);
        self.theuid = uid;
        NSString *userType = [result objectForKey:@"userType"];//userType  0为VIP，  1为理财顾问
        NSLog(@"userType=%@",userType);
        self.theuserType =userType;
        NSString * userConsultant = [result objectForKey:@"userConsultant"];
        NSLog(@"userConsultant=%@",userConsultant);
        userloginName = [result objectForKey:@"realName"];//realName
        userpictureurl = [result objectForKey:@"pictureurl"];
        NSString *strMobile = [result objectForKey:@"mobile"];
        
        NSString *code = [loginDict objectForKey:@"code"];
        NSString *token = [loginDict objectForKey:@"token"];
        self.thetoken = token;
        NSString *lastTime = [loginDict objectForKey:@"lastTime"];
        self.thelastTime = lastTime;
        //存
        [[NSUserDefaults standardUserDefaults] setObject:thetoken forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:theuid forKey:@"uid"];
        [[NSUserDefaults standardUserDefaults] setObject:theuserType forKey:@"userType"];
        [[NSUserDefaults standardUserDefaults] setObject:userloginName forKey:@"realName"];
        [[NSUserDefaults standardUserDefaults] setObject:userpictureurl forKey:@"pictureurl"];
        [[NSUserDefaults standardUserDefaults] setObject:strMobile forKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults] setObject:userConsultant forKey:@"userConsultant"];
        //             NSString *theConsultant = [result objectForKey:@"userConsultant"];
        
        if ([code isEqualToString:@"0000"]){
            [self requestucrecord];
            [self requstNetWork];
            self.canModalVC = YES;
            
        }
        else if([code isEqualToString:@"9001"]) {
            [Utility alert:@"用户不存在"];
            return;
        }
        else if([code isEqualToString:@"9999"]) {
            [Utility alert:@"登录失败"];
            return;
        }
        else if([code isEqualToString:@"9003"]) {
            [Utility alert:@"手机号码格式错误"];
            return;
        }
        else if([code isEqualToString:@"9006"]) {
            [Utility alert:@"密码错误"];
            return;
        }
        else if([code isEqualToString:@"9013"]) {
            [Utility alert:@"用户未激活"];
            return;
        }
        else if([code isEqualToString:@"9014"]) {
            [Utility alert:@"银行已关闭"];
            return;
        }
        else if([code isEqualToString:@"9020"]) {
            [Utility alert:@"用户已被冻结"];
            return;
        }
    }
    else if ([aTask isKindOfClass:[catchBankRegistTypeTask class] ])
    {
        NSDictionary * registerTyperDict = aTask.responseDict;
        NSArray *array  = [registerTyperDict objectForKey:@"info"];
        NSString *code = [registerTyperDict objectForKey:@"code"];
        if ([code isEqualToString:@"0000"]){
            catchType = [array objectAtIndex:0];
            if ([catchType isEqualToString:@"1"]) {
                NSLog(@"主动注册");
                NSLog(@"catchType=%@",catchType);
                [[NSUserDefaults standardUserDefaults] setObject:catchType forKey:@"catchType"];
            }
            else if([catchType isEqualToString:@"2"]) {
                NSLog(@"邀请注册");
            }
            else if([catchType isEqualToString:@"3"]) {
                NSLog(@"关闭注册");
            }
            RegisterViewController * RegistVC =[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
            RegistVC.theCatchType = catchType;
            [self presentViewController:RegistVC animated:NO completion:nil];  //7.0用法
        }
        else if([code isEqualToString:@"9999"]){
            [Utility alert:@"银行已关闭"];
            return;
        }
    }
    
    if (self.canModalVC) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self performSelector:@selector(presentViewController) withObject:nil afterDelay:2];
    }
}



//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 120 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
