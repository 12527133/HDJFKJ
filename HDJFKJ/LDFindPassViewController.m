//
//  LDFindPassViewController.m
//  HDJFKJ
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDFindPassViewController.h"
#import "LDRestPassWordController.h"
#import "HDVerificationModel.h"
#import "HDRegisterModel.h"
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#import "TZMD5.h"

@interface LDFindPassViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *passWord;
@property (weak, nonatomic) IBOutlet UIButton *getPasssWord;
@property (nonatomic,strong)NSString * timer;
/**
 *  倒计时时间,多少秒
 */
@property (nonatomic, assign) NSInteger durationOfCountDown;

/** 保存倒计时按钮的非倒计时状态的title */
@property (nonatomic, copy) NSString *originalTitle;

/** 保存倒计时的时长 */
@property (nonatomic, assign) NSInteger tempDurationOfCountDown;

/** 定时器对象 */
@property (nonatomic, strong) NSTimer *countDownTimer;

/**
 *  用户输入验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *passNumber;

/**
 *  真实验证码
 */
@property (nonatomic, copy) NSString *TimerTextString;

/** 时间戳 */
@property (nonatomic, strong) NSString * shijianchuo;

@end

@implementation LDFindPassViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

/** 时间戳 */
-(NSString *)getshijianchuo
{
    
    NSString * shijianchuo =[NSString stringWithFormat:@"%ld",time(nil)];
    return shijianchuo;
    
}

/**
 *  发送网络请求获取验证码
*/
- (IBAction)getPassWordButtonClick:(id)sender {
    
    if ([self checkPhoneNumber]) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@login/fetchSmsCode",KBaseUrl];
        
        // 参数
        NSDictionary *parameter = @{
                                    @"phone":self.phoneNum.text,
                                    @"smsSn":[self getshijianchuo],
                                    @"type":@"1"
                                    };
        
        [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
            if (error != nil)
            {//失败
                
                /** 1.打印请求错误原因  */
                LDLog(@"error%@",error);
                
                /** 2.请求错误提示   */
                [MBProgressHUD showError:@"网络错误"];
            }
            else
            {
                
                LDLog(@"resonse%@",response);
                
                /** 3.解析返回结果  */
                LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
                
                if ([backInfor.code isEqualToString:@"0"])
                {
                    
                    
                    self.shijianchuo = parameter[@"smsSn"];
                    
                    [self changButton];
                    
                    /** 4.解析注册结果  */
                    if (backInfor.result != nil)
                    {
                        HDVerificationModel * verification = [HDVerificationModel mj_objectWithKeyValues:backInfor.result];
                        
                        if (verification.smsCode != nil)
                        {
                            self.TimerTextString = verification.smsCode;
                        }
                    }
                    
                    /** 5.非正式环境自动填写验证码  */
                    if ([KBaseUrl isEqualToString:@"http://123.56.41.230/hd-merchant-web/mobile/"])
                    {
                        
                        self.passNumber.text = self.TimerTextString;
                    }
                    
                }
                else
                {
                    
                    /** 6.请求异常提示  */
                    [MBProgressHUD showError:backInfor.message];
                }
                
                
            }
            
        }];
       

    }
   
    
}


