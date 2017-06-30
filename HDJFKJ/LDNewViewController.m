//
//  LDNewViewController.m
//  HDJFKJ
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNewViewController.h"
//#import "WHFIrstCoVCSubView.h"
#import "LDSignInViewController.h"
#import "LDThirdViewController.h"
#import "CashLoanController.h"
#import "LDPaymentPasswordController.h"
#import "WHWorkViewController.h"
#import "LDTabBarController.h"


#import "LDPostIDCard.h"
#import "LDContactInformationViewController.h"
#import "LDBaseInformationTableViewController.h"
#import "HDOrderModel.h"
#import "WHZhiFuTanChuangView.h"

#import "WHOrderListController.h"
#import "LDNewOrderDetailVC.h"

#define Is_Iphone5 (([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO)
#define Is_Iphone6 (([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO)
#define Is_Iphone6P (([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO)
#define Is_Iphone4 (([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO)
@interface LDNewViewController ()<UIScrollViewDelegate>
//还款计划视图
@property (nonatomic, strong) UIView * repaymentView;
//还款计划提示Label
@property (nonatomic, strong)  UILabel * rightLabel;
/**
 *  借款金额
 */
@property (nonatomic, strong)  UILabel * moneyCount;
/**
 *  万单位 借款金额
 */
@property (nonatomic,strong) NSString * midleCount;
/**
 *  千单位 借款金额
 */
@property (nonatomic,strong) NSString * largeCount;
/**
 *  还款期限
 */
@property (nonatomic, strong)  UILabel * month;
/**
 *  还款金额
 */
@property (nonatomic, strong)  UILabel * leastMoneycount;
/**
 *  slider
 */
@property (nonatomic,strong) UISlider * slider;
/**
 *  slider1
 */
@property (nonatomic,strong) UISlider * slider2;
/**
 *  slider1
 */
@property (nonatomic,strong) UISlider * slider3;
@property (nonatomic,strong) UIScrollView * scrol;
@property (nonatomic,strong) UILabel  * notice2;
@property (nonatomic,strong) UILabel  * notice1;
@property (nonatomic,strong) UIView  * line;

//是否发送过订单请求
@property (nonatomic, assign) BOOL isSendorderRequert;
@end

@implementation LDNewViewController
- (void)viewWillAppear:(BOOL)animated{
    //设置状态栏的前景色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    //设置导航栏的背景图
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    //设置导航栏字体为白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏的前景色为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //设置导航栏字体颜色为黑色
    [self.navigationController.navigationBar setTitleTextAttributes:@{
       NSForegroundColorAttributeName:[UIColor blackColor]}];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatScreatView];

    [self creatMoneyCount];
    if ([LDUserInformation sharedInstance].UserId == nil) {
        
        self.line.hidden = YES;
        self.notice1.hidden = YES;
    
        self.notice2.hidden = YES;
    }else{
        
        [self sendRequest];
    }
    
    //审核通过的订单
    [self sendOrderRequest];
}


