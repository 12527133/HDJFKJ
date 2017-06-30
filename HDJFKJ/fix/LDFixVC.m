//
//  LDFixVC.m
//  MerchantEdition
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDFixVC.h"
#import "TZMD5.h"
#import "LDUserInformation.h"
#import "HDVerificationModel.h"

@interface LDFixVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLable;

/**
 *  获取验证码button
 */
@property (weak, nonatomic) IBOutlet UIButton *titmeButton;
/**
 *  用户手动输入的验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *inputCode;
/**
 *  网络请求下来的正确验证码
 */
@property (nonatomic,copy) NSString * realCode;

/**
 *  用户手动输入的密码
 */
@property (weak, nonatomic) IBOutlet UITextField *payPassWord;
/**
 *  用户二次手动输入的密码
 */
@property (weak, nonatomic) IBOutlet UITextField *againPassWord;
/**
 *  提示lable,根据记入不同修改项,文字不同,(修改支付密码,修改登录密码)
 */
@property (weak, nonatomic) IBOutlet UILabel *payPassWordLable;
/**
 *  下一步按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *nextButtob;

//时间戳
@property (nonatomic, strong) NSString * smsSn;

@property (nonatomic, weak) NSTimer * timer;

@property (nonatomic, assign) NSInteger timeSecond;

@end

@implementation LDFixVC
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (LDScreenHeight == 480) {
        
            if (textField == self.inputCode) {
                LDLog(@"inputCode");
                [UIView animateWithDuration:0.25 animations:^{
        
                    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        
                }];
        
            }
        
            if (textField == self.payPassWord) {
                LDLog(@"payPassWord");
                [UIView animateWithDuration:0.25 animations:^{
        
                self.view.transform = CGAffineTransformMakeTranslation(0, -70);
        
                }];
        
            }
        
            if (textField == self.againPassWord) {
        
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.view.transform = CGAffineTransformMakeTranslation(0, -90);
                    
                }];
            }
        
    }


    return YES;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.ISPay) {
        
        self.title = @"修改支付密码";
        
        self.payPassWord.keyboardType = UIKeyboardTypeNumberPad;
        self.againPassWord.keyboardType = UIKeyboardTypeNumberPad;
        
    }else{
        
        self.title = @"修改登录密码";
        self.payPassWord.placeholder = @"6-32位数字和字母组合";
        self.payPassWordLable.text  =@"登录密码";
    }
    
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    self.payPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 用语密码输入
    self.payPassWord.secureTextEntry = YES;
    
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    self.againPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 用语密码输入
    self.againPassWord.secureTextEntry = YES;
    
    
    [self.payPassWord addTarget:self action:@selector(dishTextFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    
    [self.againPassWord addTarget:self action:@selector(dishTextFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    
    
    self.inputCode.delegate = self;
    self.payPassWord.delegate = self;
    self.againPassWord.delegate = self;
    self.phoneNumberLable.text  = [LDUserInformation sharedInstance].phoneNumber;
    
    self.titmeButton.layer.cornerRadius = 5.0;
    self.titmeButton.layer.borderWidth = 0.0;
    
    self.nextButtob.layer.cornerRadius = 5.0;
    self.nextButtob.layer.borderWidth = 0.0;
}


- (void)dishTextFieldDidChange:(UITextField *)sender{

    if ([self.title isEqualToString:@"修改支付密码"]) {
        if (sender.text.length > 6) {
            sender.text = [sender.text substringToIndex:6];
        }
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        
    }];
    
}

- (BOOL)checkVerCode{
    
    
    if ([self.inputCode.text isEqualToString:self.realCode]) {
        //验证码正确
        return YES;
        
    }else{
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的验证码!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [avc addAction:action];
        
        [self presentViewController:avc animated:YES completion:nil];
        
        return NO;

        
    }
}


- (BOOL)checkPassWord{
   
    if (self.payPassWord.text.length == 6) {
        
        if ([self.payPassWord.text isEqualToString:self.againPassWord.text]) {
            
            
            return YES;
            
            
        }else{
            
            UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次密码不一致!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [avc addAction:action];
            
            [self presentViewController:avc animated:YES completion:nil];
            
            
            return NO;
        }

    }else{
    
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请设置六位支付密码!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [avc addAction:action];
        
        [self presentViewController:avc animated:YES completion:nil];
        
        
        return NO;
        
    
    }
    
}

- (IBAction)nextButtonClick:(id)sender {
    
    
    
    
    if (self.ISPay) {//支付密码
        
        
        
        if ((self.payPassWord.text.length != 0)&&(self.againPassWord.text.length != 0)) {
            
            if ([self checkVerCode]) {
                
                if ([self checkPassWord]) {
                    
                    [self sendChangePayPassWordRequest];
                }
                
            }
        }else{
            
            UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请将信息补充完整" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [avc addAction:action];
            
            [self presentViewController:avc animated:YES completion:nil];
            
            
        }
        

    }else{//登录密码
    
        
        
        if ((self.payPassWord.text.length != 0)&&(self.againPassWord.text.length != 0)) {
            
            if ([self checkVerCode]) {//验证码正确
                if (self.payPassWord.text.length > 32) {
                    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码位数需小于32位" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }];
                    
                    [avc addAction:action];
                    
                    [self presentViewController:avc animated:YES completion:nil];
                }
                else if (self.payPassWord.text.length < 6){
                    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码位数需大于6位" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }];
                    
                    [avc addAction:action];
                    
                    [self presentViewController:avc animated:YES completion:nil];
                    
                
                }
                else{
                
                    if (([self.payPassWord.text isRegisterPassword])) {//是密码
                        
                        //判断两次密码是否相同
                        if (([self.payPassWord.text isEqualToString:self.againPassWord.text])) {//两次密码相同
                            
                            [self sendChangeLoginPassWordRequest];
                        }else{//密码不相同
                            
                            UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次密码设定不相同" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                
                            }];
                            
                            [avc addAction:action];
                            
                            [self presentViewController:avc animated:YES completion:nil];
                          
                        }
                    }else{
                        
                        
                        UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请设定6-32位数字和字母组合密码" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            
                        }];
                        
                        [avc addAction:action];
                        
                        [self presentViewController:avc animated:YES completion:nil];
                        
                    }
                    
                }

                
            }
          
        }else{
            
            UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请将信息补充完整" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [avc addAction:action];
            
            [self presentViewController:avc animated:YES completion:nil];
            
            
        }

    }
    
}


/**
 *  修改登录密码请求
 */
