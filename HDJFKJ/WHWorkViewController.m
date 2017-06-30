


#import "WHWorkViewController.h"
#import "WHPersonProcessTopView.h"
#import "WHJobView.h"
#import "WHStudentView.h"
#import "WHEntrepreneursView.h"
#import "WHChooseWorkView.h"
#import "LTPickerView.h"
#import "WHShangBanZuModel.h"
#import "STPickerArea.h"
#import "WHStudentInfoModel.h"
#import "WHChuangYeZheModel.h"
#import "WHBaseInfoModel.h"
#import "LDContactInformationViewController.h"
#import "LDTabBarController.h"
#import "WHCustomInfoInfoStepAll.h"
@interface WHWorkViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
//1.底层基本试图
@property (nonatomic, strong) UIScrollView * scrollView;
//2.工作视图
@property (nonatomic, strong) WHJobView * jobView;
//3.学生视图
@property (nonatomic, strong) WHStudentView * studentView;
//4.创业者视图
@property (nonatomic, strong) WHEntrepreneursView * entrepreneurView;
//5.选择身份弹窗
@property (nonatomic, strong) WHChooseWorkView * chooseWorkView;
//6.弹窗半透明阴影
@property (nonatomic, strong) UIView * chooseBGView;

//显示身份的Label
@property (nonatomic, strong) UILabel * shenfenLabel;
//指示完善程度试图的高度
@property (nonatomic, assign) float addHeight;

/**
 * 上班族有关的属性
 **/
//职业
@property (nonatomic, strong) NSString * jobNum;
//单位规模
@property (nonatomic, strong) NSString * companySizeNum;
//现单位工作年限
@property (nonatomic, strong) NSString * nowYearNum;
//总工作年限
@property (nonatomic, strong) NSString * sumYear;
//职务
@property (nonatomic, strong) NSString * postNum;
// "区号"和"电话" "-" 拼接后的字符串
@property (nonatomic,copy) NSString * pingJiePhoneNumber;
// 拆分省市
@property (nonatomic,strong) NSString * JobProvince;
@property (nonatomic,strong) NSString * JobCityArea;
//上班族模型
@property (nonatomic, strong) WHShangBanZuModel * shangbanzu;

/**
 * 学生党相关属性
 **/

//拆分学校地址--省市(参数)

@property (nonatomic,strong) NSString * schoolProvince;
@property (nonatomic,strong) NSString * schoolCityArea;
//学生模型
@property (nonatomic, strong) WHStudentInfoModel * studentInfoModel;

@property (nonatomic, assign) BOOL isEnding;

@property (nonatomic, strong) UITextView * currentTextView;

/**
 * 创业者相关属性
 **/
//企业规模,参数层
@property (nonatomic, strong) NSString * eCompanySizeNum;
//企业年限
@property (nonatomic, strong) NSString *eSumYearNum;

//企业地址
@property (nonatomic, strong) NSString *eCompanyProvince;
@property (nonatomic, strong) NSString *eCompanyCityArea;

@property (nonatomic, strong) WHChuangYeZheModel * chuangyezheModel;

//"区号"和"电话" "-" 拼接后的字符串
@property (nonatomic,copy) NSString * ePingJiePhoneNumber;

//判断联系人是否完善，0表示未完善，1表示已完善
@property (nonatomic, strong) NSString * contactInfo;

//个人信息完善程度视图
@property (nonatomic, strong) WHPersonProcessTopView * topView;

@property (nonatomic, assign) float moveHeight;
@property (nonatomic, strong) UITextField * currentTextField;

//点击关闭按钮，2秒返回首页
@property (nonatomic, weak) NSTimer * timer;

@property (nonatomic, assign) BOOL  isAnimation;

@end

@implementation WHWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    [self createScrollView];
    
    self.isAnimation = NO;
    
    //设置视图移动高度
    [self setMoveHeightValue];

    
}

- (void)setMoveHeightValue{
    self.moveHeight = 0;
    if (_studentView.frame.origin.x == 0) {
        if (LDScreenHeight > 667) {
            self.moveHeight = -100+64;
        }
        else if (LDScreenHeight == 667)
        {
            self.moveHeight = - 140+64;
        }
        else{
            self.moveHeight = -200+64;
        }
    }
    if (_jobView.frame.origin.x == 0) {
        
        self.moveHeight = -200+64;
    }
    if (_entrepreneurView.frame.origin.x == 0) {
        if (LDScreenHeight < 667) {
            self.moveHeight = -64;
        }else{
            //
        }
        
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //请求用户基本信息获取工作类型
    [self requestUserMessageRequest];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UITextViewTextDidEndEditingNotification object:nil];
    
    //消除第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
}

//键盘弹起时
-(void)openKeyboard:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.35f animations:^{
        if (_scrollView.contentSize.height > _scrollView.frame.size.height) {
            
            _scrollView.contentOffset = CGPointMake( 0, _scrollView.contentSize.height - _scrollView.frame.size.height);
        }
        if (_studentView.frame.origin.x == 0 && self.currentTextView.tag == 11) {
            self.view.frame = CGRectMake( 0, -100+64, self.view.frame.size.width, self.view.frame.size.height);
        }else{
            self.view.frame = CGRectMake( 0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
        }
    }];
    
}

