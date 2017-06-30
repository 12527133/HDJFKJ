//
//  LDSubmitVCController.m
//  HDJFKJ
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDSubmitVCController.h"
#import "LDTabBarController.h"
#import "WHChekListController.h"
#import "LDNewOrderDetailVC.h"


@interface LDSubmitVCController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel * note1;
@property (nonatomic, strong) UILabel * note2;
@property (nonatomic, strong) UILabel * note;
@end

@implementation LDSubmitVCController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    /** 取消侧滑返回  */
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            
        }
    }
}

- (void)dealloc{

    LDLog(@"销毁下单成功控制器，界面");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = LDBackroundColor;
    self.navigationItem.title = @"交易详情";
    [self creatSubView];
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:nil highImage:nil target:self action:nil];
    
    
    
}


- (void)creatSubView{
    UIView * topView = [UIView new];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(15);
        make.height.equalTo(250);
    }];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"成功"]];
    [self.view addSubview:image];
    [image makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(topView).offset(2*LDPadding);
        make.size.equalTo(CGSizeMake(100, 100));
    }];
    
    self.note = [UILabel new];
    [self.view addSubview:self.note];
    self.note.font = LD17Font;
    self.note.numberOfLines = 0;
    self.note.text = @"订单提交成功";
    self.note.textColor = WHColorFromRGB(0x4279d6);
    [self.note makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(image.bottom).offset(LDPadding);
    }];
    
    
    self.note1 = [UILabel new];
    [self.view addSubview:self.note1];
    self.note1.font = LD15Font;
    self.note1.numberOfLines = 0;
    self.note1.text = @"您的订单已经成功转入审核阶段";
    self.note1.alpha = 0.5;
    [self.note1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(self.note.bottom).offset(2*LDPadding);
    }];
    if ([self.fromClass isEqualToString:@"querenzhifu"]) {
        self.note1.text = @"正在生成您的分期账单请耐心等";
    }
    
    
    self.note2 = [UILabel new];
    [self.view addSubview:self.note2];
    self.note2.font = LD15Font;
    self.note2.numberOfLines = 0;
    self.note2.text = @"您可在 \"我的订单\" 中随时查看进度";
    self.note2.alpha = 0.5;
    [self.note2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(self.note1.bottom).offset(LDPadding);
    }];

    UIButton * lookOredr = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookOredr setBackgroundImage:[UIImage imageNamed:@"login_botton"] forState:UIControlStateNormal];
    [self.view addSubview:lookOredr];
    [lookOredr addTarget:self action:@selector(orderDetail) forControlEvents:UIControlEventTouchUpInside];
    
    [lookOredr makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.bottom).offset(3*LDPadding);
        make.left.equalTo(self.view).offset(LDPadding);
        make.right.equalTo(self.view).offset(-LDPadding);
        make.height.equalTo(45);
    }];
    
    UILabel * note3 = [UILabel new];
    [self.view addSubview:note3];
    note3.font = LD17Font;
    note3.textColor = [UIColor whiteColor];
    note3.numberOfLines = 0;
    note3.text = @"查看订单详情";
    [note3 makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(lookOredr);
    }];
    
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_botton"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backFirst) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lookOredr.bottom).offset(2*LDPadding);
        make.left.equalTo(self.view).offset(LDPadding);
        make.right.equalTo(self.view).offset(-LDPadding);
        make.height.equalTo(45);
    }];
    
    UILabel * note4 = [UILabel new];
    [self.view addSubview:note4];
    note4.font = LD17Font;
    note4.numberOfLines = 0;
    note4.textColor = [UIColor whiteColor];

    note4.text = @"返回首页";
    [note4 makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backButton);
    }];

}

/**
 *  订单详情
 */
- (void)orderDetail{
    
    LDNewOrderDetailVC * VC = [[LDNewOrderDetailVC alloc] init];
    VC.applyId = self.applyId;
    
    [self.navigationController pushViewController:VC animated:YES];
}

//返回首页
- (void)backFirst{

    
    LDTabBarController * tabBar = [[LDTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
    
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        
        
        
    }];
    
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
