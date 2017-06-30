//
//  UIBarButtonItem+LDNavBarItem.m
//  HDJFKJ
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "UIBarButtonItem+LDNavBarItem.h"
@implementation UIBarButtonItem (LDNavBarItem)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target title:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.text = @"返回";
    [button setTintColor:[UIColor blackColor]];
    
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    button.size = button.currentBackgroundImage.size;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}


@end
