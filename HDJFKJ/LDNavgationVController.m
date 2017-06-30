//
//  LDNavgationVController.m
//  HDJFKJ
//
//  Created by apple on 16/2/28.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNavgationVController.h"

@interface LDNavgationVController ()

@end

@implementation LDNavgationVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航栏字体为白色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏下面的线
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    //设置状态栏的前景色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

  
    
   
}

/**
 * 当第一次使用这个类的时候会调用一次
 */
//+ (void)initialize
//{
////     当导航栏用在NavigationController中, appearance设置才会生效
////    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
//    UINavigationBar *bar = [UINavigationBar appearance];
////    bar.backgroundColor = WHColorFromRGB(0xd33a31);
//    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
//}


/**
* 可以在这个方法中拦截所有push进来的控制器
*/
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        
        
        
        button.size = CGSizeMake(70, 30);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
        // 让按钮的内容往左边偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}

- (void)back
{
    [self popViewControllerAnimated:YES];

}


@end