- (void)changButton{
    
    __block int timeout=58; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [self.getPasssWord setBackgroundColor:WHColorFromRGB(0x4279d6)];
                self.getPasssWord.enabled = YES;
                
                self.getPasssWord.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            
            int seconds = timeout % 59;
            
            NSString *strTime = [NSString stringWithFormat:@"重新获取(%.2d)", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [self.getPasssWord setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateDisabled];
                
                [self.getPasssWord setBackgroundColor:WHColorFromRGB(0xdedede)];
                self.getPasssWord.enabled = NO;
                self.getPasssWord.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}

- (BOOL)checkPhoneNumber{
    
    if (![self.phoneNum.text isTelephone:self.phoneNum.text]) {//不合法的手机号码
        
        [self showFailViewWithString:@"请输入正确的手机号码!"];
        
        return NO;
        
    }else{//正确格式的手机号码
        
        return YES;
    }
}
- (void)sendRequest{
    NSString *urlString = [NSString stringWithFormat:@"%@login/verifySmsCode",KBaseUrl];
    
    // 参数
    NSDictionary *parameter = @{
                                @"phone":self.phoneNum.text,
                                @"smsSn":self.shijianchuo,
                                @"smsCode":self.passNumber.text,
                                };
    
    [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
        if (error != nil)
        {//失败
            
            /** 1.打印请求错误  */
            LDLog(@"error%@",error);
            
            
        }
        else
        {//成功
            LDLog(@"resonse%@",response);
            
            /** 2.解析返回结果*/
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];

            /** 3. code值为0，请求结果正常  */
            if ([backInfor.code isEqualToString:@"0"]) {
                
                /** 4.解析验证手机结果  */
                if (backInfor.result != nil) {
                    HDRegisterModel * registerModel = [HDRegisterModel mj_objectWithKeyValues:backInfor.result];
                    
                    /** 5.持久存储token，id */
                    [[NSUserDefaults standardUserDefaults] setObject:registerModel.id forKey:@"id"];
            
                    [[NSUserDefaults standardUserDefaults] setObject:registerModel.token forKey:@"token"];
                    
                    /** 6.给单利赋值  */
                    [[LDUserInformation sharedInstance] setPhoneNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
                    
                    [[LDUserInformation sharedInstance] setUserId:registerModel.id];
                    
                    [[LDUserInformation sharedInstance] setToken:registerModel.token];
                }
                
                /** 7.持久存储手机号 */
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneNum.text forKey:@"phoneNumber"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
               
                
                /** 8.推出重置密码页  */
                
                LDRestPassWordController * vc = [[LDRestPassWordController alloc] init];
                
                vc.phoneNumber = self.phoneNum.text;
                
                vc.fromWhere = self.fromWhere;
                [self.navigationController pushViewController:vc animated:YES];


                
            }else{
                
                /** 9.提示请求异常原因 */
                [MBProgressHUD showError:backInfor.message];
            }
            
        }
        
    }];


}

- (IBAction)nextButtonClick:(id)sender {
    
    if ([self.phoneNum.text isTelephone:self.phoneNum.text]) {
        
        
        if (self.shijianchuo != nil) {
            
            if (self.passNumber.text.length > 0) {
                
                [self sendRequest];
            }
            else{
            
                [self showFailViewWithString:@"请输入验证码"];
            }
            
        }
        else{
        
            [self showFailViewWithString:@"您还没有获取验证码"];
        }
        
    }else{
    
        [self showFailViewWithString:@"请输入正确的手机号"];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"找回登录密码";
    
    /** 设置手机号，验证码变化的textField的方法 */
    [self.passNumber addTarget:self action:@selector(yanzhengma:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneNum addTarget:self action:@selector(ShoujiHao:) forControlEvents:UIControlEventEditingChanged];
    
    /** 设置键盘 */
    self.passNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    
    
    //消除第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
    
    self.getPasssWord.layer.cornerRadius = 5.0;
    self.getPasssWord.layer.borderWidth = 0.0;
    
    self.nextButton.layer.cornerRadius = 5.0;
    self.nextButton.layer.borderWidth = 0.0;
    
}

- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tap{
    
    
    [self.view endEditing:YES];
}

-(void)ShoujiHao:(UITextField*)sender{
    if (sender.text.length > 11) {
        sender.text = [NSString stringWithFormat:@"%@",[sender.text substringToIndex:11]];
    }


}

-(void)yanzhengma:(UITextField*)textField{
    
    if (textField.text.length > 4) {
        textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:4]];
    }
}





-(NSString*)timer{
    _timer = [NSString stringWithFormat:@"%ld",time(nil)];
    return _timer;


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
