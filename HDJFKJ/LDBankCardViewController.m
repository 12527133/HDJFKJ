//
//  LDBankCardViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBankCardViewController.h"
#import "LDBankResultModel.h"
#import "WHBankAgreementController.h"
#import "LTPickerView.h"

#import "HDChooseBankController.h"
#import "LDNavgationVController.h"
@interface LDBankCardViewController ()<UITextFieldDelegate>
/**
 *  卡号
 */
@property (nonatomic,strong) UITextField * cardNumber;
//开户行
@property (nonatomic, strong) UITextField * cardBankName;
//开户行简称
@property (nonatomic, strong) NSString * cardBankEnglish;
/* 持卡人姓名,身份证号 */
@property (nonatomic,strong) UITextField * name;
/** 身份证*/
@property (nonatomic, strong) UITextField * shenfenzheng;

@property (nonatomic, strong) UIButton * agreeButton;

@property (nonatomic,strong) SCCaptureCameraController * CameraController;

@property (nonatomic,assign) NSInteger cardLength;

@property (nonatomic, strong) UIView * careInfoBgView;
@end

@implementation LDBankCardViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title  =@"银行卡";
    
    self.view.backgroundColor = LDBackroundColor;
    
    [self creatSubView];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];

    [center addObserver:self selector:@selector(cancleButtonRemove) name:@"cancle1ButtonClick" object:nil];

    
    //消除第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tap{
    
    
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{

    /** 显示状态栏 */
    [UIApplication sharedApplication].statusBarHidden = NO;

    [super viewWillAppear:animated];
    
    /** 银行卡信息不为空给银行卡名称赋值 */
    if (self.bankModel.bankCode != nil && self.bankModel.bankName != nil) {
        self.cardBankName.text = self.bankModel.bankName;
    }
    
}
- (void)cancleButtonRemove{
    
    [UIApplication sharedApplication].statusBarHidden = NO;

    [self dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarHidden = NO;

    }];
}
- (BOOL)prefersStatusBarHidden{

    return NO;
}
/**
 *  添加子控件
 */
