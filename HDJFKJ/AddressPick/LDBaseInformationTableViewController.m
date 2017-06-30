

#import "LDBaseInformationTableViewController.h"
#import "PrefixHeader.pch"
#import "WHBaseInfoView.h"
#import "WHBaseInfoModel.h"
#import "WHWorkViewController.h"
#import "LDBasicModel.h"
#import "LDBasicGroupModel.h"
#import "UserInfo.h"
#import "LDTabBarController.h"
#import "AFNetworkTool.h"
#import "TZMD5.h"
#import "GTMBase64.h"
#import "WHSendImageRequest.h"
#import "LTPickerView.h"
#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"
#import "WHPersonProcessTopView.h"
#import "HDAccessToken.h"
#import "HDBaseInfoNextVC.h"


@interface LDBaseInformationTableViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) WHBaseInfoView * baseInfoView;

//当前点击的时间按钮
@property (nonatomic, strong) UIButton * commonButton;

//婚姻状况码值
@property (nonatomic, strong) NSString * marrageNumber;

//教育程度码值
@property (nonatomic, strong) NSString * eduNumber;

/**
 *  身份证下面的地址(居住地址),拆分(省)--(市,区)
 */
@property (nonatomic,strong) NSString * juzhuProvince;
@property (nonatomic,strong) NSString * juzhuCityArea;

/**
 *  户籍所在地址,拆分
 */
@property (nonatomic,strong) NSString * householdProvince;
@property (nonatomic,strong) NSString * householdCityArea;

/** 居住地址 */
@property (nonatomic, strong) NSString * homeProvince;
@property (nonatomic, strong) NSString * homeCity;
@property (nonatomic, strong) NSString * homeArea;
@property (nonatomic, strong) NSString * homeProvinceCode;
@property (nonatomic, strong) NSString * homeCityCode;
@property (nonatomic, strong) NSString * homeAreaCode;
@property (nonatomic, strong) NSString * homeAddress;

//当前的textField
@property (nonatomic, strong) UITextField * currentTextField;

@property (nonatomic, strong) WHBaseInfoModel * baseInfoModel;

@property (nonatomic, strong) NSString * faceVerified;
/** imageView  */
@property (nonatomic,strong) UIImageView * selfImageView;
/**
 *  人脸识别分数,一定大于40
 */
@property (nonatomic,copy) NSString * score;
/**
 *  是否上传过人脸识别后的图片,上传后才可下一步
 */
@property (nonatomic,assign) BOOL backImageBool;
//是不是同一个人
@property (nonatomic,copy) NSString * isSamePerson;

@property (nonatomic,assign) float addHeight;

@property (nonatomic, weak) NSTimer * timer;

@property (nonatomic, strong) NSArray * endTimeArr;

@end

@implementation LDBaseInformationTableViewController
- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UITextViewTextDidEndEditingNotification object:nil];
    [super viewWillAppear:animated];
}
//textView开始编辑
-(void)openKeyboard:(NSNotification *)notification{
    if ([_baseInfoView.hujiDetailTextView.text isEqualToString:@"省/市/区(县)/街道/楼/室"]) {
        _baseInfoView.hujiDetailTextView.text = @"";
        _baseInfoView.hujiDetailTextView.textColor = WHColorFromRGB(0x051b28);
    }
    
}

