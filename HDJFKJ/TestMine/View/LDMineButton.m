//
//  LDMineButton.m
//  OCLDProject
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDMineButton.h"
//#import <UIButton+WebCache.h>
//#define top  25/667
//#define left  49/375
//#define width  23/375
//#define height  25/667
//#define Y  63/667
#define ChangeH  LDScreenHeight * 94.25/667
//CGFloat buttonW = 320 27

//CGFloat buttonH = ChangeH;

//( LDScreenWidth * 27 )320
@implementation LDMineButton

- (instancetype)initWithFrame:(CGRect)frame
{

    LDLog(@"%f",LDScreenWidth);
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:LDRGBColor(50, 50, 50, 1) forState:UIControlStateNormal];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.LDY = self.LDHeight * 0.2652;
    self.imageView.LDHeight = ( LDScreenWidth * 27 )/320;
    self.imageView.LDWidth = ( LDScreenWidth * 27 )/320;
    self.imageView.LDCenterX = self.LDWidth * 0.5;
    self.titleLabel.LDX = 0;
    
    self.titleLabel.LDY = self.LDHeight * 0.73;
    self.titleLabel.LDWidth = self.LDWidth;
    self.titleLabel.LDHeight = self.LDHeight * 18 /94.25;

}

@end
