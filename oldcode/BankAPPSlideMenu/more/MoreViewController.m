//
//  MoreViewController.m
//  BankAPP
//
//  Created by LiuXueQun on 14-3-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "MoreViewController.h"
#import "ChangePassWordVController.h"
#import "ChangeMobileNumVController.h"
#import "UserGuideViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJson.h"
#import "MoreInfoViewController.h"
#import "DataBaseCenter.h"
#import "Content.h"
@interface MoreViewController ()
{
    NSArray *aryList;
    BOOL _isPreHidden;
}
@end

@implementation MoreViewController
@synthesize imagePickerController = _imagePickerController;
@synthesize grayView = _grayView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customNavigationTitle];
        [self customNavLeftButton];
        aryList = [[NSArray alloc]initWithObjects:@"特权身份   白金卡",@"清除缓存",@"密码修改",@"欢迎信息",@"更多信息",@"当前版本 1.0", nil];
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
    titleLabel.text = @"更 多";
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
    else{
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
    //头像替换完成之后，恢复
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIWindow *window = appDelegate.window;
        window.clipsToBounds = YES;
        window.frame = CGRectMake(0, 20, window.frame.size.width, window.frame.size.height);
        window.bounds = CGRectMake(0, 20, window.frame.size.width, window.frame.size.height);
    }
}

-(void)viewWillDisappear:(BOOL)animated
{    
    [DockView sharedDockView].hidden = _isPreHidden;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isPreHidden = [DockView sharedDockView].hidden;
    if ([DockView sharedDockView].hidden == NO) {
        [DockView sharedDockView].hidden = YES;
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (IS_IPHONE5) {
        self.scrollview.frame = CGRectMake(0, -20, self.view.frame.size.width, 568-64-56);
    }
    self.scrollview.contentSize = CGSizeMake(320, 440);
    self.scrollview.alwaysBounceVertical = YES;
    self.scrollview.scrollEnabled = YES;
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString * struserName = [mySettingData objectForKey:@"realName"];
    NSString * struserpictureurl = [mySettingData objectForKey:@"pictureurl"];
    NSString * strMobile = [mySettingData objectForKey:@"mobile"];
    
    self.lblMobile.text = strMobile;
    self.lblName.text = struserName;
    [self.imagePerson setImageWithURL:[NSURL URLWithString:struserpictureurl] placeholderImage:[UIImage imageNamed:@"1305774588258"]];
    
    
//    self.tabView.layer.borderWidth = 1;
//    self.tabView.layer.borderColor = [UIColor grayColor].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    [self.clearView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapPerson = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked2:)];
    self.imagePerson.userInteractionEnabled = YES;
    [self.imagePerson addGestureRecognizer:tapPerson];
    
    // 图片选择器
	_imagePickerController = [[UIImagePickerController alloc]init];
	_imagePickerController.allowsEditing = YES; // 使被选择的图片可以执行缩放，移动等编辑操作
	_imagePickerController.delegate = self;
    /*
     *下边这个是用来给相册添加图片
     *
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
     btn.frame = CGRectMake(50, 350, 40, 40);
     [btn addTarget:self action:@selector(aaa:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:btn];
     
     self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 390, 60, 60)];
     [self.imageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_collection_pressed" ofType:@"png"]]];
     [self.view addSubview:self.imageView];
     */

}

#pragma mark - Network
- (void)requestList {
    UploadAndChangeUserPhotoPostObj *postData = [[UploadAndChangeUserPhotoPostObj alloc] init];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];
    
    
    postData.photo = UIImagePNGRepresentation(self.imagePerson.image);
    postData.uid = struid;
    postData.token = strtoken;
    
    NSArray *aryK = [postData aryKey];
    NSArray *aryV = [postData aryValue];
    UploadAndChangeUserPhotoTask *task = [[UploadAndChangeUserPhotoTask alloc]initWithpostAryKey:aryK withAryValue:aryV withDelegate:self];
    [task run];
}

#pragma mark - task delegate
- (void)didTaskStarted:(Task *)aTask {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}



