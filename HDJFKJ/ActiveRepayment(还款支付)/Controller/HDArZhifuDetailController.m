

#import "HDArZhifuDetailController.h"
#import "HDARZhifuDetailView.h"
#import "HDARVerificationCodeView.h"
#import "HDARSuccessView.h"
#import "HDARZhifuBankView.h"
#import "HDARBankListVIew.h"
#import "WHBaseInfoModel.h"
#import "HDARAddBankCardController.h"
#import "HDARZhifuSuccessController.h"
@interface HDArZhifuDetailController ()

/** 支付详情View */
@property (nonatomic, strong) HDARZhifuDetailView * detailView;

/** 确认支付按钮 */
@property (nonatomic, strong) UIButton * nextButton;

/** 验证码弹窗 */
@property (nonatomic, strong) HDARVerificationCodeView * verCodeView;

/** 弹窗背景图 */
@property (nonatomic, strong) UIView * tangchuangBgView;

/** 等待时间 */
@property (nonatomic, strong) NSTimer * timer;

/** 支付加载中， 成功界面 */
@property (nonatomic, strong) HDARSuccessView * successView;

/** 选择银行卡视图 */
@property (nonatomic, strong) HDARZhifuBankView * bankView;

/** 弹窗背景视图 */
@property (nonatomic, strong) UIView * tangChuangBGView;

/** 银行卡列表弹窗 */
@property (nonatomic, strong) HDARBankListVIew *bankListView;

/** 用户基本信息 */
@property (nonatomic, strong) WHBaseInfoModel * baseInfoModel;

/** 银行卡数组 */
@property (nonatomic, strong) NSMutableArray * bankArray;

/** 验证码计时器 */
@property (nonatomic, strong) NSTimer * YZTimer;

/** 重新发送验证码倒计时时间 */
@property (nonatomic, assign) int time;

/** 签约银行卡id */
@property (nonatomic, strong) NSString * signBankCardId;

@end

@implementation HDArZhifuDetailController


- (void)dealloc{
    
    LDLog(@"销毁支付详情界面");
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 创建title */
    [self createTitleView];
    
    self.view.backgroundColor = LDBackroundColor;
    
    /** 创建详情View */
    [self createZhifuDetailView];
    
    /** 确认交易信息里银行卡信息不为空 创建选择银行卡View */
    if (self.repayConfirm.bankCardId != nil) {
        self.signBankCardId = self.repayConfirm.bankCardId;
        [self createBankView];
    }
    
    
    /** 创建 按钮 */
    [self createNextButton];
    
}
/** 创建titleView */
- (void)createTitleView{
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 64)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, titleView.frame.size.width, 21)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = WHColorFromRGB(0x323232);
    titleLabel.text = @"在线支付";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:titleLabel];
    
    UILabel * subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, titleView.frame.size.width, 14)];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = WHColorFromRGB(0x9fa8b7);
    subTitleLabel.text = @"收款方：新希望慧农(天津)科技有限公司";
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont systemFontOfSize:10];
    [titleView addSubview:subTitleLabel];
    
    
    /** 返回按钮 */
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44 , 44)];
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickNavLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    /** 横线  */
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height - 0.5, LDScreenWidth, 0.5)];
    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
    [titleView addSubview:lineLabel];
    
    [self.view addSubview:titleView];
}
- (void)clickNavLeftButton:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/** 创建还款详情视图 */
- (void)createZhifuDetailView{
    
    self.detailView = [[HDARZhifuDetailView alloc]initWithFrame:CGRectMake(0, 64, LDScreenWidth, 278*bili)];
    [self.detailView createSubView];
    
    [self.view addSubview:self.detailView];
    
    /** 给视图控件赋值 */
    [self setZhifuValue];
    
}
/** 赋值 */
- (void)setZhifuValue{
    
    /** 商品名称 */
    self.detailView.topLabel.text = self.repayConfirm.commodityName;
    
    /** 支付总额 */
    self.detailView.totalMoneyLabel.text = self.repayConfirm.repayAmt;
    
    /** 手续费 */
    self.detailView.shouxufeiRightLabel.text =[NSString stringWithFormat:@"%@元",self.repayConfirm.paymentFee] ;
    
    
    /** 应还金额 */
    self.detailView.payBackRightLabel.text = [NSString stringWithFormat:@"%@元",self.repayConfirm.psInstmAmt];
    
    /** 滞纳金 */
    self.detailView.lateFreerightLabel.text = [NSString stringWithFormat:@"%@元",self.repayConfirm.lateFee];
    
    /** 优惠金额 */
    self.detailView.youhuiRightLabel.text = [NSString stringWithFormat:@"%@元",self.repayConfirm.discountAmt];
    
    if ([self.repayConfirm.lateFee floatValue] == 0) {
        [self.detailView setLateFreeNilFrame];
    }
    
    
    [self createshouxufeitishiLabel];
}

