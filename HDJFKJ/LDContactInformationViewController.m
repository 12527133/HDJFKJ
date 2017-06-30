

#import "LDContactInformationViewController.h"
#import "WHContactInfoView.h"
#import "LDTabBarController.h"
#import "WHTiJiaoControllrt.h"
#import "WHLianXiRenInfoModel.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"
#import "WHPersonProcessTopView.h"
#import "WHSendOtherMateriaController.h"
#import "LDNavgationVController.h"
#import "WHAddressBookModel.h"
#import "AddressBookTiShiView.h"

/** 是否需要授权运营商模型 */
#import "HDForceAuthFlag.h"
/** 通讯录类  */
#import "WHGetAddressBook.h"

#import "HDCustomRalationVC.h"

@interface LDContactInformationViewController ()<UIScrollViewDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) WHContactInfoView * contactInfoView;

//选择按钮的tag值
@property (nonatomic, assign) NSInteger buttonTag;
//打回修改。联系人模型
@property (nonatomic, strong) WHLianXiRenInfoModel * reliatonModel;

/**
 *  关系
 */
@property (nonatomic,strong) NSString * relationshipNum1;
@property (nonatomic,strong) NSString * relationshipNum2;
@property (nonatomic,strong) NSString * relationshipNum3;

@property (nonatomic, assign) BOOL  isEnding;

@property (nonatomic,assign) float addHeight;

@property (nonatomic, weak) NSTimer * timer;

/** 通讯录数据 */
@property (nonatomic, strong) NSMutableArray * addressBookArray;

@end

@implementation LDContactInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"联系人信息";
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    //1.创建ScrollView
    [self createScrollView];
    
    //2.创建联系人试图
    [self createContactInfoView];
    
    //3.获取联系人信息
    if (([self.fromeWhere isEqualToString:@"xinyongfen"] && [self.isFinsh isEqualToString:@"1"]) || [self.fromeWhere isEqualToString:@"xiugai"] || ([self.fromeWhere isEqualToString:@"shenhe"] && [self.isFinsh isEqualToString:@"1"])) {
        [self requestUserMessageRequest];
    }
    self.isEnding = YES;
    
    //消除第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tap];
}



- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
}


- (void)getAddressBookQuanXian:(UIButton *)button{
    
    if (button != nil) {
        [button.superview removeFromSuperview];
    }
    
    [self performSelector:@selector(getAddressBookInfo) withObject:nil afterDelay:0.1];
    
    
}
- (void)getAddressBookInfo{
    
    BOOL isAddressBook = [WHGetAddressBook getAddressBookMessage];
    
    if (isAddressBook) {
        /** 获取通讯录 */
        self.addressBookArray = [WHGetAddressBook returnAddressBookMessage];
        
        if (self.addressBookArray.count > 0) {

            
            if ([LDUserInformation sharedInstance].iosVerson != nil){
                /** 打开系统联系人界面 */
                [self openSystemRelation];
            }
            else{
            
                /** 打开自定义联系人 */
                [self openZidingyiRelation];
            }

        }else{
            
            [self showFailViewWithString:@"您的联系人暂无联系人"];
            
        }
    }
    
}

