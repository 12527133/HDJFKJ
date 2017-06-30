//
//  LDBaseTableViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBaseTableViewController.h"
#import "BaiduMobStat.h"
@interface LDBaseTableViewController ()<UIGestureRecognizerDelegate>


/** DataArray */
@property (nonatomic,strong) NSArray * dataArray;


@end

@implementation LDBaseTableViewController


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
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
    
    
    //自定义NavgationController,和返回返回按钮后，侧滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
   
}


/** 错误提示 */
- (void)showFailViewWithString:(NSString *)error{
    
    [MBProgressHUD showError:error];
}

/** 加载提示 */
- (void)showWithImageWithString:(NSString *)message{
    [MBProgressHUD showMessage:message];
}

/** 成功提示 */
- (void)showSuccessViewWithString:(NSString *)success{
    [MBProgressHUD showSuccess:success];
}
/** 取消加载 */
- (void)dismissHDLoading{
    [MBProgressHUD hideHUD];
}


//加载jif动画
- (void)showJifWithString:(NSString *)string toView:(UIView *)view{


    [HDLoading showJifWithString:string toView:view];
}

/** 移除加载 */
- (void)hiddenLodJifToView:(UIView *)view{
    
    [HDLoading hiddenLodJifToView:view];
}

@end
