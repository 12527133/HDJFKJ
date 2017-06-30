//
//  LDRestPassWordController.m
//  HDJFKJ
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDRestPassWordController.h"
#import "LDFirstViewController.h"
#import "LDTabBarController.h"
#import "WHUserLoginModel.h"
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#import "TZMD5.h"


@interface LDRestPassWordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *surePassword;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;


//导航栏
@property(nonatomic,strong)UIView * NavigationView;
//导航栏上的文字
@property(nonatomic,strong)UILabel * label;
//导航栏按钮
@property(nonatomic,strong)UIButton * button;
//导航栏下的那条线
@property(nonatomic,strong)UILabel * label2;
//时间戳
@property(nonatomic,strong)NSString * timer;

@end

@implementation LDRestPassWordController
/**
 *  重置密码提交
*/
- (IBAction)sureButtonClick:(UIButton *)sender {
    if ([self checkPassWord]) {
        
        if ([self.fromWhere isEqualToString:@"saomadenglu"]){
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saomaRuestLoginSuccess) name:@"saomaRuestLoginSuccess" object:nil];
        }
        
        
        [self sendRequest];
        
    }
   
}
/** 扫码———登录———请求扫码数据---推出找回密码页*/
- (void)saomaRuestLoginSuccess{
    
    [MBProgressHUD showError:@"重置密码成功"];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)dealloc{

    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"saomaRuestLoginSuccess" object:nil];
    
    
    LDLog(@"销毁找回密码填写密码控制器 ");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}
//登录网络请求
- (void)sendLoginRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@login/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    //手机号和密码
    NSString * string = [TZMD5 md5:self.password.text];
    
    [params setObject:self.phoneNumber forKey:@"phone"];
    
    [params setObject:string forKey:@"password"];
    
    /** 渠道名称 */
    [params setObject:@"iOS" forKey:@"platform"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1. 显示失败信息  */
            LDLog(@"%@",error);
            
        }else{
            
            /** 2.解析返回结果  */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** 3.返回码值为0，请求正常*/
            if ([backInfor.code isEqualToString:@"0"]) {
                
                if (backInfor.result != nil){
                
                    /** 4.持久存储登录后返回信息  */
                    [self analysisResponse:backInfor.result];
                    
                    /** 5.解析登录返回信息  */
                    WHUserLoginModel * userModel = [WHUserLoginModel mj_objectWithKeyValues:backInfor.result];
                    
                    /** 6.持久化部分登录后返回信息  */
                    [[NSUserDefaults standardUserDefaults] setObject:userModel.id forKey:@"id"];
                    [[NSUserDefaults standardUserDefaults] setObject:userModel.token forKey:@"token"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"password"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumber forKey:@"phoneNumber"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    /** 7.给单利赋值  */
                    [[LDUserInformation sharedInstance] setUserId:userModel.id];
                    [[LDUserInformation sharedInstance] setToken:userModel.token];
                    [[LDUserInformation sharedInstance] setPhoneNumber:self.phoneNumber];
                    [[LDUserInformation sharedInstance] setPassWord:self.password.text];
                }
                
                
                if ([self.fromWhere isEqualToString:@"saomadenglu"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"saomaLoginSuccess" object:nil];
                }
                else{
                
                    [MBProgressHUD showError:@"重置密码成功"];
                    
                    /** 推出登录注册找回密码流程 */
                    if ([self.fromWhere isEqualToString:@"tuichu"]) {
                        LDTabBarController * tab = [[LDTabBarController alloc] init];
                        
                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                    }else{
                        
                        /** 注册登录请求通知 */
                        
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
                        
                    }
                }
                
                
                
                LDLog(@"%@",@"登录成功");
                
            }
            
        }
    }];
}

//重置密码请求
- (void)sendRequest{
    
    [MBProgressHUD showMessage:@"正在重置密码"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@login/resetPassword",KBaseUrl];
    
    // 参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"token"] = [LDUserInformation sharedInstance].token;
    parameter[@"id"] = [LDUserInformation sharedInstance].UserId;
    parameter[@"password"] = [TZMD5 md5:self.surePassword.text];
    
    NSLog(@"%@",parameter);
    [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
        if (error != nil)
        {//失败
            
            /** 1.打印请求错误原因  */
            LDLog(@"error%@",error);
            
            /** 2.请求错误提示   */
            [MBProgressHUD showError:@"网络错误"];
        }
        else
        {//成功
            
            LDLog(@"resonse%@",response);
            
            /** 3.解析返回结果  */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            if ([backInfor.code isEqualToString:@"0"])
            {
                
                
                
                /** 4.重置成功后发送登录请求  */
                [self sendLoginRequest];
                
                
            }
            else
            {
                /** 5.请求异常提示  */
                [MBProgressHUD showError:backInfor.message];
    
            }
            
        }
        
    }];
    



}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置登录密码";
    
    [self.password addTarget:self action:@selector(chongzhimima:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
    
    self.nextButton.layer.cornerRadius = 5.0;
    self.nextButton.layer.borderWidth = 0.0;

}
- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tap{
    
    
    [self.view endEditing:YES];
}
-(void)chongzhimima:(UITextField*)sender{

    if (sender.text.length > 32) {
        sender.text = [NSString stringWithFormat:@"%@",[sender.text substringToIndex:32]];
    }
    

}




-(void)creatNaview{
    self.NavigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.NavigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.NavigationView];
    
    CGFloat X = (LDScreenWidth- 60)/2;
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(X, 31, 60, 20)];
    self.label.text = @"重置密码";
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.NavigationView addSubview:self.label];
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavigationView.frame.size.height - 1, self.view.frame.size.width, 1)];
    self.label2.backgroundColor = [UIColor lightGrayColor];
    self.label2.alpha = 0.7;
    [self.NavigationView addSubview:self.label2];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设定密码合法性验证
- (BOOL)checkPassWord{
    
    if (([self.password.text isPassword])) {//是密码
        //判断两次密码是否相同
        if (([self.password.text isEqualToString:self.surePassword.text])) {//两次密码相同
            
            return YES;
            
        }else{//密码不相同
            [self showFailViewWithString:@"两次输入的密码不相同"];
            
            return NO;
            
            
            
        }
    }else{
        
        [MBProgressHUD showError:@"设定正确的密码"];
        return NO;
        
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSCharacterSet * cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;

}


-(NSString *)timer{

    _timer = [NSString stringWithFormat:@"%ld",time(nil)];
    return _timer;

}

//解析返回数据.首页全局数据存储
- (void)analysisResponse:(id)result{
    
    //归档存储用户信息
    [NSKeyedArchiver archiveRootObject:result toFile:UserInfoDict];
    
}

@end
