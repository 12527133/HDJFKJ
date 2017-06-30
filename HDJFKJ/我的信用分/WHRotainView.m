

#import "WHRotainView.h"
#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>

@implementation WHRotainView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHRotainView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
- (void)imageRotain{
    [UIView animateWithDuration:10 animations:^{
        //设置要被动画的那个视图
        //在动画结束时，它的属性处于什么状态
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(M_PI * 2);
        rotationAnimation.duration = 0.7;
        //rotationAnimation.repeatCount = 2;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [self.bangbangtang.layer addAnimation:rotationAnimation forKey:nil];
    }];

}
- (void)imageRotain2{
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:self.bangbangtang.layer.transform];
//    // 设置围绕x轴旋转π后的transform值
//    rotationAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.bangbangtang.layer.transform, M_PI * 3, 0, 0, 1.0)];
//    rotationAnimation.duration = 3.0;
//    rotationAnimation.removedOnCompletion = NO;
//    [self.bangbangtang.layer addAnimation:rotationAnimation forKey:nil];
    
    [UIView animateWithDuration:35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(M_PI * 10);
        
        
        rotationAnimation.removedOnCompletion = NO;
        //rotationAnimation.fillMode = kCAFillModeForwards;
        
        
        [self.bangbangtang.layer addAnimation:rotationAnimation forKey:nil];
    } completion:^(BOOL finished) {
    
    }];
}
@end