#pragma mark -- 发送订单请求
//网络订单请求
- (void)sendOrderRequest{
    
    if ([LDUserInformation sharedInstance].UserId != nil && [LDUserInformation sharedInstance].token != nil && !self.isSendorderRequert) {
        
        self.isSendorderRequert = YES;
        
        NSString * str = [NSString stringWithFormat:@"%@order/list",KBaseUrl ];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
        [params setObject:@"2" forKey:@"status"];
        [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
        
        [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
            if (error != nil) {
                LDLog(@"%@",error);
            }else{
                
                NSString * code = [response objectForKey:@"code"] ;
                if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
                    
                    [self analysisOrderResponse:response];
                    
                }else{
                }
                LDLog(@"%@",response);
            }
        }];
        
    }
}
- (void)analysisOrderResponse:(id)response{
    
    NSArray * resultArray = [response objectForKey:@"result"];
    NSMutableArray * orderArray = [HDOrderModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
    
    for (int i = 0; i < orderArray.count; i++) {
        HDOrderModel * orderModel = orderArray[i];
        
        if (![orderModel.status isEqualToString:@"已打回"] && ![orderModel.status isEqualToString:@"已通过"]){
            [orderArray removeObject:orderModel];
        }
    }
    
    if (orderArray.count > 0) {
        
        WHZhiFuTanChuangView * tanchuang = [WHZhiFuTanChuangView view];
        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
        [appWindow addSubview:tanchuang];
        
        
        tanchuang.titleLabel.text = @"订单提醒";
        tanchuang.contentLabel.text = @"您有待处理的订单";
        
        tanchuang.frame = CGRectMake(0, 0, LDScreenWidth, LDScreenHeight);
        
        
        [tanchuang.sureButton addTarget:self action:@selector(clickTanChuangSureButton:) forControlEvents:UIControlEventTouchUpInside];
        if (orderArray.count == 1) {
            HDOrderModel * orderModel = orderArray[0];
            tanchuang.sureButton.tag = [orderModel.id integerValue];
        }
        
        [tanchuang.cancelButton addTarget:self action:@selector(clickTanChuangCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
}

#pragma mark -- 确认支付弹窗的按钮响应方法
- (void)clickTanChuangCancelButton:(UIButton *)sender{
    [sender.superview removeFromSuperview];
}
- (void)clickTanChuangSureButton:(UIButton *)sender{
    
    [sender.superview removeFromSuperview];
    
    if (sender.tag > 0) {
        
        LDNewOrderDetailVC * orderDetail = [[LDNewOrderDetailVC alloc]init];
        orderDetail.applyId = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else{
        WHOrderListController * orderDetail = [[WHOrderListController alloc]init];
        
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}





- (void)creatMoneyCount{

    
        UILabel * notice1 = [UILabel new];
    self.notice1 = notice1;
        notice1.text = @"还款计划: ";
        notice1.font = LD17Font;
    self.notice1.alpha = 0.7;

        [self.scrol addSubview:notice1];
        [notice1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.scrol).offset(-20);
            
            make.top.equalTo(self.scrol).offset(8);
            
        }];
        UILabel * notice2 = [UILabel new];
    self.notice2 = notice2;
    self.notice2.alpha = 0.7;

        notice2.textColor = [UIColor redColor];
        notice2.font = LD17Font;
        [self.scrol addSubview:notice2];
        [notice2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(notice1);
            
            make.left.equalTo(notice1.right);
            
        }];
        
        UILabel * line = [UILabel new];
    self.line = line;
        line.backgroundColor = [UIColor blackColor];
        line.font = LD17Font;
        [self.scrol addSubview:line];
        line.backgroundColor = LDRGBColor(200, 199, 204, 1);
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0.5);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(notice1.bottom).offset(8);
        }];
  

  
    
    UIButton * header = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:header];
   
    header.backgroundColor = [UIColor clearColor];
    [header makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrol).offset(0);
        make.right.equalTo(self.scrol).offset(0);
        make.height.equalTo(45);
        make.top.equalTo(notice1);
    }];
    [header addTarget:self action:@selector(clickRepayMent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    UILabel * notice = [UILabel new];
    notice.text = @"借款金额";
    notice.alpha = 0.6;
    notice.font = LD15Font;
    [self.scrol addSubview:notice];
    [notice makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrol);
   
        make.top.equalTo(line).offset(18);

    }];
    
    
    UILabel * moneyCount = [UILabel new];
    moneyCount.text = @"1000";
    moneyCount.font  =[UIFont systemFontOfSize:30];
    moneyCount.textColor = WHColorFromRGB(0xE84c3D);
    self.moneyCount = moneyCount;
    [self.scrol addSubview:moneyCount];
    [moneyCount makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrol).offset(-5);
        make.top.equalTo(notice.bottom).offset(18);
    }];
    
    
    
    
    
    
    UILabel * moneyCountYuan = [UILabel new];
    moneyCountYuan.text = @"元";
    moneyCountYuan.font  =[UIFont systemFontOfSize:15];
    [self.scrol addSubview:moneyCountYuan];
    [moneyCountYuan makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(moneyCount.bottom).offset(-7);
        make.left.equalTo(moneyCount.right).offset(5);
    }];
    
    
    UILabel * wan = [UILabel new];
    [self.view addSubview:wan];
    wan.text = @"万";
    wan.textColor = WHColorFromRGB(0xFA9019);
    wan.font = [UIFont systemFontOfSize:12];
    [wan makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrol).offset(10);
        make.top.equalTo(moneyCount.bottom).offset(29);
    }];

    UISlider * slider = [[UISlider alloc] init];
    [self.view addSubview:slider];
    self.slider = slider;
    [slider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrol).offset(30);
        make.right.equalTo(self.scrol).offset(-LDPadding);
        make.centerY.equalTo(wan);
        make.height.equalTo(10);
    }];

    slider.minimumValue = 0;
    slider.maximumValue = 200000;
    slider.value = 0;
    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    slider.tag = 1;
    slider.minimumTrackTintColor = WHColorFromRGB(0xFA9019);
    slider.maximumTrackTintColor = WHColorFromRGB(0xFA9019);
    slider.thumbTintColor = WHColorFromRGB(0xFA9019);
    

    UILabel * qian = [UILabel new];
    [self.view addSubview:qian];
    qian.text = @"千";
    qian.textColor = WHColorFromRGB(0xE84c3D);;
    qian.font = [UIFont systemFontOfSize:12];
    [qian makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrol).offset(10);
        make.top.equalTo(slider.bottom).offset(48);
    }];
    
    UISlider * slider2 = [[UISlider alloc] init];
    [self.view addSubview:slider2];
    self.slider2 = slider2;
    [slider2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrol).offset(30);
        make.right.equalTo(self.scrol).offset(-LDPadding);
        make.centerY.equalTo(qian);
    }];
    slider2.minimumValue = 0;
    slider2.maximumValue = 10;
    slider2.value = 1;
    [slider2 addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    slider2.tag = 2;
    slider2.minimumTrackTintColor = WHColorFromRGB(0xE84C3D);
    slider2.maximumTrackTintColor = WHColorFromRGB(0xE84c3D);
    slider2.thumbTintColor = WHColorFromRGB(0xE84c3D);


    
    
    UILabel * data = [UILabel new];
    [self.view addSubview:data];
    data.text = @"还款期限";
    data.alpha = 0.6;

    data.font = LD15Font;
    [data makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrol);
        make.top.equalTo(slider2.bottom).offset(28);
    }];
    

    
    UILabel * month = [UILabel new];
    [self.view addSubview:month];
    self.month = month;
    month.text = @"6";
    month.textColor = WHColorFromRGB(0x41c7FF);
    
    month.font = [UIFont systemFontOfSize:30];
    [month makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrol).offset(-15);
        make.top.equalTo(data.bottom).offset(18);
    }];
    
    UILabel * monthText = [UILabel new];
    monthText.text = @"个月";
    monthText.alpha = 0.6;
    monthText.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:monthText];
    [monthText makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(month.bottom).offset(-5);
        make.left.equalTo(month.right);
    }];
    
    UISlider * slider3 = [[UISlider alloc] init];
    [self.view addSubview:slider3];
    [slider3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrol).offset(30);
        make.right.equalTo(self.scrol).offset(-LDPadding);
        make.top.equalTo(month.bottom).offset(20);
    }];
    self.slider3 = slider3;
    slider3.minimumValue = 1;
    slider3.maximumValue = 6;
    slider3.value = 1;
    [slider3 addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    slider3.tag = 3;
    slider3.minimumTrackTintColor = WHColorFromRGB(0x41c7FF);
    slider3.maximumTrackTintColor = WHColorFromRGB(0x41c7FF);
    slider3.thumbTintColor = WHColorFromRGB(0x41c7FF);

    
    
    UILabel * leastMoney = [UILabel new];
    leastMoney.font = [UIFont systemFontOfSize:13];
    leastMoney.text = @"* 每月最低还款  ";
    leastMoney.alpha = 0.6;

    [self.view addSubview:leastMoney];
    [leastMoney makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrol).offset(-10);
        make.top.equalTo(slider3.bottom).offset(34);
    }];
    
    UILabel * leastMoneycount = [UILabel new];
    leastMoneycount.textColor = [UIColor redColor];
    leastMoneycount.font = [UIFont systemFontOfSize:13];
    leastMoneycount.text = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:@"1000" duration:6]];
    self.leastMoneycount = leastMoneycount;
    [self.view addSubview:leastMoneycount];
    [leastMoneycount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leastMoney);
        make.left.equalTo(leastMoney.right);
    }];
    UILabel * leastMoneycountYuan = [UILabel new];
    leastMoneycountYuan.text = @"元";
    leastMoneycountYuan.font  =[UIFont systemFontOfSize:13];
    [self.scrol addSubview:leastMoneycountYuan];
    [leastMoneycountYuan makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(leastMoneycount.bottom).offset(0);
        make.left.equalTo(leastMoneycount.right).offset(3);
    }];
    
    

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"xuanwwwze"] forState:UIControlStateNormal];
    [button setTitle:@"立即申请" forState:UIControlStateNormal];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrol).offset(10);
        make.right.equalTo(self.scrol).offset(-10);
        make.height.equalTo(45);
        make.top.equalTo(leastMoney.bottom).offset(12);
    }];
    [button addTarget:self action:@selector(clickCashButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * banner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
    [self.view addSubview:banner];
    [banner makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrol).offset(0);
        make.right.equalTo(self.scrol).offset(0);
        make.top.equalTo(button.bottom).offset(13);

    }];
}