//textView结束编辑
- (void)closeKeyboard:(NSNotification *)notification{
    
    if (_baseInfoView.hujiDetailTextView.text.length == 0 ) {
        _baseInfoView.hujiDetailTextView.text = @"省/市/区(县)/街道/楼/室";
        _baseInfoView.hujiDetailTextView.textColor = WHColorFromRGB(0xc8c7cc);
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"基本信息";
    
    //1.创建scrollView;
    [self createScrollView];
    
    //2.创建内容视图
    [self createBaseInfoView];
    
    [self requestUserMessageRequest];
    
    //消除第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
    
    
    
    
    
}
- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tap{
    
    if (_baseInfoView.hujiDetailTextView.text.length == 0) {
        _baseInfoView.hujiDetailTextView.text = @"省/市/区(县)/街道/楼/室";
        _baseInfoView.hujiDetailTextView.textColor = WHColorFromRGB(0xc8c7cc);
    }
    [self.view endEditing:YES];
}

//加载OCR识别出的数据
- (void)loadOCRData{
    
    _baseInfoView.nameTextField.text = _baseModel.name;
    
    _baseInfoView.idCardTextField.text = _baseModel.IDCardNumber;
    
    
    
    if ([self timeToNSInteger:_baseModel.idTermBegin] > 0) {
        
        [_baseInfoView.startTimeButton setTitle:_baseModel.idTermBegin forState:UIControlStateNormal];
        
        _baseInfoView.startTimeButton.selected = YES;
    }
    
    if ([self timeToNSInteger:_baseModel.idTermEnd] > 0) {
        
        [_baseInfoView.endTimeButton setTitle:_baseModel.idTermEnd forState:UIControlStateNormal];
        
        _baseInfoView.endTimeButton.selected = YES;
    }
    _baseInfoView.hujiDetailTextView.textColor = WHColorFromRGB(0x051b28);
    _baseInfoView.hujiDetailTextView.text = _baseModel.address;
    
}

//自定义左侧Items
- (void)createGobackHomePageButton{
    
    
    UIButton * backHomePage = [[UIButton alloc]init];
    backHomePage.size = CGSizeMake(50, 30);
    
    [backHomePage setTitleColor:WHColorFromRGB(0x051b28) forState:UIControlStateNormal];
    [backHomePage setTitle:@"关闭" forState:UIControlStateNormal];
    
    [backHomePage addTarget:self action:@selector(clickbackHomePage:) forControlEvents:UIControlEventTouchUpInside];
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backHomePage];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:leftItem, nil];
    
}
- (void)clickbackHomePage:(UIButton *)sender{
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
    [self showSuccessViewWithString:@"即将跳转到首页"];
    
}
- (void)dismiss{
    [_timer invalidate];
    LDTabBarController * tabbar = [[LDTabBarController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
}
- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}



//1.创建ScrollView
- (void)createScrollView{
    //初始化scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 64)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    
    self.addHeight= 0.0;
    
    if (![self.fromeWhere isEqualToString:@"xinyongfen"] && ![self.fromeWhere isEqualToString:@"xiugai"] && ![self.fromeWhere isEqualToString:@"shenhe"]) {
        self.addHeight = 90 * LDScreenWidth/375;
        WHPersonProcessTopView * topView = [WHPersonProcessTopView view];
        topView.frame = CGRectMake(0, 0, LDScreenWidth, 90 * LDScreenWidth/375);
        NSArray * array1 = @[@"person_shenfenzheng_selected",@"person_jiben_selected",@"person_congye",@"person_lianxiren"];
        NSArray * array2 = @[@"person_arrow1",@"person_arrow2",@"person_arrow"];
        [topView initImageNameWithIconImageNameArr:array1 arrowImageNameArr:array2];
        [_scrollView addSubview:topView];
    }
    
    _scrollView.contentSize = CGSizeMake(LDScreenWidth, 696 + self.addHeight);
    _scrollView.backgroundColor = WHColorFromRGB(0xf0f0f0);
}
//2.创建内容试图
- (void)createBaseInfoView{
    
    
    
    
    //创建View
    _baseInfoView = [WHBaseInfoView view];
    _baseInfoView.frame = CGRectMake(0, self.addHeight, LDScreenWidth, 630);
    [_scrollView addSubview:_baseInfoView];
    
    //设置控件textFIeld的tag值和代理
    _baseInfoView.nameTextField.keyboardType = UIKeyboardTypeDefault;
    _baseInfoView.nameTextField.tag = 1;
    _baseInfoView.nameTextField.delegate = self;
    
    _baseInfoView.idCardTextField.keyboardType = UIKeyboardTypeDefault;
    _baseInfoView.idCardTextField.tag = 2;
    _baseInfoView.idCardTextField.delegate = self;
    
    if (!self.sendUserMessage) {
        
        _baseInfoView.nameTextField.textColor = WHColorFromRGB(0xc8c7cc);
        _baseInfoView.idCardTextField.textColor = WHColorFromRGB(0xc8c7cc);
        
        _baseInfoView.nameTextField.userInteractionEnabled = NO;
        _baseInfoView.idCardTextField.userInteractionEnabled = NO;
    }
    
    _baseInfoView.hujiDetailTextView.keyboardType = UIKeyboardTypeDefault;
    //_baseInfoView.hujiDetailTextField.tag = 3;
    _baseInfoView.hujiDetailTextView.delegate = self;
    
    _baseInfoView.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _baseInfoView.emailTextField.tag = 4;
    _baseInfoView.emailTextField.delegate = self;
    
    _baseInfoView.juzhuDetailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _baseInfoView.juzhuDetailTextField.tag = 5;
    _baseInfoView.juzhuDetailTextField.delegate = self;
    
    _baseInfoView.juzhuTextField.tag = 6;
    
    
    //添加按钮方法
    _baseInfoView.startTimeButton.tag = 1001;
    _baseInfoView.endTimeButton.tag = 1002;
    [_baseInfoView.startTimeButton addTarget:self action:@selector(buttonStartClick:) forControlEvents:UIControlEventTouchUpInside];
    [_baseInfoView.endTimeButton addTarget:self action:@selector(buttonEndClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_baseInfoView.juzhuButton addTarget:self action:@selector(clickJuzhuDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_baseInfoView.maritalButton addTarget:self action:@selector(clickMaritalButton:) forControlEvents:UIControlEventTouchUpInside];
    [_baseInfoView.educationButton addTarget:self action:@selector(clickEducationButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_baseInfoView.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.fromeWhere isEqualToString:@"xinyongfen"]){
        [_baseInfoView.nextButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    _baseInfoView.nextButton.layer.cornerRadius = 5.0;
    _baseInfoView.nextButton.layer.borderWidth = 0.0;
    
}

#pragma mark -- 居住地址按钮
- (void)clickJuzhuDetailButton:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    self.currentTextField = _baseInfoView.juzhuTextField;
    
    [[[STPickerArea alloc]initWithDelegate:self]show];
    
}
#pragma mark -- 户籍地址按钮
- (void)clickHujiDetailButton:(UIButton *)sender{
    [self.view endEditing:YES];
    //self.currentTextField = _baseInfoView.hujiTextField;
    [[[STPickerArea alloc]initWithDelegate:self]show];
    
}
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province provinceCode:(NSString *)provinceCode city:(NSString *)city cityCode:(NSString *)cityCode area:(NSString *)area areaCode:(NSString *)areaCode{
    
    
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    
    self.currentTextField.text = text;
    
    if (self.currentTextField.tag == 6) {//居住地址拆分
        
        self.homeProvince = province;
        self.homeProvinceCode = provinceCode;
        
        self.homeCity = city;
        self.homeCityCode = cityCode;
        
        self.homeArea = area;
        self.homeAreaCode = areaCode;
        
        self.juzhuProvince = province;
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
        self.juzhuCityArea = [NSString stringWithFormat:@"%@ %@",city,area];
        
    }
    if (self.currentTextField.tag == 7) {//户籍所在地址拆分
        self.householdProvince =province;
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
        self.householdCityArea = [NSString stringWithFormat:@"%@ %@",city,area];
    }
}


#pragma mark -- 身份证有效期选择按钮

- (void)buttonEndClick:(UIButton *)sender{
    if ([_baseInfoView.startTimeButton.titleLabel.text isEqualToString:@"开始日期"] || self.endTimeArr.count == 0) {
        [self showFailViewWithString:@"请先选择开始日期"];
    }
    else{
        LTPickerView* pickerView = nil;
        
        pickerView = [LTPickerView new];
        pickerView.dataSource = self.endTimeArr;//设置要显示的数据
        
        pickerView.defaultStr = @"1";//默认选择的数据
        [pickerView show];//显示
        //回调block
        pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
            //obj:LTPickerView对象
            //str:选中的字符串
            //num:选中了第几行
            [_baseInfoView.endTimeButton setTitle:str forState:UIControlStateNormal];
            _baseInfoView.endTimeButton.selected = YES;
        };
        
        pickerView.closeblock = ^{
            NSLog(@"结束编辑");
        };
        
    }
    
}


- (void)buttonStartClick:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    self.commonButton = button;
    LDLog(@"%ld",(long)button.tag);
    STPickerDate *datePicker = [[STPickerDate alloc]initWithDelegate:self];
    [datePicker show];
}
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    LDLog(@"%ld",(long)self.commonButton.tag);
    
    
    NSString *text = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)year, (long)month, (long)day];
    
    if (![_baseInfoView.startTimeButton.titleLabel.text isEqualToString:text]){
        
        [_baseInfoView.endTimeButton setTitle:@"结束日期" forState:UIControlStateNormal];
        [_baseInfoView.startTimeButton setTitle:text forState:UIControlStateNormal];
        
        _baseInfoView.startTimeButton.selected = YES;
        
        _baseInfoView.endTimeButton.selected = NO;
        
        self.endTimeArr = @[[NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)year + 5, (long)month, (long)day],[NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)year+10, (long)month, (long)day],[NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)year + 20, (long)month, (long)day],@"长期"];
        
    }
    
}