/** 手续费由第三方支付公司收取 */
- (void)createshouxufeitishiLabel{
    
    UILabel * subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*bili, self.detailView.frame.origin.y+self.detailView.frame.size.height, LDScreenWidth - 50*bili, 21)];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = WHColorFromRGB(0x9fa8b7);
    subTitleLabel.text = @"手续费由第三方支付公司收取";
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    subTitleLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:subTitleLabel];
}


/** 创建选择银行卡视图 */
- (void)createBankView{
    
    self.bankView = [[HDARZhifuBankView alloc]initWithFrame:CGRectMake(0, self.detailView.frame.size.height + self.detailView.frame.origin.y + 10*bili, LDScreenWidth, 50*bili)];
    
    [self.bankView createSubView];
    
    [self.view addSubview:self.bankView];
    
    /** 赋值 */
    [self.bankView.iconImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"wode_yinhangka_2.0.4"]];
    [self.bankView.iconImage setContentMode:UIViewContentModeScaleAspectFit];
    
    if (self.signResult != nil) {
        
        self.bankView.bankNameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.signResult.bank,self.signResult.cardtailno];
    }
    else{
        
        self.bankView.bankNameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.repayConfirm.bankName,self.repayConfirm.bankNo];
    }
    
    
    /** 银行选择按钮方法 */
    [self.bankView.bankButton addTarget:self action:@selector(clickChooseBank:) forControlEvents:UIControlEventTouchUpInside];
    
}

/** 选择银行卡 */
- (void)clickChooseBank:(UIButton *)sender{
    
    [self sendBankCardListRequest];
    
}
/** 选择银行卡弹窗 */
- (void)createChooseBankView{
    
    /** 创建弹窗背景视图 */
    self.tangChuangBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight )];
    self.tangChuangBGView.backgroundColor = LDRGBColor(0, 0, 0, 0.0);
    [self.view addSubview:self.tangChuangBGView];
    
    /** 创建弹窗 */
    self.bankListView = [[HDARBankListVIew alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, LDScreenWidth, 320*bili)];
    self.bankListView.bankCardArray = self.bankArray;
    
    [self.tangChuangBGView addSubview:self.bankListView];
    [self.bankListView createSubView];
    [self.bankListView.cancelButton addTarget:self action:@selector(bankTanchuangCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.bankListView.bankButton addTarget:self action:@selector(tanchuangXinBank:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 动画弹出银行卡试图 */
    [UIView animateWithDuration:0.3f animations:^{
        self.tangChuangBGView.backgroundColor = LDRGBColor(0, 0, 0, 0.5);
        
        self.bankListView.frame = CGRectMake(0, self.view.frame.size.height - 320*bili, LDScreenWidth, 320*bili);
    } completion:^(BOOL finished) {
        
    }];
    
    /** 点击银行卡回调，返回选择的银行卡  */
    __block typeof(self) blockSelf = self;
    self.bankListView.selectBank = ^(LDHaveCardListModel * bankList){
        
        /** 保存选择的银行卡 */
        blockSelf.arBank = bankList;
        
        blockSelf.signBankCardId = bankList.id;
        
        
        /** 跟新确认信息里的银行卡信息 */
        if ( blockSelf.bankView == nil) {
            [blockSelf createBankView];
        }
        else{
            blockSelf.bankView.bankNameLabel.text = [NSString stringWithFormat:@"%@(%@)",bankList.bank,bankList.cardtailno];
        }
        
        /** 销毁选择银行卡弹窗 */
        [blockSelf.bankListView removeFromSuperview];
        [blockSelf.tangChuangBGView removeFromSuperview];
        
        /** 前去签约 */
        [blockSelf sendPaymentSignRequest];
    };
}

/** 关闭弹窗 */
- (void)bankTanchuangCancel:(UIButton *)sender{
    [UIView animateWithDuration:0.3f animations:^{
        self.tangChuangBGView.backgroundColor = LDRGBColor(0, 0, 0, 0.0);
        
        self.bankListView.frame = CGRectMake(0, self.view.frame.size.height, LDScreenWidth, 320*bili);
    } completion:^(BOOL finished) {
        
        [self.bankListView removeFromSuperview];
        
        [self.tangChuangBGView removeFromSuperview];
        
        self.bankListView = nil;
        
        self.tangChuangBGView = nil;
        
    }];
    
}
/** 选择新银行卡 */
- (void)tanchuangXinBank:(UIButton *)sender{
    
    self.bankDetail = nil;
    
    if (self.baseInfoModel == nil) {
        [self requestBasicMessageRequest];
    }
    else{
        
        [self pushAddCardBankController];
    }
}


/**
 * 网络请求,获取用户的基本信息
 **/
- (void)requestBasicMessageRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** 4.code == 0请求成功  */
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                
                /** 5.解析基本信息 */
                if (backInfo.result != nil){
                    
                    self.baseInfoModel = [WHBaseInfoModel mj_objectWithKeyValues:backInfo.result];
                    
                    [self pushAddCardBankController];
                }
                
            }else{
                
                /** 6.请求异常提示 */
                [self showFailViewWithString:backInfo.message];
                
            }
            
            LDLog(@"%@",response);
        }
    }];
}