/**
 *  立即申请
 */
- (void)clickCashButton{
    
    //用户未登陆前去登陆
    if ([LDUserInformation sharedInstance].token == nil || [LDUserInformation sharedInstance].UserId == nil){
        
        LDSignInViewController * signIn = [[LDSignInViewController alloc]init];
        
        signIn.indexFlag = 41;
        [self.navigationController pushViewController:signIn animated:YES];
        
        //用户登陆后验证资料是否完善
    }else{
        
        [self yanzhengyonghuziliaoRequest];
        
    }
}

#pragma mark -- 现金贷验证用户信息是否完善请求
//网络请求
- (void)yanzhengyonghuziliaoRequest{
    
//    [SVProgressHUD showWithStatus:@"正在验证用户信息"];
    [HDLoading showWithImageWithString:@"正在验证用户信息"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/infoStep",KBaseUrl ];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
//            [SVProgressHUD showErrorWithStatus:@"加载信息失败!"];
            [HDLoading showFailViewWithString:@"网络错误"];
            
        }else{
//            [SVProgressHUD dismiss];
            
            NSInteger code = [[response objectForKey:@"code"] integerValue];
            
            
            
            if (code == 0 || code == -7) {
                
                [self sendRequestBuyNow];
                
                
            }
            if (code == -2) {
                [HDLoading showFailViewWithString:@"登录失效,重新登录"];
                LDSignInViewController * vc = [[LDSignInViewController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (code == -100) {
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                alert.tag = -100;
                
                [alert show];
            }
            if (code == -21) {
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -21;
                [alert show];
            }
            if (code == -3) {
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -3;
                [alert show];
            }
            if (code == -4){
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -4;
                [alert show];
                
            }
            if (code == -41) {
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -41;
                [alert show];
            }
            if (code == -42) {
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -42;
                [alert show];
            }
            if (code == -43) {
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -43;
                [alert show];
            }
            if (code == -5) {
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -5;
                [alert show];
            }
            if (code == -6) {
                [HDLoading dismissHDLoading];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -6;
                [alert show];
            }
            LDLog(@"%@",response);
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == -21) {
        //完善用户支付密码
        LDPaymentPasswordController *password = [[LDPaymentPasswordController alloc]init];
        password.fromeWhere = @"shouye";
        [self.navigationController pushViewController:password animated:YES];
    }
    if (alertView.tag == -3) { //完善基本信息
        LDBaseInformationTableViewController * baseInfo = [[LDBaseInformationTableViewController alloc]init];
                baseInfo.fromeWhere = @"shouye";
        [self.navigationController pushViewController:baseInfo animated:YES];
    }
    if (alertView.tag == -4) {
        //完善省份信息
        LDPostIDCard * PostIDCard = [[LDPostIDCard alloc] init];
        PostIDCard.fromeWhere = @"shouye";
        [self.navigationController pushViewController:PostIDCard animated:YES];
    }
    if (alertView.tag == -41) {
        //完善工作信息
        WHWorkViewController * jobInfo = [[WHWorkViewController alloc]init];
        jobInfo.fromeWhere = @"shouye";
        [self.navigationController pushViewController:jobInfo animated:YES];
    }
    if (alertView.tag == -42) {
        //完善学生信息
        WHWorkViewController * StudentInfo = [[WHWorkViewController alloc] init];
        StudentInfo.fromeWhere = @"shouye";
        [self.navigationController pushViewController:StudentInfo animated:YES];
    }
    if (alertView.tag == -43) {
        //完善创业信息
        WHWorkViewController * Entrepreneurs = [[WHWorkViewController alloc] init];
        Entrepreneurs.fromeWhere = @"shouye";
        [self.navigationController pushViewController:Entrepreneurs animated:YES];
    }
    if (alertView.tag == -5) {
        //完善高级信息
        LDPostIDCard * PostIDCard = [[LDPostIDCard alloc] init];
        PostIDCard.fromeWhere = @"shouye";
        [self.navigationController pushViewController:PostIDCard animated:YES];
    }
    if (alertView.tag == -6) {
        //完善联系人信息
        LDContactInformationViewController * ContactInfo = [[LDContactInformationViewController alloc] init];
        ContactInfo.fromeWhere = @"shouye";
        [self.navigationController pushViewController:ContactInfo animated:YES];
    }
    
}
/**
 *  网络请求,立即购买,购买验证
 */
- (void)sendRequestBuyNow{
    
    
    NSString * url = [NSString stringWithFormat:@"%@order/buyCheck",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].phoneNumber) forKey:@"phoneNo"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            [HDLoading showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                [HDLoading dismissHDLoading];
                CashLoanController * cashLoan = [[CashLoanController alloc]init];
                //每月还款金额
                cashLoan.moneyCount = self.leastMoneycount.text;
                //还款总额
                cashLoan.moneySumCount = self.moneyCount.text;
                //还款期数
                cashLoan.monthCount = self.month.text;
                
                [self.navigationController pushViewController:cashLoan animated:YES];
                
                
            }else if ([backInfor.code intValue] == -100){
                
                //服务器异常
                [HDLoading showFailViewWithString:backInfor.message];
                
                return ;
                
            }else if ([backInfor.code intValue] == -2) {
                
                [HDLoading dismissHDLoading];
                
                //未登录
                LDSignInViewController * vc = [[LDSignInViewController alloc] init];
                

                [self.navigationController pushViewController:vc animated:YES];
                
                LDLog(@"未登录1234");
                
                return ;
                
            }else if([backInfor.code intValue] == -12) {
                //有未完结订单,无法购买
                [HDLoading showFailViewWithString:backInfor.message];
                return;
                
            }else if([backInfor.code intValue] == -4) {
                
                //三个月内有被拒绝订单,无法购买.
                [HDLoading showFailViewWithString:backInfor.message];
                return;
                
            }else{
                [HDLoading showFailViewWithString:backInfor.message];
            }
            
        }
    }];
    
}


