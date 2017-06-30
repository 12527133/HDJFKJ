//
//  LDJobTabbleViewController.m
//  ceshi
//
//  Created by 石伟浩 on 16/5/19.
//  Copyright © 2016年 石伟浩. All rights reserved.
//

#import "LDJobTabbleViewController.h"
#import "WHJobView.h"
#import "LDBasicGroupModel.h"
#import "LDBasicModel.h"
#import "LDBaseInformationCell.h"
#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"
#import "LDBaseInformationCell.h"

#import "LTPickerView/LTPickerView.h"

#import "WHShangBanZuModel.h"

#import "LDTabBarController.h"
#import "LDContactInformationViewController.h"
@interface LDJobTabbleViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,STPickerAreaDelegate, STPickerDateDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) WHJobView * jobView;

@property (nonatomic, copy) NSString  *jobNum;
@property (nonatomic, copy) NSString * companySizeNum;
@property (nonatomic, copy) NSString *nowYearNum;
@property (nonatomic, strong) NSString * sumYear;
@property (nonatomic, strong) NSString *postNum;
/**
 *  "区号"和"电话" "-" 拼接后的字符串
 */
@property (nonatomic,copy) NSString * pingJiePhoneNumber;

/**
 *  拆分省市
 */
@property (nonatomic,strong) NSString * JobProvince;
@property (nonatomic,strong) NSString * JobCityArea;

@property (nonatomic, strong) WHShangBanZuModel * shangbanzu;

@property (nonatomic, assign) float moveHeight;
@end

@implementation LDJobTabbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"工作信息";
    
    //1.创建ScrollView
    [self createScrollView];
    
    //2.创建联系人试图
    [self createJobView];
    
    self.moveHeight = 0;
    if (LDScreenHeight > 667) {
        self.moveHeight = -150;
    }
    
    else{
        self.moveHeight = -216;
    }
    
    if ([self.fromeWhere isEqualToString:@"wode"] || [self.fromeWhere isEqualToString:@"xiugai"]) {
        [self requestShangBanZuMessageRequest];
        
    }
    
    
    [self createGobackHomePageButton];
    
    //消除第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
}

- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tap{
    
    
    [self selfViewEnding];
}



- (void)createGobackHomePageButton{
    UIButton * backHomePage = [[UIButton alloc]init];
    backHomePage.size = CGSizeMake(50, 30);
    
    [backHomePage setTitleColor:WHColorFromRGB(0x051b28) forState:UIControlStateNormal];
    [backHomePage setTitle:@"关闭" forState:UIControlStateNormal];
    //[backHomePage setBackgroundColor:[UIColor redColor]];
    [backHomePage addTarget:self action:@selector(clickbackHomePage:) forControlEvents:UIControlEventTouchUpInside];
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backHomePage];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:leftItem, nil];
    
}
- (void)clickbackHomePage:(UIButton *)sender{
    LDTabBarController * tabbar = [[LDTabBarController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
    
}
- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}


/***
 *9.21修改登陆键盘弹出，见面上移
 ****/
//注册键盘通知
- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UITextViewTextDidEndEditingNotification object:nil];
}

