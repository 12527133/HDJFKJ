

#import "CashLoanController.h"
#import "WHCashLoanFirstView.h"
#import "WHCashLoanFiveView.h"
#import "WHCashLoanFourView.h"
#import "WHCashLoanScondView.h"
#import "WHCashLoanThreeView.h"
#import "WHCashLoanSixCiew.h"
#import "WHTiJiaoControllrt.h"
#import "WHUserLoginModel.h"
#import "WebView.h"

/** 担保商模型  */
#import "HDCashBusinessModel.h"

@interface CashLoanController ()<UITextFieldDelegate>
//ScrolleView用于添加更多内容
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) WHCashLoanFirstView * firstView;

@property (nonatomic, strong) WHCashLoanScondView * secondView;

@property (nonatomic, strong) WHCashLoanThreeView * threeView;

@property (nonatomic, strong) WHCashLoanFourView * fourView;

@property (nonatomic, strong) WHCashLoanFiveView * fiveView;

@property (nonatomic, strong) WHCashLoanSixCiew * sixView;


//当前选择中的期数
@property (nonatomic, strong) UIButton * currentQishuButton;
//当前选中的用途按钮
@property (nonatomic, strong) UIButton * currentYongtuButton;
@property (nonatomic, strong) NSString * yongtu;

@property (nonatomic, strong) NSMutableArray * qishuButtonArray;
@property (nonatomic, strong) NSMutableArray * yongtuButtonArray;

@property (nonatomic, strong) NSMutableDictionary * params;

@property (nonatomic, strong) WHUserLoginModel * user;

@end

@implementation CashLoanController

/**
 * 延期加载期数数组
 **/
- (NSMutableArray *)qishuButtonArray{
    if (!_qishuButtonArray) {
        _qishuButtonArray = [[NSMutableArray alloc]init];
    }
    return _qishuButtonArray;
}

/**
 * 延迟加载用途数组
 **/
- (NSMutableArray *)yongtuButtonArray{
    if (!_yongtuButtonArray) {
        _yongtuButtonArray = [[NSMutableArray alloc]init];
    }
    return _yongtuButtonArray;
}

/**
 * 延迟加载ScrollView
 **/
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.user = [WHUserLoginModel createuserInfoModel];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"现金贷";
    
    //初始化scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, LDScreenWidth, LDScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.contentSize = CGSizeMake(LDScreenWidth, LDScreenHeight-64);
    _scrollView.backgroundColor = WHColorFromRGB(0xf6f6f6);
    
    [self createFirstView];
    [self createSecondView];
    [self createThreeView];
    [self createFourView];
    [self createFiveView];
    [self createSixView];
    
    //消除第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
}
//点屏幕取消键盘
- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tapGesture{

    [self.view endEditing:YES];
}



//创建贷款金额试图
- (void)createFirstView{
    self.firstView = [WHCashLoanFirstView view];
    self.firstView.frame = CGRectMake(0, 10, LDScreenWidth, 45);
    self.firstView.cashMoneyTextFiled.delegate = self;
    self.firstView.cashMoneyTextFiled.tag = 1;
    self.firstView.cashMoneyTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.firstView.cashMoneyTextFiled addTarget:self action:@selector(cashTextFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    
    [_scrollView addSubview:self.firstView];
}

//textField响应方法
- (void)cashTextFieldDidChange:(UITextField *)sender{
    NSUInteger index = [self.firstView.cashMoneyTextFiled.text rangeOfString:@"."].location;
    NSRange range = [@"." rangeOfString:self.firstView.cashMoneyTextFiled.text];
    if ( range.location == 0) {
        self.firstView.cashMoneyTextFiled.text = @"";
    }else {
        if (self.firstView.cashMoneyTextFiled.text.length > index+ 2) {
            self.firstView.cashMoneyTextFiled.text = [self.firstView.cashMoneyTextFiled.text substringToIndex:index + 3];
        }
        float cashMonry = [self.firstView.cashMoneyTextFiled.text floatValue];
        if (cashMonry > 200000) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"贷款金额，每笔最高20万" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            
            double monthmoney = [self getAvergMonthMoney:self.firstView.cashMoneyTextFiled.text duration:self.currentQishuButton.tag];
            self.secondView.avergMonthMontyLabel.text = [NSString stringWithFormat:@"%.2f",monthmoney];
        }
    
    }
    
    
}
- (double)getAvergMonthMoney:(NSString *)money duration:(NSInteger )duration{
    double totalMoney = [money doubleValue];
    double month = (double)duration ;
    double monthmoney=(totalMoney*0.125/12*(pow((1+0.125/12),month)))/(pow((1+0.125/12),month)-1)+totalMoney*0.29/100;
    return monthmoney;
}