- (void)creatSubView{
    
    /** 创建持卡人标题Label  */
    UILabel * customerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 19*bili, LDScreenWidth - 15*bili, 18*bili)];
    customerTitleLabel.backgroundColor = [UIColor clearColor];
    customerTitleLabel.textColor = WHColorFromRGB(0x9fa8b7);
    customerTitleLabel.text = @"持卡人信息";
    customerTitleLabel.textAlignment = NSTextAlignmentLeft;
    customerTitleLabel.font = [UIFont systemFontOfSize:13*bili];
    [self.view addSubview:customerTitleLabel];
    
    /** 创建持卡人信息背景图  */
    UIView * customerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*bili, LDScreenWidth, 90*bili)];
    customerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customerBgView];
    
    /** 创建持卡人姓名 */
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 0, 65*bili, customerBgView.frame.size.height/2)];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textColor = WHColorFromRGB(0x292929);
    leftLabel.text = @"姓名";
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = [UIFont systemFontOfSize:15*bili];
    [customerBgView addSubview:leftLabel];
    
    self.name = [[UITextField alloc]initWithFrame:CGRectMake(103*bili, 0, LDScreenWidth - 105*bili, customerBgView.frame.size.height/2)];
    self.name.textColor = WHColorFromRGB(0x9fa8b7);
    self.name.textAlignment = NSTextAlignmentLeft;
    self.name.font = [UIFont systemFontOfSize:15*bili];
    self.name.userInteractionEnabled = NO;
    [customerBgView addSubview:self.name];
    
    /** 创建身份证号 */
    UILabel * leftLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, customerBgView.frame.size.height/2, 65*bili, customerBgView.frame.size.height/2)];
    leftLabel2.backgroundColor = [UIColor clearColor];
    leftLabel2.textColor = WHColorFromRGB(0x292929);
    leftLabel2.text = @"身份证号";
    leftLabel2.textAlignment = NSTextAlignmentLeft;
    leftLabel2.font = [UIFont systemFontOfSize:15*bili];
    [customerBgView addSubview:leftLabel2];
    
    self.shenfenzheng = [[UITextField alloc]initWithFrame:CGRectMake(103*bili, customerBgView.frame.size.height/2, LDScreenWidth - 105*bili, customerBgView.frame.size.height/2)];
    self.shenfenzheng.textColor = WHColorFromRGB(0x9fa8b7);
    self.shenfenzheng.textAlignment = NSTextAlignmentLeft;
    self.shenfenzheng.font = [UIFont systemFontOfSize:15*bili];
    self.shenfenzheng.userInteractionEnabled = NO;
    [customerBgView addSubview:self.shenfenzheng];
    
    /** 创建分割线 */
    UILabel * topLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
    topLine1.backgroundColor = WHColorFromRGB(0xdddddd);
    [customerBgView addSubview:topLine1];
    
    UILabel * topLine2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, customerBgView.frame.size.height/2, LDScreenWidth - 15*bili, 0.5)];
    topLine2.backgroundColor = WHColorFromRGB(0xdddddd);
    [customerBgView addSubview:topLine2];
    
    UILabel * topLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0, customerBgView.frame.size.height - 0.5, LDScreenWidth, 0.5)];
    topLine3.backgroundColor = WHColorFromRGB(0xdddddd);
    [customerBgView addSubview:topLine3];
    
    
    /*
     * 创建银行卡信息 
    */
    /** 创建持卡人标题Label  */
    UILabel * bankCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 158*bili, LDScreenWidth - 15*bili, 18*bili)];
    bankCardLabel.backgroundColor = [UIColor clearColor];
    bankCardLabel.textColor = WHColorFromRGB(0x9fa8b7);
    bankCardLabel.text = @"银行卡信息";
    bankCardLabel.textAlignment = NSTextAlignmentLeft;
    bankCardLabel.font = [UIFont systemFontOfSize:13*bili];
    [self.view addSubview:bankCardLabel];
    
    /** 创建银行卡信息背景图  */
    UIView * bankCardBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 180*bili, LDScreenWidth, 90*bili)];
    bankCardBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bankCardBgView];
    
    /** 创建银行卡号 */
    UILabel * leftLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 0, 65*bili, bankCardBgView.frame.size.height/2)];
    leftLabel3.backgroundColor = [UIColor clearColor];
    leftLabel3.textColor = WHColorFromRGB(0x292929);
    leftLabel3.text = @"银行卡号";
    leftLabel3.textAlignment = NSTextAlignmentLeft;
    leftLabel3.font = [UIFont systemFontOfSize:15*bili];
    [bankCardBgView addSubview:leftLabel3];
    
    self.cardNumber = [[UITextField alloc]initWithFrame:CGRectMake(103*bili, 0, LDScreenWidth - 150*bili, bankCardBgView.frame.size.height/2)];
    self.cardNumber.textColor = WHColorFromRGB(0x2b2b2b);
    self.cardNumber.textAlignment = NSTextAlignmentLeft;
    self.cardNumber.placeholder = @"请输入银行卡号";
    self.cardNumber.font = [UIFont systemFontOfSize:15*bili];
    self.cardNumber.keyboardType = UIKeyboardTypeNumberPad;
    [self.cardNumber addTarget:self action:@selector(cardNumberChange:) forControlEvents:UIControlEventEditingChanged];
    [bankCardBgView addSubview:self.cardNumber];
    
    UIButton * saoMiaobutton = [[UIButton alloc]initWithFrame:CGRectMake(LDScreenWidth - 45*bili, 0, bankCardBgView.frame.size.height/2, bankCardBgView.frame.size.height/2)];
    [bankCardBgView addSubview:saoMiaobutton];
    [saoMiaobutton setImage:[UIImage imageNamed:@"iconfont-camera"] forState:UIControlStateNormal];
    
    
    [saoMiaobutton addTarget:self action:@selector(saoMiaobuttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    /** 创建身份证号 */
    UILabel * leftLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, bankCardBgView.frame.size.height/2, 65*bili, bankCardBgView.frame.size.height/2)];
    leftLabel4.backgroundColor = [UIColor clearColor];
    leftLabel4.textColor = WHColorFromRGB(0x292929);
    leftLabel4.text = @"所属银行";
    leftLabel4.textAlignment = NSTextAlignmentLeft;
    leftLabel4.font = [UIFont systemFontOfSize:15*bili];
    [bankCardBgView addSubview:leftLabel4];
    
    self.cardBankName = [[UITextField alloc]initWithFrame:CGRectMake(103*bili, bankCardBgView.frame.size.height/2, LDScreenWidth - 105*bili, bankCardBgView.frame.size.height/2)];
    self.cardBankName.textColor = WHColorFromRGB(0x2b2b2b);
    self.cardBankName.textAlignment = NSTextAlignmentLeft;
    self.cardBankName.font = [UIFont systemFontOfSize:15*bili];
    self.cardBankName.placeholder = @"请选择";
    [bankCardBgView addSubview:self.cardBankName];
    
    
    UIImageView * arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 23*bili, 60*bili, 8*bili, 14*bili)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_blue_8x14"];
    [bankCardBgView addSubview:arrowImageView];
    
    UIButton * bankNameButton = [[UIButton alloc]initWithFrame: self.cardBankName.frame];
    [bankNameButton addTarget:self action:@selector(selectBankName:) forControlEvents:UIControlEventTouchUpInside];
    [bankCardBgView addSubview:bankNameButton];
    
    /** 创建分割线 */
    UILabel * bottomLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
    bottomLine1.backgroundColor = WHColorFromRGB(0xdddddd);
    [bankCardBgView addSubview:bottomLine1];
    
    UILabel * bottomLine2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, bankCardBgView.frame.size.height/2, LDScreenWidth - 15*bili, 0.5)];
    bottomLine2.backgroundColor = WHColorFromRGB(0xdddddd);
    [bankCardBgView addSubview:bottomLine2];
    
    UILabel * bottomLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0, bankCardBgView.frame.size.height - 0.5, LDScreenWidth, 0.5)];
    bottomLine3.backgroundColor = WHColorFromRGB(0xdddddd);
    [bankCardBgView addSubview:bottomLine3];
    
    
    
    /** 手机号对应提示 */
    UIButton * checkOrderButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 270*bili, LDScreenWidth, 45*bili)];
    [checkOrderButton setImage:[UIImage imageNamed:@"check_yiwen"] forState:UIControlStateNormal];
    
    [checkOrderButton setTitle:[NSString stringWithFormat:@" 请您确保银行卡对应的预留手机号为%@",[LDUserInformation sharedInstance].phoneNumber] forState:UIControlStateNormal];
    [checkOrderButton setTitleColor:WHColorFromRGB(0x9fa8b7) forState:UIControlStateNormal];
    checkOrderButton.userInteractionEnabled = NO;
    checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:12*bili];
    [self.view addSubview:checkOrderButton];
    
    
    /** 同意协议按钮 */
    self.agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(20*bili, 342*bili, 120*bili, 17)];
    [self.agreeButton setTitle:@" 我已经阅读并同意" forState:UIControlStateNormal];
    [self.agreeButton setTitleColor:WHColorFromRGB(0x9fa8b7) forState:UIControlStateNormal];
    self.agreeButton.titleLabel.font = [UIFont systemFontOfSize:12*bili];
    [self.agreeButton setImage:[UIImage imageNamed:@"yinhangka_NO"] forState:UIControlStateNormal];
    [self.agreeButton setImage:[UIImage imageNamed:@"yinhangka_Yes"] forState:UIControlStateSelected];
    self.agreeButton.selected = YES;
    [self.agreeButton addTarget:self action:@selector(leftAgreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.agreeButton];
    
    /** 用户协议 */
    UIButton * agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(130*bili, 342*bili, 137*bili, 17)];
    [self.view addSubview:agreeButton];
    agreeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [agreeButton setTitle:@"《银行卡代扣服务协议》" forState:UIControlStateNormal];
    [agreeButton setTitleColor:WHColorFromRGB(0x4279D6) forState:UIControlStateNormal];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:12*bili];
    [agreeButton addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (LDScreenWidth == 320) {
        self.agreeButton.frame = CGRectMake(20*bili, 342*bili, 125*bili, 17);
        agreeButton.frame = CGRectMake(137*bili, 342*bili, 137*bili, 17);
    }
    
    
    /** 下一步按钮*/
    UIButton * nextButton = [[UIButton alloc]initWithFrame:CGRectMake(16*bili, 373*bili, LDScreenWidth- 32*bili, 50*bili)];
    [self.view addSubview:nextButton];
    nextButton.backgroundColor = WHColorFromRGB(0x4279d6);
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 5.0;
    nextButton.layer.borderWidth = 0.0;
  
    
    /** 给控件赋值 */
    [self setvalueForTextField];
}

