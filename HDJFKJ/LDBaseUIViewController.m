//
//  LDBaseUIViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBaseUIViewController.h"
#import "BaiduMobStat.h"
@interface LDBaseUIViewController()<UIGestureRecognizerDelegate>

@end
@implementation LDBaseUIViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* cName = [NSString stringWithFormat:@"%@",  self.class, nil];
    
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSString* cName = [NSString stringWithFormat:@"%@",  self.class, nil];

    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.gifFirst = NO;
    

    //自定义NavgationController,和返回返回按钮后，侧滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    

    
}


/** 错误提示 */
- (void)showFailViewWithString:(NSString *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:error afterDelay:2.0];
    });
    
    
}

/** 加载提示 */
- (void)showWithImageWithString:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:message];
    });
    
}

/** 成功提示 */
- (void)showSuccessViewWithString:(NSString *)success{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:success];
    });
    
}
/** 取消加载 */
- (void)dismissHDLoading{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    
    
}

//加载jif动画
- (void)showJifWithString:(NSString *)string toView:(UIView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if (!self.gifFirst) {
            
            self.gifFirst = YES;
            
            [HDLoading showJifWithString:string toView:view];
        }
        else{
            [MBProgressHUD showMessage:string];
        }
    });
    
    
    
    
}

/** 移除加载 */
- (void)hiddenLodJifToView:(UIView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.gifFirst) {
            [HDLoading hiddenLodJifToView:view];
        }
        else{
            [MBProgressHUD hideHUD];
        }
    });
    
    
    
}
@end