- (void)didTaskFinished:(Task *)aTask {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSDictionary *dict = aTask.responseDict;
    NSString *code = [dict objectForKey:@"code"];
    if ([code isEqualToString:@"0000"]) {
        [Utility alert:@"用户图像修改成功"];
    }else if ([code isEqualToString:@"9999"]){
        [Utility alert:@"用户图像修改失败"];
    }else if ([code isEqualToString:@"9998"]){
        [Utility alert:@"登录信息验证失败"];
    }else if ([code isEqualToString:@"5001"]){
        [Utility alert:@"没有文件对象"];
    }else if ([code isEqualToString:@"5002"]){
        [Utility alert:@"文件格式错误"];
    }else if ([code isEqualToString:@"5003"]){
        [Utility alert:@"文件大小超限"];
    }else if ([code isEqualToString:@"5005"]){
        [Utility alert:@"文件上传失败"];
    }
}

#pragma mark - tap people detail info
- (void)tapClicked:(UITapGestureRecognizer *)sender
{
    NSLog(@"tap");
    ChangeMobileNumVController *changeMNVC = [[ChangeMobileNumVController alloc]initWithNibName:@"ChangeMobileNumVController" bundle:nil];
    [self.navigationController pushViewController:changeMNVC animated:YES];
}

- (void)tapClicked2:(UITapGestureRecognizer *)sender
{
    NSLog(@"person");
    //修改头像
//    [self showActionsheet];
    [self showClearview];
}

- (void)showClearview
{
    self.grayView = [[UIView alloc]init];
    self.grayView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.grayView.backgroundColor = [UIColor colorWithRed:25 green:25 blue:25 alpha:0.3];
    [self.view addSubview:self.grayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked3:)];
    [self.grayView addGestureRecognizer:tap];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(40, self.view.frame.size.height-200+40, 240, 40);
    btn1.tag = 20001;
    [btn1 setTitle:@"选择本地图片" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"文本域"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClearViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.grayView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(40, self.view.frame.size.height-200+50+40, 240, 40);
    btn2.tag = 20002;
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"文本域"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClearViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.grayView addSubview:btn2];
}


- (void)btnClearViewClicked:(id)sender
{
    UIButton *btn = (id)sender;
    if (btn.tag == 20001) {
        [self.grayView removeFromSuperview];
        [self pickImageAction];
    }
    else if (btn.tag == 20002){
        [self.grayView removeFromSuperview];
    }
}

- (void)tapClicked3:(UITapGestureRecognizer *)sender
{
    [self.grayView removeFromSuperview];
}

//- (void)showActionsheet
//{
//    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择本地图片", nil];
//    [actionsheet showInView:self.view];
//}


#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stringCell = @"identifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringCell];
    }
    cell.textLabel.text = [aryList objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
    }
    else if (indexPath.row == 3){
    }
    else if (indexPath.row == 4){
    }
}

//#pragma mark - action sheet delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        NSLog(@"拍照");
//    }
//    else if (buttonIndex == 1)
//    {
//        NSLog(@"读取相册");
//        [self pickImageAction];
//    }
//}


//从相册选择图片
- (void)pickImageAction
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:NO completion:nil];
    }
    else
    {
        NSLog(@"设备不支持相册");
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; // 原始图片
	if(_imagePickerController.allowsEditing == YES){
		image = [info objectForKey:@"UIImagePickerControllerEditedImage"]; // 编辑（缩放，移动）后的图片
	}
    //保存图片到本地，方法见下文
    [self saveimage:image withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc]initWithContentsOfFile:fullPath];
    self.imagePerson.image = savedImage;
    [self dismissViewControllerAnimated:NO completion:nil];
    [self uploadPicture];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片到本地