/** 给控件赋值 ：身份证号 ，姓名 */
- (void)setvalueForTextField{

    /** 赋值 姓名 */
    if (self.baseInfo.idName != nil && self.baseInfo.idName.length > 1) {
        if (self.baseInfo.idName.length == 2) {
            NSMutableString * idName = [[NSMutableString alloc] initWithString:self.baseInfo.idName];
            [idName replaceCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            self.name.text = idName;
        }
        else{
        
            NSMutableString * idName = [[NSMutableString alloc] initWithString:self.baseInfo.idName];
            [idName replaceCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            
            [idName replaceCharactersInRange:NSMakeRange(idName.length - 1, 1) withString:@"*"];
            
            self.name.text = idName;
        }
    }
    
   
    /** 给身份证号赋值 */
    if (self.baseInfo.idNo != nil) {
        NSMutableString * idNo = [[NSMutableString alloc] initWithString:self.baseInfo.idNo];
        
        
        [idNo replaceCharactersInRange:NSMakeRange(3, idNo.length - 5) withString:@"*************"];

        self.shenfenzheng.text = idNo;
    }
}

- (void)cardNumberChange:(UITextField *)textField{
    
    
    

    [self formatCardNumber:textField.text textFild:textField];
}

- (void)formatCardNumber:(NSString *)cardNumber textFild:(UITextField *)textField{
    
    if (cardNumber.length < 25) {
        NSMutableString * string = [[NSMutableString alloc]initWithString:cardNumber];
        
        if (cardNumber.length > self.cardLength) {
            switch (cardNumber.length) {
                case 5:
                    [string insertString:@" " atIndex:4];
                    break;
                case 10:
                    [string insertString:@" " atIndex:9];
                    break;
                case 15:
                    [string insertString:@" " atIndex:14];
                    break;
                case 20:
                    [string insertString:@" " atIndex:19];
                    break;
                default:
                    break;
            }
            textField.text = string;
        }
        
        self.cardLength = cardNumber.length;
    }
    
    
    
}
- (void)agreeButtonClick{
    
    WHBankAgreementController * webView = [[WHBankAgreementController alloc]initWithURL:bankPayUrl];
    webView.title = @"代扣服务协议";
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)leftAgreeButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}


/** 添加银行卡确认信息视图 */
- (void)cardInfonmationView{

    UIView * cardInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth - 70*bili, 200*bili)];
    cardInfoView.backgroundColor = [UIColor whiteColor];
    
    /** 设置View的圆角 */
    cardInfoView.layer.cornerRadius = 10.0;
    cardInfoView.layer.borderWidth = 0.0;
    
    /** 标题Label */
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cardInfoView.frame.size.width, 50*bili)];
    titleLabel.textColor = WHColorFromRGB(0x323232);
    titleLabel.text = @"银行卡信息确认";
    titleLabel.font = [UIFont boldSystemFontOfSize:17*bili];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [cardInfoView addSubview:titleLabel];
    
    /** 银行卡  */
    UILabel * bankNumLabel =  [[UILabel alloc]initWithFrame:CGRectMake(30*bili, 50*bili, cardInfoView.frame.size.width - 60*bili, 35*bili)];
    bankNumLabel.textColor = WHColorFromRGB(0x323232);
    bankNumLabel.text = [NSString stringWithFormat:@"卡号：%@",self.cardNumber.text];
    bankNumLabel.font = [UIFont systemFontOfSize:15*bili];
    bankNumLabel.textAlignment =  NSTextAlignmentLeft;
    bankNumLabel.backgroundColor = [UIColor clearColor];
    [cardInfoView addSubview:bankNumLabel];
    
    /** 银行名称 */
    UILabel * bankNameLabel =  [[UILabel alloc]initWithFrame:CGRectMake(30*bili, 85*bili, cardInfoView.frame.size.width - 60*bili, 35*bili)];
    bankNameLabel.textColor = WHColorFromRGB(0x323232);
    bankNameLabel.text = [NSString stringWithFormat:@"所属银行：%@",self.cardBankName.text];
    bankNameLabel.font = [UIFont systemFontOfSize:15*bili];
    bankNameLabel.textAlignment =  NSTextAlignmentLeft;
    bankNameLabel.backgroundColor = [UIColor clearColor];
    [cardInfoView addSubview:bankNameLabel];
    
    /** 手机号  */
    UILabel * phoneLabel =  [[UILabel alloc]initWithFrame:CGRectMake(30*bili, 120*bili, cardInfoView.frame.size.width - 60*bili, 35*bili)];
    phoneLabel.textColor = WHColorFromRGB(0x323232);
    phoneLabel.text = [NSString stringWithFormat:@"预留手机号：%@",[LDUserInformation sharedInstance].phoneNumber];
    phoneLabel.font = [UIFont systemFontOfSize:15*bili];
    phoneLabel.textAlignment =  NSTextAlignmentLeft;
    phoneLabel.backgroundColor = [UIColor clearColor];
    [cardInfoView addSubview:phoneLabel];
    
    /** 按钮 */
    UIButton * cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 155*bili, cardInfoView.frame.size.width/2.0, 45*bili)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    [cardInfoView addSubview:cancel];
    
    UIButton * sure = [[UIButton alloc]initWithFrame:CGRectMake(cardInfoView.frame.size.width/2.0, 155*bili, cardInfoView.frame.size.width/2.0, 45*bili)];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    [cardInfoView addSubview:sure];

    [cancel addTarget:self action:@selector(clickQuxiao:) forControlEvents:UIControlEventTouchUpInside];
    [sure addTarget:self action:@selector(clickQueDing:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 分割线 */
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 155*bili, cardInfoView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
    [cardInfoView addSubview:lineLabel];
    
    UILabel * lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(cardInfoView.frame.size.width/2.0, 155*bili, 0.5, 45*bili)];
    lineLabel2.backgroundColor = WHColorFromRGB(0xdddddd);
    [cardInfoView addSubview:lineLabel2];
    
    
    
    self.careInfoBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight)];
    self.careInfoBgView.backgroundColor = LDRGBColor(0, 0, 0, 0.0);
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    cardInfoView.alpha = 0.0;
    
    cardInfoView.center = self.careInfoBgView.center;
    
    [window addSubview:self.careInfoBgView];
    
    [self.careInfoBgView addSubview:cardInfoView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.careInfoBgView.backgroundColor = LDRGBColor(0, 0, 0, 0.4);
        
        cardInfoView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
    
}

