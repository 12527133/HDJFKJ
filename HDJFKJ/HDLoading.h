

#import <UIKit/UIKit.h>

@interface HDLoading : UIView


+ (void)showWithImageWithString:(NSString *)string;
+ (void)showFailViewWithString:(NSString *)string;
+ (void)showSuccessViewWithString:(NSString *)string;
+ (void)dismissHDLoading;

//加载jif动画
+ (void)showJifWithString:(NSString *)string toView:(UIView *)view;

/** 移除加载 */
+ (void)hiddenLodJifToView:(UIView *)view;
@end
