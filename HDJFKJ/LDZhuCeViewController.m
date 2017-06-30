//
//  LDZhuCeViewController.m
//  HDJFKJ
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//
#import "LDZhuCeViewController.h"
#import "LDPaymentPasswordController.h"
#import "LDTabBarController.h"
#import "LDSignInViewController.h"
#import "YongHuXieYIViewController.h"
#import "LDResponseModel.h"
#import "HDVerificationModel.h"
#import "HDRegisterModel.h"

#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define StringEmpty @""
#import "TZMD5.h"
#define MIMA  '/^[a-zA-Z0-9]{6,32}$/'

@interface LDZhuCeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

//界面按钮
/**
 *  下一步按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

/**
 *  手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**
 *  密码文本
 */
@property (weak, nonatomic) IBOutlet UITextField *passWord;
/**
 *  确认密码文本
 */
@property (weak, nonatomic) IBOutlet UITextField *surePassword;
/**
 *  验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *VerificationCode;
/**
 *  真实验证码
 */
@property (nonatomic, copy) NSString *TimerTextString;
/**
 *  是否同意协议
 */
@property (nonatomic, assign) BOOL isAgreeConsent;

/*
 用户协议
 **/
@property (weak, nonatomic) IBOutlet UIButton *huyongxieyi;


@property(nonatomic,strong)NSString * userNumber;
@property(nonatomic,strong)NSString * passsWord;

//时间戳
@property (nonatomic,strong)NSString * timer;

//保存时间戳
@property(nonatomic,strong)NSString * SHIJianChuo;

//计时器
@property (nonatomic, strong) NSTimer * YZTimer;

//倒计时时间
@property (nonatomic, assign) int time;
@end

@implementation LDZhuCeViewController

- (void)leftButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"saomaRuestLoginSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    LDLog(@"销毁《注册》控制器");
    
}
/**
 *  是否同意协议
 */
- (IBAction)agreeConsent:(UIButton *)sender {
    
    self.isAgreeConsent = !self.isAgreeConsent;
    
    LDLog(@"%d",self.isAgreeConsent);
    
    if (self.isAgreeConsent) {
        
        [sender setImage:[UIImage imageNamed:@"用户协议框"]  forState:UIControlStateNormal];
        
    }else{
        
        [sender setImage:[UIImage imageNamed:@"同意协议"]  forState:UIControlStateNormal];
        
    }
}


#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //背景颜色
    self.view.backgroundColor = LDBackroundColor;
    
    self.navigationItem.title = @"注册";
    
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LDBackroundColor;
    //下一步按钮
    self.nextButton.tag = 1;
    self.nextButton.tintColor = LDDisEnableColor;
    //注册文本输入框变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.phoneNumber addTarget:self action:@selector(shoujihaoTextFeild:) forControlEvents:UIControlEventEditingChanged];
    
    [self.VerificationCode addTarget:self action:@selector(yanzhengma:) forControlEvents:UIControlEventEditingChanged];
    [self.passWord addTarget:self action:@selector(shezhimima:) forControlEvents:UIControlEventEditingChanged];
    if ([self.fromWhere isEqualToString:@"wodezhuce"]) {
        [self createGobackHomePageButton];
    }
    
    self.timeButton.layer.cornerRadius = 5.0;
    self.timeButton.layer.borderWidth = 0.0;
    
    self.nextButton.layer.cornerRadius = 5.0;
    self.timeButton.layer.borderWidth = 0.0;
}

/**
 * 创建导航栏右侧关闭按钮
 **/
- (void)createGobackHomePageButton{
    
    
    UIButton * backPage = [[UIButton alloc]init];
    
    backPage.frame =CGRectMake(0, 0, 30, 30);
    
    [backPage setImage:[UIImage imageNamed:@"X_guanbi"] forState:UIControlStateNormal];

    [backPage addTarget:self action:@selector(ClickdismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backPage];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    
}
/**
 * 关闭控制器
 **/
- (void)ClickdismissButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//验证码位数
-(void)shezhimima:(UITextField*)sender{
    
    if (sender.text.length > 32) {
        sender.text = [NSString stringWithFormat:@"%@",[sender.text substringToIndex:32]];
    }
    
}
//验证验证码位数
-(void)yanzhengma:(UITextField*)textField{
    
    if (textField.text.length > 4) {
        textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:4]];
    }
}