/**
 *  slider滑动监听事件
 */
- (void)updateValue:(UISlider *)slider{
    
    if (slider.tag == 1) {
        
        if ((slider.value == 0)) {
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",0 + [self.largeCount intValue]];
            
            self.midleCount = @"0";
            
    self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }

        
            if ((slider.value <= 10000)&&(slider.value > 0)) {
                
                
                self.moneyCount.text = [NSString stringWithFormat:@"%d",10000 + [self.largeCount intValue]];
                self.midleCount = @"10000";
                self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            }
        if ((slider.value <= 20000)&&(slider.value > 10000)) {
            
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",20000 + [self.largeCount intValue]];
            self.midleCount = @"20000";
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 30000)&&(slider.value > 20000)) {
            
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",30000 + [self.largeCount intValue]];
            self.midleCount = @"30000";
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 40000)&&(slider.value > 30000)) {
                        self.midleCount = @"40000";
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",40000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 50000)&&(slider.value > 40000)) {
                        self.midleCount = @"50000";
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",50000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 60000)&&(slider.value > 50000)) {
                        self.midleCount = @"60000";
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",60000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 70000)&&(slider.value > 60000)) {
                        self.midleCount = @"70000";
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",70000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 80000)&&(slider.value > 70000)) {
                        self.midleCount = @"80000";
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",80000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 90000)&&(slider.value > 80000)) {
                        self.midleCount = @"90000";
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",90000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 100000)&&(slider.value > 90000)) {
                        self.midleCount = @"100000";
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",100000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 110000)&&(slider.value > 100000)) {
            self.midleCount = @"110000";

            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",110000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 120000)&&(slider.value > 110000)) {
            self.midleCount = @"120000";

            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",120000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 130000)&&(slider.value > 120000)) {
            self.midleCount = @"130000";

            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",130000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 140000)&&(slider.value > 130000)) {
            self.midleCount = @"140000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",140000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 150000)&&(slider.value > 140000)) {
            self.midleCount = @"150000";

self.moneyCount.text = [NSString stringWithFormat:@"%d",150000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 160000)&&(slider.value > 150000)) {
            self.midleCount = @"160000";

self.moneyCount.text = [NSString stringWithFormat:@"%d",160000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 170000)&&(slider.value > 160000)) {
            self.midleCount = @"170000";

self.moneyCount.text = [NSString stringWithFormat:@"%d",170000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 180000)&&(slider.value > 170000)) {
            self.midleCount = @"180000";

            self.moneyCount.text = @"180000";
            self.moneyCount.text = [NSString stringWithFormat:@"%d",180000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value <= 190000)&&(slider.value > 180000)) {
            self.midleCount = @"190000";
            self.moneyCount.text = [NSString stringWithFormat:@"%d",190000 + [self.largeCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        
    }else if(slider.tag == 2){
    
        if ((slider.value == 0)) {
            self.largeCount = @"0";
            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue]];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        
        if ((slider.value > 0)&&(slider.value <= 1)) {
            self.largeCount = @"1000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 1000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        if ((slider.value > 1)&&(slider.value <= 2)) {
            self.largeCount = @"2000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 2000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        if ((slider.value > 2)&&(slider.value <= 3)) {
            self.largeCount = @"3000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 3000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
        }
        if ((slider.value > 3)&&(slider.value <= 4)) {
            self.largeCount = @"4000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 4000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        if ((slider.value > 4)&&(slider.value <= 5)) {
            self.largeCount = @"5000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 5000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        if ((slider.value > 5)&&(slider.value <= 6)) {
            self.largeCount = @"6000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 6000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        if ((slider.value > 6)&&(slider.value <= 7)) {
            self.largeCount = @"7000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 7000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        if ((slider.value > 7)&&(slider.value <= 8)) {
            self.largeCount = @"8000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 8000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        if ((slider.value > 8)&&(slider.value <= 9)) {
            self.largeCount = @"9000";

            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 9000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }
        if ((slider.value > 9)) {
            self.largeCount = @"10000";
            
            self.moneyCount.text = [NSString stringWithFormat:@"%d",[self.midleCount intValue] + 10000];
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:[self.month.text intValue]]];
            
        }

    }else{
    
        if ((slider.value < 2)) {
            
            self.month.text = @"6";
          self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:6]];
        }
        if ((slider.value >=2)&&(slider.value < 3)) {
            
            self.month.text = @"9";
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:9]];
        }
        if ((slider.value >=3 )&&(slider.value <4)) {
            
            self.month.text = @"12";
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:12]];
            
        }
        if ((slider.value >= 4)&&(slider.value < 5)) {
            
            self.month.text = @"18";
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:18]];
            
        }
        if ((slider.value >= 5)&&(slider.value < 6)) {
            
            self.month.text = @"24";
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:24]];
            
        }
        if ((slider.value >= 6)) {
            
            self.month.text = @"36";
            self.leastMoneycount.text  = [NSString stringWithFormat:@"%.2f",[self getAvergMonthMoney:self.moneyCount.text duration:36]];

            
        }
  
    }

}