/** 推出添加银行卡界面  */
- (void)pushAddCardBankController{
    
    /** 创建银行卡签约界面  */
    HDARAddBankCardController * addcard = [[HDARAddBankCardController alloc]init];
    addcard.baseInfo = self.baseInfoModel;
    addcard.bankDetail = self.bankDetail;
    addcard.orderRepays = self.orderRepays;
    addcard.repayConfirm = self.repayConfirm;
    [self.navigationController pushViewController:addcard animated:YES];
    
    /** 银行卡签约成功回调 */
    __block typeof(self) weakSelf = self;
    addcard.signSuccess = ^(HDARBankCardList * signResult){
        
        /** 保存签约结果 */
        weakSelf.signResult = signResult;
        
        weakSelf.signBankCardId = signResult.bankCardId;
        
        /** 跟新确认信息里的银行卡信息 */
        if ( self.bankView == nil) {
            [self createBankView];
        }
        else{
            weakSelf.bankView.bankNameLabel.text = [NSString stringWithFormat:@"%@(%@)",signResult.bank,signResult.cardtailno];
        }
        
        /** 销毁选择银行卡弹窗 */
        [weakSelf.bankListView removeFromSuperview];
        [weakSelf.tangChuangBGView removeFromSuperview];
    
        [weakSelf createTanChuangView];
    };
}
/** 创建“确认支付”按钮 */
- (void)createNextButton{
    
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(16*bili, LDScreenHeight  - 70*bili, LDScreenWidth- 32*bili, 50*bili)];
    [self.view addSubview:self.nextButton];
    self.nextButton.backgroundColor = WHColorFromRGB(0x4279d6);
    [self.nextButton setTitle:@"确认支付" forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 5.0;
    self.nextButton.layer.borderWidth = 0.0;
    [self.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
}
/** 点击确认支付按钮 */
- (void)clickNextButton:(UIButton *)sender{
    
    if (self.repayConfirm.bankCardId == nil) {
        /** 确认信息没有签约银行卡 弹出选银行卡界面  */
        [self sendBankCardListRequest];
        
    }
    else{
        
        /** 有选择银行卡界面直接签约支付 */
        [self sendPaymentSignRequest];
    }

}


/**创建验证码弹窗 */
- (void)createTanChuangView{
    
    self.tangchuangBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight)];
    self.tangchuangBgView.backgroundColor = LDRGBColor(0, 0, 0, 0.0);
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.tangchuangBgView];
    
    self.verCodeView = [[HDARVerificationCodeView alloc]initWithFrame:CGRectMake(0, LDScreenHeight, LDScreenWidth, 216+187*bili)];
    
    [self.verCodeView createSubView];
    [self.tangchuangBgView addSubview:self.verCodeView];
    
    /** 赋值发送验证码的手机号 */
    if (self.signResult.phone != nil) {
        NSMutableString *phone = [[NSMutableString alloc] initWithString:self.signResult.phone];
        [phone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.verCodeView.smallLabel.text = [NSString stringWithFormat:@"验证码发送至%@",phone];
    }
    
    
    /** 启动验证码计时器 */
    [self yanZhengMaTimeChange];
    
    [self.verCodeView.cancelButton addTarget:self action:@selector(tanchuangCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.verCodeView.againButton addTarget:self action:@selector(tanchuangAgain:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.tangchuangBgView.backgroundColor = LDRGBColor(0, 0, 0, 0.5);
        
        self.verCodeView.frame = CGRectMake(0, LDScreenHeight - (216+187*bili), LDScreenWidth, 216+187*bili);
        
    } completion:^(BOOL finished) {
        
    }];
    
    /** 验证码填写完后回调验证码 */
    __block typeof(self) blockSelf = self;
    self.verCodeView.complationBlock = ^(NSString * password){
        
        /** 创建支付选择窗 */
        blockSelf.successView = [[HDARSuccessView alloc]initWithFrame:CGRectMake(0, LDScreenHeight - (216+187*bili), LDScreenWidth, 216+187*bili)];
        [blockSelf.tangchuangBgView addSubview:blockSelf.successView];
        
        [blockSelf.successView createTitleView];
        
        /** 发送支付请求 */
        [blockSelf sendPaymentPayRequest:password];
        
    };
}
- (void)stopRotati{
    
    [self.successView stopRotation];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5f
                                                  target:self
                                                selector:@selector(pushNextController)
                                                userInfo:nil
                                                 repeats:YES];
    
    
}

