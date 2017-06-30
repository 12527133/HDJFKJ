//
//  LDSignInViewController.m
//  HDJFKJ
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//


#import "LDSignInViewController.h"
#import "LDTabBarController.h"
#import "LDZhuCeViewController.h"
#import "WHUserLoginModel.h"
#import "LDFindPassViewController.h"
#import "LDNavgationVController.h"
#import "LDZhuCeViewController.h"
#import "TZMD5.h"


@interface LDSignInViewController ()<UITextFieldDelegate>
//手机号输入框
@property (strong, nonatomic) UITextField *phoneNumberTextFiled;
//密码框
@property (strong, nonatomic) UITextField *passWordTextFiled;
//登录按钮
@property (strong, nonatomic) UIButton *nextButton;
//手机号图标
@property (strong, nonatomic) UIImageView * phoneImageView;
//密码图标
@property (strong, nonatomic) UIImageView * passwordImageView;
//忘记密码按钮
@property (strong, nonatomic) UIButton * forgetButton;

@end

@implementation LDSignInViewController
@synthesize number;

- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    
    //设置状态栏的前景色为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置状态栏的前景色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
//忘记密码响应方法
- (void)forgetPassWordButtonClick:(UIButton *)sender {
    
    
    LDFindPassViewController * findVC = [[LDFindPassViewController alloc] init];
    
    findVC.fromWhere = self.fromWhere;
    
    [self.navigationController pushViewController:findVC animated:YES];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置登录按钮状态.透明度
    
    self.phoneNumberTextFiled.text = self.number;
    
    
    //设置登录按钮状态.透明度
    
    self.nextButton.userInteractionEnabled = self.phoneNumberTextFiled.text.length && self.passWordTextFiled.text.length;
    
    //设置文本框代理
    self.phoneNumberTextFiled.delegate  =self;
    self.passWordTextFiled.delegate = self;
    
    //注册文本输入框变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self createUIView];
}

/** 扫码———登录———请求扫码数据---推出登录页*/
- (void)saomaRuestLoginSuccess{
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


//创建视图中的控件
-(void)createUIView{
    
    self.view.backgroundColor = WHColorFromRGB(0xf6f6f6);
    
    /**
     * 1.创建关闭按钮
     **/
    UIImageView * quxiao = [[UIImageView alloc]initWithFrame:CGRectMake(18, 38, 15, 15)];
    quxiao.image = [UIImage imageNamed:@"quxiao"];
    [self.view addSubview:quxiao];
    
    //创建按钮
    UIButton * shartButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 50)];
    [shartButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:shartButton];
    
    /**
     * 2.创建logo
     **/
    NSString * imageName = @"login_logo";
    
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((LDScreenWidth - 90*bili)/2, 90 * bili, 90*bili, 90*bili)];
    logoImageView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:logoImageView];
    
    /**
     * 3.创建登录窗
     **/
    //登录窗背景
    UIView * loginBackView = [[UIView alloc]initWithFrame:CGRectMake(0, logoImageView.frame.origin.y + 150*LDScreenWidth/375, LDScreenWidth, 90)];
    loginBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginBackView];
    
    //输入手机号小图标
    self.phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 23, 23)];
    self.phoneImageView.image = [UIImage imageNamed:@"手机号ICON"];
    [loginBackView addSubview:self.phoneImageView];
    
    //输入密码小图标
    self.passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 56, 23, 23)];
    self.passwordImageView.image = [UIImage imageNamed:@"密码ICON"];
    [loginBackView addSubview:self.passwordImageView];
    
    //手机号输入框，textfield
    self.phoneNumberTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, LDScreenWidth - 85, 45)];
    self.phoneNumberTextFiled.placeholder = @"请输入手机号";
    [loginBackView addSubview:self.phoneNumberTextFiled];
    self.phoneNumberTextFiled.textColor = WHColorFromRGB(0x2b2b2b);
    self.phoneNumberTextFiled.font = [UIFont systemFontOfSize:15];
    self.phoneNumberTextFiled.delegate = self;
    self.phoneNumberTextFiled.keyboardType = UIKeyboardTypePhonePad;
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    self.phoneNumberTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if ([LDUserInformation sharedInstance].phoneNumber != nil) {
        self.phoneNumberTextFiled.text = [LDUserInformation sharedInstance].phoneNumber;
        self.phoneImageView.image = [UIImage imageNamed:@"手机号ICON 选中"];
    }
    
    //密码输入框
    self.passWordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(70,45, LDScreenWidth - 85, 45)];
    self.passWordTextFiled.placeholder = @"请输入密码";
    [loginBackView addSubview:self.passWordTextFiled];
    self.passWordTextFiled.textColor = WHColorFromRGB(0x2b2b2b);
    self.passWordTextFiled.font = [UIFont systemFontOfSize:15];
    self.passWordTextFiled.delegate = self;
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    self.passWordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 用语密码输入
    self.passWordTextFiled.secureTextEntry = YES;
    
    //手机输入框和密码输入框方法
    [self.phoneNumberTextFiled addTarget:self action:@selector(phoneNumberChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordTextFiled addTarget:self action:@selector(passwordChange:) forControlEvents:UIControlEventEditingChanged];
    
    //忘记密码按钮
    self.forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(LDScreenWidth - 78, 45, 78, 45)];
    [self.forgetButton setBackgroundColor:[UIColor whiteColor]];
    [self.forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    self.forgetButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.forgetButton addTarget:self action:@selector(forgetPassWordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBackView addSubview:self.forgetButton];
    
    
    //分割xian
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
    line1.backgroundColor = WHColorFromRGB(0xd9d9d9);
    [loginBackView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(20, 45, LDScreenWidth-20, 0.5)];
    line2.backgroundColor = WHColorFromRGB(0xd9d9d9);
    [loginBackView addSubview:line2];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 89.5, LDScreenWidth, 0.5)];
    line3.backgroundColor = WHColorFromRGB(0xd9d9d9);
    [loginBackView addSubview:line3];
    
    /**
     * 登录按钮
     **/
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(13, loginBackView.frame.origin.y + 90 + 26*LDScreenWidth/375 , 350*LDScreenWidth/375, 45*LDScreenWidth/375)];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"login_botton"] forState:UIControlStateNormal];
    [self.nextButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:WHColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    self.nextButton.titleLabel.alpha = 0.5;
    self.nextButton.userInteractionEnabled = NO;
    /**
     * 马上注册按钮
     **/
    //“没有账号”Label
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 30*LDScreenWidth/375, LDScreenWidth/2, 13)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"没有账号?";
    label.textColor = WHColorFromRGB(0x5e5e5e);
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    //注册按钮
    UIButton * registerButton = [[UIButton alloc]initWithFrame:CGRectMake(LDScreenWidth/2, self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 30*LDScreenWidth/375, 54, 13)];
    [registerButton setTitle:@"马上注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:registerButton];
    
    
}

