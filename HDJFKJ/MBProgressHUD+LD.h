
#import "MBProgressHUD.h"

@interface MBProgressHUD (LD)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay;
+ (void)showError:(NSString *)error afterDelay:(NSTimeInterval)delay;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
