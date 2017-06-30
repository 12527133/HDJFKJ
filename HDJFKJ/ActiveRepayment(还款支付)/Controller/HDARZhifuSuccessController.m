

#import "HDARZhifuSuccessController.h"
#import "LDThirdViewController.h"
@interface HDARZhifuSuccessController ()

/** 还款总额 */
@property (nonatomic, strong) UILabel * totalMoneyLabel;

/** 确认支付按钮 */
@property (nonatomic, strong) UIButton * nextButton;

@end

@implementation HDARZhifuSuccessController



- (void)dealloc{

    LDLog(@"销毁支付成功控制器");
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    /** 取消侧滑 */
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    /** 开启侧滑 */
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付结果";
    
    self.view.backgroundColor = LDBackroundColor;
    
    
    
    /** 关闭按钮 */
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"关闭" target:self action:@selector(rightButtonClick)];
    
    /** 创建视图 */
    [self createSubView];
    
    /** 创建下一步按钮 */
    [self createNextButton];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"" target:self action:nil];
}

/** 点击关闭按钮 */
- (void)rightButtonClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createSubView{

    /** 背景图 */
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 207*bili)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    /** 成功图片 */
    UIImageView * successIamge = [[UIImageView alloc]initWithFrame:CGRectMake(159*bili, 38*bili, 57*bili, 57*bili)];
    successIamge.image = [UIImage imageNamed:@"成功"];
    [bgView addSubview:successIamge];
    
    /** 还款总额Label */
    /** 还款总额 */
    self.totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*bili, 120*bili, LDScreenWidth - 60*bili, 52*bili)];
    self.totalMoneyLabel.backgroundColor = [UIColor clearColor];
    self.totalMoneyLabel.textColor = WHColorFromRGB(0x202020);
    if (self.paymentAmt != nil) {
        self.totalMoneyLabel.text = self.paymentAmt;
    }
    else{
        self.totalMoneyLabel.text = @"0.00";
    }
    self.totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.totalMoneyLabel.font = [UIFont systemFontOfSize:44*bili];
    [bgView addSubview:self.totalMoneyLabel];
    
}

/** 创建“确认支付”按钮 */
- (void)createNextButton{
    
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(16*bili, 220*bili, LDScreenWidth- 32*bili, 50*bili)];
    [self.view addSubview:self.nextButton];
    self.nextButton.backgroundColor = WHColorFromRGB(0x4279d6);
    [self.nextButton setTitle:@"查看账单详情" forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 5.0;
    self.nextButton.layer.borderWidth = 0.0;
    [self.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickNextButton:(UIButton *)sender{

    LDThirdViewController * thirdVC = [[LDThirdViewController alloc]init];
    
    [self.navigationController pushViewController:thirdVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
