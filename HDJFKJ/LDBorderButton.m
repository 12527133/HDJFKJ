//
//  LDBorderButton.m
//  HDJFKJ
//
//  Created by apple on 16/4/4.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBorderButton.h"

@implementation LDBorderButton

- (instancetype)init{

    LDLogFunc;
    return 0;
}
+ (instancetype)LDQuickButtonWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置边款宽度
    button.layer.borderWidth = 1.5;
    //设置圆角
    button.layer.cornerRadius = 4.5;
    //设置颜色RGB,用于生成ColorRef
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    // 设置边框颜色
    button.layer.borderColor = borderColorRef;
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

//    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    
//    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
//    
//    button.size = button.currentBackgroundImage.size;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return (LDBorderButton *)button;
}

@end
