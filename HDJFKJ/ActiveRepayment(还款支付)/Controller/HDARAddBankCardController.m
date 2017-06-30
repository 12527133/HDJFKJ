

#import "HDARAddBankCardController.h"
#import "WHBankAgreementController.h"
#import "HDChooseBankController.h"
#import "LDNavgationVController.h"
@interface HDARAddBankCardController ()
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

@property (nonatomic,assign) NSInteger cardLength;

@property (nonatomic, strong) UIView * careInfoBgView;

/** 预留手机号*/
@property (nonatomic, strong) UITextField * phoneNum;
@end

@implementation HDARAddBankCardController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    /** 银行卡信息不为空给银行卡名称赋值 */
    if (self.bankModel.bankCode != nil && self.bankModel.bankName != nil) {
        self.cardBankName.text = self.bankModel.bankName;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银行卡";
    self.view.backgroundColor = LDBackroundColor;
    
    /** 创建顶部视图 */
    [self createTopView];
    
    /** 创建内容视图 */
    [self createAddContentView];
    
    //消除第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tap{
    
    
    [self.view endEditing:YES];
}


/** 创建银行卡顶部视图 */
- (void)createTopView{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 40*bili)];
    topView.backgroundColor = WHColorFromRGB(0x4279d6);
    //[self.view addSubview:topView];
    
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth/3, topView.frame.size.height)];
    leftLabel.text = @"绑定银行卡";
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:13*bili];
    leftLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:leftLabel];
    
    UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth/3*2, 0, LDScreenWidth/3, topView.frame.size.height)];
    rightLabel.text = @"还款";
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = [UIFont systemFontOfSize:13*bili];
    rightLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:rightLabel];
    
    UILabel * middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth/3, 0, LDScreenWidth/3, topView.frame.size.height)];
    middleLabel.text = @"•••>>";
    middleLabel.textColor = [UIColor whiteColor];
    middleLabel.font = [UIFont systemFontOfSize:17*bili];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:middleLabel];
    
    UIImageView * topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 40*bili)];
    topImageView.image = [UIImage imageNamed:@"arAddBankTop"];
    [self.view addSubview:topImageView];
    
}