//验证手机号位数
-(void)shoujihaoTextFeild:(UITextField*)textField{
    
    if (textField.text.length > 11) {
        textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:11]];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 文本输入框变化响应方法
-(void)textChange{
    
    if (self.phoneNumber.text.length && self.passWord.text.length&&self.surePassword.text.length) {
        
        self.nextButton.tag = 2;
        
        self.nextButton.tintColor = LDEnableColor;
    } ;
    
}

/**
 * 发送网络请求,获取验证码
 **/
- (void)sendTimerRequest{
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@register/fetchSmsCode",KBaseUrl];
    
    // 参数
    NSDictionary *parameter = @{
                                @"phone":self.phoneNumber.text,
                                @"smsSn":[self timer],
                                @"type":@"0"
                                };
    
    
    [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
        if (error != nil) {//失败
            
            /** 1.打印请求错误信息  */
            LDLog(@"error%@",error);
            
            /** 2.请求错误提示     */
            [MBProgressHUD showError:@"网络错误"];
            
        }
        else//成功
        {
            LDLog(@"%@",response);
            
            
            /** 3.解析返回结果  */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** 4.code值为0，请求正常*/
            if ([backInfor.code isEqualToString:@"0"]) {
                
                /** 获取验证码时的时间戳 */
                self.SHIJianChuo = [parameter objectForKey:@"smsSn"];
                
                
                if (backInfor.result != nil){
                    /** 5.解析验证码  */
                    HDVerificationModel * verification = [HDVerificationModel mj_objectWithKeyValues:backInfor.result];
                    self.TimerTextString = verification.smsCode;
                
                }
                
                
                /** 6.自动填写验证码，非正式环境的地址，自动填写验证码 */
                if ([KBaseUrl isEqualToString:@"http://123.56.41.230/hd-merchant-web/mobile/"]) {
                    self.VerificationCode.text  =self.TimerTextString;
                }
                
                
                
            }else{
                /** 7.提示网络请求异常信息 */
                [MBProgressHUD showError:backInfor.message];
                
                /** 8.请求异常后重置“获取验证码按钮” */
                self.timeButton.userInteractionEnabled = YES;
                [self.timeButton setTitle:@"发送验证码" forState:UIControlStateNormal];

                [self.timeButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
                /** 9.销毁计时器  */
                [self deallocTimer];
                
            }
            
            
            
        }
        
    }];
}


/**
 * 1.验证码点击按钮，校验及倒计时显示
 *
 **/

#pragma mark - 获取验证码点击事件
- (IBAction)sendEvent:(id)sender {
    
    /** 1.正则表达式验证手机号是否正确 */
    if ([self.phoneNumber.text isTelephone:self.phoneNumber.text]) {
        
        /**  2.开启计时器 */
        [self yanZhengMaTimeChange];
        
        /**  3.发送验证码请求  */
        [self sendTimerRequest];
        
    }else{
        /** 4.手机号异常提示   */
        [MBProgressHUD showError:@"请输入正确的手机号码"];
    }
}
//启动计时器，开始倒计时
- (void)yanZhengMaTimeChange{
    
    self.timeButton.userInteractionEnabled = NO;
    self.time = 60;
    [self.timeButton setTitle:@"重新获取(60s)" forState:UIControlStateNormal];
    
    [self.timeButton setBackgroundColor:WHColorFromRGB(0xdedede)];
    
    self.YZTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}
