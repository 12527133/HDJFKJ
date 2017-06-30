//
//  LDApplyForCreditViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDApplyForCreditViewController.h"
#import "LDTabBarController.h"
#import "LDTabBarController.h"
#import "LDTabBarController.h"
#import "LDTabBarController.h"
#import "LDTabBarController.h"
#import "LDTabBarController.h"
#import "LDForthViewController.h"
#import "LDtest2222ViewController.h"

@interface LDApplyForCreditViewController ()

@end

@implementation LDApplyForCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationItem.title =@"申请授信";

    self.navigationController.navigationBarHidden = NO;
}



- (IBAction)commitCreditButtonClick:(id)sender {
    
    BOOL isShouXin = YES;
    
    if (isShouXin) {
        
        [self whichControllerToBack];
        
    }else{
    
        [MBProgressHUD showError:@"请授信"];
    }
    

}

//返回哪个控制器
- (void)whichControllerToBack{
    
    
    if ([self.fromeWhere isEqualToString:@"wode"]) {
        
        LDLog(@"返回到我的界面");
        
        for (UIViewController * vc in self.navigationController.viewControllers) {
            
            NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
            
            if ([vcClass isEqualToString:@"LDForthViewController"]) {
                //如果是确认订单控制器,就pop到该控制器
                [self.navigationController popToViewController:vc animated:NO];
                
            }
            
        }
        
    }else if ([self.fromeWhere isEqualToString:@"zhuce"]){
        
        //返回到首页,可能需要发送登录请求
        LDLog(@"返回到首页,可能需要发送登录请求");
        LDTabBarController * tabbar = [[LDTabBarController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
        
        
    }else if ([self.fromeWhere isEqualToString:@"xianjindai"]) {
        
        LDLog(@"返回到现金贷");
        
//        for (UIViewController * vc in self.navigationController.viewControllers) {
//            
//            NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
//            
//            if ([vcClass isEqualToString:@"LDForthViewController"]) {
//                
//                [self.navigationController popToViewController:vc animated:NO];
//                
//            }
//            
//        }
        
    }else{//下单
        
        LDLog(@"返回到下单(银行卡)或是push到银行卡.");
        LDtest2222ViewController * vc = [[LDtest2222ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