/** 打开自定义联系人界面 */
- (void)openZidingyiRelation{
    [self showWithImageWithString:@"正在加载"];
    
    HDCustomRalationVC * addBookVC = [[HDCustomRalationVC alloc]init];
    addBookVC.dataArray = [WHAddressBookModel mj_objectArrayWithKeyValuesArray:self.addressBookArray];
    
    LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:addBookVC];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    addBookVC.addressBook = ^(WHAddressBookModel * addressBook){
        
        addressBook.mobile= [addressBook.mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
        addressBook.mobile= [addressBook.mobile stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        addressBook.mobile= [addressBook.mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        
        if (self.buttonTag == 1) {
            
            if ([addressBook.mobile isTelephone:addressBook.mobile]) {
                _contactInfoView.contactName1.text = addressBook.name;
                
                _contactInfoView.phoneNumber1.text = [self formatPhoneNum:addressBook.mobile];
                
                self.contactInfoView.noRelationView1.hidden = YES;
            }
            else{
                [self showFailViewWithString:@"联系方式不是手机号"];
            }
            
        }else {
            
            if ([addressBook.mobile isTelephone:addressBook.mobile]) {
                _contactInfoView.contactName2.text = addressBook.name;
                _contactInfoView.phoneNumber2.text = [self formatPhoneNum:addressBook.mobile];
                
                
                self.contactInfoView.noRelationView2.hidden = YES;
                
            }
            else{
                [self showFailViewWithString:@"联系方式不是手机号"];
            }
            
            
        }
        
    };
}



- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tap{
    
    
    [self.view endEditing:YES];
}



//1.创建ScrollView
- (void)createScrollView{
    
    
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, LDScreenWidth, LDScreenHeight -64)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    
    self.scrollView.contentSize = CGSizeMake(LDScreenWidth, LDScreenHeight -64);
    self.scrollView.backgroundColor = LDBackroundColor;
}
//2.创建联系人试图
- (void)createContactInfoView{
    //初始化子视图
    self.contactInfoView = [[WHContactInfoView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 500*bili)];
    [self.contactInfoView createSubViews];
    
    [self.scrollView addSubview:_contactInfoView];
    
    //设置控件(联系人1)
    
    [self.contactInfoView.noRelationButton1 addTarget:self action:@selector(clickContactButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _contactInfoView.contactName1.keyboardType = UIKeyboardTypeDefault;
    _contactInfoView.contactName1.tag = 1;
    _contactInfoView.contactName1.delegate = self;
    [_contactInfoView.contactButton1 addTarget:self action:@selector(clickContactButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _contactInfoView.relationship1.tag = 2;
    _contactInfoView.relationship1.delegate = self;
    _contactInfoView.relationship1.keyboardType = UIKeyboardTypeDefault;
    [_contactInfoView.relationButton1 addTarget:self action:@selector(clickRelationButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _contactInfoView.phoneNumber1.keyboardType = UIKeyboardTypeNumberPad;
    _contactInfoView.phoneNumber1.tag = 3;
    _contactInfoView.phoneNumber1.delegate = self;
    
    //(联系人2)
    [self.contactInfoView.noRelationButton2 addTarget:self action:@selector(clickContactButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _contactInfoView.contactName2.keyboardType = UIKeyboardTypeDefault;
    _contactInfoView.contactName2.tag = 4;
    _contactInfoView.contactName2.delegate = self;
    [_contactInfoView.contactButton2 addTarget:self action:@selector(clickContactButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _contactInfoView.relationship2.tag = 5;
    _contactInfoView.relationship2.delegate = self;
    _contactInfoView.relationship2.keyboardType = UIKeyboardTypeDefault;
    [_contactInfoView.relationButton2 addTarget:self action:@selector(clickRelationButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _contactInfoView.phoneNumber2.keyboardType = UIKeyboardTypeNumberPad;
    _contactInfoView.phoneNumber2.tag = 6;
    _contactInfoView.phoneNumber2.delegate = self;
    
    
    /*************************************/
    _contactInfoView.contactButton1.tag = 1;
    _contactInfoView.contactButton2.tag = 2;
    self.contactInfoView.noRelationButton1.tag = 1;
    self.contactInfoView.noRelationButton2.tag = 2;
    
    _contactInfoView.relationButton1.tag = 1;
    _contactInfoView.relationButton2.tag = 2;
    
    [_contactInfoView.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.fromeWhere isEqualToString:@"xinyongfen"]){
        [_contactInfoView.nextButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    _contactInfoView.nextButton.layer.borderWidth = 0.0;
    _contactInfoView.nextButton.layer.cornerRadius = 5.0;
}

//点击联系人按钮
- (void)clickRelationButton:(UIButton *)sender{
    self.isEnding = NO;
    [self.view endEditing:YES];
    
    
    if (sender.tag == 1) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"关系选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"配偶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship1.text = @"配偶";
            self.relationshipNum1 = @"1";
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"父母" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship1.text = @"父母";
            self.relationshipNum1 = @"2";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"子女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship1.text = @"子女";
            self.relationshipNum1 = @"3";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"兄弟姐妹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship1.text = @"兄弟姐妹";
            self.relationshipNum1 = @"9";
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    if (sender.tag == 2) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"关系选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"配偶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"配偶";
            self.relationshipNum2 = @"1";
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"父母" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"父母";
            self.relationshipNum2 = @"2";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"子女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"子女";
            self.relationshipNum2 = @"3";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"兄弟姐妹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"兄弟姐妹";
            self.relationshipNum2 = @"9";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"朋友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"朋友";
            self.relationshipNum2 = @"11";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"同事" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"同事";
            self.relationshipNum2 = @"6";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"同学" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"同学";
            self.relationshipNum2 = @"10";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"合伙人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"合伙人";
            self.relationshipNum2 = @"7";
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"其他血亲" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"其他血亲";
            self.relationshipNum2 = @"4";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"其他姻亲" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"其他姻亲";
            self.relationshipNum2 = @"5";
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"其他关系" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _contactInfoView.relationship2.text = @"其他关系";
            self.relationshipNum2 = @"8";
        }]];
        
        
        
    }
}
#pragma mark -- textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ( textField.tag > 4 && LDScreenHeight < 667) {
        
        [UIView animateWithDuration:0.35f animations:^{
            
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
        
    }
    else{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

//点击下一步按钮,校验用户信息
- (void)clickNextButton:(UIButton *)sender{
    [self.view endEditing:YES];
    
    
    NSString * sValid2 = [self.contactInfoView.phoneNumber2.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * sValid1 = [self.contactInfoView.phoneNumber1.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if (_contactInfoView.contactName1.text.length == 0 || _contactInfoView.contactName1.text == nil || self.relationshipNum1.length == 0 || self.relationshipNum1 == nil || self.relationshipNum2.length == 0 || self.relationshipNum2 == nil || _contactInfoView.contactName2.text.length == 0 || _contactInfoView.contactName2.text == nil ) {
        [MBProgressHUD showError:@"请完善联系人信息"];
    }
    else if (![_contactInfoView.contactName1.text isChinese]) {
        [MBProgressHUD showError:@"联系人1的姓名不合法"];
    }
    else if (![_contactInfoView.contactName2.text isChinese]) {
        [MBProgressHUD showError:@"联系人2的姓名不合法"];
    }
    else if (![sValid1 isTelephone:sValid1]){
        [MBProgressHUD showError:@"联系人1的联系方式不合法"];
    }
    else if (![sValid2 isTelephone:sValid2]){
        [MBProgressHUD showError:@"联系人2的联系方式不合法"];
    }
    
    
    else if ( [_contactInfoView.contactName2.text isEqualToString:_contactInfoView.contactName1.text]){
        [MBProgressHUD showError:@"联系人姓名不能相同"];
    }
    else if ([_contactInfoView.phoneNumber2.text isEqualToString:_contactInfoView.phoneNumber1.text]){
        [MBProgressHUD showError:@"联系人的联系方式不能相同"];
    }
    
    else{
        [self sendRequest];
    }
    
}

#pragma mark -- 发送网络请求
/**
 * 发送联系人信息
 **/
- (void)sendRequest{
    
    [MBProgressHUD showMessage:@"正在提交"];
    
    NSString * url = [NSString stringWithFormat:@"%@register/contacterInfo",KBaseUrl];
    
    [[LDNetworkTools sharedTools] request:POST url:url params:[self getParameters] callback:^(id response, NSError *error) {
        if (error != nil) {
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            LDLog(@"%@",response);
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUD];
                
                if ([self.fromeWhere isEqualToString:@"xinyongfen"]) {
                    
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
                
                else{
                    LDTabBarController * tab = [[LDTabBarController alloc] init];
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                    
                }
                
            }else{
                [MBProgressHUD showError:backInfor.message];
                
            }
        }
    }];
}

- (NSMutableDictionary *)getParameters{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [parameters setObject:NILSTR(self.contactInfoView.contactName1.text) forKey:@"name1"];
    [parameters setObject:NILSTR(self.relationshipNum1) forKey:@"relation1"];
    
    NSString * sValid = [self.contactInfoView.phoneNumber1.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [parameters setValue:sValid forKey:@"phone1"];
    [parameters setObject:NILSTR(self.contactInfoView.contactName2.text) forKey:@"name2"];
    [parameters setObject:NILSTR(self.relationshipNum2) forKey:@"relation2"];
    
    NSString * sValid2 = [self.contactInfoView.phoneNumber2.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [parameters setValue:sValid2 forKey:@"phone2"];
    
    [parameters setObject:NILSTR(self.relationshipNum3) forKey:@"relation3"];
    
    return parameters;
    
}

#pragma mark -- 获取联系人信息
/**
 * 网络请求,获取联系人信息
 **/
- (void)requestUserMessageRequest{
    
    [MBProgressHUD showMessage:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/contacts",KBaseUrl];
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
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** 4.code == 0请求成功 */
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUD];
                
                /** 5.解析联系人信息 */
                if (backInfo.result != nil){
                    
                    self.reliatonModel = [WHLianXiRenInfoModel mj_objectWithKeyValues:backInfo.result];
                    
                    /** 6.给控件赋值*/
                    [self loadRelationData];
                    
                }
                
            }else{
                
                /** 7.请求异常提示 */
                [MBProgressHUD showError:backInfo.message];
            }
            
            LDLog(@"%@",response);
        }
    }];
}

- (void)loadRelationData{
    
    //联系人姓名赋值
    if (self.reliatonModel.name1 != nil) {
        _contactInfoView.contactName1.text = _reliatonModel.name1;
    }
    if (self.reliatonModel.name2 != nil) {
        _contactInfoView.contactName2.text = _reliatonModel.name2;
    }
    
    
    
    //联系人手机号
    if (self.reliatonModel.phone1 != nil) {
        _contactInfoView.phoneNumber1.text = [self formatPhoneNum:_reliatonModel.phone1];
    }
    if (self.reliatonModel.phone2 != nil) {
        _contactInfoView.phoneNumber2.text = [self formatPhoneNum:_reliatonModel.phone2];
    }
    
    
    //联系人关系
    NSArray * array = @[@"配偶",@"父母",@"子女",@"其他血亲",@"其他姻亲",@"同事",@"合伙人",@"其他关系",@"兄弟姐妹",@"同学",@"朋友"];
    int relation = [self.reliatonModel.relation1 intValue];
    if (relation > 0) {
        if (relation < 4) {
            _contactInfoView.relationship1.text = array[relation - 1];
            self.relationshipNum1 = self.reliatonModel.relation1;
        }
        else if (relation == 9) {
            _contactInfoView.relationship1.text = @"兄弟姐妹";
            self.relationshipNum1 = self.reliatonModel.relation1;
        }
        
    }
    
    relation = [self.reliatonModel.relation2 intValue];
    if (relation > 0) {
        _contactInfoView.relationship2.text = array[relation - 1];
        self.relationshipNum2 = self.reliatonModel.relation2;
    }
    
    
    
    /** 判断是否隐藏无联系人视图 */
    if (self.reliatonModel.name1 == nil || self.self.reliatonModel.phone1 == nil) {
        self.contactInfoView.noRelationView1.hidden = NO;
    }
    else{
        self.contactInfoView.noRelationView1.hidden = YES;
    }
    
    if (self.reliatonModel.name2 == nil || self.self.reliatonModel.phone2 == nil) {
        self.contactInfoView.noRelationView2.hidden = NO;
    }
    else{
        self.contactInfoView.noRelationView2.hidden = YES;
    }
    
}


#pragma mark -- 打开系统通讯录
-(void)clickContactButton:(UIButton *)button{
    [self.view endEditing:YES];
    self.buttonTag = button.tag;
    
    NSMutableArray * array = [WHGetAddressBook returnAddressBookArray];
    if (array.count > 0) {
        [NSKeyedArchiver archiveRootObject:@"是" toFile:AddressBook];
    }
    
    
    /** 是否弹第一个窗 */
    NSString * addressBook = [NSKeyedUnarchiver unarchiveObjectWithFile:AddressBook];
    
    if (addressBook == nil) {
        AddressBookTiShiView * tihiView = [[AddressBookTiShiView alloc]initWithFrame:CGRectMake(0, 0, 321*bili, 428*bili)];
        
        [tihiView createViewWithTitle:@"提示" content:@"为了保证联系人真实有效\n请您允许访问通讯录" buttonTitle:@"继续"];
        
        [tihiView.sureButton addTarget:self action:@selector(getAddressBookQuanXian:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        
        if (![addressBook isEqualToString:@"是"]) {
            
            AddressBookTiShiView * tihiView = [[AddressBookTiShiView alloc]initWithFrame:CGRectMake(0, 0, 321*bili, 428*bili)];
            
            [tihiView createViewWithTitle:@"提示" content:@"为了保证联系人真实有效\n请您允许访问通讯录" buttonTitle:@"去设置"];
            
            [tihiView.sureButton addTarget:self action:@selector(getAddressBookSheZhi) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            
            [self getAddressBookInfo];
            
        }
    }
    
}

- (NSMutableString *)formatPhoneNum:(NSString *)phoneNum{
    
    NSMutableString * string = [[NSMutableString alloc]initWithString:phoneNum];
    
    [string insertString:@" " atIndex:3];
    
    [string insertString:@" " atIndex:8];
    
    return string;
}

/** 跳转至设置界面 */
- (void)getAddressBookSheZhi{
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

/** 打开系统联系人界面 */
- (void)openSystemRelation{
    
    [self showWithImageWithString:@"正在加载"];
    
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:^{
        [self dismissHDLoading];
    }];
}


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *phone = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonPhoneProperty));
    
    NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex((__bridge ABMultiValueRef)(phone), index);
    
    phoneNumber= [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    phoneNumber= [phoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phoneNumber= [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if ([firstName isEqualToString:@"(null)"] || [firstName isEqualToString:@"<null>"] || firstName == nil) {
        firstName = @"";
    }
    if ([lastName isEqualToString:@"(null)"] || [lastName isEqualToString:@"<null>"] || lastName == nil) {
        lastName = @"";
    }
    
    LDLog(@"firstName:%@",firstName);
    LDLog(@"lastName:%@",lastName);
    LDLog(@"phone:%@",phoneNumber);
    
    
//    if (self.buttonTag == 1) {
//        _contactInfoView.contactName1.text = [NSString stringWithFormat:@"%@%@",lastName,firstName];
//        _contactInfoView.phoneNumber1.text = [self formatPhoneNum:phoneNumber];
//    }else {
//        _contactInfoView.contactName2.text = [NSString stringWithFormat:@"%@%@",lastName,firstName];
//        _contactInfoView.phoneNumber2.text = [self formatPhoneNum:phoneNumber];
//    }
    
    if (self.buttonTag == 1) {
        
        if ([phoneNumber isTelephone:phoneNumber]) {
            _contactInfoView.contactName1.text = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            
           _contactInfoView.phoneNumber1.text = [self formatPhoneNum:phoneNumber];
            
            self.contactInfoView.noRelationView1.hidden = YES;
        }
        else{
            [self showFailViewWithString:@"联系方式不是手机号"];
        }
        
    }else {
        
        if ([phoneNumber isTelephone:phoneNumber]) {
            _contactInfoView.contactName2.text = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            _contactInfoView.phoneNumber2.text = [self formatPhoneNum:phoneNumber];
            
            
            self.contactInfoView.noRelationView2.hidden = YES;
            
        }
        else{
            [self showFailViewWithString:@"联系方式不是手机号"];
        }
        
        
    }
    
}


@end
