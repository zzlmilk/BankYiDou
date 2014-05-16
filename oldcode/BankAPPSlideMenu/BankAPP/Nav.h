//
//  Nav.h
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Nav : NSObject

@property (strong, nonatomic) NSString *navId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *resourceType;
@property (strong, nonatomic) NSString *listType;
@property (strong, nonatomic) NSString *detailType;
@property (strong, nonatomic) NSArray *subNavs;
@property (strong, nonatomic) NSString *hasAD;

-(id)initWithId:(NSString *)theId
           name:(NSString *)theName
    displayName:(NSString *)theDisplayName
      imageName:(NSString *)theImage
           desc:(NSString *)theDesc
   resourceType:(NSString *)resType
       listType:(NSString *)theListType
          hasAD:(NSString *)theHasAD
     detailType:(NSString *)theDetailType;
@end