#pragma mark -- 婚姻选择按钮
- (void)clickMaritalButton:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"婚姻状况" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"已婚" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.maritalTextField.text = @"已婚";
        self.marrageNumber = @"1";
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"未婚" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.maritalTextField.text = @"未婚";
        self.marrageNumber = @"0";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.maritalTextField.text = @"其他";
        self.marrageNumber = @"-1";
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark -- 教育选择按钮
- (void)clickEducationButton:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"教育程度" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"专科" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.educationTextField.text = @"专科";
        self.eduNumber = @"20";
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"本科" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.educationTextField.text = @"本科";
        self.eduNumber = @"10";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"高中及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.educationTextField.text = @"高中及以下";
        self.eduNumber = @"30";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"初中及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.educationTextField.text = @"初中及以下";
        self.eduNumber = @"40";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"硕士及以上" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.educationTextField.text = @"硕士及以上";
        self.eduNumber = @"09";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"博士" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.educationTextField.text = @"博士";
        self.eduNumber = @"08";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"无" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _baseInfoView.educationTextField.text = @"无";
        self.eduNumber = @"50";
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
    
}


#pragma mark -- 下一步按钮,校验数据，发送请求
- (void)clickNextButton:(UIButton *)sender{
    
    [self selfViewEditing];

    
    if ([self baseInfoIsComplation]) {
        [self sendRequest];
    }
}




