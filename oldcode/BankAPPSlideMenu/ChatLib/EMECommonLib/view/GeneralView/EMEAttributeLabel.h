//
//  EMEAttributeLabel.h
//  EMEAPP
//
//  Created by YXW on 13-11-22.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMEAttributeLabel : UILabel{
    NSMutableAttributedString *resultAttributedString;
}

-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor;
-(void)setText:(NSString *)text WithFont:(UIFont *)font AndColor:(UIColor *)color;
@end