//键盘收起时
- (void)closeKeyboard:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.26f animations:^{
        
        self.view.frame = CGRectMake( 0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)sender{
    [self selfViewEnding];
}
//1.创建ScrollView
- (void)createScrollView{
    //初始化scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight -64 )];
    
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    
    self.addHeight= 0.0;

    if (![self.fromeWhere isEqualToString:@"xinyongfen"] && ![self.fromeWhere isEqualToString:@"xiugai"] && ![self.fromeWhere isEqualToString:@"shenhe"]) {
        self.addHeight = 90 * LDScreenWidth/375;
        self.topView = [WHPersonProcessTopView view];
        self.topView.frame = CGRectMake(0, 0, LDScreenWidth, 90 * LDScreenWidth/375);
        NSArray * array1 = @[@"person_shenfenzheng_selected",@"person_jiben_selected",@"person_congye_selected",@"person_lianxiren"];
        NSArray * array2 = @[@"person_arrow1",@"person_arrow2",@"person_arrow3"];
        [self.topView initImageNameWithIconImageNameArr:array1 arrowImageNameArr:array2];
        [_scrollView addSubview:self.topView];
    }
    
    
    _scrollView.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    [self createSubViews];
    
    
}
/**
 * 1.创建选择身份试图
 *
 **/

- (void)createSubViews{
    /**
     *  1.创建选择身份按钮
     **/
    UIView * chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 + self.addHeight, LDScreenWidth, 45)];
    chooseView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:chooseView];
    self.addHeight += 45;
    
    //创建chooseView的子视图
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 32, 15)];
    leftLabel.text = @"身份";
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.textColor = WHColorFromRGB(0x2b2b2b);
    [chooseView addSubview:leftLabel];
    
    UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth -83, 15, 47, 15)];
    rightLabel.text = @"上班族";
    rightLabel.font = [UIFont systemFontOfSize:15];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = WHColorFromRGB(0x2b2b2b);
    [chooseView addSubview:rightLabel];
    self.shenfenLabel = rightLabel;
    
    UIImageView * arrowIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 25, 13, 10, 19)];
    arrowIamgeView.image = [UIImage imageNamed:@"shouyefanhui_2.0.4"];
    [chooseView addSubview:arrowIamgeView];
    
    UIButton * chooseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45)];
    [chooseView addSubview:chooseButton];
    [chooseButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollView.contentSize = CGSizeMake(LDScreenWidth, 595 + self.addHeight );
    
    [self createJobView];
    [self createStudentView];
    [self createEntrepreneurView];
    
}

//选择身份方法
- (void)chooseAction:(UIButton *)sender{
    [self selfViewEnding];
    
    [self createChooseWorkView];
}

/**
 * 2.创建上班族视图
 **/