- (void)saveimage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:imageName];
    
    NSLog(@"fullPath:%@",fullPath);
    //将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)uploadPicture
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *strtoken = [mySettingData objectForKey:@"token"];
    NSString *struid = [mySettingData objectForKey:@"uid"];

    
    ASIFormDataRequest *requestR = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://117.79.93.103/data/ds/file/uploadAndChangeUserPhoto?uid=%@&token=%@",struid,strtoken]]];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSData *data = UIImagePNGRepresentation(image);
    NSMutableData *imageData = [[NSMutableData alloc] initWithData:data];
    
    [requestR setDelegate:self];
    [requestR addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestR addRequestHeader:@"Content-Type" value:@"text/javascript"];
    [requestR addRequestHeader:@"Content-Type" value:@"text/plain"];
    [requestR addRequestHeader:@"Content-Type" value:@"text/json"];
    [requestR addRequestHeader:@"Content-Type" value:@"binary/octet-stream"];
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";//分界线的标识符
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];//分界线 --AaB03x
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];//结束符 AaB03x--
    NSMutableString *body=[[NSMutableString alloc]init];//http body的字符串
    if (data) {
        [body appendFormat:@"%@\r\n",MPboundary];//添加分界线，换行
        [body appendFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"currentImage.png\"\r\n"];
        [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    }
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];//声明结束符：--AaB03x--
    NSMutableData *myRequestData=[NSMutableData data];//声明myRequestData，用来放入http body
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];//将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:imageData];//将image的data加入
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];//加入结束符--AaB03x--
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];//设置Content-Type的值
    [requestR addRequestHeader:@"Content-Type" value:content];
    [requestR addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
    [requestR appendPostData:myRequestData];
    [requestR setDidFinishSelector:@selector(requestDidSuccess:)];
    [requestR setDidFailSelector:@selector(requestDidFailed:)];
    [requestR startAsynchronous];
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    [self.grayView removeFromSuperview];
}
- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    NSDictionary *dict = [request.responseString JSONValue];
    NSString *code = [dict objectForKey:@"code"];
    if ([code isEqualToString:@"0000"]) {
        [Utility alert:@"用户图像修改成功"];
    }else if ([code isEqualToString:@"9999"]){
        [Utility alert:@"用户图像修改失败"];
    }else if ([code isEqualToString:@"9998"]){
        [Utility alert:@"登录信息验证失败"];
    }else if ([code isEqualToString:@"5001"]){
        [Utility alert:@"没有文件对象"];
    }else if ([code isEqualToString:@"5002"]){
        [Utility alert:@"文件格式错误"];
    }else if ([code isEqualToString:@"5003"]){
        [Utility alert:@"文件大小超限"];
    }else if ([code isEqualToString:@"5005"]){
        [Utility alert:@"文件上传失败"];
    }
}

/*
 *为相册添加图片的方法
 *
 - (void)aaa:(id)sender
 {
 UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
 }
 // UIImagePickerController 声明文件中最下方的注释部分
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
 NSString *msg = @"保存成功";
 if(error != nil){
 msg = @"保存失败";
 }
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
 [alertView show];
 }
 */

//- (void)uploadImages
//{
//    NSData *data = UIImagePNGRepresentation(self.imagePerson.image)
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    
    //清除token uid
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    [mySettingData removeObjectForKey:@"token"];
    [mySettingData removeObjectForKey:@"uid"];
    [mySettingData synchronize];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//    [delegate exitApp];
    [delegate exitApp1];
}

- (IBAction)buttonClicked:(id)sender {
    UIButton *btn = (id)sender;
    if (btn.tag == 201) {
        
    }else if (btn.tag == 202){
    
    }else if (btn.tag == 203){
        ChangePassWordVController *changeVC = [[ChangePassWordVController alloc]initWithNibName:@"ChangePassWordVController" bundle:nil];
        [self.navigationController pushViewController:changeVC animated:YES];
    }else if (btn.tag == 204){
        UserGuideViewController *userVC = [[UserGuideViewController alloc]init];
        userVC.stringDif = @"10002";
        [self presentViewController:userVC animated:NO completion:nil];
    }else if (btn.tag == 205){
        MoreInfoViewController *moreInfovc = [[MoreInfoViewController alloc]initWithNibName:@"MoreInfoViewController" bundle:nil];
        [self.navigationController pushViewController:moreInfovc animated:YES];
    }else if (btn.tag == 206){
    
    }
}
@end