- (void)clickQuxiao:(UIButton *)button{

    [UIView animateWithDuration:0.3 animations:^{
        
        button.superview.alpha = 0.0;
        self.careInfoBgView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [button.superview removeFromSuperview];
        [self.careInfoBgView removeFromSuperview];
        
        
        
        
    }];
}

- (void)clickQueDing:(UIButton *)button{

    [UIView animateWithDuration:0.3 animations:^{
        
        button.superview.alpha = 0.0;
        self.careInfoBgView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [button.superview removeFromSuperview];
        [self.careInfoBgView removeFromSuperview];
        
        [self sendRequest];
        
    }];
    
}




/**
 *  下一步,将姓名和卡号发送到后端,
 */
- (void)nextButtonClick{
     
    
    if (self.baseInfo.idNo == nil || self.baseInfo.idName == nil) {
        
        [self showFailViewWithString:@"实名信息有误"];
    }
    else if (self.cardNumber.text.length==0) {
        
        [self showFailViewWithString:@"请输入银行卡号"];
    }
    else if (!self.agreeButton.selected){
        
        [self showFailViewWithString:@"请您阅读协议并同意"];
    }
    else if (self.cardBankName.text.length == 0){
        [self showFailViewWithString:@"请选择开户行"];
    }
    else{
        [self.view endEditing:YES];
        
         [self cardInfonmationView];
    }

    

}

