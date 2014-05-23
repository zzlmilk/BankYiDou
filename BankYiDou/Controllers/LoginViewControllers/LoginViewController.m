//
//  LoginViewController.m
//  BankYiDou
//
//  Created by zzlmilk on 14-5-14.
//  Copyright (c) 2014年 zzlmilk. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import <CommonCrypto/CommonHMAC.h> //MD5加密



@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *password = @"rex123";
    password = [self getMd5_32Bit_String:password];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"15901794453" forKey:@"mobile"];
    [dic setObject:password forKey:@"password"];
    
    
    [User userPostsParameters:dic WithBlock:^(User *user, NSError *error) {
        NSLog(@"%@",[user displayName]);
        NSLog(@"%@",[user token]);
    }];

}

-(IBAction)loginButton_TouchUpInside:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