/** 判断各项信息是否填写完成 并且合法 */
- (BOOL)baseInfoIsComplation{
    
    if (_baseInfoView.nameTextField.text.length == 0 || _baseInfoView.idCardTextField.text.length == 0 || [_baseInfoView.startTimeButton.titleLabel.text isEqualToString:@"开始日期"] || [_baseInfoView.endTimeButton.titleLabel.text isEqualToString:@"结束日期"] || _baseInfoView.hujiDetailTextView.text.length == 0 || _baseInfoView.maritalTextField.text.length == 0 || _baseInfoView.educationTextField.text.length == 0 || _baseInfoView.juzhuTextField.text.length == 0 || _baseInfoView.juzhuDetailTextField.text.length == 0 ) {
        
        
        [self showFailViewWithString:@"请将信息补充完整"];
        
        return NO;
    }
    else{
        
        if (![_baseInfoView.nameTextField.text isChinese]) {
            
            [self showFailViewWithString:@"用户姓名不合法"];
            
            return NO;
            
        }else if (![_baseInfoView.idCardTextField.text isIDCard]){
            
            [self showFailViewWithString:@"用户身份证号不合法"];
            
            return NO;
            
        }else if (![_baseInfoView.emailTextField.text isEmail]){
            
            [self showFailViewWithString:@"用户邮箱不合法"];
            
            return NO;
            
        }else if ([self timeToNSInteger:_baseInfoView.startTimeButton.titleLabel.text] == 0){
            
            [self showFailViewWithString:@"身份证有效期不正确"];
            
            return NO;
        }
        else if (![_baseInfoView.endTimeButton.titleLabel.text isEqualToString:@"长期"] && [self timeToNSInteger:_baseInfoView.endTimeButton.titleLabel.text]== 0){
            
            [self showFailViewWithString:@"身份证有效期不正确"];
            
            return NO;
        }
        else{
            
            return YES;
            
        }
    }
    
    
    
}

/**
 *  下一步提交基本信息资料
 */