//修改时间
- (void)timeChange{
    
    
    self.time --;
    if (self.time == 0) {
        self.timeButton.userInteractionEnabled = YES;
        [self.timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self.timeButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
        
        [self deallocTimer];
    }else{
        [self.timeButton setTitle:[NSString stringWithFormat:@"重新获取(%.2ds)",self.time] forState:UIControlStateNormal];
    }
}
//销毁计时器
- (void)deallocTimer{
    [self.YZTimer invalidate];
}

#pragma mark - 手机号码合法性验证
- (BOOL)checkPhoneNumber{
    
    if (![self.phoneNumber.text isTelephone:self.phoneNumber.text]) {//不合法的手机号码
        
        [self showFailViewWithString:@"请输入正确的手机号码!"];
        
        return NO;
        
    }else{//正确格式的手机号码
        return YES;
    }
}
#pragma mark - 短信验证码合法性验证
- (BOOL)checkTimerPassWord{
    
    if (![self.TimerTextString isEqualToString:self.VerificationCode.text]) {//验证码不一致
        
        LDLog(@"TimerTextString%@,VerificationCode%@",self.TimerTextString,self.VerificationCode);
        
        [self showFailViewWithString:@"请输入正确的验证码"];
        
        return NO;
    }else{//验证码相同
        
        return YES;
    }
}
#pragma mark - 设定密码合法性验证
- (BOOL)checkPassWord{
    if (([self.passWord.text isRegisterPassword])) {//是密码
        //判断两次密码是否相同
        if (([self.passWord.text isEqualToString:self.surePassword.text])) {//两次密码相同
            
            return YES;
            
        }else{//密码不相同
            
            [self showFailViewWithString:@"两次输入的密码不相同"];
            
            return NO;
   
        }
    }else{
        
        
        [MBProgressHUD showError:@"设置正确的密码"];
        return NO;
        
    }
    
}

- (BOOL)checkAgreeConsent{
    
    if (self.isAgreeConsent == 1) {
        
        [MBProgressHUD showError:@"您未同意注册协议"];
        
        return NO;
        
    }else{
        
        return YES;
        
    }
}




/**
 * 注册请求
 **/
- (void)sendRequest{
    [MBProgressHUD showMessage:@"正在注册"];
    
    NSString * urlString = [NSString stringWithFormat:@"%@register/verifySmsCode",KBaseUrl];
    // 参数
    NSString * MDStr = [TZMD5 md5:self.passWord.text];
    NSDictionary *parameter = @{
                                @"phone":self.phoneNumber.text,
                                @"smsSn":self.SHIJianChuo,
                                @"smsCode":self.VerificationCode.text,
                                @"password":MDStr,
                                };
    
    [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
        if (error != nil)
        {//失败
            /** 1.打印请求错误信息   */
            LDLog(@"error%@",error);
            
            /** 2.网络错误提示  */
            [MBProgressHUD showError:@"网络错误"];
        }
        else
        {//成功
            
            LDLog(@"%@",response);
            
            /** 3.解析返回结果  */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                

                
                
                /** 4.发送登录请求,自动登录 */
                [self sendLoginRequest];
                
                /** 5.解析注册返回数据  */
                if (backInfor.result != nil){
                
                    HDRegisterModel * registerModel = [HDRegisterModel mj_objectWithKeyValues:backInfor.result];
                    
                    /** 6.保存注册返回的数据到本地 */
                    [[NSUserDefaults standardUserDefaults] setObject:registerModel.id forKey:@"id"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:registerModel.token forKey:@"token"];
                    
                    /** 7.给单利赋值 */
                    //保存ID和token
                    [[LDUserInformation sharedInstance] setUserId:registerModel.id];
                    
                    
                    [[LDUserInformation sharedInstance] setToken:registerModel.token];
                }
            
                /** 8.保存手机号和密码至本地 */
                [[NSUserDefaults standardUserDefaults] setObject:self.passWord.text forKey:@"password"];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumber.text forKey:@"phoneNumber"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                
                /** 9.给单利赋值  */
                [[LDUserInformation sharedInstance] setPassWord:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
                
                [[LDUserInformation sharedInstance] setPhoneNumber:[[NSUserDefaults     standardUserDefaults] objectForKey:@"phoneNumber"]];
                
                
                /** 10.注册成功，退出登录注册找回密码功能  */
                
                
                if ([self.fromWhere isEqualToString:@"saomadenglu"]){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"saomaLoginSuccess" object:nil];
                    
                }else{
                    /** 移除指示器*/
                    
                    [MBProgressHUD showSuccess:@"注册成功"];
                    [self performSelector:@selector(zhuceSuccess) withObject:nil afterDelay:1.5];
                    
                }
                
                
                
            }else{
                
                /** 11.请求异常提示  */
                [MBProgressHUD showError:backInfor.message];
            }
            
        }
        
    }];
    
}