/**
 *  还款金额计算规则
 */
- (double)getAvergMonthMoney:(NSString *)money duration:(NSInteger )duration{
    
    double totalMoney = [money doubleValue];
    
    double month = (double)duration ;
    double monthmoney=(totalMoney*0.125/12*(pow((1+0.125/12),month)))/(pow((1+0.125/12),month)-1)+totalMoney*0.29/100;
    return monthmoney;
}
/**
 *  还款计划
 */
- (void)sendRequest{
    NSString * str = [NSString stringWithFormat:@"%@index/",KBaseUrl];
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
        
  
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            LDLog(@"%@",error);
        }else{
            NSString * str = response[@"result"][@"repaystatus"];
            LDLog(@"%@",str);
            LDLog(@"%@",response);
            self.notice2.text = str;
           
        }
    }];

}

//创建还款计划视图
- (void)creatHeaderView{
    
    _repaymentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, LDScreenWidth, 45)];
    _repaymentView.userInteractionEnabled = YES;
    _repaymentView.backgroundColor = WHColorFromRGB(0xf6f6f6);
    [self.view addSubview:_repaymentView];
    
    //1.label作为分割线
    UILabel * bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _repaymentView.frame.size.height-0.5, _repaymentView.frame.size.width, 0.5)];
    bottomLabel.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_repaymentView addSubview:bottomLabel];
    bottomLabel.userInteractionEnabled = YES;
    //2.箭头ImageVIew
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20, 11, 10, 18)];
    imageView.image = [UIImage imageNamed:@"返回"];
    [_repaymentView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    //3."还款计划"Label
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _repaymentView.frame.size.width/2,_repaymentView.frame.size.height)];
    leftLabel.text = @"还款计划：";
    leftLabel.textColor = WHColorFromRGB(0x051b28);
    leftLabel.textAlignment = NSTextAlignmentRight;
    leftLabel.font = [UIFont systemFontOfSize:15];
    [_repaymentView addSubview:leftLabel];
    leftLabel.userInteractionEnabled = YES;
    //4."本月还款"label
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(_repaymentView.frame.size.width/2, 0, _repaymentView.frame.size.width/2,_repaymentView.frame.size.height)];
    _rightLabel.backgroundColor = [UIColor clearColor];
    _rightLabel.text = @"";
    _rightLabel.textColor = WHColorFromRGB(0xd33a31);
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    _rightLabel.font = [UIFont systemFontOfSize:15];
    [_repaymentView addSubview:_rightLabel];
    _rightLabel.userInteractionEnabled = YES;
    
    //5.创建遮挡整个视图的Button
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _repaymentView.frame.size.width, _repaymentView.frame.size.height)];
    [button setTitle:_rightLabel.text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickRepayMent:) forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = YES;
    [button setBackgroundColor:[UIColor redColor]];
    [_repaymentView addSubview:button];
    
}
- (void)LDButtonClick{
    LDLogFunc;
}

