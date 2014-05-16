//
//  App.h
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "JDSideMenu.h"

@interface App : NSObject

@property (readonly, nonatomic) Config *cfg;
@property (strong, nonatomic) JDSideMenu *jwviewManager;
//@property (readonly, nonatomic) CoreData *coreData;
//@property (readonly, nonatomic) ArticleData *articleData;
//@property (readonly, nonatomic) PictureData *pictureData;
//@property (readonly, nonatomic) VoteData *voteData;
//@property (readonly, nonatomic) ContactData *contactData;


+ (App *) sharedInstance;

+(Boolean) isEmptyOrNull:(NSString *) str ;

@end
