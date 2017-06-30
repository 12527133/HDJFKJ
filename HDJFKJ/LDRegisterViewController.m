//
//  LDRegisterViewController.m
//  HDJFKJ
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDRegisterViewController.h"
#import "LDTabBarController.h"
#import "LDZhuCeViewController.h"
#import "LDSignInViewController.h"
#import "LDPaymentPasswordController.h"
#import "LDNavgationVController.h"
typedef void (^LDSettingItemModelOption)();

@interface LDRegisterViewController ()
@property(nonatomic,copy) LDSettingItemModelOption option;

@end

@implementation LDRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    LDLog(@"%@",[NSString string]);
    

}
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;

}
- (IBAction)JumpButtonClick:(id)sender {
    
    LDTabBarController * tabBar = [[LDTabBarController alloc] init];
  //  LDPaymentPasswordController * tabBar = [[LDPaymentPasswordController alloc]init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
}
- (IBAction)loginButtonClick:(id)sender {
    
    LDSignInViewController * signinVC = [[LDSignInViewController alloc] init];
    
    LDNavgationVController * navVC = [[LDNavgationVController alloc]initWithRootViewController:signinVC];
   // [self.navigationController pushViewController:signinVC animated:YES];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (IBAction)registerButtonClick:(id)sender {
    
    LDZhuCeViewController * zhuceVC = [[LDZhuCeViewController alloc] init];
    
    [self.navigationController pushViewController:zhuceVC animated:YES];

   }

- (void)dealloc{
    LDLogFunc;
}

@end