- (void)zhuceSuccess{

    if ([self.fromWhere isEqualToString:@"saomadenglu"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saomaLoginSuccess" object:nil];
    }else{
        
        
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

//登录网络请求
- (void)sendLoginRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@login/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    NSString * string = [TZMD5 md5:self.passWord.text];
    [params setObject:self.phoneNumber.text forKey:@"phone"];
    [params setObject:string forKey:@"password"];
    /** 渠道名称 */
    [params setObject:@"iOS" forKey:@"platform"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印请求错误信息 */
            LDLog(@"%@",error);
            
        }else{
            
            /**  解析返回结果 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** code值为0，返回结果正常 */
            if ([backInfor.code isEqualToString:@"0"]) {
                
                if (backInfor.result != nil){
                    [self analysisResponse:backInfor.result];
                
                }
                LDLog(@"%@",@"注册页，注册后登陆成功");
                
            }
            
        }
    }];
}


//解析返回数据.首页全局数据存储
- (void)analysisResponse:(id)result{
    
    //归档存储用户信息
    [NSKeyedArchiver archiveRootObject:result toFile:UserInfoDict];
    
}


//用户协议
- (IBAction)sender:(id)sender {
    
    YongHuXieYIViewController * yonghuxieyi = [[YongHuXieYIViewController alloc]initWithURL:registerUserUrl];
    [self.navigationController pushViewController:yonghuxieyi animated:YES];
    
}
- (IBAction)nextButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    /** 验证手机号的合法性 */
    if ([self checkPhoneNumber]) {
        
        
        /** 验证码获取后时间戳不为空 */
        if (self.SHIJianChuo != nil) {
            
            /** 验证验证码不为空 */
            if (self.VerificationCode.text.length > 0) {
                
                /** 验证密码 */
                if ([self checkPassWord]) {
                    
                    /** 验证是否同意注册协议 */
                    if ([self checkAgreeConsent]) {
                        
                        if ([self.fromWhere isEqualToString:@"saomadenglu"]){
                            
                            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saomaRuestLoginSuccess) name:@"saomaRuestLoginSuccess" object:nil];
                        }
                        
                        
                        [self sendRequest];
                    }
                }
            }
            else{
                
                [self showFailViewWithString:@"验证码不能为空"];
            }
        }
        else{
        
            [self showFailViewWithString:@"您还没有获取验证码"];
        }
       
        
    }
}
/** 扫码———登录———请求扫码数据---推出注册页*/
- (void)saomaRuestLoginSuccess{
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    BOOL isAllowInput = YES;
    NSString * setText = textField.text;
    
    if (textField == self.passWord) {
        NSString * allowCharacters = kAlphaNum;
        NSCharacterSet * setOfnonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:allowCharacters]invertedSet];
        if ([string stringByTrimmingCharactersInSet:setOfnonNumberSet].length > 0) {
            if (setText.length + string.length > 18) {
                isAllowInput = NO;
            }
        }
        else if (![string isEqualToString:StringEmpty]){
            
            isAllowInput = NO;
        }
    }
    return isAllowInput;
    
    
}



//无用的设置密码数字字母混合写
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$ : )(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}
-(NSString *)timer
{
    
    _timer =[NSString stringWithFormat:@"%ld",time(nil)];
    return _timer;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end

