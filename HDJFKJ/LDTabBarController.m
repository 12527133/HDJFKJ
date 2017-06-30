//
//  LDTabBarController.m
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDTabBarController.h"
#import "WHNewFirstController.h"

#import "LDThirdViewController.h"
#import "LDForthViewController.h"
#import "LDTabBarView.h"

#import "LDNavgationVController.h"
#import "QRViewController.h"
#import "LDNewOrderDetailVC.h"
#import "LDFirstViewController.h"
#import "LDNewViewController.h"
#import "LDNewMineVC.h"
@interface LDTabBarController ()<UITabBarDelegate>
@property (nonatomic,weak) UIButton * publishButton;
@end

@implementation LDTabBarController


+ (void)initialize
{
    
    
    
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fenfujunTabbar];
    
    [self controlStateSelected];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    

}

//分付君tabbar
- (void)fenfujunTabbar{
    // 添加子控制器
    [self setupChildVc:[[WHNewFirstController alloc] init] title:@"首页" image:@"shouye_2.0.4_default" selectedImage:@"shouye_2.0.4"];
    
    [self setupChildVc:[[LDThirdViewController alloc] init] title:@"账单" image:@"zhangdan_2.0.4_default" selectedImage:@"zhangdan_2.0.4"];
    
    [self setupChildVc:[[LDNewMineVC alloc] init] title:@"我的" image:@"wode_2.0.4_default" selectedImage:@"wode_2.0.4"];
}


/**
 *  创建子控制器
 *
 *  @param vc            控制器名称
 *  @param title         tabBarItem 文字
 *  @param image         tabBarItem 默认图片
 *  @param selectedImage tabBarItem 选中图片
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    //设置导航栏标题
    vc.navigationItem.title = title;
    //设置图片和文字
    vc.tabBarItem.title = title;
    
    vc.tabBarItem.image = [UIImage imageNamed:image];
    
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    //设置tabbar字体大小
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:title size:10.0], NSFontAttributeName, nil]
                                 forState:UIControlStateNormal];
    
    
    //包装一个导航控制器
    LDNavgationVController * nav = [[LDNavgationVController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
    
    
}
- (void)controlStateSelected{
    
    UIColor *titleHighlightedColor = WHColorFromRGB(0xfd5d14);
   
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor,NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
}


//监听Tabbar点击事件，
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if ([item.title isEqualToString:@"首页"]){
        [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:FQSY];
    }
    if ([item.title isEqualToString:@"账单"]) {
        [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:ZDSY];
    }
    if ([item.title isEqualToString:@"我的"]) {
        [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:WDSY];
    }
    
    
    NSLog(@"%@",item.title);
    
    
}

@end
