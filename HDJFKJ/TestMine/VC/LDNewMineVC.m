//
//  LDNewMineVC.m
//  OCLDProject
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNewMineVC.h"
#import "LDNewMineVCFooter.h"
#import "LDNMineTableViewCell.h"
#import "HDMineNOLoginCell.h"
#import "LDNavgationVController.h"
#import "LDSignInViewController.h"
#import "LDZhuCeViewController.h"
#import "HDMineBaseInfoController.h"
#import "LDMySore.h"

@interface LDNewMineVC ()

@end

@implementation LDNewMineVC
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
static NSString * const LDNMineCell = @"NMineCell";
static NSString * const HDMineNologin = @"MineNologin";
- (void)setupTable
{
    self.tableView.backgroundColor = LDRGBColor(245, 245, 249, 1);
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake( -37, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDNMineTableViewCell class]) bundle:nil] forCellReuseIdentifier:LDNMineCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDMineNOLoginCell class]) bundle:nil] forCellReuseIdentifier:HDMineNologin];

    // 设置footer
    self.tableView.tableFooterView = [[LDNewMineVCFooter alloc] init];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    
    self.view.backgroundColor = LDRGBColor(245, 245, 249, 1);
    [self setupTable];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /** 设置导航栏背景 */
    [self setNavgationBackground];
    
    
    [self.tableView reloadData];
  
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /** 一级界面取消侧滑返回  */
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            
        }
    }
    
}

- (void)setNavgationBackground{
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /** 设置导航栏字体为白色 */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    /** 设置导航背景图 */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    
    /** 是否显示下划线 */
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    /** 设置二级界面导航栏背景色为白色 */
    [self setNavgationBackgroundWight];
    
    /** 非一级界面添加侧滑功能 */
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

/** 设置二级界面导航栏背景色为白色 */
- (void)setNavgationBackgroundWight{
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    /** 设置导航栏字体为白色 */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHColorFromRGB(0x323232)}];
    
    /** 设置导航背景图 */
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    
    /** 是否显示下划线 */
    self.navigationController.navigationBar.shadowImage = nil;
    
}


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([LDUserInformation sharedInstance].UserId != nil && [LDUserInformation sharedInstance].token != nil) {
        LDNMineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:LDNMineCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.scoreButton addTarget:self action:@selector(goScore) forControlEvents:UIControlEventTouchUpInside];
        
        cell.headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScoreButton)];
        [cell.headerImageView addGestureRecognizer:tap];
        
        
        return cell;
    }
    else{
        
        HDMineNOLoginCell * cell = [tableView dequeueReusableCellWithIdentifier:HDMineNologin];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.registerButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.touxiangLoginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LDScreenHeight * 166 /667;
    
}


- (void)clickLoginButton:(UIButton *)sender{
    LDSignInViewController * signIn = [[LDSignInViewController alloc]init];
    signIn.fromWhere = @"wode";
    LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:signIn];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}
- (void)clickRegisterButton:(UIButton *)sender{
    
    LDZhuCeViewController * zhuce = [[LDZhuCeViewController alloc]init];
    zhuce.fromWhere = @"wodezhuce";
    LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:zhuce];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (void)clickScoreButton{

    
    HDMineBaseInfoController * myScore = [[HDMineBaseInfoController alloc]init];
    [self.navigationController pushViewController:myScore animated:YES];

}

- (void)goScore{
    
    LDMySore * myScore = [[LDMySore alloc]init];
    [self.navigationController pushViewController:myScore animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
