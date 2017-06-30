

#import "LDPaymentPasswordController.h"
#import "WHPasswordView.h"
#import "LDPaymentPasswordSureController.h"

@interface LDPaymentPasswordController ()
@property (nonatomic, strong) NSString * zhifuPassword;
@end

@implementation LDPaymentPasswordController



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if ([self.fromeWhere isEqualToString:@"xiadan"]) {
        
        
    }else{
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:nil highImage:nil target:nil action:nil];
        
    }
    
    self.navigationItem.title = @"支付密码";

    
    
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100 * LDScreenWidth/375, LDScreenWidth, 18)];
    label.text = @"请设定您的支付密码";
    label.textColor = WHColorFromRGB(0x051b28);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 150 * LDScreenWidth/375, LDScreenWidth, 13)];
    label2.text = @"支付密码是您分期购物的凭证，请牢记";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = WHColorFromRGB(0xD3D3D3);
    label2.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label2];
    
    
    WHPasswordView * passwordView = [[WHPasswordView alloc]initWithFrame:CGRectMake((LDScreenWidth-270*LDScreenWidth/375)/2, (LDScreenHeight - 50)/2 -50, 270*LDScreenWidth/375, 270*LDScreenWidth/375/6)];
    [self.view addSubview:passwordView];
    passwordView.complationBlock = ^(NSString * password){
        
        self.zhifuPassword = password;
        NSLog(@"=====%@=======",password);
    };
    
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10, LDScreenHeight/2 , LDScreenWidth - 20, 45)];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:WHColorFromRGB(0x4279d6)];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 0.0;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)buttonclick:(UIButton *)sender{
    if (!(self.zhifuPassword.length == 6)) {
        
        
        [HDLoading showFailViewWithString:@"请输入6位密码"];
        
    }else{
        
        LDPaymentPasswordSureController * paymentSureVC = [[LDPaymentPasswordSureController alloc] init];
        
        //将密码传到下个界面对比较,是否两次输入相同
        paymentSureVC.passWordText = self.zhifuPassword;
        paymentSureVC.fromeWhere = self.fromeWhere;
        
        [self.navigationController pushViewController:paymentSureVC animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
