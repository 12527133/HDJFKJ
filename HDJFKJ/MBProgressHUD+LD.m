

#import "MBProgressHUD+LD.h"

@implementation MBProgressHUD (LD)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    [MBProgressHUD hideHUD];
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5];
}
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    [MBProgressHUD hideHUD];
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 秒之后再消失
    if (delay == 0.0){
        delay = 1.5;
    }
    
    [hud hide:YES afterDelay:delay];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    [self show:error icon:@"error.png" view:view afterDelay:(NSTimeInterval)delay];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}
+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    [self show:success icon:@"success.png" view:view afterDelay:delay];
}
+ (void)showError:(NSString *)error toView:(UIView *)view{

    [self show:error icon:@"success.png" view:view];
}
#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success 
{
    [self showSuccess:success toView:nil];
}

+ (void)showSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay
{
    [self showSuccess:success toView:nil afterDelay:delay];
}
+ (void)showError:(NSString *)error afterDelay:(NSTimeInterval)delay
{
    [self showError:error toView:nil afterDelay:(NSTimeInterval)delay];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