/** 支付成功推出成功窗 */
- (void)pushNextController{
    
    [self.verCodeView removeFromSuperview];
    
    [self.tangchuangBgView removeFromSuperview];
    
    self.verCodeView = nil;
    self.tangchuangBgView = nil;
    
    [self.timer invalidate];
    
    HDARZhifuSuccessController * successVC = [[HDARZhifuSuccessController alloc]init];
    successVC.paymentAmt = self.repayConfirm.repayAmt;
    [self.navigationController pushViewController:successVC animated:YES];
    
}

/** 关闭弹窗 */
- (void)tanchuangCancel:(UIButton *)sender{
    [UIView animateWithDuration:0.3f animations:^{
        self.tangchuangBgView.backgroundColor = LDRGBColor(0, 0, 0, 0.0);
        
        self.verCodeView.frame = CGRectMake(0, LDScreenHeight, LDScreenWidth, 216+187*bili);
    } completion:^(BOOL finished) {
        
        [self.verCodeView removeFromSuperview];
        
        [self.tangchuangBgView removeFromSuperview];
        
        self.verCodeView = nil;
        self.tangchuangBgView = nil;
        
    }];
    
}
/** 重新发送验证码  */
- (void)tanchuangAgain:(UIButton *)sender{
    
    /** 启动验证码计时器 */
    [self yanZhengMaTimeChange];
    
    /** 再次签约获取验证码 */
    [self sendPaymentSignRequest];
}


/** 获取银行卡列表  */
- (void)sendBankCardListRequest{
    
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@person/bankcard/list",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:@"1" forKey:@"channel"];
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"billInfo == %@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                
                
                if (backInfo.result != nil) {
                    NSArray * array = backInfo.result[@"list"];
                    
                    self.bankArray = [LDHaveCardListModel mj_objectArrayWithKeyValuesArray:array];
                    
                    /** 银行卡列表不为空 */
                    if (self.bankArray.count > 0) {
                        
                        [self dismissHDLoading];
                        
                        [self createChooseBankView];
                    }
                    /** 银行卡列表为空 再次请求扣款卡*/
                    else{
                        [self dismissHDLoading];
                        
                        [self tanchuangXinBank:nil];
                    }
                }
                else{
                    
                    /** 请求数据为空，直接推出添加银行卡  */
                    [self dismissHDLoading];
                    
                    [self tanchuangXinBank:nil];
                    
                }
                
            }else{
                [self showFailViewWithString:backInfo.message];
            }
            
        }
    }];
}