- (void)sendRequest{
    
    //[self showWithImageWithString:@"正在提交"];
    
    NSString * url = [NSString stringWithFormat:@"%@register/customInfo",KBaseUrl];
    
    [[LDNetworkTools sharedTools] request:POST url:url params:[self getParameters] callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印请求错误信息  */
            LDLog(@"error%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            LDLog(@"%@",response);
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                /** 4.把用户姓名赋值给单利 */
                [[LDUserInformation sharedInstance] setUserName:_baseInfoView.nameTextField.text];
                
                /** 5,信息分--身份证--基本信息-- 回到信用分,*/
                if ([self.fromeWhere isEqualToString:@"xinyongfen"])
                {
                    
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        
                        NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
                        
                        if ([vcClass isEqualToString:@"LDMySore"]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }
                    }
                    
                    /** 6.不是信用分,进行工作信息 */
                }
                else if([self.fromeWhere isEqualToString:@"shenhe"]){
                    
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        
                        NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
                        
                        if ([vcClass isEqualToString:@"LDReViewInformation"]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }
                    }
                }
                else if ([self.fromeWhere isEqualToString:@"addBankCard"]){
                    
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        
                        NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
                        
                        if ([vcClass isEqualToString:@"LDtest2222ViewController"]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }
                    }
                }
                
                else{
                    WHWorkViewController * workVC = [[WHWorkViewController alloc]init];
                    workVC.fromeWhere = self.fromeWhere;
                    
                    [self.navigationController pushViewController:workVC animated:YES];
                }
                
            }else
            {
                /** 7.请求异常提示  */
                [self showFailViewWithString:backInfor.message];
            }
        }
    }];
    
}

#pragma mark - 拼接参数
- (NSMutableDictionary *)getParameters{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    //真实姓名
    [parameters setObject:NILSTR(_baseInfoView.nameTextField.text) forKey:@"idName"];
    //身份
    [parameters setObject:NIL0STR(self.jobType) forKey:@"occupation"];
    //教育程度
    [parameters setObject:NILSTR(self.eduNumber) forKey:@"education"];
    //身份证
    [parameters setObject:NILSTR(_baseInfoView.idCardTextField.text) forKey:@"idNo"];
    //邮件
    [parameters setObject:NILSTR(_baseInfoView.emailTextField.text) forKey:@"email"];
    //婚姻
    [parameters setValue:NILSTR(self.marrageNumber) forKey:@"marital"];
    
    //居住地址,省市三级
    [parameters setObject:NILSTR(self.homeProvince) forKey:@"homeProvince"];
    [parameters setObject:NILSTR(self.homeCity) forKey:@"homeCity"];
    [parameters setObject:NILSTR(self.homeArea) forKey:@"homeArea"];
    [parameters setObject:NILSTR(self.homeProvinceCode) forKey:@"homeProvinceCode"];
    [parameters setObject:NILSTR(self.homeCityCode) forKey:@"homeCityCode"];
    [parameters setObject:NILSTR(self.homeAreaCode) forKey:@"homeAreaCode"];
    [parameters setObject:NILSTR(_baseInfoView.juzhuDetailTextField.text) forKey:@"homeAddress"];
    
    
    [parameters setObject:NILSTR(_baseInfoView.juzhuDetailTextField.text) forKey:@"addrTown"];
    //户籍地址
    [parameters setObject:NILSTR(_baseInfoView.hujiDetailTextView.text) forKey:@"regAddrTown"];
    //身份证有限期
    [parameters setObject:NILSTR(_baseInfoView.startTimeButton.titleLabel.text) forKey:@"idTermBegin"];
    [parameters setObject:NILSTR(_baseInfoView.endTimeButton.titleLabel.text) forKey:@"idTermEnd"];
    
    //是否进行过人脸识别,1进行过人脸识别
    [parameters setObject:NILSTR(@"1") forKey:@"faceVerified"];
    //人脸识别分数,
    [parameters setObject:NILSTR(@"80") forKey:@"faceSimilarity"];
    //人脸识别结果:是不是同一个人
    [parameters setObject:NILSTR(@"0") forKey:@"faceResult"];
    
    LDLog(@"%@-%@-%@-%@-%@-%@-%@-%@-%@-",_baseInfoView.nameTextField.text,_baseInfoView.maritalTextField.text,_baseInfoView.educationTextField.text,_baseInfoView.idCardTextField.text,_baseInfoView.hujiDetailTextView.text,_baseInfoView.juzhuTextField.text,_baseInfoView.juzhuDetailTextField.text,_baseInfoView.emailTextField.text,self.faceVerified);
    
    return parameters;
    
}

#pragma mark -- scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self selfViewEditing];
    
}
//结束界面结束编辑
- (void)selfViewEditing{
    
    [self.view endEditing:YES];
}