/** 创建填写内容试图 */
- (void)createAddContentView{
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*bili, LDScreenWidth, LDScreenHeight - 40*bili - 64)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    /** 创建持卡人标题Label  */
    UILabel * customerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 19*bili, LDScreenWidth - 15*bili, 18*bili)];
    customerTitleLabel.backgroundColor = [UIColor clearColor];
    customerTitleLabel.textColor = WHColorFromRGB(0x9fa8b7);
    customerTitleLabel.text = @"持卡人信息";
    customerTitleLabel.textAlignment = NSTextAlignmentLeft;
    customerTitleLabel.font = [UIFont systemFontOfSize:13*bili];
    [contentView addSubview:customerTitleLabel];
    
    /** 创建持卡人信息背景图  */
    UIView * customerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*bili, LDScreenWidth, 90*bili)];
    customerBgView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:customerBgView];
    
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
    [contentView addSubview:bankCardLabel];
    
    /** 创建银行卡信息背景图  */
    UIView * bankCardBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 180*bili, LDScreenWidth, 135*bili)];
    bankCardBgView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:bankCardBgView];
    
    /** 创建银行卡号 */
    UILabel * leftLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 0, 65*bili, bankCardBgView.frame.size.height/3)];
    leftLabel3.backgroundColor = [UIColor clearColor];
    leftLabel3.textColor = WHColorFromRGB(0x292929);
    leftLabel3.text = @"银行卡号";
    leftLabel3.textAlignment = NSTextAlignmentLeft;
    leftLabel3.font = [UIFont systemFontOfSize:15*bili];
    [bankCardBgView addSubview:leftLabel3];
    
    self.cardNumber = [[UITextField alloc]initWithFrame:CGRectMake(103*bili, 0, LDScreenWidth - 150*bili, bankCardBgView.frame.size.height/3)];
    self.cardNumber.textColor = WHColorFromRGB(0x2b2b2b);
    self.cardNumber.textAlignment = NSTextAlignmentLeft;
    self.cardNumber.placeholder = @"请输入银行卡号";
    self.cardNumber.font = [UIFont systemFontOfSize:15*bili];
    self.cardNumber.keyboardType = UIKeyboardTypeNumberPad;
    [self.cardNumber addTarget:self action:@selector(cardNumberChange:) forControlEvents:UIControlEventEditingChanged];
    [bankCardBgView addSubview:self.cardNumber];
    
    /** 创建所属银行 */
    UILabel * leftLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, bankCardBgView.frame.size.height/3, 65*bili, bankCardBgView.frame.size.height/3)];
    leftLabel4.backgroundColor = [UIColor clearColor];
    leftLabel4.textColor = WHColorFromRGB(0x292929);
    leftLabel4.text = @"所属银行";
    leftLabel4.textAlignment = NSTextAlignmentLeft;
    leftLabel4.font = [UIFont systemFontOfSize:15*bili];
    [bankCardBgView addSubview:leftLabel4];
    
    self.cardBankName = [[UITextField alloc]initWithFrame:CGRectMake(103*bili, bankCardBgView.frame.size.height/3, LDScreenWidth - 105*bili, bankCardBgView.frame.size.height/3)];
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
    
    /** 预留手机号 */
    UILabel * leftLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, bankCardBgView.frame.size.height/3*2, 80*bili, bankCardBgView.frame.size.height/3)];
    leftLabel5.backgroundColor = [UIColor clearColor];
    leftLabel5.textColor = WHColorFromRGB(0x292929);
    leftLabel5.text = @"预留手机号";
    leftLabel5.textAlignment = NSTextAlignmentLeft;
    leftLabel5.font = [UIFont systemFontOfSize:15*bili];
    [bankCardBgView addSubview:leftLabel5];
    
    self.phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(103*bili, bankCardBgView.frame.size.height/3*2, LDScreenWidth - 105*bili, bankCardBgView.frame.size.height/3)];
    self.phoneNum.textColor = WHColorFromRGB(0x2b2b2b);
    self.phoneNum.textAlignment = NSTextAlignmentLeft;
    self.phoneNum.font = [UIFont systemFontOfSize:15*bili];
    self.phoneNum.placeholder = @"请输入手机号";
    self.phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [bankCardBgView addSubview:self.phoneNum];
    [self.phoneNum addTarget:self action:@selector(phoneNumberChange:) forControlEvents:UIControlEventEditingChanged];
    
    /** 创建分割线 */
    UILabel * bottomLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
    bottomLine1.backgroundColor = WHColorFromRGB(0xdddddd);
    [bankCardBgView addSubview:bottomLine1];
    
    UILabel * bottomLine2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, bankCardBgView.frame.size.height/3, LDScreenWidth - 15*bili, 0.5)];
    bottomLine2.backgroundColor = WHColorFromRGB(0xdddddd);
    [bankCardBgView addSubview:bottomLine2];
    
    UILabel * bottomLine22 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, bankCardBgView.frame.size.height/3*2, LDScreenWidth - 15*bili, 0.5)];
    bottomLine22.backgroundColor = WHColorFromRGB(0xdddddd);
    [bankCardBgView addSubview:bottomLine22];
    
    UILabel * bottomLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0, bankCardBgView.frame.size.height - 0.5, LDScreenWidth, 0.5)];
    bottomLine3.backgroundColor = WHColorFromRGB(0xdddddd);
    [bankCardBgView addSubview:bottomLine3];
    
    /** 同意协议按钮 */
    self.agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(20*bili, 369*bili, 120*bili, 17)];
    [self.agreeButton setTitle:@" 我已经阅读并同意" forState:UIControlStateNormal];
    [self.agreeButton setTitleColor:WHColorFromRGB(0x9fa8b7) forState:UIControlStateNormal];
    self.agreeButton.titleLabel.font = [UIFont systemFontOfSize:12*bili];
    [self.agreeButton setImage:[UIImage imageNamed:@"yinhangka_NO"] forState:UIControlStateNormal];
    [self.agreeButton setImage:[UIImage imageNamed:@"yinhangka_Yes"] forState:UIControlStateSelected];
    self.agreeButton.selected = YES;
    [self.agreeButton addTarget:self action:@selector(leftAgreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.agreeButton];
    
    /** 用户协议 */
    UIButton * agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(130*bili, 369*bili, 160*bili, 17)];
    [contentView addSubview:agreeButton];
    agreeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [agreeButton setTitle:@"《银行卡快捷支付服务协议》" forState:UIControlStateNormal];
    [agreeButton setTitleColor:WHColorFromRGB(0x4279D6) forState:UIControlStateNormal];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:12*bili];
    [agreeButton addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (LDScreenWidth == 320) {
        self.agreeButton.frame = CGRectMake(20*bili, 342*bili, 125*bili, 17);
        agreeButton.frame = CGRectMake(137*bili, 342*bili, 160*bili, 17);
    }
    
    
    /** 下一步按钮*/
    float buttonY = 0.0;
    if (Is_Iphone5) {
        buttonY = 370*bili;
    }
    if (Is_Iphone6) {
        buttonY = 400*bili;
    }
    if (Is_Iphone6P) {
        buttonY = 400*bili;
    }
    
    UIButton * nextButton = [[UIButton alloc]initWithFrame:CGRectMake(16*bili, buttonY, LDScreenWidth- 32*bili, 50*bili)];
    [contentView addSubview:nextButton];
    nextButton.backgroundColor = WHColorFromRGB(0x4279d6);
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 5.0;
    nextButton.layer.borderWidth = 0.0;
    
    /** 提示 */
    
    float checkButtonY = 0.0;
    
    if (Is_Iphone5) {
        checkButtonY = 474*bili;
    }
    else{
        checkButtonY = 500*bili;
    }
    
    UIButton * checkOrderButton = [[UIButton alloc]initWithFrame:CGRectMake(30*bili, checkButtonY, LDScreenWidth-60*bili, 40*bili)];
    [checkOrderButton setImage:[UIImage imageNamed:@"check_yiwen"] forState:UIControlStateNormal];
    checkOrderButton.titleLabel.numberOfLines = 2;
    
    [checkOrderButton setTitle:@"绑定银行卡仅在第一次还款时出现，后续主动还款默认使用该张银行卡" forState:UIControlStateNormal];
    [checkOrderButton setTitleColor:WHColorFromRGB(0x9fa8b7) forState:UIControlStateNormal];
    
    checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:13*bili];
    [self.view addSubview:checkOrderButton];
    
    
    
    /** 给控件赋值 */
    [self setvalueForTextField];
}
//选择开户行
- (void)selectBankName:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    HDChooseBankController * chooseBank = [[HDChooseBankController alloc]init];
    chooseBank.arBankCard = self;
    LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:chooseBank];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
    
}