//网络请求(姓名卡号发送到后端,返回银行卡类型),
- (void)sendRequest{
    
    [self showWithImageWithString:@"正在添加"];
    
    NSString * url = [NSString stringWithFormat:@"%@person/bankcard/add",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].UserId) forKey:@"id"];

    //去除扫描证件带来的空格
    NSString * sValid = [self.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //卡号
    [params setObject:sValid forKey:@"cardNo"];
  
     //姓名
    [params setObject:self.baseInfo.idName forKey:@"holder"];
    //开户行
    [params setObject:self.bankModel.bankCode forKey:@"bankCode"];
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
           
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
        }else{
            
            //返回码,状态码信息.
            LDBankResultModel * model = [LDBankResultModel mj_objectWithKeyValues:response];
            

            if ([model.code isEqualToString:@"0"]) {
                
                
                [self showSuccessViewWithString:@"添加成功"];
                
                
                [self performSelector:@selector(dissmissSelf) withObject:nil afterDelay:2.0];
                
                
                
                
            }else{
                [self showFailViewWithString:model.message];
                
            }
        }
    }];
}

/** 退出当前控制器  */

- (void)dissmissSelf{

    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.fromBankCard != nil) {
        
    }

    _gobackBlock();
}

//选择开户行
- (void)selectBankName:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    HDChooseBankController * chooseBank = [[HDChooseBankController alloc]init];
    chooseBank.bankCard = self;
    LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:chooseBank];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];

}

