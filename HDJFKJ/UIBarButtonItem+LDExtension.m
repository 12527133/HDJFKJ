//
//  UIBarButtonItem+LDExtension.m
//  HDJFKJ
//
//  Created by apple on 16/4/4.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "UIBarButtonItem+LDExtension.h"

@implementation UIBarButtonItem (LDExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15*bili];
    button.size = CGSizeMake(50, 40 );
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

@end
