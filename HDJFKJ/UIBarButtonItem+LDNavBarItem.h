//
//  UIBarButtonItem+LDNavBarItem.h
//  HDJFKJ
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LDNavBarItem)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target title:(NSString *)title action:(SEL)action;

@end