//手机号输入发生变化方法
-(void)phoneNumberChange:(UITextField*)textField{
    
    //限制输入的手机号为11位
    if (textField.text.length > 11) {
        
        textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:11]];
    }
    //改变输入后手机号图标变化
    if (textField.text.length > 0) {
        self.phoneImageView.image = [UIImage imageNamed:@"手机号ICON 选中"];
    }
    else{
        self.phoneImageView.image = [UIImage imageNamed:@"手机号ICON"];
    }
}
//密码收入发生变化方法
- (void)passwordChange:(UITextField *)textField{
    if (textField.text.length > 0) {
        self.passwordImageView.image = [UIImage imageNamed:@"密码ICON 选中"];
        self.forgetButton.hidden = YES;
    }
    else{
        self.passwordImageView.image = [UIImage imageNamed:@"密码ICON"];
        self.forgetButton.hidden = NO;
    }
}

#pragma mark - 文本输入框变化响应方法
-(void)textChange{
    
    self.nextButton.userInteractionEnabled = self.phoneNumberTextFiled.text.length && self.passWordTextFiled.text.length;
    
    self.nextButton.titleLabel.alpha = self.nextButton.enabled ? 1 : 0.5;
    
}
//文本框编辑开始
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    float distance = LDScreenHeight - self.nextButton.frame.origin.y;
    if (distance < 216) {
        [UIView animateWithDuration:0.35f animations:^{
            self.view.frame = CGRectMake(0, distance - 216, LDScreenWidth, LDScreenHeight);
            
        }];
    }
}
//文本框编辑结束
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.35f animations:^{
        self.view.frame = CGRectMake(0, 0, LDScreenWidth, LDScreenHeight);
        
    }];
}


#pragma mark - dealloc
-(void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"saomaRuestLoginSuccess" object:nil];
    LDLog(@"销毁登录控制器");
}