- (void)sendChangeLoginPassWordRequest{
    
    [MBProgressHUD showMessage:@"请稍后..."];
    NSString *urlString = [NSString stringWithFormat:@"%@login/resetPassword",KBaseUrl];
    
    //参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"password"] = [TZMD5 md5:self.againPassWord.text];
    
    parameter[@"token"] = [LDUserInformation sharedInstance].token;
    parameter[@"id"] = [LDUserInformation sharedInstance].UserId;
    
    parameter[@"smsCode"] = self.inputCode.text;
    parameter[@"smsSn"] = [NSString stringWithFormat:@"%@",self.smsSn];
   parameter[@"phone"] = self.phoneNumberLable.text;
    
   [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
        
        if (error != nil) {//失败
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"请求失败,请重试"];
            
        }else{
            
            LDLog(@"resonse%@",response);
            
            /** 3.解析返回信息  */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                [MBProgressHUD showSuccess:@"修改成功"];
                LDLog(@"%@",[NSThread currentThread]);

                
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        
                        NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
                        
                        if ([vcClass isEqualToString:@"LDNewMineVC"]) {
                            
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }
                    }

            }else{
                
               [MBProgressHUD showError:backInfor.message];
            }
            
            
        }
        
    }];
                           


}
/**
 *  修改支付密码请求
 */
