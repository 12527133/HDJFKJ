

#import "LDPaymentPasswordSureController.h"
#import "WHPasswordView.h"
#import "LDUserInformation.h"
#import "TZMD5.h"
#import "LDTabBarController.h"
@interface LDPaymentPasswordSureController ()

@property (nonatomic, strong) NSString * zhifuPassword;

@end

@implementation LDPaymentPasswordSureController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"确认支付密码";
    self.navigationController.navigationBarHidden = NO;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100 * LDScreenWidth/375, LDScreenWidth, 18)];
    label.text = @"请再次输入您的支付密码";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = WHColorFromRGB(0x051b28);
    label.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 150 * LDScreenWidth/375, LDScreenWidth, 13)];
    label2.text = @"支付密码是您分期购物的凭证，请牢记";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = WHColorFromRGB(0xcD3D3D3);
    label2.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label2];
    
    
    WHPasswordView * passwordView = [[WHPasswordView alloc]initWithFrame:CGRectMake((LDScreenWidth-270*LDScreenWidth/375)/2, (LDScreenHeight - 50)/2 -50, 270*LDScreenWidth/375, 270*LDScreenWidth/375/6)];
    [self.view addSubview:passwordView];
    passwordView.complationBlock = ^(NSString * password){
        
        self.zhifuPassword = password;
        NSLog(@"=====%@=======",password);
    };
    
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10, LDScreenHeight/2 , LDScreenWidth - 20, 45)];
    
    
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:WHColorFromRGB(0x4279d6)];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 0.0;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
}


/**
 * 点击按钮，发送设置支付密码请求
 **/
- (void)buttonclick:(UIButton *)sender{
    if ([self.zhifuPassword isEqualToString:self.passWordText]) {
       
        [HDLoading showWithImageWithString:@"正在提交"];
        
        
        NSString * url = [NSString stringWithFormat:@"%@register/payPassword",KBaseUrl];
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        if ([LDUserInformation sharedInstance].token != nil){
            [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
        }
        
        if ([LDUserInformation sharedInstance].UserId != nil) {
            [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
        }
        
        if (self.zhifuPassword != nil) {
            [params setObject:[TZMD5 md5:self.zhifuPassword]  forKey:@"payPassword"];
        }
        
        LDNetworkTools * manager = [LDNetworkTools sharedTools];
        
        [manager request:POST url:url params:params callback:^(id response, NSError *error) {
            if (error != nil) {
                
                /** 1.打印请求错误信息*/
                LDLog(@"支付密码error%@",error);
                
                /** 2.网络错误提示*/
                [HDLoading showFailViewWithString:@"网络错误"];
                
            }else{
                
                /** 跳转流程
                 * 1.商品购买页-->登录-->注册-->支付密码-->高级信息-。。。->联系人-->购买页
                 * 2.首页(薪金贷按钮)-->登录--注册-->支付密码-->高级信息-。。。->联系人-->首页
                 * 3.分期(薪金贷按钮)-->登录--注册-->支付密码-->高级信息-。。。->联系人-->分期
                 * 4.信用分-->支付密码-->信用分
                 * 5.我的-->登录-->注册-->支付密码-->我的
                 * 6.确认订单-->支付密码-->高级信息-。。。->联系人-->确认订但
                 **/
                
                
                
                /** 3.解析返回结果 */
                LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
                
                if ([backInfor.code isEqualToString:@"0"]) {
                    
                    
                    if ([self.fromeWhere isEqualToString:@"anquanzhongxin"]) {
                        
                    [HDLoading showSuccessViewWithString:@"支付密码设定成功"];
                        
                    }else{
                        
                    
                    }
                    

                    if ([self.fromeWhere isEqualToString:@""] || self.fromeWhere == nil) {

                        [HDLoading showSuccessViewWithString:@"注册成功"];
                        /** 推出登录注册找回密码流程 */
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                   
                    
                    
                    else{
                        
                        [HDLoading dismissHDLoading];
                        
                        /** 推出登录注册找回密码流程 */
                        if ([self.fromeWhere isEqualToString:@"tuichu"]) {
                            LDTabBarController * tab = [[LDTabBarController alloc] init];
                            
                            [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                        }else{
                            
                            [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
                            
                        }
                        
                    }

                }
  
            }
        }];
        
        
    }else{
        
        /** 4.请求异常提示 */
        [HDLoading showFailViewWithString:@"输入密码不一致"];
    }
    
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
