//
//  MoreViewController.h
//  BankAPP
//
//  Created by LiuXueQun on 14-3-26.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadAndChangeUserPhotoPostObj.h"
#import "UploadAndChangeUserPhotoTask.h"
//图片选择器实现2个delegate（UINavigationBarDelegate,UIImagePickerControllerDelegate）
@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL JDSideOpenOrNot;
}
@property (nonatomic, retain) UIImagePickerController *imagePickerController;


@property (strong, nonatomic) IBOutlet UIImageView *imagePerson;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile;
@property (strong, nonatomic) IBOutlet UITableView *tabView;
@property (strong, nonatomic) IBOutlet UIView *clearView;
@property (nonatomic, strong) UIImageView *imageView;//
@property (nonatomic, strong) UIView *grayView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
- (IBAction)btnClicked:(id)sender;
- (IBAction)buttonClicked:(id)sender;
@end