/** 给控件赋值 ：身份证号 ，姓名 */
- (void)setvalueForTextField{
    
    NSString * userName = nil;
    NSString * userNo = nil;
    
    
    if (self.bankDetail != nil) {
        userName = self.bankDetail.holder;
        userNo = self.bankDetail.holderNo;
        
        self.cardNumber.text = [self addSpaceToBankNo:self.bankDetail.cardNo];
        
        self.cardBankName.text = self.bankDetail.bankName;
        
        if (self.bankDetail.phone == nil) {
            self.phoneNum.text = [LDUserInformation sharedInstance].phoneNumber;
        }
        else{
            self.phoneNum.text = self.bankDetail.phone;
        }
        
        
    }
    else{
        userName = self.baseInfo.idName;
        userNo = self.baseInfo.idNo;
        
    }
    
    /** 赋值 姓名 */
    if (userName != nil && userName.length > 1) {
        if (userName.length == 2) {
            NSMutableString * idName = [[NSMutableString alloc] initWithString:userName];
            [idName replaceCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            self.name.text = idName;
        }
        else{
            
            NSMutableString * idName = [[NSMutableString alloc] initWithString:userName];
            [idName replaceCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            
            [idName replaceCharactersInRange:NSMakeRange(idName.length - 1, 1) withString:@"*"];
            
            self.name.text = idName;
        }
    }
    
    
    /** 给身份证号赋值 */
    if (userNo != nil) {
        NSMutableString * idNo = [[NSMutableString alloc] initWithString:userNo];
        
        
        [idNo replaceCharactersInRange:NSMakeRange(3, idNo.length - 5) withString:@"*************"];
        
        self.shenfenzheng.text = idNo;
    }
}

- (void)cardNumberChange:(UITextField *)textField{

    if (textField.text.length > self.cardLength) {
        /** 每次把银行卡中的空格去掉 */
        [self formatCardNumber:[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] textFild:textField];
    }
    
    self.cardLength = textField.text.length;
    
}

//手机号输入发生变化方法
-(void)phoneNumberChange:(UITextField*)textField{
    
    //限制输入的手机号为11位
    if (textField.text.length > 11) {
        
        textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:11]];
    }
    
}

