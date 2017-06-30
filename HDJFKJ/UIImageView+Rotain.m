//
//  UIImageView+Rotain.m
//  diancaibao
//
//  Created by jujutec on 15/11/23.
//  Copyright © 2015年 jujutec. All rights reserved.
//

#import "UIImageView+Rotain.h"

@implementation UIImageView (Rotain)
- (void)rotate:(NSTimeInterval)duration
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_2_PI * 2);
    rotationAnimation.duration = 2;
    rotationAnimation.repeatCount = duration;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:rotationAnimation forKey:@"UIViewRotation"];
}

//停止旋转动画
- (void)stopRotation
{
    [self.layer removeAnimationForKey:@"UIViewRotation"];
}
@end