- (void)saoMiaobuttonClick{

    
    self.CameraController = [[SCCaptureCameraController alloc] init];
    
    self.CameraController.scNaigationDelegate = self;
    
    self.CameraController.iCardType = TIDBANK;
    
    self.CameraController.IsBankCark = YES;
    
    self.CameraController.isDisPlayTxt = NO;
  
    [self presentViewController:self.CameraController animated:YES completion:nil];

}

// 银行卡回调接口
- (void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name
{
    
    NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"卡号  ： %@\n发卡行 ： %@\n机构代码： %@\n卡种  ： %@\n卡名  ： %@\n",bank_num,bank_name,bank_orgcode,bank_class,card_name]];
    LDLog(@"BANK INFO = %@\n",astring);
    
    self.cardNumber.text = bank_num;

    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 格式化获取到的银行卡号*/

- (void)sendBankCardImage:(UIImage *)BankCardImage // 获取银行卡图片
{
    self.CameraController.captureManager = nil;
    self.CameraController.drawView = nil;
    self.CameraController = nil;
    
    
}
-(void)dealloc{
    self.CameraController.captureManager = nil;
    self.CameraController.drawView = nil;
    self.CameraController = nil;


    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancle1ButtonClick" object:nil];
    
    
    LDLog(@"销毁添加银行卡控制器");
    
}





@end