- (void)formatCardNumber:(NSString *)cardNumber textFild:(UITextField *)textField{
    
    /** 限制银行卡位数小于等于19位 */
    if (cardNumber.length < 20) {
        
        /** 计算插入的空格数量 */
        int count = cardNumber.length/4;
        
        /** 转化为可变字符串 */
        NSMutableString * string = [[NSMutableString alloc]initWithString:cardNumber];
        
        /** 插入空格 */
        for (int i = 1; i< count+1; i++) {
            [string insertString:@" " atIndex:i*5-1];
        }
        
        /** 控件赋值  */
        textField.text = string;
    }
    
    else{
         cardNumber = [NSString stringWithFormat:@"%@",[cardNumber substringToIndex:19]];
        int count = cardNumber.length/4;
        
        NSMutableString * string = [[NSMutableString alloc]initWithString:cardNumber];
        for (int i = 1; i< count+1; i++) {
            [string insertString:@" " atIndex:i*5-1];
        }
        textField.text = string;
    }
    
}
- (void)agreeButtonClick{
    
    WHBankAgreementController * webView = [[WHBankAgreementController alloc]initWithURL:kuanjiezhifuUlr];
    webView.title = @"快捷支付服务协议";
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)leftAgreeButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}





/**
 *  下一步,将姓名和卡号发送到后端,
 */
- (void)nextButtonClick{
    
    
    if (self.name.text.length == 0 || self.shenfenzheng.text.length == 0) {
        
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
    else if (![self.phoneNum.text isTelephone:self.phoneNum.text]){
        [self showFailViewWithString:@"请输入正确的手机号"];
    }
    else{
        [self.view endEditing:YES];
        
        [self sendPaymentSignRequest];
    }
    
    
    
}

/** 签约获取验证码  */
- (void)sendPaymentSignRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@payment/sign",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    /** 订单id */
    params[@"applyId"] = self.orderRepays.orderNo;
    
    /** 金额  */
    params[@"amount"] = self.repayConfirm.repayAmt;
    
    /** 卡号 */
    params[@"cardNo"] = [self.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /** 持卡人 */
    if (self.bankDetail == nil) {
        params[@"holder"] = self.baseInfo.idName;
    }
    else{
        params[@"holder"] = self.bankDetail.holder;
    }
    /** 银行代码 */
    if (self.bankModel != nil) {
        params[@"bankCode"] = self.bankModel.bankCode;
    }
    else{
        params[@"bankCode"] = self.bankDetail.bankCode;
    }
    /** 预留手机号 */
    params[@"phone"] = [self.phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];;
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"sign == %@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                HDARBankCardList * arbank = [HDARBankCardList mj_objectWithKeyValues:backInfo.result];
                
                arbank.bank = self.cardBankName.text;
                
                
                NSMutableString * cardtailno = [[NSMutableString alloc] initWithString:[self.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
                [cardtailno replaceCharactersInRange:NSMakeRange(0, cardtailno.length - 4) withString:@""];
                arbank.cardtailno = cardtailno;
                
                _signSuccess(arbank);
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
                
                
            }else if ([backInfo.code isEqualToString:@"-201"]){
                
                [self showFailViewWithString:@"签约失败"];
            }
            
            else{
                [self showFailViewWithString:backInfo.message];
            }
            
        }
    }];
}




/** 银行卡添加空格 */
- (NSString *)addSpaceToBankNo:(NSString *)bankNo{
    
    NSMutableString * string = [[NSMutableString alloc]initWithString:bankNo];
    
    [string insertString:@" " atIndex:4];
    [string insertString:@" " atIndex:9];
    [string insertString:@" " atIndex:14];
    [string insertString:@" " atIndex:19];
    
    return string;
}

/** 手机号添加空格 */
- (NSString *)addSpaceToPhoneNo:(NSString *)phoneNo{
    
    NSMutableString * string = [[NSMutableString alloc]initWithString:phoneNo];
    
    [string insertString:@" " atIndex:3];
    
    [string insertString:@" " atIndex:8];
    
    return string;
    
}



















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