#pragma mark -- textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 3) {
        [UIView animateWithDuration:0.3f animations:^{
            _scrollView.contentOffset = CGPointMake( 0, _scrollView.contentSize.height - _scrollView.frame.size.height);
            
        }];
    }
    
    
    if (textField.tag > 3) {
        
        if (_scrollView.contentOffset.y == _scrollView.contentSize.height - _scrollView.frame.size.height) {
            [UIView animateWithDuration:0.3f animations:^{
                self.view.frame = CGRectMake(0, -150+64, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        else{
            
            [UIView animateWithDuration:0.3f animations:^{
                _scrollView.contentOffset = CGPointMake( 0, _scrollView.contentSize.height - _scrollView.frame.size.height);
                
                self.view.frame = CGRectMake(0, -150+64, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


/**
 * 网络请求,获取用户的基本信息
 **/
- (void)requestUserMessageRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
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
            
            LDLog(@"%@",response);
            
            /** 3.解析返回信息  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            //code == 0请求成功
            if ([backInfo.code isEqualToString:@"0"]) {
                [self dismissHDLoading];
                
                /** 4.解析基本信息 */
                if (backInfo.result != nil){
                    
                    self.baseInfoModel = [WHBaseInfoModel mj_objectWithKeyValues:backInfo.result];
                    
                    /** 5.给控件赋值 */
                    [self loadBaseInfon];
                }
                
            }
            else
            {
                /** 6.请求异常提示 */
                [self showFailViewWithString:backInfo.message];
            }
        }
    }];
}
/**
 * 基本信息赋值给视图控件
 **/
- (void)loadBaseInfon{
    
    //真实姓名
    
    if (self.baseInfoModel.idName != nil) {
        _baseInfoView.nameTextField.text = self.baseInfoModel.idName;
    }
    
    //身份证号
    if (self.baseInfoModel.idNo != nil) {
        _baseInfoView.idCardTextField.text = self.baseInfoModel.idNo;
    }
    //户籍所在地
    if (self.baseInfoModel.regAddrTown != nil) {
        
        _baseInfoView.hujiDetailTextView.textColor = WHColorFromRGB(0x323232);
        _baseInfoView.hujiDetailTextView.text = self.baseInfoModel.regAddrTown;
    }
    
    //婚姻状况
    if (self.baseInfoModel.marital != nil) {
        self.marrageNumber = self.baseInfoModel.marital;
        
        if ([self.baseInfoModel.marital isEqualToString:@"1"]) {
            _baseInfoView.maritalTextField.text = @"已婚";
        }
        if ([self.baseInfoModel.marital isEqualToString:@"0"]){
            _baseInfoView.maritalTextField.text = @"未婚";
        }
        if ([self.baseInfoModel.marital isEqualToString:@"-1"]){
            _baseInfoView.maritalTextField.text = @"其他";
        }
    }
    
    //教育程度
    if (self.baseInfoModel.education != nil) {
        self.eduNumber = self.baseInfoModel.education;
        if ([self.baseInfoModel.education isEqualToString:@"30"]) {
            
            _baseInfoView.educationTextField.text = @"高中及以下";
        }
        if ([self.baseInfoModel.education isEqualToString:@"10"]) {
            
            _baseInfoView.educationTextField.text = @"本科";
        }
        if ([self.baseInfoModel.education isEqualToString:@"09"]) {
            
            _baseInfoView.educationTextField.text = @"硕士及以上";
        }
        if ([self.baseInfoModel.education isEqualToString:@"08"]) {
            _baseInfoView.educationTextField.text = @"博士";
        }
        if ([self.baseInfoModel.education isEqualToString:@"20"]){
            _baseInfoView.educationTextField.text = @"专科";
        }
        if ([self.baseInfoModel.education isEqualToString:@"40"]){
            _baseInfoView.educationTextField.text = @"初中及以下";
        }
        if ([self.baseInfoModel.education isEqualToString:@"50"]){
            _baseInfoView.educationTextField.text = @"无";
        }
    }
    
    //邮箱
    if (self.baseInfoModel.email != nil) {
        _baseInfoView.emailTextField.text = self.baseInfoModel.email;
    }
    
    //居住地省份
    if (self.baseInfoModel.homeProvince != nil && self.baseInfoModel.homeProvinceCode != nil) {
        self.homeProvince = self.baseInfoModel.homeProvince;
        self.homeProvinceCode = self.baseInfoModel.homeProvinceCode;
    }
    //居住城市
    if (self.baseInfoModel.homeCity != nil && self.baseInfoModel.homeCityCode != nil) {
        self.homeCityCode = self.baseInfoModel.homeCityCode;
        self.homeCity = self.baseInfoModel.homeCity;
    }
    
    
    
    //居住地城市
    if (self.baseInfoModel.homeArea != nil && self.baseInfoModel.homeAreaCode != nil) {
        self.homeArea = self.baseInfoModel.homeArea;
        self.homeAreaCode = self.baseInfoModel.homeAreaCode;
    }
    
    //省，市，县拼接
    if (self.homeProvince.length != 0 && self.homeCity.length != 0 && self.homeArea.length != 0) {
        
        _baseInfoView.juzhuTextField.text = [NSString stringWithFormat:@"%@ %@ %@",self.homeProvince,self.homeCity,self.homeArea];
    }
    
    //现居住详细地址
    if (self.baseInfoModel.homeAddress != nil) {
        _baseInfoView.juzhuDetailTextField.text = self.baseInfoModel.homeAddress;
        self.homeAddress = self.baseInfoModel.homeAddress;
    }
    
    
    //身份证开始日期
    if ( self.baseInfoModel.idTermBegin != nil) {
        
        if ([self timeToNSInteger:self.baseInfoModel.idTermBegin] > 0){
            _baseInfoView.startTimeButton.selected = YES;
            [_baseInfoView.startTimeButton setTitle:self.baseInfoModel.idTermBegin forState:UIControlStateNormal];
        }
    }
    
    //身份证结束日期
    if (self.baseInfoModel.idTermEnd != nil) {
        if ([self.baseInfoModel.idTermEnd isEqualToString:@"长期"]) {
            [_baseInfoView.endTimeButton setTitle:self.baseInfoModel.idTermEnd forState:UIControlStateNormal];
            _baseInfoView.endTimeButton.selected = YES;
        }else{
            if ([self timeToNSInteger:self.baseInfoModel.idTermEnd] > 0) {
                _baseInfoView.endTimeButton.selected = YES;
                [_baseInfoView.endTimeButton setTitle:self.baseInfoModel.idTermEnd forState:UIControlStateNormal];
            }
            
        }
    }
    
    //人脸识别标示，1标示已识别，0未识别
    if (self.baseInfoModel.faceVerified != nil) {
        self.faceVerified = self.baseInfoModel.faceVerified;
        
    }
    
    
    //工作类型
    self.jobType = self.baseInfoModel.occupation;
    if (self.jobType == nil) {
        self.jobType = @"2";
    }
}


//经实践转换成int类型
- (NSInteger)timeToNSInteger:(NSString *)time{
    //1.设置时间格式
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd";
    //2.时间字符串转化成NSData
    NSDate *date = [fmt dateFromString:time];
    //计算距1970年的秒数
    NSTimeInterval secondDate = [date timeIntervalSince1970];
    return secondDate;
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

/**
 *  下一步提交基本信息资料
 */
- (void)sendRegisterGetNHAccessTokenRequest{
    
    
    NSString * url = [NSString stringWithFormat:@"%@register/getNHAccessToken",KBaseUrl];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [parameters setObject:[LDUserInformation sharedInstance].phoneNumber forKey:@"phone"];
    
    
    

    
    [[LDNetworkTools sharedTools] request:POST url:url params:parameters callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印请求错误信息  */
            LDLog(@"error%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            LDLog(@"%@",response);
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                [self dismissHDLoading];
                
                HDAccessToken * accessToken = [HDAccessToken mj_objectWithKeyValues:backInfor.result];
                
                HDBaseInfoNextVC * nextVC = [[HDBaseInfoNextVC alloc]init
                                             ];
                nextVC.accessToken = accessToken;
                nextVC.userName = self.baseInfoView.nameTextField.text;
                nextVC.userNo = self.baseInfoView.idCardTextField.text;
                [self.navigationController pushViewController:nextVC animated:YES];
                
                
            }else
            {
                /** 7.请求异常提示  */
                [self showFailViewWithString:backInfor.message];
            }
        }
    }];
    
}

@end