//创建期数按钮的试图
- (void)createSecondView{
    self.secondView = [WHCashLoanScondView view];
    self.secondView.frame = CGRectMake(0, 65, LDScreenWidth, 130);
    [_scrollView addSubview:self.secondView];
    
    self.secondView.sixButton.tag = 6;

    [self.secondView.sixButton addTarget:self action:@selector(clickQiShuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondView.nineButton.tag = 9;
    [self.secondView.nineButton addTarget:self action:@selector(clickQiShuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.secondView.twelveButton.tag = 12;
    [self.secondView.twelveButton addTarget:self action:@selector(clickQiShuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondView.eighteenButton.tag = 18;
    [self.secondView.eighteenButton addTarget:self action:@selector(clickQiShuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.secondView.twentyfourButton.tag = 24;
    [self.secondView.twentyfourButton addTarget:self action:@selector(clickQiShuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondView.thittysixButton.tag = 36;
    [self.secondView.thittysixButton addTarget:self action:@selector(clickQiShuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self LDReloadData];
}

- (void)LDReloadData{
    //每月还款数
    LDLog(@"%@",self.moneyCount);
    //贷款总额
    LDLog(@"%@",self.moneySumCount);
    //分期数
    LDLog(@"%@",self.monthCount);
    
    
    //self.firstView.cashMoneyTextFiled.userInteractionEnabled = NO;
    self.firstView.cashMoneyTextFiled.text = self.moneySumCount;
    self.secondView.avergMonthMontyLabel.text = self.moneyCount;
    switch ([self.monthCount intValue]) {
        case 6:
            
            self.secondView.sixButton.selected = YES;
            self.currentQishuButton = self.secondView.sixButton;
            break;
        case 9:
            
            self.secondView.nineButton.selected = YES;
            self.currentQishuButton = self.secondView.nineButton;
            break;
        case 12:
            
            self.secondView.twelveButton.selected = YES;
            self.currentQishuButton = self.secondView.twelveButton;
            break;
        case 18:
            
            
            self.secondView.eighteenButton.selected = YES;
            self.currentQishuButton = self.secondView.eighteenButton;
            break;
        case 24:
          
            
            self.secondView.twentyfourButton.selected = YES;
            self.currentQishuButton = self.secondView.twentyfourButton;
            break;
        case 36:
            
            
            self.secondView.thittysixButton.selected = YES;
            self.currentQishuButton = self.secondView.thittysixButton;
            break;
        default:
           
            self.secondView.sixButton.selected = YES;
            self.currentQishuButton = self.secondView.sixButton;
            break;
            
    }
    
    
}

//点击期数按钮
- (void)clickQiShuButton:(UIButton *)sender{

    //切换当前选择的期数按钮
    self.currentQishuButton.selected = NO;
    sender.selected = YES;
    self.currentQishuButton = sender;
    if (self.firstView.cashMoneyTextFiled.text.length > 0) {
        
        double monthmoney = [self getAvergMonthMoney:self.firstView.cashMoneyTextFiled.text duration:self.currentQishuButton.tag];
        self.secondView.avergMonthMontyLabel.text = [NSString stringWithFormat:@"%.2f",monthmoney];
    }
}

- (void)createThreeView{
    
    self.threeView = [WHCashLoanThreeView view];
    self.threeView.frame = CGRectMake(0, 205, LDScreenWidth, 90);
    [_scrollView addSubview:self.threeView];
    
    
    self.threeView.lvyouButton.selected = YES;
    self.currentYongtuButton = self.threeView.lvyouButton;
    self.yongtu = self.threeView.lvyouButton.titleLabel.text;
    
    [self.threeView.lvyouButton addTarget:self action:@selector(clickYongtuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.threeView.hunqingButton addTarget:self action:@selector(clickYongtuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.threeView.zhuangxiuButton addTarget:self action:@selector(clickYongtuButton:) forControlEvents:UIControlEventTouchUpInside];
    

    [self.threeView.jiaoyuButton addTarget:self action:@selector(clickYongtuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.threeView.otherButton addTarget:self action:@selector(clickYongtuButton:) forControlEvents:UIControlEventTouchUpInside];
    
}
//用途按钮
- (void)clickYongtuButton:(UIButton *)sender{
    
    //切换当前选择额按钮
    self.currentYongtuButton.selected = NO;
    sender.selected = YES;
    self.currentYongtuButton = sender;
    if (![sender.titleLabel.text isEqualToString:@"其他"]) {
        self.yongtu = sender.titleLabel.text;
        [self reSetViewFrame];
    }else{
        [self reSetViewFrame];
        self.yongtu = @"";
    }
    
}


- (void)createFourView{
    self.fourView = [WHCashLoanFourView view];
    self.fourView.frame = CGRectMake(0, 295, LDScreenWidth, 90);
    self.fourView.hidden = YES;
    [_scrollView addSubview:self.fourView];
    self.fourView.daikuanyongyuTextField.delegate = self;
    self.fourView.daikuanyongyuTextField.returnKeyType = UIReturnKeyDone;
    self.fourView.daikuanyongyuTextField.tag = 2;
}

- (void)createFiveView{
    
    self.fiveView = [WHCashLoanFiveView view];
    
    self.fiveView.frame = CGRectMake(0, 305, LDScreenWidth, 90);
    
    [_scrollView addSubview:self.fiveView];
    
    self.fiveView.bissnessIDTextField.delegate = self;
    self.fiveView.bissnessIDTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.fiveView.bissnessIDTextField.returnKeyType = UIReturnKeyDone;
    self.fiveView.bissnessIDTextField.tag = 3;
    
}
- (void)createSixView{
    self.sixView = [WHCashLoanSixCiew view];
    self.sixView.frame = CGRectMake(0, _scrollView.contentSize.height - 100, LDScreenWidth, 100);
    [_scrollView addSubview:self.sixView];
    
    [self.sixView.shenqingshuButton addTarget:self action:@selector(clickShenqingshu:) forControlEvents:UIControlEventTouchUpInside];
    [self.sixView.nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    
}
//点申请书
- (void)clickShenqingshu:(UIButton *)sender{
    WebView * webView = [[WebView alloc]initWithURL:@"http://123.56.233.192/appagree/agreement.html"];
    [self.navigationController pushViewController:webView animated:YES];



}
//点击下一步
- (void)clickNext:(UIButton *)sender{
    float cashMoney = [self.firstView.cashMoneyTextFiled.text floatValue];
    
    if (cashMoney == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"贷款金额不能为0元" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if (cashMoney > 200000){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"贷款金额，每笔最高20万" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else if ([self.fiveView.bisnessNameLabel.text isEqualToString:@"暂无信息"] || self.fiveView.bisnessNameLabel.text.length == 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"担保商户不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else if (self.yongtu.length == 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择贷款用途" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    else{
        [self sendCashLoanRequest];
        
    }

}



//重新设置第四个view和第五个View的Frame
- (void)reSetViewFrame{
    
    
    
    if ([self.currentYongtuButton.titleLabel.text isEqualToString:@"其他"]) {
        float height = 595;
        if (height > LDScreenHeight - 64) {
            _scrollView.contentSize = CGSizeMake(LDScreenWidth, height);
        }
        else{
            _scrollView.contentSize = CGSizeMake(LDScreenWidth, LDScreenHeight - 64);
        }
        self.fourView.hidden = NO;
        self.fiveView.frame = CGRectMake(0, 395, LDScreenWidth, 90);
        
    }else{
        
        _scrollView.contentSize = CGSizeMake(LDScreenWidth, LDScreenHeight - 64);
        
        self.fiveView.frame = CGRectMake(0, 305, LDScreenWidth, 90);
        self.fourView.hidden = YES;
    }
    self.sixView.frame = CGRectMake(0, _scrollView.contentSize.height - 100, LDScreenWidth, 100);
}


#pragma mark -- textField的协议方法
//取消键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self.view endEditing:YES];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 3) {
        
        self.fiveView.bisnessNameLabel.text = @"暂无信息";
        if (_scrollView.contentSize.height > _scrollView.frame.size.height) {
            
            
            [UIView animateWithDuration:0.35 animations:^{
                _scrollView.contentOffset = CGPointMake( 0, _scrollView.contentSize.height - _scrollView.frame.size.height);
            } completion:nil];
            
            
        }
        
        
        //输入商户id的试图距离scrollView下变得高度
        float distance = _scrollView.contentSize.height - self.fiveView.frame.origin.y;
        
        if (distance < 216) {
            
            [UIView animateWithDuration:0.35 animations:^{
                
                self.view.frame = CGRectMake(0.0, distance -(216+84), self.view.frame.size.width, self.view.frame.size.height);
                
            } completion:nil];
            
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 3){
        [self sendGetBissnessNameRequest];
    }
    
    if (textField.tag == 2) {
        self.yongtu = textField.text;
    }
    [UIView animateWithDuration:0.35 animations:^{
        self.view.frame = CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
    
    

}

//获取担保商名称请求
- (void)sendGetBissnessNameRequest{
    
    [MBProgressHUD showMessage:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@cashLoan/queryBussinessNm",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.user.id forKey:@"userId"];
    [params setObject:self.user.token forKey:@"token"];
    [params setObject:self.fiveView.bissnessIDTextField.text forKey:@"bussinessId"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil)
        {
    
            NSLog(@"%@",error);
            
            /** 1.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
        }
        else
        {
            
            LDLog(@"%@",response);
            
            /** 2.解析担保商信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.errcode isEqualToString:@"200"]) {
                
                
                
                /** 3.解释商户信息  */
                HDCashBusinessModel * bussiness = [HDCashBusinessModel mj_objectWithKeyValues:backInfo.object];
                
                /** 4.给视图控件赋值 */
                if (bussiness.name != nil) {
                    
                    [MBProgressHUD hideHUD];
                    
                    self.fiveView.bisnessNameLabel.text = bussiness.name;
                }
                else{
                    [MBProgressHUD showError:@"无商户名称"];
                    
                    self.fiveView.bisnessNameLabel.text = @"";
                }
                
            }
            
            else
            {
                /** 5.返回异常提示*/
                [MBProgressHUD showError:backInfo.msg];
                
                self.fiveView.bisnessNameLabel.text = @"";
            
            }
            
        }
    }];
}

//发送现金待请求
- (void)sendCashLoanRequest{
    
    
    [MBProgressHUD showMessage:@"正在提交"];
    
    NSString * str = [NSString stringWithFormat:@"%@cashLoan/uploadRedis",KBaseUrl];
    self.params = [NSMutableDictionary dictionary];
    
    [_params setObject:[LDUserInformation sharedInstance].UserId forKey:@"userId"];
    [_params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [_params setObject:self.firstView.cashMoneyTextFiled.text forKey:@"loanAmount"];
    [_params setObject:[NSString stringWithFormat:@"%ld",(long)self.currentQishuButton.tag] forKey:@"periods"];
    [_params setObject:self.secondView.avergMonthMontyLabel.text forKey:@"periodAmount"];
    [_params setObject:self.yongtu forKey:@"usage"];
    [_params setObject:self.fiveView.bissnessIDTextField.text forKey:@"bussinessId"];
    [_params setObject:self.fiveView.bisnessNameLabel.text forKey:@"bussinessName"];

    [[LDNetworkTools sharedTools] request:POST url:str params:_params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            NSLog(@"%@",error);
            
            /** 1.显示失败信息 */
            [MBProgressHUD showError:@"网络错误"];
        }else{
            
            /** 2.解析返回结果*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.errcode isEqualToString:@"200"]) {
                
                [MBProgressHUD hideHUD];
                
                /** 3.推出提交其他资料界面 */
                WHTiJiaoControllrt * tijiao = [[WHTiJiaoControllrt alloc]init];
                tijiao.fromWhere = @"xianjindai";
                tijiao.params = self.params;
                
                [self.navigationController pushViewController:tijiao animated:YES];
            }
            else
            {
                /** 4.请求异常提示*/
                [MBProgressHUD showError:backInfo.msg];
            }
            
            
        }
         LDLog(@"%@",response);
    }];
   
}

@end
