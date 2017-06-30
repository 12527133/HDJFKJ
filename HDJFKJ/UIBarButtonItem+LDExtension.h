//
//  UIBarButtonItem+LDExtension.h
//  HDJFKJ
//
//  Created by apple on 16/4/4.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LDExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
