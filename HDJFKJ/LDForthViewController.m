//
//  LDForthViewController.m
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDForthViewController.h"
#import "LDSignInViewController.h"
#import "WHMineSecondController.h"
#import "WHUserLoginModel.h"
#import "LDThirdViewController.h"
#import "WHOrderListController.h"
#import "WHSetController.h"
#import "LDtest2222ViewController.h"
#import "LDNavgationVController.h"
#import "WHImageSaveAndLoad.h"

#import "LDMySore.h"
#import "LDZhuCeViewController.h"
#import "LDFixVC.h"
#import "LDSafetyCenter.h"

#import "WHWithOutOrderController.h"
@interface LDForthViewController ()

//点击按钮后的背景图
@property (nonatomic, strong) UIView * selectedView;




//用户对象
@property (nonatomic, strong) WHUserLoginModel * user;

@end

@implementation LDForthViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获得用户对像
    self.user = [WHUserLoginModel createuserInfoModel];
    //刷新界面
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.title = @"我的";
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    //1.创建右侧导航栏的设置按钮
    [self createRightNavButton];
    
}
- (void)friendsClick2{
    
    LDMySore * score = [[LDMySore alloc] init];
    
    [self.navigationController pushViewController:score animated:YES];
    
}
//1.创建左侧导航栏
- (void)createRightNavButton{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [button setBackgroundImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickSetButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //作为Item的子视图添加上去
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//点击导航栏右侧“设置”按钮
- (void)clickSetButton:(UIButton *)sender{
    if (self.user == nil) {
        
        //推出登录界面
        LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
        
        [self.navigationController pushViewController:signinVC animated:YES];

    }else{
        
        WHSetController * setController = [[WHSetController alloc]init];
        
        [self.navigationController pushViewController:setController animated:YES];
    }
}
//设置tableViewHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 1) {
        return 1;
    }
    else{
        return 5;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    else if (indexPath.section == 1){
        return 45;
    }
    else{
        return 45;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (indexPath.section == 0) {
        //1.创建头像
        UIImageView * touxiangImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 70, 70)];
        touxiangImageView.image = [UIImage imageNamed:@"touxiang-weidenglu"];
        [cell addSubview:touxiangImageView];
        
        //2.账号Label
        UILabel * accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(99, 42.5, LDScreenWidth - 99 , 15)];
        accountLabel.textColor = WHColorFromRGB(0x2b2b2b);
        accountLabel.font = [UIFont boldSystemFontOfSize:15];
        accountLabel.textAlignment = NSTextAlignmentLeft;
        
        [cell addSubview:accountLabel];
        
        //3.点击箭头
        UIImageView * nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 25, 41, 10, 15)];
        nextImageView.image = [UIImage imageNamed:@"wodo_touxiang_jiantou"];
        [cell addSubview:nextImageView];
        
        //4.如果，登录状态加载数据
        if (self.user != nil) {

            // 加载用户头像
            UIImage * touxiangImage = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"%@.png",[LDUserInformation sharedInstance].UserId ]];
            if (touxiangImage) {
                [touxiangImageView sd_setImageWithURL:nil placeholderImage:touxiangImage];
            }
            
            // 加载用户账号
            accountLabel.text = [NSString stringWithFormat:@"账号：%@",self.user.phone] ;
        }else{
            UIView * loginAndregisterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 100)];
            [cell addSubview:loginAndregisterView];
            loginAndregisterView.backgroundColor = [UIColor whiteColor];
            
            UIButton * loginButton = [[UIButton  alloc]initWithFrame:CGRectMake( (LDScreenWidth-240)/2 + 100 + 40, 30, 100, 40)];
            [loginButton setTitle:@"登录" forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton setBackgroundColor:WHColorFromRGB(0xe84c3d)];
            loginButton.layer.cornerRadius = 5.0f;
            loginButton.layer.borderWidth = 0;
            loginButton.layer.borderColor = [[UIColor clearColor] CGColor];
            [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            [loginAndregisterView addSubview:loginButton];
            
            UIButton * registerButton = [[UIButton  alloc]initWithFrame:CGRectMake( (LDScreenWidth-240)/2, 30, 100, 40)];
            [registerButton setTitle:@"注册" forState:UIControlStateNormal];
            [registerButton setTitleColor:WHColorFromRGB(0xe84c3d) forState:UIControlStateNormal];
            [registerButton setBackgroundColor:[UIColor whiteColor]];
            registerButton.layer.cornerRadius = 5.0f;
            registerButton.layer.borderWidth = 1.0;
            registerButton.layer.borderColor = [WHColorFromRGB(0xe84c3d) CGColor];
            [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
            [loginAndregisterView addSubview:registerButton];
            
            
        }
        
        //5.上下连个线
        UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
        topLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
        [cell addSubview:topLine];
        
        UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, LDScreenWidth, 0.5)];
        bottomLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
        [cell addSubview:bottomLine];

    }else if (indexPath.section == 1) {
        NSArray * imageNameArr = @[@"wode_dingdan_2.0.4",@"wode_zhangdan_2.0.4",@"wode_saoma_2.1.1",@"wode_xinyongfen_2.0.4",@"wode_yinhangka_2.0.4"];
        NSArray * labelTextArr = @[@"我的订单",@"我的账单",@"扫码记录",@"我的资料",@"我的银行卡"];
        
        //1.创建图标
        UIImageView * iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageNameArr[indexPath.row]]];
        [cell addSubview:iconImage];
        
        //2.创建文本
        UILabel * cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, LDScreenWidth - 60, 15)];
        cellLabel.textColor = WHColorFromRGB(0x2b2b2b);
        cellLabel.textAlignment = NSTextAlignmentLeft;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.text = labelTextArr[indexPath.row];
        [cell addSubview:cellLabel];
        
        //3.设置每一行cell图标的大小位置
        if (indexPath.row == 0) {
            iconImage.frame = CGRectMake(18.5, 10.5, 23, 24);
        }else if (indexPath.row == 1) {
            iconImage.frame = CGRectMake(16.5, 12, 27, 21);
        }else if (indexPath.row == 2) {
            iconImage.frame = CGRectMake(18.5, 11, 23, 23);
        }
        else if (indexPath.row == 3) {
            iconImage.frame = CGRectMake(17.5, 10, 25, 25);
        }
        else {
            iconImage.frame = CGRectMake(16.5, 12, 27, 21);
        }
        
        //4.创建箭头shouyefanhui_2.0.4
        UIImageView * nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 25, 15, 10, 15)];
        nextImageView.image = [UIImage imageNamed:@"shouyefanhui_2.0.4"];
        [cell addSubview:nextImageView];
        
        //5.创建cell间的线
        if (indexPath.row == 0) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
            line.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:line];
        }
        else if (indexPath.row == 1){
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(60, 0, LDScreenWidth-60, 0.5)];
            line.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:line];
        }
        else if (indexPath.row == 2){
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(60, 0, LDScreenWidth-60, 0.5)];
            line.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:line];
        }
        else if (indexPath.row == 3){
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(60, 0, LDScreenWidth-60, 0.5)];
            line.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:line];
        }
        else {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(60, 0, LDScreenWidth-60, 0.5)];
            line.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:line];
            
            UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, LDScreenWidth, 0.5)];
            bottomLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:bottomLine];
        }
        
        
    
    }
    else {
        //创建图标
        UIImageView * iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wode_anquan_2.0.4"]];
        iconImage.frame = CGRectMake(19, 9.5, 22, 26);
        [cell addSubview:iconImage];
        
        //创建文本
        UILabel * cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, LDScreenWidth - 60, 15)];
        cellLabel.textColor = WHColorFromRGB(0x2b2b2b);
        cellLabel.textAlignment = NSTextAlignmentLeft;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.text = @"安全中心";
        [cell addSubview:cellLabel];
        
        //3.创建箭头shouyefanhui_2.0.4
        UIImageView * nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 25, 15, 10, 15)];
        nextImageView.image = [UIImage imageNamed:@"shouyefanhui_2.0.4"];
        [cell addSubview:nextImageView];
        
        //4.上下连个线
        UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
        topLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
        [cell addSubview:topLine];
        
        UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, LDScreenWidth, 0.5)];
        bottomLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
        [cell addSubview:bottomLine];
        
    }
    UIView * selectView = [[UIView alloc]init];
    selectView.backgroundColor = WHColorFromRGB(0xd9d9d9);
    cell.selectedBackgroundView = selectView;
    if (indexPath.section == 0) {
        selectView.frame = CGRectMake(0, 0, LDScreenWidth, 90);
    }
    else{
        selectView.frame = CGRectMake(0, 0, LDScreenWidth, 45);
    }
    if (self.user == nil && indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.user == nil) {
            //推出登录界面
//            LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
//            [self.navigationController pushViewController:signinVC animated:YES];
        }
        else{
            WHMineSecondController * secondController = [[WHMineSecondController alloc]init];
            [self.navigationController pushViewController:secondController animated:YES];
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            //统计买点
            [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:DDWD];
            
            if (self.user != nil) {
                //推出订单列表
                WHOrderListController * orderList = [[WHOrderListController alloc]init];
                [self.navigationController pushViewController:orderList animated:YES];
                
            }else{
                //推出登录界面
                LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
                [self.navigationController pushViewController:signinVC animated:YES];
                
            }
        }
        else if (indexPath.row == 1){
            
            //统计买点
            [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:ZDWD];
            
            if (self.user != nil) {
                //推出账单列表
                LDThirdViewController * thirdVC = [[LDThirdViewController alloc]init];
                thirdVC.indexflag = 1;
                [self.navigationController pushViewController:thirdVC animated:YES];
                
            }else{
                //推出登录界面
                LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
                [self.navigationController pushViewController:signinVC animated:YES];
                
            }
        
        }else if (indexPath.row == 2){
            
            if (self.user != nil) {
               
                
                WHWithOutOrderController * withOrder = [[WHWithOutOrderController alloc]init];
                [self.navigationController pushViewController:withOrder animated:YES];
            }else{
                //推出登录界面
                LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
                [self.navigationController pushViewController:signinVC animated:YES];
                
                
            }
            
        }
        else if (indexPath.row == 3){
            
            //统计买点
            [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:ZLWD];
            
            if (self.user != nil) {
                LDMySore * myScore = [[LDMySore alloc]init];
                [self.navigationController pushViewController:myScore animated:YES];
            }else{
                //推出登录界面
                LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
                [self.navigationController pushViewController:signinVC animated:YES];
                
            }
            
        }
        else{
            
            //统计买点
            [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:YHKWD];
            
            if (self.user != nil) {
                
                LDtest2222ViewController * secondController = [[LDtest2222ViewController alloc]init];
                secondController.title = @"我的银行卡";
                secondController.indexFlag = 41;
                [self.navigationController pushViewController:secondController animated:YES];
            }else{
                //推出登录界面
                LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
                [self.navigationController pushViewController:signinVC animated:YES];
            }
        }
    }
    else{
        
        if (self.user != nil) {
            LDSafetyCenter * safety = [[LDSafetyCenter alloc] init];
            
            [self.navigationController pushViewController:safety animated:YES];
            
            LDLogFunc;
        }
        else{
            //推出登录界面
            LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
            [self.navigationController pushViewController:signinVC animated:YES];
        }
        
        
        
    }

}

- (void)loginAction{
    //推出登录界面
    LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
    [self.navigationController pushViewController:signinVC animated:YES];
}
- (void)registerAction{
    LDZhuCeViewController * zhuce = [[LDZhuCeViewController alloc]init];
    [self.navigationController pushViewController:zhuce animated:YES];

}

//保存点击按钮的背景图，并设置其颜色
- (void)saveAndSetSelectedView:(UIView *)selectView{

    self.selectedView = selectView;
    
    self.selectedView.backgroundColor = WHColorFromRGB(0xd9d9d9);
}


@end