- (void)sendChangePayPassWordRequest{
    
    [MBProgressHUD showMessage:@"请稍后..."];

    NSString *urlString = [NSString stringWithFormat:@"%@login/resetPayPassword",KBaseUrl];
     //参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"payPassword"] = [TZMD5 md5:self.againPassWord.text];

    parameter[@"token"] = [LDUserInformation sharedInstance].token;
    parameter[@"id"] = [LDUserInformation sharedInstance].UserId;
    
    parameter[@"smsCode"] = self.inputCode.text;
    parameter[@"smsSn"] = [NSString stringWithFormat:@"%@",self.smsSn];
    parameter[@"phone"] = self.phoneNumberLable.text;
        
        [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
            if (error != nil)
            {
                 /** 1.打印请求错误信息*/
                NSLog(@"%@",error);
            
                /** 2.请求错误提示  */
                [MBProgressHUD showError:@"请求失败,请重试"];
    
            }else{
    
                LDLog(@"resonse%@",response);
    
                /** 3.解析返回信息  */
                LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
    
                if ([backInfor.code isEqualToString:@"0"]) {
                    [MBProgressHUD showSuccess:@"修改成功"];
                    LDLog(@"%@",[NSThread currentThread]);
                    
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        
                        NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
                        
                        if ([vcClass isEqualToString:@"LDNewMineVC"]) {
                            
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }
                    }
                }else{
    
                    [MBProgressHUD showError:backInfor.message];
                }
                
                
            }
            
        }];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                           
- (IBAction)timeButtonClick:(id)sender {
    
    self.titmeButton.userInteractionEnabled = NO;
    
    self.timeSecond = 60;
    
    NSString *strTime = [NSString stringWithFormat:@"重新获取(%.2ld)", (long)self.timeSecond];
    [self.titmeButton setTitle:strTime forState:UIControlStateNormal];

    [self.titmeButton setBackgroundColor:WHColorFromRGB(0xdedede)];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(changeSmsButton)
                                            userInfo:nil
                                             repeats:YES];
    
    self.smsSn = [self getCurrentTimeWithFormat:@"yyyyMMddHHmmssSSS"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@login/fetchSmsCode",KBaseUrl];
    
    // 参数
    NSDictionary *parameter = @{
                                @"phone":self.phoneNumberLable.text,
                                @"smsSn":[NSString stringWithFormat:@"%@",self.smsSn],
                                @"type":@"1"
                                };
    
    LDLog(@"%@",[parameter objectForKey:@"smsSn"]);
    
    [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
        if (error != nil) {//失败
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
            
            /** 3.重置发送验证码按钮  */
            [_timer invalidate];
            [self.titmeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.titmeButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
            self.titmeButton.userInteractionEnabled = YES;

            
        }else{
            
            LDLog(@"resonse%@",response);
            
            /** 4.解析返回信息 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                /** 5.验证码数据 */
                
                if (backInfor.result != nil) {
                    HDVerificationModel * verification = [HDVerificationModel mj_objectWithKeyValues:backInfor.result];
                    self.realCode = verification.smsCode;
                }
                
                
                
                
                if ([KBaseUrl isEqualToString:@"http://123.56.41.230/hd-merchant-web/mobile/"]) {
                    self.inputCode.text = self.realCode;
                }
                
            }else{
                
                /** 6.重置发送验证码按钮 */
                [_timer invalidate];
                
                [self.titmeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.titmeButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
                self.titmeButton.userInteractionEnabled = YES;
                
                /** 7.请求异常提示  */
                [MBProgressHUD showError:backInfor.message];
            }
        }
    }];
}


- (void)changeSmsButton{
    
    
    NSString *strTime = [NSString stringWithFormat:@"重新获取(%.2ld)", (long)self.timeSecond];
    
    [self.titmeButton setTitle:strTime forState:UIControlStateNormal];
    
    [self.titmeButton setBackgroundColor:WHColorFromRGB(0xdedede)];
    self.timeSecond --;
    
    if (self.timeSecond < 0) {
        [_timer invalidate];
        
        [self.titmeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.titmeButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
        self.titmeButton.userInteractionEnabled = YES;
    }
}


- (NSString *)getCurrentTimeWithFormat:(NSString *)format{
    //把当前时间转化成字符串
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = format;
    NSString* nowDateString = [fmt stringFromDate:now];
    return nowDateString;
}

@end
