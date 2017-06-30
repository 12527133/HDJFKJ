//
//  UIImageView+Rotain.h
//  diancaibao
//
//  Created by jujutec on 15/11/23.
//  Copyright © 2015年 jujutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Rotain)
//让当前视图顺时针不断旋转
- (void)rotate:(NSTimeInterval)duration;
//停止旋转动画
- (void)stopRotation;
@end