/** 签约获取验证码  */
- (void)sendPaymentSignRequest{
    
    [self showWithImageWithString:@"请稍后..."];
    
    NSString * str = [NSString stringWithFormat:@"%@payment/sign",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    /** 银行卡id */
    params[@"bankCardId"] = self.signBankCardId;

    /** 订单id */
    params[@"applyId"] = self.orderRepays.orderNo;
    
    /** 交易金额 */
    params[@"amount"] = self.repayConfirm.repayAmt;
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"billInfo == %@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                self.signResult = [HDARBankCardList mj_objectWithKeyValues:backInfo.result];
                
                self.signBankCardId = self.signResult.bankCardId;
                
                self.signResult.bank = self.repayConfirm.bankName;
                
                self.signResult.cardtailno = self.repayConfirm.bankNo;
                
                /** 获取到验证码，如果验证码弹窗不存在，创建弹窗*/
                if (self.verCodeView == nil) {
                    /** 创建支付验证码半窗 */
                    [self createTanChuangView];
                }
            }
            else if ([backInfo.code isEqualToString:@"-201"]){
                
                [self showFailViewWithString:@"签约失败"];
            }
            
            else{
                [self showFailViewWithString:backInfo.message];
            }
            
        }
    }];
}


/** 支付请求 */
- (void)sendPaymentPayRequest:(NSString *)smsCode{
    
    NSString * str = [NSString stringWithFormat:@"%@payment/pay",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    /** 订单id */
    params[@"applyId"] = self.orderRepays.orderNo;
    
    /** 银行卡Id  */
    params[@"bankCardId"] = self.signResult.bankCardId;
    
    /** 交易id */
    params[@"paymentId"] = self.signResult.paymentId;
    
    /** 金额  */
    params[@"amount"] = self.repayConfirm.repayAmt;
    
    /** 验证码 */
    params[@"smsCode"] = smsCode;
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
            /** 支付加载视图从父视图中移除*/
            [self.successView removeFromSuperview];
            
            /** 置空支付加载视图  */
            self.successView = nil;
            
            /** 清空验证码 */
            [self.verCodeView clearYanZhengMa];
            
            /** 验证码视图获得第一响应者 */
            [self.verCodeView.textField becomeFirstResponder];
            
        }else{
            
            LDLog(@"billInfo == %@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 停止，绘制成功对勾*/
                [self stopRotati];
                
            }
            else{
                
                /** 支付加载视图从父视图中移除*/
                [self.successView removeFromSuperview];
                
                /** 置空支付加载视图  */
                self.successView = nil;
                
                /** 清空验证码 */
                [self.verCodeView clearYanZhengMa];
                
                /** 验证码视图获得第一响应者 */
                [self.verCodeView.textField becomeFirstResponder];
                
                /** 支付失败提示 */
                if ([backInfo.code isEqualToString:@"-101"]) {
                    
                    [self showFailViewWithString:@"银行卡不存在"];
                    
                }
                else if ([backInfo.code isEqualToString:@"-102"]) {
                    
                    [self showFailViewWithString:@"该银行卡未签约"];
                    
                }
                else if ([backInfo.code isEqualToString:@"-201"]) {
                    
                    [self showFailViewWithString:@"京东支付失败"];
                    
                }
                else{
                    [self showFailViewWithString:backInfo.message];
                }
                
            }
            
            
        }
    }];
}

/** 获取银行卡详情  */
- (void)sendPersonBankcardDetailRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@person/bankcard/detail",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    /** 银行卡Id  */
    if (self.arBank != nil) {
        params[@"bankCardId"] = self.arBank.id;
    }
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"billInfo == %@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                /** 解析银行卡详情 */
                self.bankDetail = [HDARBankDetail mj_objectWithKeyValues:backInfo.result];
                /** 推出银行卡签约界面 */
                [self pushAddCardBankController];
                
            }
            
            else{
                [self showFailViewWithString:backInfo.message];
            }
            
            
        }
    }];
}

//启动计时器，开始倒计时
- (void)yanZhengMaTimeChange{
    
    [self.YZTimer invalidate];
    
    [self.verCodeView.againButton setTitleColor:WHColorFromRGB(0xbdbdbd) forState:UIControlStateNormal];
    
    self.verCodeView.againButton.userInteractionEnabled = NO;
    self.time = 60;
    [self.verCodeView.againButton setTitle:@"重新获取(60s)" forState:UIControlStateNormal];
    
    self.YZTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}
//修改时间
- (void)timeChange{
    
    
    self.time --;
    if (self.time == 0) {
        
        [self.verCodeView.againButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
        self.verCodeView.againButton.userInteractionEnabled = YES;
        [self.verCodeView.againButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self.YZTimer invalidate];
        
    }else{
        [self.verCodeView.againButton setTitle:[NSString stringWithFormat:@"重新获取(%.2ds)",self.time] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