//键盘弹起时
-(void)openKeyboard:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.35f animations:^{
        self.view.frame = CGRectMake( 0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

//键盘收起时
- (void)closeKeyboard:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

//1.创建ScrollView
- (void)createScrollView{
    //初始化scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.contentSize = CGSizeMake(LDScreenWidth, 595);
    _scrollView.backgroundColor = WHColorFromRGB(0xf0f0f0);
}
//2.创建工作信息视图
- (void)createJobView{
    _jobView = [WHJobView view];
    _jobView.frame = CGRectMake(0, 0, LDScreenWidth, 595);
    [_scrollView addSubview:_jobView];
    
    
    _jobView.companyName.delegate = self;
    _jobView.companyName.tag = 1;
    _jobView.companyName.keyboardType = UIKeyboardTypeDefault;
    
    _jobView.companyQuHao.delegate = self;
    _jobView.companyQuHao.tag = 2;
    _jobView.companyQuHao.keyboardType = UIKeyboardTypeNumberPad;
    
    _jobView.companyPhone.delegate = self;
    _jobView.companyPhone.tag = 3;
    _jobView.companyPhone.keyboardType = UIKeyboardTypeNumberPad;
    
    [_jobView.companyQuHao addTarget:self action:@selector(companyQuHaoChange:) forControlEvents:UIControlEventEditingChanged];
    [_jobView.companyPhone addTarget:self action:@selector(companyPhoneChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [_jobView.jobButton addTarget:self action:@selector(clickJobButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.companySizeButton addTarget:self action:@selector(clickCompanySizeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.nowYearButton addTarget:self action:@selector(clickNowYearButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.sumYearNumButton addTarget:self action:@selector(clickSumYearNumButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.postButton addTarget:self action:@selector(clickPostButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.companyPlaceButton addTarget:self action:@selector(clickCompanyPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.companyDetailPlaceButton addTarget:self action:@selector(clickCompanyDetailPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_jobView.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

//限制区号和电话号的输入位数
- (void)companyQuHaoChange:(UITextField *)sender{
    if (sender.text.length > 4) {
        sender.text = [NSString stringWithFormat:@"%@",[sender.text substringToIndex:4]];
    }
}
- (void)companyPhoneChange:(UITextField *)sender{
    if (sender.text.length > 13) {
        sender.text = [NSString stringWithFormat:@"%@",[sender.text substringToIndex:13]];
    }
}

#pragma mark -- 职业按钮
- (void)clickJobButton:(UIButton *)sender{
    [self selfViewEnding];
    
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = @[@"公务员、教师、医师、律师等专业人员",@"金融、电力、能源等资源垄断行业",@"国有大中型企业或业务合作单位",@"中小型企业，有固定职业",@"个体工商户",@"无固定职业",@"无"];//设置要显示的数据
    pickerView.defaultStr = @"1";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        switch (num) {
            case 0:
                self.jobNum = @"A";
                break;
            case 1:
                self.jobNum = @"B";
                break;
            case 2:
                self.jobNum = @"C";
                break;
            case 3:
                self.jobNum = @"D";
                break;
            case 4:
                self.jobNum = @"E";
                break;
            case 5:
                self.jobNum = @"F";
                break;
            case 6:
                self.jobNum = @"G";
                break;
        }
        _jobView.job.text = str;
        
        LDLog(@"%@",_jobView.job.text);
    };
    pickerView.closeblock = ^{};
    
}
#pragma mark -- 单位规模按钮
- (void)clickCompanySizeButton:(UIButton *)sender{
    [self selfViewEnding];
    
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = @[@"20人以下",@"50人(含)以下",@"50-100人",@"100-500人",@"500人以上",@"无",@"501-1000",@"1001-5000人",@"5000以上"];//设置要显示的数据
    pickerView.defaultStr = @"1";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        
        _jobView.companySize.text = str;
        self.companySizeNum = [NSString stringWithFormat:@"%d",num];
        LDLog(@"%@",_jobView.companySize.text);
    };
    pickerView.closeblock = ^{
        
    };
}
#pragma mark -- 现单位工作年限按钮
- (void)clickNowYearButton:(UIButton *)sender{
    [self selfViewEnding];
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];//设置要显示的数据
    pickerView.defaultStr = @"1";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        
        _jobView.nowYear.text = str;
        self.nowYearNum = [NSString stringWithFormat:@"%d",num];
        LDLog(@"%@",_jobView.nowYear.text);
    };
    pickerView.closeblock = ^{};
}
#pragma mark -- 总工作年限按钮
- (void)clickSumYearNumButton:(UIButton *)sender{
    [self selfViewEnding];
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];//设置要显示的数据
    pickerView.defaultStr = @"1";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        _jobView.sumYearNum.text = str;
        self.sumYear = [NSString stringWithFormat:@"%d",num];
        LDLog(@"%@",_jobView.sumYearNum.text);
    };
    pickerView.closeblock = ^{};
}
#pragma mark -- 职务按钮
- (void)clickPostButton:(UIButton *)sender{
    [self selfViewEnding];
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = @[@"高级管理人员",@"一般管理人员",@"一般正式员工",@"非正式员工",@"无",@"企业负责人",@"中层管理人员",@"其他",@"厅局级以上",@"处级",@"科级",@"一般干部"];//设置要显示的数据
    pickerView.defaultStr = @"1";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        int postNumber = -1;
        
        if (num < 7) {
            
            postNumber = num + 1;
            self.postNum = [NSString stringWithFormat:@"%d",postNumber];
            _jobView.post.text = str;
            LDLog(@"(<7)%@=====www%@",_jobView.post.text,self.postNum);
            
        }
        if (num == 7) {
            postNumber = num + 2;
            self.postNum = [NSString stringWithFormat:@"%d",postNumber];
            _jobView.post.text = str;
            LDLog(@"(=7)%@=====%@",_jobView.post.text,self.postNum);
        }
        if (num > 7) {
            
            postNumber = num + 3;
            self.postNum = [NSString stringWithFormat:@"%d",postNumber];
            _jobView.post.text = str;
            LDLog(@"(>7)%@=====%@",_jobView.post.text,self.postNum);
        }
        
        _jobView.post.text = str;
        LDLog(@"%@wwww%@",_jobView.post.text,self.postNum);
    };
    pickerView.closeblock = ^{};
}
#pragma mark -- 单位地址按钮
- (void)clickCompanyPlaceButton:(UIButton *)sender{
    [self selfViewEnding];
    if (LDScreenHeight < 667) {
        [UIView animateWithDuration:0.3f animations:^{
            _scrollView.contentOffset = CGPointMake( 0, _scrollView.contentSize.height - _scrollView.frame.size.height);
            
        }];
    }
    
    
    [[[STPickerArea alloc]initWithDelegate:self]show];
}
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    _jobView.companyPlace.text = text;
    
    self.JobProvince = province;
    if ([province isEqualToString:@"北京"]) {
        area = city;
        city = @"北京";
        
    }
    if ([province isEqualToString:@"上海"]) {
        area = city;
        city = @"上海";
        
    }
    if ([province isEqualToString:@"天津"]) {
        area = city;
        city = @"天津";
        
    }
    if ([province isEqualToString:@"重庆"]) {
        area = city;
        city = @"重庆";
        
    }
    self.JobCityArea = [NSString stringWithFormat:@"%@ %@",city,area];
    
}


#pragma mark -- 单位详细地址按钮
- (void)clickCompanyDetailPlaceButton:(UIButton *)sender{
    [sender setTitle:@"" forState:UIControlStateNormal];
    [_jobView.companyDetailPlace becomeFirstResponder];
}

#pragma mark -- textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ( textField.tag > 1) {
        [UIView animateWithDuration:0.35f animations:^{
            
            if (LDScreenHeight < 667) {
                [UIView animateWithDuration:0.3f animations:^{
                    _scrollView.contentOffset = CGPointMake( 0, _scrollView.contentSize.height - _scrollView.frame.size.height);
                    self.view.frame = CGRectMake(0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
                    
                }];
            }
            
            else{
                [UIView animateWithDuration:0.3f animations:^{
                    
                    self.view.frame = CGRectMake(0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
                    
                }];
            }
            
        }];
        
    }
    else{
        [UIView animateWithDuration:0.35f animations:^{
            
            self.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    if (_jobView.companyDetailPlace.text.length == 0) {
        [_jobView.companyDetailPlaceButton setTitle:@"街道/楼/室" forState:UIControlStateNormal];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
}
- (void)selfViewEnding{
    [self.view endEditing:YES];
    if (_jobView.companyDetailPlace.text.length == 0) {
        [_jobView.companyDetailPlaceButton setTitle:@"街道/楼/室" forState:UIControlStateNormal];
    }
}

#pragma mark -- 验证用户信息,发送数据
- (void)clickNextButton:(UIButton *)sender{
    if (_jobView.companyName.text.length == 0 || _jobView.job.text.length == 0 || _jobView.companySize.text.length == 0 || _jobView.nowYear.text.length == 0 || _jobView.sumYearNum.text.length == 0 || _jobView.post.text.length == 0 || _jobView.companyPlace.text.length == 0 || _jobView.companyDetailPlace.text.length == 0 || _jobView.companyPhone.text.length == 0 || _jobView.companyQuHao.text.length == 0) {
        [HDLoading showFailViewWithString:@"请将信息补充完善"];
    }
    else if (![self checkCompanyPhone]){
        [HDLoading showFailViewWithString:@"请输入正确的固定电话"];
    }
    else{
        [self sendRequest];
    }
}
- (BOOL)checkCompanyPhone{
    
    self.pingJiePhoneNumber = [NSString stringWithFormat:@"%@-%@",_jobView.companyQuHao.text,_jobView.companyPhone.text];
    
    if ((_jobView.companyQuHao.text.length == 3 || _jobView.companyQuHao.text.length == 4) && (_jobView.companyPhone.text.length > 6)) {
        
        return YES;
        
    }else{
        return NO;
    }
    
    
}
#pragma mark - 拼接参数
- (NSMutableDictionary *)getParameters{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    //公司名称
    [parameters setObject:NILSTR(_jobView.companyName.text) forKey:@"company"];
    //职业
    [parameters setValue:NILSTR(self.jobNum) forKey:@"work"];
    //规模
    [parameters setValue:self.companySizeNum forKey:@"companyScale"];
    //现工作年限
    [parameters setValue:NILSTR(self.nowYearNum) forKey:@"workYear"];
    //总工作年限
    [parameters setValue:NILSTR(self.sumYear) forKey:@"fullWorkYear"];
    //职务
    [parameters setValue:NILSTR(self.postNum) forKey:@"position"];
    //省
    [parameters setObject:NILSTR(self.JobProvince) forKey:@"companyAddrProvince"];
    //市区
    [parameters setObject:NILSTR(self.JobCityArea) forKey:@"companyAddrCounty"];
    //详细地址
    [parameters setObject:NILSTR(_jobView.companyDetailPlace.text) forKey:@"companyAddrTown"];
    //电话
    [parameters setObject:NILSTR(self.pingJiePhoneNumber) forKey:@"companyTelNo"];
    
    LDLog(@"公司名%@",[parameters objectForKey:@"company"]);
    
    LDLog(@"公司名%@",[parameters objectForKey:@"work"]);
    LDLog(@"工作类型%@",[parameters objectForKey:@"companyScale"]);
    LDLog(@"公司规模%@",[parameters objectForKey:@"workYear"]);
    LDLog(@"工作总年限%@",[parameters objectForKey:@"fullWorkYear"]);
    LDLog(@"职务%@",[parameters objectForKey:@"position"]);
    LDLog(@"公司地址%@",[parameters objectForKey:@"companyAddrProvince"]);
    LDLog(@"公司地址详细地址%@",[parameters objectForKey:@"companyAddrTown"]);
    LDLog(@"公司电话%@",[parameters objectForKey:@"companyTelNo"]);
    
    return parameters;
    
}
//发送数据
- (void)sendRequest{
    
    [HDLoading showWithImageWithString:@"正在提交"];
    NSString * url = [NSString stringWithFormat:@"%@register/workInfo",KBaseUrl];
    
    [[LDNetworkTools sharedTools] request:POST url:url params:[self getParameters] callback:^(id response, NSError *error) {
        if (error != nil) {
            
            LDLog(@"%@",error);
            [HDLoading showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];

            LDLog(@"%@",response);
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                [HDLoading dismissHDLoading];
                
                
                
                if ([self.fromeWhere isEqualToString:@"xinyongfen"]) {
                    
                    
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        
                        NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
                        
                        if ([vcClass isEqualToString:@"LDMySore"]) {
                            
                            //如果是确认订单控制器,就pop到该控制器
                            [self.navigationController popToViewController:vc animated:NO];
                            
                        }
                    }
                    
                }else{
                
            LDContactInformationViewController * advancedVC = [[LDContactInformationViewController alloc] init];
            
            advancedVC.fromeWhere = self.fromeWhere;
            
            [self.navigationController pushViewController:advancedVC animated:YES];
                
                
                }
                

            }
            
        }
    }];
    
    
}



//**************请求上班族数据*****************
- (void)requestShangBanZuMessageRequest{
    
    [HDLoading showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/work",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            // 显示失败信息
            [HDLoading showFailViewWithString:@"网络错误"];
        }else{
            
            NSString * code = [response objectForKey:@"code"] ;
            
            
            //code == 0请求成功
            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
                [HDLoading dismissHDLoading];
                
                NSDictionary * dict = [response objectForKey:@"result"];
                self.shangbanzu = [WHShangBanZuModel paresShangBanModelWithDictionary:dict];
                
                
                [self loadJobInfo];
                
            }else{
                // 显示失败信息
                [HDLoading showFailViewWithString:[response objectForKey:@"message"]];
            }
            
            LDLog(@"%@",response);
        }
    }];
}

//加载工作信息
- (void)loadJobInfo{
    
    //-------------公司名称-------------
    if ([self.shangbanzu.company isEqualToString:@"(null)"] || [self.shangbanzu.company isEqualToString:@"<null>"] || self.shangbanzu.company == nil) {
        
        self.shangbanzu.company = @"";
    }else{
        //_jobView.companyName.text = self.shangbanzu.company;
    }
    
    NSArray * arrayX = @[@"公务员、教师、医师、律师等专业人员",@"金融、电力、能源等资源垄断行业",@"国有大中型企业或业务合作单位",@"中小型企业，有固定职业",@"个体工商户",@"无固定职业",@"无"];
    
    //-------------职业------------------
    if ([self.shangbanzu.work isEqualToString:@"(null)"] || [self.shangbanzu.work isEqualToString:@"<null>"] || self.shangbanzu.work == nil) {
        self.shangbanzu.work = @"";
    }else{
//        self.jobNum = self.shangbanzu.work;
//        if ([self.shangbanzu.work isEqualToString:@"A"]) {
//            self.shangbanzu.work = @"公务员、教师、医师、律师等专业人员";
//        }
//        else if ([self.shangbanzu.work isEqualToString:@"B"]){
//            self.shangbanzu.work = @"金融、电力、能源等资源垄断行业";
//        }
//        else if ([self.shangbanzu.work isEqualToString:@"C"]){
//            self.shangbanzu.work = @"国有大中型企业或业务合作单位";
//        }
//        else if ([self.shangbanzu.work isEqualToString:@"D"]){
//            self.shangbanzu.work = @"中小型企业，有固定职业";
//        }
//        else if ([self.shangbanzu.work isEqualToString:@"E"]) {
//            self.shangbanzu.work = @"个体工商户";
//        }
//        else if ([self.shangbanzu.work isEqualToString:@"F"]){
//            self.shangbanzu.work = @"无固定职业";
//        }
//        else if ([self.shangbanzu.work isEqualToString:@"G"]) {
//            self.shangbanzu.work = @"无";
//        }
//        else{
//            self.shangbanzu.work = @"";
//        }
        
//        NSArray * array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G"];
//        NSInteger index = [array indexOfObject:self.shangbanzu.work ];
//        _jobView.job.text = arrayX[index] ;
//        self.jobNum = self.shangbanzu.work;
    }
    
    //--------------------公司规模---------------------
    if ([self.shangbanzu.companyScale isEqualToString:@"(null)"] || [self.shangbanzu.companyScale isEqualToString:@"<null>"] || self.shangbanzu.companyScale == nil) {
        
        self.shangbanzu.companyScale = @"";
    }else{
//        NSArray * array = @[@"20人以下",@"50人(含)以下",@"50-100人",@"100-500人",@"500人以上",@"无",@"501-1000",@"1001-5000人",@"5000以上"];
//        _jobView.companySize.text = array[[self.shangbanzu.companyScale intValue]] ;
//        self.companySizeNum = self.shangbanzu.companyScale;
    }
    
    //----------------当前工作年限--------------------
    if ([self.shangbanzu.workYear isEqualToString:@"(null)"] || [self.shangbanzu.workYear isEqualToString:@"<null>"] || self.shangbanzu.workYear == nil) {
        
        self.shangbanzu.workYear = @"";
    }else{
//        NSArray * array = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
//        _jobView.nowYear.text =array[[self.shangbanzu.workYear intValue]] ;
//        self.nowYearNum = self.shangbanzu.workYear;
    }
    
    //---------------总工作年限-------------------
    if ([self.shangbanzu.fullWorkYear isEqualToString:@"(null)"] || [self.shangbanzu.fullWorkYear isEqualToString:@"<null>"] || self.shangbanzu.fullWorkYear == nil) {
        self.shangbanzu.fullWorkYear = @"";
    }else{
//        NSArray * array = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
//        _jobView.sumYearNum.text =array[[self.shangbanzu.fullWorkYear intValue]] ;
//        self.sumYear = self.shangbanzu.fullWorkYear;
    }
    
    //-----------------职位-------------------
    if ([self.shangbanzu.position isEqualToString:@"(null)"] || [self.shangbanzu.position isEqualToString:@"<null>"] || self.shangbanzu.position == nil) {
        
        self.shangbanzu.position = @"";
    }else{
//        NSArray * array = @[@"高级管理人员",@"一般管理人员",@"一般正式员工",@"非正式员工",@"无",@"企业负责人",@"中层管理人员"];
//        NSArray * array2 = @[@"厅局级以上",@"处级",@"科级",@"一般干部"];
//        NSInteger postion = [self.shangbanzu.position intValue];
//        if (postion > 0 && postion < 8) {
//            _jobView.post.text = array[postion - 1] ;
//        }else if (postion == 9){
//            _jobView.post.text = @"其他";
//        }else{
//            _jobView.post.text = array2[postion -11];
//        }
//        self.postNum = self.shangbanzu.position;
    }
    
    //--------------------公司省份--------------------
    if ([self.shangbanzu.companyAddrProvince isEqualToString:@"(null)"] || [self.shangbanzu.companyAddrProvince isEqualToString:@"<null>"] || self.shangbanzu.companyAddrProvince == nil) {
        self.JobProvince = @"";
    }else{
        self.JobProvince = self.shangbanzu.companyAddrProvince;
    }
    
    //---------------------公司市区-------------------
    if ([self.shangbanzu.companyAddrCounty isEqualToString:@"(null)"] || [self.shangbanzu.companyAddrCounty isEqualToString:@"<null>"] || self.shangbanzu.companyAddrCounty == nil) {
        self.JobCityArea = @"";
    }else{
        self.JobCityArea = self.shangbanzu.companyAddrCounty;
    }
    
    //-----------------拼接公司地址----------------------
//    if (self.JobCityArea.length != 0 && self.JobProvince.length != 0) {
//        _jobView.companyPlace.text = [NSString stringWithFormat:@"%@ %@",self.shangbanzu.companyAddrProvince,self.shangbanzu.companyAddrCounty];
//    }
    
    //-------------------公司详细地址---------------
    if ([self.shangbanzu.companyAddrTown isEqualToString:@"(null)"] || [self.shangbanzu.companyAddrTown isEqualToString:@"<null>"] || self.shangbanzu.companyAddrTown == nil) {
        self.shangbanzu.companyAddrTown = @"";
        
    }else{
//        [_jobView.companyDetailPlaceButton setTitle:@"" forState:UIControlStateNormal];
//        _jobView.companyDetailPlace.text = self.shangbanzu.companyAddrTown;
    }
    
    
    
     //------------公司电话呢-------------------
    
    if ([self.shangbanzu.companyTelNo isEqualToString:@"(null)"] || [self.shangbanzu.companyTelNo isEqualToString:@"<null>"] || self.shangbanzu.companyTelNo == nil) {
        self.shangbanzu.companyTelNo = @"";
        
    }else{
        //phoneArray = [self.shangbanzu.companyTelNo componentsSeparatedByString:@"-"];
        
        //    if (phoneArray.count == 2) {
        //        _jobView.companyPhone.text = [phoneArray lastObject];
        //        _jobView.companyQuHao.text = [phoneArray firstObject];
        //        
        //    }
    }
    
   
   
    
    
    if (self.shangbanzu.company.length > 0 && self.shangbanzu.work.length > 0 && self.shangbanzu.companyScale.length > 0 && self.shangbanzu.workYear.length > 0 && self.shangbanzu.fullWorkYear.length > 0 && self.shangbanzu.position.length > 0 && self.JobProvince.length > 0 && self.JobCityArea.length > 0 && self.shangbanzu.companyAddrTown.length > 0 && self.shangbanzu.companyTelNo.length > 0) {
        
        //公司名称
        _jobView.companyName.text = self.shangbanzu.company;
        
        
        //职业
        self.jobNum = self.shangbanzu.work;
        if ([self.shangbanzu.work isEqualToString:@"A"]) {
            _jobView.job.text = @"公务员、教师、医师、律师等专业人员";
        }
        else if ([self.shangbanzu.work isEqualToString:@"B"]){
            _jobView.job.text = @"金融、电力、能源等资源垄断行业";
        }
        else if ([self.shangbanzu.work isEqualToString:@"C"]){
            _jobView.job.text = @"国有大中型企业或业务合作单位";
        }
        else if ([self.shangbanzu.work isEqualToString:@"D"]){
            _jobView.job.text = @"中小型企业，有固定职业";
        }
        else if ([self.shangbanzu.work isEqualToString:@"E"]) {
            _jobView.job.text = @"个体工商户";
        }
        else if ([self.shangbanzu.work isEqualToString:@"F"]){
            _jobView.job.text = @"无固定职业";
        }
        else {
            _jobView.job.text = @"无";
        }
        
        
        //公司规模
        NSArray * array = @[@"20人以下",@"50人(含)以下",@"50-100人",@"100-500人",@"500人以上",@"无",@"501-1000",@"1001-5000人",@"5000以上"];
        _jobView.companySize.text = array[[self.shangbanzu.companyScale intValue]] ;
        self.companySizeNum = self.shangbanzu.companyScale;
        
        
        //工作年限
        NSArray * array2 = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
        _jobView.nowYear.text =array2[[self.shangbanzu.workYear intValue]] ;
        self.nowYearNum = self.shangbanzu.workYear;

        //总工作年限
        _jobView.sumYearNum.text =array2[[self.shangbanzu.fullWorkYear intValue]] ;
        self.sumYear = self.shangbanzu.fullWorkYear;

        
        //职位
        NSArray * array3 = @[@"高级管理人员",@"一般管理人员",@"一般正式员工",@"非正式员工",@"无",@"企业负责人",@"中层管理人员"];
        NSArray * array4 = @[@"厅局级以上",@"处级",@"科级",@"一般干部"];
        NSInteger postion = [self.shangbanzu.position intValue];
        if (postion > 0 && postion < 8) {
            _jobView.post.text = array3[postion - 1] ;
        }else if (postion == 9){
            _jobView.post.text = @"其他";
        }else{
            _jobView.post.text = array4[postion -11];
        }
        self.postNum = self.shangbanzu.position;

        
        //公司地址
        _jobView.companyPlace.text = [NSString stringWithFormat:@"%@ %@",self.shangbanzu.companyAddrProvince,self.shangbanzu.companyAddrCounty];
        
        //公司详细地址
        [_jobView.companyDetailPlaceButton setTitle:@"" forState:UIControlStateNormal];
        _jobView.companyDetailPlace.text = self.shangbanzu.companyAddrTown;

        //公司电话
        NSArray * phoneArray = [self.shangbanzu.companyTelNo componentsSeparatedByString:@"-"];
        
        if (phoneArray.count == 2) {
            _jobView.companyPhone.text = [phoneArray lastObject];
            _jobView.companyQuHao.text = [phoneArray firstObject];
        }
        
    }
    
   

    
    
}



@end
