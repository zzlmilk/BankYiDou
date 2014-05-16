//
//  Nav.m
//  BankAPP
//
//  Created by kevin on 14-2-20.
//  Copyright (c) 2014年 junyi.zhu. All rights reserved.
//

#import "Nav.h"

@implementation Nav

-(id)initWithId:(NSString *)theId
           name:(NSString *)theName
    displayName:(NSString *)theDisplayName
      imageName:(NSString *)theImage
           desc:(NSString *)theDesc
   resourceType:(NSString *)resType
       listType:(NSString *)theListType
          hasAD:(NSString *)theHasAD
     detailType:(NSString *)theDetailType

{
    if (self = [super init]) {
        self.navId = theId;
        self.name = theName;
        self.displayName = theDisplayName;
        self.imageName = theImage;
        self.desc = theDesc;
        self.resourceType = resType;
        self.listType = theListType;
        self.hasAD = theHasAD;
        self.detailType = theDetailType;
        
    }
    return self;
}

@end
