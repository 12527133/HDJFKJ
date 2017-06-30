//
//  LDBorderButton.h
//  HDJFKJ
//
//  Created by apple on 16/4/4.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDBorderButton : UIButton
+ (instancetype)LDQuickButtonWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