//点击还款计划试图
- (void)clickRepayMent:(UIButton *)sender{
    
    LDLogFunc;
    
    if ([LDUserInformation sharedInstance].UserId == nil || [LDUserInformation sharedInstance].token == nil) {
        //推出登录界面
        LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
        [self.navigationController pushViewController:signinVC animated:YES];
    }
    else{
        
        
        LDThirdViewController * checkList = [[LDThirdViewController alloc]init];
        checkList.indexflag = 1;
        [self.navigationController pushViewController:checkList animated:YES];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatScreatView{
    
    UIScrollView * scrol = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    scrol.showsVerticalScrollIndicator = NO;
    
    self.scrol = scrol;
    self.scrol.delegate  =self;
    [self.view addSubview:scrol];
    
    self.scrol.backgroundColor  =[UIColor clearColor];
    
    if (Is_Iphone6P) {
        
        scrol.contentSize = CGSizeMake(LDScreenWidth, 650);
        
    }
    if (Is_Iphone6) {
        
        scrol.contentSize = CGSizeMake(LDScreenWidth, 755);
        
    }
    
    if (Is_Iphone5) {
        
        scrol.contentSize = CGSizeMake(LDScreenWidth, 755);
        
    }
    if (Is_Iphone4) {
        
        scrol.contentSize = CGSizeMake(LDScreenWidth, 755);
        
    }
    
}

@end