#pragma mark - 登录按钮
- (void)nextButtonClick:(UIButton *)sender {
    
    //判断用户名是否是正确的手机号码
    //是正确的手机号码
    
    if ([_phoneNumberTextFiled.text isTelephone:_phoneNumberTextFiled.text]) {
        
        
        //判断密码是否正确
        if ([_passWordTextFiled.text isPassword]) {//如果密码正确
            
            if ([self.fromWhere isEqualToString:@"saomadenglu"]){
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saomaRuestLoginSuccess) name:@"saomaRuestLoginSuccess" object:nil];
            }
            
            //发送登录网络请求
            [self sendRequest];
            
        }else{//用户名或密码错误
            [HDLoading showFailViewWithString:@"用户名或密码不正确"];
        }
        
    }else{//不是正确的手机号码
        [HDLoading showFailViewWithString:@"请输入正确的手机号码!"];
        
    }
    
    //用户名和密码都正确结束编辑,
    [self.view endEditing:YES];
    
    
}

- (void)registerButtonClick:(UIButton *)sender {
    
    LDZhuCeViewController * zhuceVC = [[LDZhuCeViewController alloc] init];
    zhuceVC.fromWhere = self.fromWhere;
    [self.navigationController pushViewController:zhuceVC animated:YES];
    
}

- (void)backButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([self.fromWhere isEqualToString:@"tuichu"]) {
        LDTabBarController * tab = [[LDTabBarController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
        
    }
    
    
}

//登录网络请求
- (void)sendRequest{
    
    
    [HDLoading showWithImageWithString:@"正在登录"];
    NSString * str = [NSString stringWithFormat:@"%@login/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    //手机号和密码
    NSString * string = [TZMD5 md5:self.passWordTextFiled.text];
    [params setObject:self.phoneNumberTextFiled.text forKey:@"phone"];
    [params setObject:string forKey:@"password"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            // 显示失败信息
            [HDLoading showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            /** 解析返回结果 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** code值为0，请求正常*/
            if ([backInfor.code isEqualToString:@"0"]) {
                
                if ([self.fromWhere isEqualToString:@"saomadenglu"]){
                    
                }else{
                    /** 移除指示器*/
                    [HDLoading dismissHDLoading];
                    
                }
                
                
                
                if (backInfor.result != nil) {
                    
                    /** 1.保存登录后的信息到本地*/
                    [self analysisResponse:backInfor.result];
                    
                    /** 2.解析登录分会数据 */
                    WHUserLoginModel * userModel = [WHUserLoginModel mj_objectWithKeyValues:backInfor.result];
                    
                    /** 3.保存id，token  */
                    [[NSUserDefaults standardUserDefaults] setObject:userModel.id forKey:@"id"];
                    [[NSUserDefaults standardUserDefaults] setObject:userModel.token forKey:@"token"];
                    
                    /** 4.给单利赋值 */
                    //保存ID和token
                    [[LDUserInformation sharedInstance] setUserId:userModel.id];
                    
                    [[LDUserInformation sharedInstance] setToken:userModel.token];
                    
                    [[LDUserInformation sharedInstance] setPhoneNumber:self.phoneNumberTextFiled.text];
                    
                    [[LDUserInformation sharedInstance] setPassWord:self.passWordTextFiled.text];
                    [[LDUserInformation sharedInstance] setUserName:userModel.idName];
                    
                }
                
                /** 5.保存登录密码和手机号 */
                [[NSUserDefaults standardUserDefaults] setObject:self.passWordTextFiled.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumberTextFiled.text forKey:@"phoneNumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                /** 6.数据统计  */
                [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:Login];
                
                
                if ([self.fromWhere isEqualToString:@"saomadenglu"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"saomaLoginSuccess" object:nil];
                }
                else{
                    
                    /** 7.退出登录注册忘记密码流程 */
                    if ([self.fromWhere isEqualToString:@"tuichu"]) {
                        LDTabBarController * tab = [[LDTabBarController alloc] init];
                        
                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                    }else{
                        
                        /** 注册登录请求通知 */
                        
                        
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
                        
                    }
                }
                
                
                
                
            }
            /** 9.处理返回结果异常，提示异常信息*/
            else
            {
                [HDLoading showFailViewWithString:backInfor.message];
                
            }
            
        }
    }];
}


/** 解析返回数据 */
- (void)analysisResponse:(id)result{
    
    /** 归档存储用户信息*/
    [NSKeyedArchiver archiveRootObject:result toFile:UserInfoDict];
    
}

@end