- (void)createJobView{
    _jobView = [WHJobView view];
    _jobView.frame = CGRectMake(0, self.addHeight, LDScreenWidth, 595);
    [_scrollView addSubview:_jobView];
    
    
    _jobView.companyName.delegate = self;
    _jobView.companyName.tag = 21;
    _jobView.companyName.keyboardType = UIKeyboardTypeDefault;
    
    _jobView.companyQuHao.delegate = self;
    _jobView.companyQuHao.tag = 22;
    _jobView.companyQuHao.keyboardType = UIKeyboardTypeNumberPad;
    
    _jobView.companyPhone.delegate = self;
    _jobView.companyPhone.tag = 23;
    _jobView.companyPhone.keyboardType = UIKeyboardTypeNumberPad;
    
    _jobView.companyPlace.delegate = self;
    _jobView.companyPlace.tag = 24;
    
    [_jobView.companyQuHao addTarget:self action:@selector(companyQuHaoChange:) forControlEvents:UIControlEventEditingChanged];
    [_jobView.companyPhone addTarget:self action:@selector(companyPhoneChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [_jobView.jobButton addTarget:self action:@selector(clickJobButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.companySizeButton addTarget:self action:@selector(clickCompanySizeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.nowYearButton addTarget:self action:@selector(clickNowYearButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.sumYearNumButton addTarget:self action:@selector(clickSumYearNumButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.postButton addTarget:self action:@selector(clickPostButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.companyPlaceButton addTarget:self action:@selector(clickCompanyPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [_jobView.companyDetailPlaceButton addTarget:self action:@selector(clickCompanyDetailPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _jobView.nextButton.tag = 2;
    [_jobView.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.fromeWhere isEqualToString:@"xinyongfen"]) {
        [_jobView.nextButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    _jobView.nextButton.layer.cornerRadius = 5.0;
    _jobView.nextButton.layer.borderWidth = 0.0;
}
/**
 * 上班族视图中控件的响应方法
 **/

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
    
    self.currentTextField = _jobView.companyPlace;
    [[[STPickerArea alloc]initWithDelegate:self]show];
}
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province provinceCode:(NSString *)provinceCode city:(NSString *)city cityCode:(NSString *)cityCode area:(NSString *)area areaCode:(NSString *)areaCode{

    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    self.currentTextField.text = text;
    
    
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
    //给不同属性赋值
    if (self.currentTextField.tag == 24) {
        self.JobProvince = province;
        self.JobCityArea = [NSString stringWithFormat:@"%@ %@",city,area];
    }
    if (self.currentTextField.tag == 14){
        self.schoolProvince = province;
        self.schoolCityArea = [NSString stringWithFormat:@"%@ %@",city,area];
    }
    if (self.currentTextField.tag == 34) {
        self.eCompanyProvince = province;
        self.eCompanyCityArea = [NSString stringWithFormat:@"%@ %@",city,area];
    }
}


#pragma mark -- 单位详细地址按钮
- (void)clickCompanyDetailPlaceButton:(UIButton *)sender{
    [sender setTitle:@"" forState:UIControlStateNormal];
    [_jobView.companyDetailPlace becomeFirstResponder];
}



/**
 * 3.创建学生视图
 **/

- (void)createStudentView{
    
    _studentView = [WHStudentView view];
    _studentView.frame = CGRectMake(-LDScreenWidth, self.addHeight, LDScreenWidth, 500);
    [_scrollView addSubview:_studentView];
    
    
    [_studentView.schoolButton addTarget:self action:@selector(clickSchoolButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_studentView.schoolDetailButton addTarget:self action:@selector(clickSchoolDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_studentView.dormitoryButton addTarget:self action:@selector(clickDormitoryButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _studentView.nextbutton.tag = 1;
    [_studentView.nextbutton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _studentView.money.keyboardType = UIKeyboardTypeDecimalPad;
//    _studentView.money.delegate = self;
    
    _studentView.schoolName.delegate = self;
    _studentView.schoolName.tag = 11;
    
    _studentView.faculty.delegate = self;
    _studentView.faculty.tag = 12;
    
    _studentView.money.delegate = self;
    _studentView.money.tag = 13;
    
    _studentView.schoolSity.delegate = self;
    _studentView.schoolSity.tag = 14;
    
    _studentView.schoolDetailTextView.delegate = self;
    _studentView.schoolDetailTextView.tag = 11;
    _studentView.dormitoryTextView.delegate = self;
    _studentView.dormitoryTextView.tag = 12;
    
    if ([self.fromeWhere isEqualToString:@"xinyongfen"]) {
        [_studentView.nextbutton setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    _studentView.nextbutton.layer.cornerRadius = 5.0;
    _studentView.nextbutton.layer.borderWidth = 0.0;
}
/**
 * 学生视图相关响应方法
 **/
- (void)clickSchoolButton:(UIButton *)sender{
    
    
    [UIView animateWithDuration:0.26f animations:^{
        
        self.view.frame = CGRectMake( 0,64, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    [self selfViewEnding];
    self.currentTextField = _studentView.schoolSity;
    [[[STPickerArea alloc]initWithDelegate:self]show];
    
}

- (void)clickSchoolDetailButton:(UIButton *)sender{
    
    self.currentTextView = _studentView.schoolDetailTextView;
    
    [UIView animateWithDuration:0.26f animations:^{
        
        self.view.frame = CGRectMake( 0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
    [sender setTitle:@"" forState:UIControlStateNormal];
    [_studentView.schoolDetailTextView becomeFirstResponder];
    
    
    if (_studentView.dormitoryTextView.text.length == 0) {
        [_studentView.dormitoryButton setTitle:@"宿舍详细地址" forState:UIControlStateNormal];
    }
    
}
- (void)clickDormitoryButton:(UIButton *)sender{
    self.currentTextView = _studentView.dormitoryTextView;
    [sender setTitle:@"" forState:UIControlStateNormal];
    [_studentView.dormitoryTextView becomeFirstResponder];
    
    if (_studentView.schoolDetailTextView.text.length == 0) {
        [_studentView.schoolDetailButton setTitle:@"学校详细地址" forState:UIControlStateNormal];
    }
}


/**
 * 4.创建创业者视图
 **/

- (void)createEntrepreneurView{
    
    _entrepreneurView = [WHEntrepreneursView view];
    _entrepreneurView.frame = CGRectMake(LDScreenWidth, self.addHeight, LDScreenWidth, 450);
    [_scrollView addSubview:_entrepreneurView];
    
    _entrepreneurView.companyName.keyboardType = UIKeyboardTypeDefault;
    _entrepreneurView.companyQuHao.keyboardType = UIKeyboardTypeNumberPad;
    _entrepreneurView.companyPhone.keyboardType = UIKeyboardTypeNumberPad;
    _entrepreneurView.sumYear.keyboardType = UIKeyboardTypeDefault;
    
    _entrepreneurView.companyName.delegate = self;
    _entrepreneurView.companyName.tag = 31;
    
    _entrepreneurView.companyQuHao.delegate = self;
    _entrepreneurView.companyQuHao.tag = 32;
    
    _entrepreneurView.companyPhone.delegate = self;
    _entrepreneurView.companyPhone.tag = 33;
    
    _entrepreneurView.companyPlace.delegate = self;
    _entrepreneurView.companyPlace.tag = 34;
    
    _entrepreneurView.conmanyDetailPlace.delegate = self;
    _entrepreneurView.conmanyDetailPlace.tag = 31;
    
    [_entrepreneurView.companyQuHao addTarget:self action:@selector(companyQuHaoChange:) forControlEvents:UIControlEventEditingChanged];
    [_entrepreneurView.companyPhone addTarget:self action:@selector(companyPhoneChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    _entrepreneurView.nextButton.tag = 3;
    
    [_entrepreneurView.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_entrepreneurView.sumYearButton addTarget:self action:@selector(clickSumYearButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_entrepreneurView.comanySizeButton addTarget:self action:@selector(clickSizeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_entrepreneurView.companyDetailButton addTarget:self action:@selector(clickDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_entrepreneurView.companyPlaceButton addTarget:self action:@selector(clickPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.fromeWhere isEqualToString:@"xinyongfen"]) {
        [_entrepreneurView.nextButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    _entrepreneurView.nextButton.layer.cornerRadius = 5.0;
    _entrepreneurView.nextButton.layer.borderWidth = 0.0;
}
/**
 * 创业者视图响应方法
 **/
//选择企业
- (void)clickSumYearButton:(UIButton *)sender{
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
        _entrepreneurView.sumYear.text = str;
        self.eSumYearNum = [NSString stringWithFormat:@"%d",num];
        LDLog(@"%@",_entrepreneurView.sumYear.text);
        
    };
    pickerView.closeblock = ^{
    };
}
//选择企业规模
- (void)clickSizeButton:(UIButton *)sender{
    
    [self selfViewEnding];
    
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = @[@"20人以下",@"50人(含)以下",@"50-100人",@"100-500人",@"500人以上",@"无",@"501-1000",@"1001-5000",@"5000人以上"];//设置要显示的数据
    pickerView.defaultStr = @"1";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        
        _entrepreneurView.companySize.text = str;
        self.eCompanySizeNum = [NSString stringWithFormat:@"%d",num];
        LDLog(@"%@",_entrepreneurView.companySize.text);
        
    };
    pickerView.closeblock = ^{};
}
//填写详细地址
- (void)clickDetailButton:(UIButton *)sender{
    
    [sender setTitle:@"" forState:UIControlStateNormal];
    
    [_entrepreneurView.conmanyDetailPlace becomeFirstResponder];
}

//选择地区
- (void)clickPlaceButton:(UIButton *)sender{
    [self selfViewEnding];
    self.currentTextField = _entrepreneurView.companyPlace;
    
    [[[STPickerArea alloc]initWithDelegate:self]show];
    
}



//结束textFielf编辑
- (void)selfViewEnding{
    [self.view endEditing:YES];
    if (_jobView.companyDetailPlace.text.length == 0) {
        [_jobView.companyDetailPlaceButton setTitle:@"街道/楼/室" forState:UIControlStateNormal];
    }
    if (_studentView.schoolDetailTextView.text.length == 0) {
        [_studentView.schoolDetailButton setTitle:@"学校详细地址" forState:UIControlStateNormal];
    }
    if (_studentView.dormitoryTextView.text.length == 0) {
        [_studentView.dormitoryButton setTitle:@"宿舍详细地址" forState:UIControlStateNormal];
    }
    if (_entrepreneurView.conmanyDetailPlace.text.length == 0) {
        [_entrepreneurView.companyDetailButton setTitle:@"街道/楼/室" forState:UIControlStateNormal];
    }
}

//textfield的代理方法
#pragma mark -- textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (_jobView.frame.origin.x == 0) {
        if ( textField.tag > 21) {
            
            
            [UIView animateWithDuration:0.35f animations:^{
                
                if (LDScreenHeight < 667) {
                    [UIView animateWithDuration:0.3f animations:^{
                        _scrollView.contentOffset = CGPointMake( 0, _scrollView.contentSize.height - _scrollView.frame.size.height);
                        self.view.frame = CGRectMake(0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
                        
                    }];
                }
                
                else{
                    [UIView animateWithDuration:0.3f animations:^{
                        if (_scrollView.contentSize.height > _scrollView.frame.size.height) {
                            _scrollView.contentOffset = CGPointMake( 0, _scrollView.contentSize.height - _scrollView.frame.size.height);
                        }
                        self.view.frame = CGRectMake(0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
                        
                    }];
                }
                
            }];
            
        }
        
        
        if (_jobView.companyDetailPlace.text.length == 0) {
            [_jobView.companyDetailPlaceButton setTitle:@"街道/楼/室" forState:UIControlStateNormal];
        }
    }
    
    if (_studentView.frame.origin.x == 0) {
        if ( textField.tag == 13) {
            [UIView animateWithDuration:0.35f animations:^{
                
                self.view.frame = CGRectMake(0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
            }];
            
        }
        else{
            [UIView animateWithDuration:0.26f animations:^{
                
                self.view.frame = CGRectMake( 0, 64, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        
        if (_studentView.schoolDetailTextView.text.length == 0) {
            [_studentView.schoolDetailButton setTitle:@"学校详细地址" forState:UIControlStateNormal];
        }
        if (_studentView.dormitoryTextView.text.length == 0) {
            [_studentView.dormitoryButton setTitle:@"宿舍详细地址" forState:UIControlStateNormal];
        }
    }
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
}

/**
 * 5.创建选择身份弹窗
 **/
- (void)createChooseWorkView{
    
    self.chooseBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight)];
    self.chooseBGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.chooseBGView];
    
    self.chooseWorkView = [WHChooseWorkView view];
    self.chooseWorkView.frame = CGRectMake(0, 0, 260*LDScreenWidth/375, 300*LDScreenWidth/375);
    self.chooseWorkView.center = self.chooseBGView.center;
    self.chooseWorkView.layer.cornerRadius = 10.0f;
    self.chooseWorkView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.chooseWorkView.layer.borderWidth = 0;
    [self.chooseBGView addSubview:self.chooseWorkView];
    
    //动画弹出选择窗
    self.chooseWorkView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.2 animations:^{
        self.chooseWorkView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.chooseBGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } completion:nil];
    
    
    self.chooseWorkView.studentButton.tag = 1;
    self.chooseWorkView.jobButton.tag = 2;
    self.chooseWorkView.entrepreneurButton.tag = 3;
    
    [self.chooseWorkView.cancelButton addTarget:self action:@selector(removeChooseBGView) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseWorkView.studentButton addTarget:self action:@selector(changeOccupation:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseWorkView.jobButton addTarget:self action:@selector(changeOccupation:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseWorkView.entrepreneurButton addTarget:self action:@selector(changeOccupation:) forControlEvents:UIControlEventTouchUpInside];
    
}
//关闭选择身份窗口
- (void)removeChooseBGView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.chooseWorkView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.chooseBGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.0 animations:^{
            [self.chooseBGView removeFromSuperview];
        } completion:nil];
    }];
    
}
//选择身份为学生
- (void)chooseStudent{
    
    
    self.title = @"学校信息";
    
    self.shenfenLabel.text = @"学生党";
    
    _scrollView.contentSize = CGSizeMake(LDScreenWidth, 500 + self.addHeight);
    
    if (self.isAnimation) {
        if (self.studentView.frame.origin.x < 0) {
            
            self.studentView.frame= CGRectMake(0, self.studentView.frame.origin.y, self.studentView.frame.size.width, self.studentView.frame.size.height);
                
            self.jobView.frame = CGRectMake(LDScreenWidth, self.jobView.frame.origin.y, self.jobView.frame.size.width, self.jobView.frame.size.height);
                
            self.entrepreneurView.frame = CGRectMake(LDScreenWidth*2, self.entrepreneurView.frame.origin.y, self.entrepreneurView.frame.size.width, self.entrepreneurView.frame.size.height);
            
        }
    }
    else{
        if (self.studentView.frame.origin.x < 0) {
        
            self.studentView.frame= CGRectMake(0, self.studentView.frame.origin.y, self.studentView.frame.size.width, self.studentView.frame.size.height);
            
            self.jobView.frame = CGRectMake(LDScreenWidth, self.jobView.frame.origin.y, self.jobView.frame.size.width, self.jobView.frame.size.height);
            
            self.entrepreneurView.frame = CGRectMake(LDScreenWidth*2, self.entrepreneurView.frame.origin.y, self.entrepreneurView.frame.size.width, self.entrepreneurView.frame.size.height);
        
        }
    
    }
    
    
    
    [self setMoveHeightValue];
    
    [self requestStudentMessageRequest];
}
//选择身份为上班族
- (void)chooseJob{
   
    
    self.title = @"工作信息";
    
    self.shenfenLabel.text = @"上班族";
    
    _scrollView.contentSize = CGSizeMake(LDScreenWidth, 595 + self.addHeight);
    
    if (self.isAnimation) {
        if (self.jobView.frame.origin.x != 0) {
            
            self.studentView.frame= CGRectMake(-LDScreenWidth, self.studentView.frame.origin.y, self.studentView.frame.size.width, self.studentView.frame.size.height);
                
            self.jobView.frame= CGRectMake(0, self.jobView.frame.origin.y, self.jobView.frame.size.width, self.jobView.frame.size.height);
                
            self.entrepreneurView.frame = CGRectMake(LDScreenWidth, self.entrepreneurView.frame.origin.y, self.entrepreneurView.frame.size.width, self.entrepreneurView.frame.size.height);
            
        }
    }else{
    
        if (self.jobView.frame.origin.x != 0) {
        
            self.studentView.frame= CGRectMake(-LDScreenWidth, self.studentView.frame.origin.y, self.studentView.frame.size.width, self.studentView.frame.size.height);
            
            self.jobView.frame= CGRectMake(0, self.jobView.frame.origin.y, self.jobView.frame.size.width, self.jobView.frame.size.height);
            
            self.entrepreneurView.frame = CGRectMake(LDScreenWidth, self.entrepreneurView.frame.origin.y, self.entrepreneurView.frame.size.width, self.entrepreneurView.frame.size.height);
        
        }
    }
    
    
    
    [self setMoveHeightValue];
    
    [self requestShangBanZuMessageRequest];
}
//选择身份为创业者
- (void)chooseEntrepreneur{
    
    
    self.title = @"企业信息";
    
    self.shenfenLabel.text = @"创业者";
    
    _scrollView.contentSize = CGSizeMake(LDScreenWidth, 450 + self.addHeight);
    
    
    if (self.isAnimation) {
        if (self.entrepreneurView.frame.origin.x >0 ) {
            
            self.entrepreneurView.frame= CGRectMake(0, self.entrepreneurView.frame.origin.y, self.entrepreneurView.frame.size.width, self.entrepreneurView.frame.size.height);
            
            self.jobView.frame = CGRectMake(-LDScreenWidth, self.jobView.frame.origin.y, self.jobView.frame.size.width, self.jobView.frame.size.height);
                
            self.studentView.frame = CGRectMake(-LDScreenWidth*2, self.studentView.frame.origin.y, self.studentView.frame.size.width, self.studentView.frame.size.height);
            
        }
    }else{
        if (self.entrepreneurView.frame.origin.x >0 ) {
        
        
            self.entrepreneurView.frame= CGRectMake(0, self.entrepreneurView.frame.origin.y, self.entrepreneurView.frame.size.width, self.entrepreneurView.frame.size.height);
            
            self.jobView.frame = CGRectMake(-LDScreenWidth, self.jobView.frame.origin.y, self.jobView.frame.size.width, self.jobView.frame.size.height);
            
            self.studentView.frame = CGRectMake(-LDScreenWidth*2, self.studentView.frame.origin.y, self.studentView.frame.size.width, self.studentView.frame.size.height);
        
        
        }
    }
    
    
    
    
    [self setMoveHeightValue];
    
    [self requestChuangYeZheMessageRequest];
}

/**
 * 修改身份接口
 **/
- (void)changeOccupation:(UIButton *)sender{
    
    self.isAnimation = YES;
    
    [MBProgressHUD hideHUD];
    
    /** 5.关闭选择身份界面  */
    [self removeChooseBGView];
    
    /** 6.选择不同什么界面  */
    if (sender.tag == 1)
    {
        [self chooseStudent];
    }
    else if (sender.tag == 3)
    {
        [self chooseEntrepreneur];
    }
    else
    {
        [self chooseJob];
    }
}


#pragma mark -- 验证工作信息,发送数据
- (void)clickNextButton:(UIButton *)sender{
    
    [self selfViewEnding];
    
    switch (sender.tag) {
        case 2:
        {
            if (_jobView.companyName.text.length == 0 || _jobView.job.text.length == 0 || _jobView.companySize.text.length == 0 || _jobView.nowYear.text.length == 0 || _jobView.sumYearNum.text.length == 0 || _jobView.post.text.length == 0 || _jobView.companyPlace.text.length == 0 || _jobView.companyDetailPlace.text.length == 0 || _jobView.companyPhone.text.length == 0 || _jobView.companyQuHao.text.length == 0) {
                [MBProgressHUD showError:@"请将信息补充完善"];
            }
            else if (![self checkJobCompanyPhone]){
                [MBProgressHUD showError:@"请输入正确的固定电话"];
            }
            else if ([self.nowYearNum integerValue] > [self.sumYear integerValue]){
                [self showFailViewWithString:@"现单位工作年限不能大于总工作年限"];
            }
            else{
                
                [self changeOccupationString:sender];
            }
        }
            break;
            
            
        case 1:
        {
            if (_studentView.schoolName.text.length == 0 || _studentView.faculty.text.length == 0 || _studentView.schoolSity.text.length == 0 || _studentView.schoolDetailTextView.text.length == 0 || _studentView.dormitoryTextView.text.length == 0 || _studentView.money.text.length == 0) {
                [MBProgressHUD showError:@"请将信息填写完整"];
            }
            else {
               // [self sendRequest:sender];
                 [self changeOccupationString:sender];
                
            }
        }
            break;
            
            
        case 3:
        {
            //电话
            self.ePingJiePhoneNumber = [NSString stringWithFormat:@"%@-%@",_entrepreneurView.companyQuHao.text,_entrepreneurView.companyPhone.text];
            if (_entrepreneurView.companyName.text.length == 0 || _entrepreneurView.companyQuHao.text.length == 0 || _entrepreneurView.companyPhone.text.length == 0 || _entrepreneurView.companyPlace.text.length == 0 || _entrepreneurView.conmanyDetailPlace.text.length == 0 || _entrepreneurView.companySize.text.length == 0 ) {
                [MBProgressHUD showError:@"请将信息补充完整"];
            }
            else if (![self checkEntrepreneurCompanyPhone]){
                [MBProgressHUD showError:@"请输入正确的固定电话"];
            }else {
                //[self sendRequest:sender];
                 [self changeOccupationString:sender];
                
            }
        }
            break;
    }
}
//校验公司电话
- (BOOL)checkEntrepreneurCompanyPhone{
    if ((_entrepreneurView.companyQuHao.text.length == 3 || _entrepreneurView.companyQuHao.text.length == 4) && (_entrepreneurView.companyPhone.text.length > 6)) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}
- (BOOL)checkJobCompanyPhone{
    
    self.pingJiePhoneNumber = [NSString stringWithFormat:@"%@-%@",_jobView.companyQuHao.text,_jobView.companyPhone.text];
    
    if ((_jobView.companyQuHao.text.length == 3 || _jobView.companyQuHao.text.length == 4) && (_jobView.companyPhone.text.length > 6)) {
        
        return YES;
        
    }else{
        return NO;
    }
    
    
}
#pragma mark - 拼接参数
- (NSMutableDictionary *)getJobParameters{
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
    
    return parameters;
    
}
/**
 * 发送数据,工作信息
 **/
//- (void)sendRequest:(UIButton *)sender{
- (void)sendRequest:(UIButton *)sender{

    NSString * url = [NSString stringWithFormat:@"%@register/workInfo",KBaseUrl];
    
    NSDictionary * params = nil;
    switch (sender.tag) {
        case 1:
            params = [self getStudentParameters];
            break;
        case 2:
            params = [self getJobParameters];
            break;
        case 3:
            params = [self getEntrepreneurParameters];
            break;
        default:
            break;
    }
    
    [[LDNetworkTools sharedTools] request:POST url:url params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            /** 1.打印请求错误信息 */
            LDLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }
        else
        {
            LDLog(@"%@",response);
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** 4.code = 0 请求正常  */
            if ([backInfor.code isEqualToString:@"0"]) {
                
                
                [MBProgressHUD hideHUD];
                
                /** 5，信用分 -- 工作信息 -- 返回信信用分  */
                if ([self.fromeWhere isEqualToString:@"xinyongfen"])
                {
                    
                    
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        
                        NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
                        
                        if ([vcClass isEqualToString:@"LDMySore"]) {
                            
                            //如果是确认订单控制器,就pop到该控制器
                            [self.navigationController popToViewController:vc animated:NO];
                            
                        }
                    }
                    
                }
                else if([self.fromeWhere isEqualToString:@"shenhe"]){
                    
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        
                        NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
                        
                        if ([vcClass isEqualToString:@"LDReViewInformation"]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }
                    }
                }
                
                else
                {
                    
                    LDTabBarController * tab = [[LDTabBarController alloc] init];
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
 
                }

            }
            else{
                
                [MBProgressHUD showError:backInfor.message];
            }
            
        }
    }];
    
    
}


#pragma mark - 拼接参数
- (NSMutableDictionary *)getStudentParameters{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    //学校名称
    [parameters setObject:NILSTR(_studentView.schoolName.text) forKey:@"school"];
    //学院名称
    [parameters setObject:NILSTR(_studentView.faculty.text) forKey:@"academy"];
    //学校省
    [parameters setObject:NILSTR(self.schoolProvince) forKey:@"schoolAddressProvince"];
    //市区
    [parameters setObject:NILSTR(self.schoolCityArea) forKey:@"schoolAddressCounty"];
    
    //详细地址
    [parameters setObject:NILSTR(_studentView.schoolDetailTextView.text) forKey:@"schoolAddressDetail"];
    //宿舍地址
    [parameters setObject:NILSTR(_studentView.dormitoryTextView.text) forKey:@"domitory"];
    //还款金额
    [parameters setObject:NILSTR(_studentView.money.text) forKey:@"periodUndertake"];
    
    return parameters;
}
- (NSMutableDictionary *)getEntrepreneurParameters{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    //    ID ,Token
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    //名称
    [parameters setObject:NILSTR(_entrepreneurView.companyName.text) forKey:@"corporation"];
    
    //企业电话
    [parameters setObject:NILSTR(self.ePingJiePhoneNumber) forKey:@"corporationTelNo"];
    
    //省
    [parameters setObject:NILSTR(self.eCompanyProvince) forKey:@"corporationAddrProvince"];
    //市区
    [parameters setObject:NILSTR(self.eCompanyCityArea) forKey:@"corporationAddrCounty"];
    //详细地址
    [parameters setValue:NILSTR(_entrepreneurView.conmanyDetailPlace.text)forKey:@"corporationAddr"];
    //规模
    [parameters setValue:NILSTR(self.eCompanySizeNum) forKey:@"corporationScale"];
    
    //年限
    [parameters setValue:NILSTR(self.eSumYearNum) forKey:@"corporationYear"];
    
    
    return parameters;
    
}


/**
 * 验证联系人信息是否完善
 **/
- (void)verifyContactInfo{
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/infoStepAll",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印请求错误信息 */
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }
        else
        {
            LDLog(@"%@",response);
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
        
            /** 4,code == 0请求成功*/
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUD];
                
                
                /** 4.解析信息完善信息 */
                if (backInfo.result != nil){
                
                    WHCustomInfoInfoStepAll * stepAll = [WHCustomInfoInfoStepAll mj_objectWithKeyValues:backInfo.result];
                    
                    self.contactInfo = stepAll.contactInfo;
                }else{
                    self.contactInfo = @"0";
                }
                
                
                /** 5.重新设置信息完善程度视图的图片 */
                if ([self.contactInfo isEqualToString:@"1"]){
                    NSArray * array1 = @[@"person_shenfenzheng_selected",@"person_jiben_selected",@"person_congye_selected",@"person_lianxiren_selected"];
                    NSArray * array2 = @[@"person_arrow1",@"person_arrow2",@"person_arrow3"];
                    [self.topView initImageNameWithIconImageNameArr:array1 arrowImageNameArr:array2];
                }
       
            }
            
            
        }
    }];
}

/**
 * 网络请求,获取用户的基本信息,从中获取工作信息
 **/
- (void)requestUserMessageRequest{
    
    [MBProgressHUD showMessage:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
             LDLog(@"%@",response);
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** 4.code == 0请求成功 */
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 5.解析返回数据*/
                if (backInfo.result != nil) {
                    
                    WHBaseInfoModel * baseInfoModel = [WHBaseInfoModel mj_objectWithKeyValues:backInfo.result];
                    if ([baseInfoModel.occupation isEqualToString:@"0"]) {
                        baseInfoModel.occupation = @"2";
                    }
                    
                    //请求学生信息
                    if ([baseInfoModel.occupation isEqualToString:@"1"]) {
                        [self requestStudentMessageRequest];
                        [self chooseStudent];
                    }
                    //请求创业者信息
                    else if([baseInfoModel.occupation isEqualToString:@"3"]){
                        [self requestChuangYeZheMessageRequest];
                        [self chooseEntrepreneur];
                    }
                    //请求上班族信息
                    else{
                        [self requestShangBanZuMessageRequest];
                        [self chooseJob];
                    }
                }
            
                //判断联系人完善程度
                [self verifyContactInfo];
                
            }else{
                [MBProgressHUD showError:backInfo.message];
            }
            
           
        }
    }];
}

//**************请求上班族数据*****************
- (void)requestShangBanZuMessageRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/work",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
           
        }else{
            LDLog(@"%@",response);
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** 4.code == 0请求成功 */
            if ([backInfo.code isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                
                /** 5.解析上班族数据 */
                if (backInfo.result != nil) {

                    self.shangbanzu = [WHShangBanZuModel mj_objectWithKeyValues:backInfo.result];
                    
                    /** 6.加载上班族数据 */
                    [self loadJobInfo];
                }
            }else{
                /** 7.请求异常提示*/
                [MBProgressHUD showError:backInfo.message];
            }
            
            
        }
    }];
}

//加载工作信息
- (void)loadJobInfo{
    
    //公司规模
    NSArray * array = @[@"20人以下",@"50人(含)以下",@"50-100人",@"100-500人",@"500人以上",@"无",@"501-1000",@"1001-5000人",@"5000以上"];
    //工作年限
    NSArray * array2 = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
    
    //职位
    NSArray * array3 = @[@"高级管理人员",@"一般管理人员",@"一般正式员工",@"非正式员工",@"无",@"企业负责人",@"中层管理人员"];
    NSArray * array4 = @[@"厅局级以上",@"处级",@"科级",@"一般干部"];
    
    
    //-------------公司名称-------------
    if (self.shangbanzu.company != nil) {
        
        //公司名称
        _jobView.companyName.text = self.shangbanzu.company;
    }
    
    //-------------职业------------------
    if (self.shangbanzu.work != nil) {
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
    }
    
    
    
    //--------------------公司规模---------------------
    if (self.shangbanzu.companyScale != nil) {
        
       
        _jobView.companySize.text = array[[self.shangbanzu.companyScale intValue]] ;
        self.companySizeNum = self.shangbanzu.companyScale;
    }
    
    //----------------当前工作年限--------------------
    if (self.shangbanzu.workYear != nil) {
        
        
        _jobView.nowYear.text =array2[[self.shangbanzu.workYear intValue]] ;
        self.nowYearNum = self.shangbanzu.workYear;
        
        
    }
    //---------------总工作年限-------------------
    if (self.shangbanzu.fullWorkYear != nil) {
        //总工作年限
        _jobView.sumYearNum.text =array2[[self.shangbanzu.fullWorkYear intValue]] ;
        self.sumYear = self.shangbanzu.fullWorkYear;
    }
    //-----------------职位-------------------
    if (self.shangbanzu.position != nil) {
        
        NSInteger postion = [self.shangbanzu.position intValue];
        if (postion > 0 && postion < 8) {
            _jobView.post.text = array3[postion - 1] ;
        }else if (postion == 9){
            _jobView.post.text = @"其他";
        }else{
            _jobView.post.text = array4[postion -11];
        }
        self.postNum = self.shangbanzu.position;
    }
    //--------------------公司省份、市区--------------------
    if (self.shangbanzu.companyAddrProvince != nil && self.shangbanzu.companyAddrCounty != nil) {
        
        self.JobProvince = self.shangbanzu.companyAddrProvince;
        self.JobCityArea = self.shangbanzu.companyAddrCounty;
        //公司地址
        _jobView.companyPlace.text = [NSString stringWithFormat:@"%@ %@",self.shangbanzu.companyAddrProvince,self.shangbanzu.companyAddrCounty];
    }
        
    //-------------------公司详细地址---------------
    if ( self.shangbanzu.companyAddrTown != nil) {
        //公司详细地址
        [_jobView.companyDetailPlaceButton setTitle:@"" forState:UIControlStateNormal];
        _jobView.companyDetailPlace.text = self.shangbanzu.companyAddrTown;
    }
    
    //------------公司电话呢-------------------
    if (self.shangbanzu.companyTelNo != nil) {
        //公司电话
        NSArray * phoneArray = [self.shangbanzu.companyTelNo componentsSeparatedByString:@"-"];
        
        if (phoneArray.count == 2) {
            _jobView.companyPhone.text = [phoneArray lastObject];
            _jobView.companyQuHao.text = [phoneArray firstObject];
        }
        
    }
    
}


//**************请求学生数据*****************
- (void)requestStudentMessageRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/work",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];

        }else{
            LDLog(@"%@",response);
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];

            /** 4.code == 0请求成功 */
            if ([backInfo.code isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                
                /** 5.解析学校信息 */
                if (backInfo.result != nil) {
                    self.studentInfoModel = [WHStudentInfoModel mj_objectWithKeyValues:backInfo.result];
                    /** 6.给控件赋值 */
                    [self loadStudentData];
                }
                
                
            }else{
                /** 7.请求异常提示  */
                [MBProgressHUD showError:backInfo.message];
            }
        }
    }];
}
//加载学生信息
- (void)loadStudentData{
    //-----------------------学校名称----------------------
    if (self.studentInfoModel.school != nil) {
        //学校名称
        _studentView.schoolName.text = self.studentInfoModel.school;
    }
    //----------------------学院名称--------------------
    if (self.studentInfoModel.academy != nil) {
        //学院名称
        _studentView.faculty.text = self.studentInfoModel.academy;
    }
    //------------------学校地址省份、市区--------------------
    if (self.studentInfoModel.schoolAddressProvince != nil && self.studentInfoModel.schoolAddressCounty != nil) {
        self.schoolProvince = self.studentInfoModel.schoolAddressProvince;
        self.schoolCityArea = self.studentInfoModel.schoolAddressCounty;
        //学校地址
        _studentView.schoolSity.text = [NSString stringWithFormat:@"%@ %@",self.studentInfoModel.schoolAddressProvince,self.studentInfoModel.schoolAddressCounty];
    }
    

    //-------------------学校详细地址-----------------
    if (self.studentInfoModel.schoolAddressDetail != nil) {
        
        //学校详细地址
        [_studentView.schoolDetailButton setTitle:@"" forState:UIControlStateNormal];
        _studentView.schoolDetailTextView.text = self.studentInfoModel.schoolAddressDetail;
        
    }
    
    //----------------宿舍地址-------------------
    if (self.studentInfoModel.domitory != nil) {
        //宿舍地址
        [_studentView.dormitoryButton setTitle:@"" forState:UIControlStateNormal];
        _studentView.dormitoryTextView.text = self.studentInfoModel.domitory;
    }
    //------------------偿还能力-----------
    if (self.studentInfoModel.periodUndertake != nil) {
        
        //偿还能力
        _studentView.money.text = self.studentInfoModel.periodUndertake;
        
    }
    

    
}


//获取创业者信息
- (void)requestChuangYeZheMessageRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/work",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
    
        }else{
            
            LDLog(@"%@",response);
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];

            /** 4.code == 0请求成功*/
            if ([backInfo.code isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                
                /** 5.解析创业者信息  */
                if (backInfo.result != nil) {
                    self.chuangyezheModel = [WHChuangYeZheModel mj_objectWithKeyValues:backInfo.result];
                    
                    /** 6.给控件赋值*/
                    [self loadEntrepreneursData];
                }
   
            }else{
                /** 7.请求异常提示 */
                [MBProgressHUD showError:backInfo.message];
            }
            
            
        }
    }];
}

- (void)loadEntrepreneursData{
    
    //---------------------企业名称-------------------
    if (self.chuangyezheModel.corporation != nil) {
        
        //企业名称
        _entrepreneurView.companyName.text = self.chuangyezheModel.corporation;
        
    }
    
    //--------------------企业电话-------------------
    if (self.chuangyezheModel.corporationTelNo != nil) {
        
        //企业电话呢
        NSArray * phoneArray = [self.chuangyezheModel.corporationTelNo componentsSeparatedByString:@"-"];
        if (phoneArray.count == 2) {
            
            NSArray * phoneArray = [self.chuangyezheModel.corporationTelNo componentsSeparatedByString:@"-"];
            _entrepreneurView.companyPhone.text = [phoneArray lastObject];
            _entrepreneurView.companyQuHao.text = [phoneArray firstObject];
            
        }
    }
    
    //--------------------企业---省份、市区------------
    if (self.chuangyezheModel.corporationAddrProvince != nil && self.chuangyezheModel.corporationAddrCounty != nil) {
       
        //企业地址
        _entrepreneurView.companyPlace.text = [NSString stringWithFormat:@"%@ %@",self.chuangyezheModel.corporationAddrProvince,self.chuangyezheModel.corporationAddrCounty];
        self.eCompanyProvince = self.chuangyezheModel.corporationAddrProvince;
        self.eCompanyCityArea = self.chuangyezheModel.corporationAddrCounty;
    }
    
    
    
    //------------------企业规模---------------
    if (self.chuangyezheModel.corporationScale != nil) {
        //企业规模
        self.eCompanySizeNum = self.chuangyezheModel.corporationScale;
        NSArray * array = @[@"20人以下",@"50人(含)以下",@"50-100人",@"100-500人",@"500人以上",@"无",@"501-1000",@"1001-5000",@"5000人以上"];
        _entrepreneurView.companySize.text = array[[self.chuangyezheModel.corporationScale intValue]] ;
    }
    
    //---------------------企业年限--------------------
    if ( self.chuangyezheModel.corporationYear != nil) {
        //企业年限
        self.eSumYearNum = self.chuangyezheModel.corporationYear;
        NSArray * array2 = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
        _entrepreneurView.sumYear.text = array2[[self.chuangyezheModel.corporationYear intValue]] ;
    }
    
    //-------------------企业详细地址-------------------
    if (self.chuangyezheModel.corporationAddr != nil) {
        //企业详细地址
        [_entrepreneurView.companyDetailButton setTitle:@"" forState:UIControlStateNormal];
        _entrepreneurView.conmanyDetailPlace.text = self.chuangyezheModel.corporationAddr;
    }

}
/**
 * 修改身份接口
 **/
- (void)changeOccupationString:(UIButton *)sender{
    
    self.isAnimation = YES;
    
    [MBProgressHUD showMessage:@"正在提交"];
    
    NSString * str = [NSString stringWithFormat:@"%@register/changeOccupation",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)sender.tag] forKey:@"occupation"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            /** 1.打印错误信息*/
            NSLog(@"%@", error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
        }else{
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            
            /** 4.code == 0请求成功 */
            if ([backInfo.code isEqualToString:@"0"])
            {
                
                
                [self sendRequest:sender];

                
            }else
            {
                
                /** 7.请求异常提示  */
                [MBProgressHUD showError:backInfo.message];
            }
            
            LDLog(@"%@",response);
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
