//
//  LDNewMineVCFooter.m
//  OCLDProject
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNewMineVCFooter.h"
#import "LDMineButton.h"
#import "WHOrderListController.h"
#import "LDFirstViewController.h"
#import "LDtest2222ViewController.h"
#import "LDNavgationVController.h"
#import "LDSignInViewController.h"
#import "HDMineMoreController.h"
//#import <UIButton+WebCache.h>
//#import "LDMineViewController.h"
#define PaddingX 0.5
#define ChangeH  LDScreenHeight * 94.25/667

@implementation LDNewMineVCFooter
-(NSArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray = @[@"订单",@"望望白条",@"银行卡",@"更多",@"",@""];
    }
    return _dataArray;
}
-(NSArray *)imageDataArray{
    
    if (!_imageDataArray) {
        
        _imageDataArray = @[
                            @"1",@"2",@"3",@"4",
                            ];
    }
    return _dataArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
       
        // 方块个数
        NSUInteger count = 6;
        
        // 方块的尺寸
        NSUInteger maxColsCount = 3; // 一行的最大列数
        
        CGFloat buttonW = (LDScreenWidth - 1) / maxColsCount;
        
        CGFloat buttonH = ChangeH;
        
        // 创建所有的方块
        for (NSUInteger i = 0; i < count; i++) {
            // 创建按钮
            LDMineButton *button = [LDMineButton buttonWithType:UIButtonTypeCustom];
            
            [self addSubview:button];
            
            // 设置frame(余数123)
            button.LDX = (i % maxColsCount) * (buttonW + PaddingX);
            
            //除数(0)
            
            button.LDY = (i / maxColsCount) * (buttonH + PaddingX) + PaddingX;

            button.LDWidth = buttonW;
            
            button.LDHeight = ChangeH;
            
            [button setTitle:self.dataArray[i] forState:UIControlStateNormal];

            if (i == 0) {
                
                [button setImage:[UIImage imageNamed:@"Slice Copy"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (i == 1) {
                
                [button setImage:[UIImage imageNamed:@"Slice Copy 2"] forState:UIControlStateNormal];
                [button setTag:i];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (i == 2) {
                
                [button setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
                                [button setTag:i];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (i == 3) {
                
                [button setImage:[UIImage imageNamed:@"Slice Copy 3"] forState:UIControlStateNormal];
                    [button setTag:i];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            self.backgroundColor = LDRGBColor(217, 217, 217, 1);

        }
        
        // 设置footer的高度 == 最后一个按钮的bottom(最大Y值)
        self.LDHeight = self.subviews.lastObject.LDBottom + 0.5;
        
        // 设置tableView的contentSize
        UITableView *tableView = (UITableView *)self.superview;
        tableView.tableFooterView = self;
        [tableView reloadData]; // 重新刷新数据(会重新计算contentSize)
        

    }
    return self;
}

- (void)buttonClick:(LDMineButton *)button
{
    
    UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
    //取出当前导航控制器
    UINavigationController *nav = tabBarVc.selectedViewController;
    
    /** 分期界面 */
    if (button.tag == 1) {
        [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:FQSY];
                
        [MBProgressHUD showError:@"此功能暂未开通"];
        
    }
    else{
        if ([LDUserInformation sharedInstance].UserId==nil || [LDUserInformation sharedInstance].token == nil){
            
            LDSignInViewController * signIn = [[LDSignInViewController alloc]init];
            signIn.fromWhere = @"wode";
            LDNavgationVController * nextNav = [[LDNavgationVController alloc]initWithRootViewController:signIn];
            [nav presentViewController:nextNav animated:YES completion:nil];
            
        }else{
            
            /** 订单列表  */
            if (button.tag == 0) {
                
                //统计买点
                [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:DDWD];
                
                LDLog(@"%ld",(long)button.tag);
                WHOrderListController * vc = [[WHOrderListController alloc] init];
                
                [nav pushViewController:vc animated:YES];
                
                
            }else if (button.tag == 2){
                
                //统计买点
                [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:YHKWD];
                
                LDtest2222ViewController * vc = [[LDtest2222ViewController alloc] init];
                
                vc.indexFlag = 41;
                [nav pushViewController:vc animated:YES];
                
                
                /** 更多  */
            }else if (button.tag == 3){
                
                HDMineMoreController * vc = [[HDMineMoreController alloc] init];
                
                [nav pushViewController:vc animated:YES];
                
                
                
                
            }else{
                LDLog(@"else");
                
            }
        }
    
    
    }

    LDLogFunc;
}

@end
