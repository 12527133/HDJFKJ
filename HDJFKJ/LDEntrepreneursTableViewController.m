//
//  LDEntrepreneursTableViewController.m
//  ceshi
//
//  Created by 石伟浩 on 16/5/18.
//  Copyright © 2016年 石伟浩. All rights reserved.
//

#import "LDEntrepreneursTableViewController.h"
#import "LDJobStudentInforController.h"
#import "LDJobTabbleViewController.h"
#import "LDBasicGroupModel.h"
#import "LDBasicModel.h"
#import "LDBaseInformationCell.h"
#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"
#import "LDBaseInformationCell.h"
#import "LTPickerView/LTPickerView.h"
#import "WHChuangYeZheModel.h"
#import "LDTabBarController.h"
#import "LDContactInformationViewController.h"

@interface LDEntrepreneursTableViewController ()<UITextFieldDelegate, STPickerAreaDelegate, STPickerDateDelegate,UITextViewDelegate>
/**
 *  企业规模,参数层
 */
@property (nonatomic, strong) NSString *companySizeNum;
/**
 *  企业年限
 */
@property (nonatomic, strong) NSString *sumYearNum;

/**
 *  企业地址
 */
@property (nonatomic, strong) NSString *companyProvince;
@property (nonatomic, strong) NSString *companyCityArea;

@property (nonatomic, strong) WHChuangYeZheModel * chuangyezheModel;

/**
 *  "区号"和"电话" "-" 拼接后的字符串
 */
@property (nonatomic,copy) NSString * pingJiePhoneNumber;
@end

@implementation LDEntrepreneursTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业信息";
    
    self.companyName.keyboardType = UIKeyboardTypeDefault;
    self.companyQuHao.keyboardType = UIKeyboardTypeNumberPad;
    self.companyPhone.keyboardType = UIKeyboardTypeNumberPad;
    self.sumYear.keyboardType = UIKeyboardTypeDefault;
    self.companyName.delegate = self;
    self.companyQuHao.delegate = self;
    self.companyPhone.delegate = self;
    self.conmanyDetailPlace.delegate = self;
    [self.companyQuHao addTarget:self action:@selector(companyQuHaoChange:) forControlEvents:UIControlEventEditingChanged];
    [self.companyPhone addTarget:self action:@selector(companyPhoneChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    [self.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sumYearButton addTarget:self action:@selector(clickSumYearButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.comanySizeButton addTarget:self action:@selector(clickSizeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.companyDetailButton addTarget:self action:@selector(clickDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.companyPlaceButton addTarget:self action:@selector(clickPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapx = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderForTextFiled:)];
    [self.view addGestureRecognizer:tapx];
    
    if ([self.fromeWhere isEqualToString:@"wode"] || [self.fromeWhere isEqualToString:@"xiugai"]) {
        [self requestChuangYeZheMessageRequest];
    }
    
    [self createGobackHomePageButton];
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.conmanyDetailPlace.text.length == 0) {
        [self.companyDetailButton setTitle:@"街道/楼/室" forState:UIControlStateNormal];
    }
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

- (void)resignFirstResponderForTextFiled:(UITapGestureRecognizer *)tap{
    
    //[self.view removeGestureRecognizer:tap];
    [self selfViewEnding];
}
//下一步校验数据，发送请求
- (void)clickNextButton:(UIButton *)sender{
    
    //电话
    self.pingJiePhoneNumber = [NSString stringWithFormat:@"%@-%@",self.companyQuHao.text,self.companyPhone.text];
    if (self.companyName.text.length == 0 || self.companyQuHao.text.length == 0 || self.companyPhone.text.length == 0 || self.companyPlace.text.length == 0 || self.conmanyDetailPlace.text.length == 0 || self.companySize.text.length == 0 ) {
        [HDLoading showFailViewWithString:@"请将信息补充完整"];
    }
    else if (![self checkCompanyPhone]){
        [HDLoading showFailViewWithString:@"请输入正确的固定电话"];
    }else {
        [self sendRequest];
        
    }
    
}
//校验公司电话
- (BOOL)checkCompanyPhone{
    if ((self.companyQuHao.text.length == 3 || self.companyQuHao.text.length == 4) && (self.companyPhone.text.length > 6)) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}

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
        self.sumYear.text = str;
        self.sumYearNum = [NSString stringWithFormat:@"%d",num];
        LDLog(@"%@",self.sumYear.text);
        
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
        
        self.companySize.text = str;
        self.companySizeNum = [NSString stringWithFormat:@"%d",num];
        LDLog(@"%@",self.companySize.text);
        
    };
    pickerView.closeblock = ^{};
}
//填写详细地址
- (void)clickDetailButton:(UIButton *)sender{
    
    [sender setTitle:@"" forState:UIControlStateNormal];
    
    [self.conmanyDetailPlace becomeFirstResponder];
    
    
    
}

- (void) textViewDidChange:(UITextView *)textView{
    
//    if ([textView.text length] == 0) {
//        
//        [self.companyDetailButton setTitle:@"街道/楼/室" forState:UIControlStateNormal];;
//        
//    }else{
//        
//    
//    }
    
}
//选择地区
- (void)clickPlaceButton:(UIButton *)sender{
    [self selfViewEnding];
    [[[STPickerArea alloc]initWithDelegate:self]show];
    
}
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    
    self.companyPlace.text = text;
    
    
    
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
    self.companyProvince = province;
    self.companyCityArea = [NSString stringWithFormat:@"%@ %@",city,area];
}

- (void)selfViewEnding{
    [self.view endEditing:YES];
    if (self.conmanyDetailPlace.text.length == 0) {
        [self.companyDetailButton setTitle:@"街道/楼/室" forState:UIControlStateNormal];
    }
    
}

//提交创业者信息
- (void)sendRequest{
    
    [HDLoading showWithImageWithString:@"正在提交"];
    
    NSString * url = [NSString stringWithFormat:@"%@register/workInfo",KBaseUrl];
    
    [[LDNetworkTools sharedTools] request:POST url:url params:[self getParameters] callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            LDLog(@"%@",error);
            [HDLoading showFailViewWithString:@"网络错误"];
        }else{
            
            LDLog(@"%@",response);
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
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
            else if ([backInfor.code isEqualToString:@"100"]){
                [HDLoading showFailViewWithString:@"系统错误"];
            }else{
                [HDLoading showFailViewWithString:backInfor.message];
            }
            
        }
    }];
    
    
}
#pragma mark - 拼接参数
- (NSMutableDictionary *)getParameters{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    //    ID ,Token
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    //名称
    [parameters setObject:NILSTR(self.companyName.text) forKey:@"corporation"];
    
    //企业电话
    [parameters setObject:NILSTR(self.pingJiePhoneNumber) forKey:@"corporationTelNo"];
    
    //省
    [parameters setObject:NILSTR(self.companyProvince) forKey:@"corporationAddrProvince"];
    //市区
    [parameters setObject:NILSTR(self.companyCityArea) forKey:@"corporationAddrCounty"];
    //详细地址
    [parameters setValue:NILSTR(self.conmanyDetailPlace.text)forKey:@"corporationAddr"];
    //规模
    [parameters setValue:NILSTR(self.companySizeNum) forKey:@"corporationScale"];
    
    //年限
    [parameters setValue:NILSTR(self.sumYearNum) forKey:@"corporationYear"];
    
    
    return parameters;
    
}

//获取创业者信息
- (void)requestChuangYeZheMessageRequest{
    
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
                self.chuangyezheModel = [WHChuangYeZheModel paresChuangYeZheModelWithDictionary:dict];
                //给控件赋值
                [self loadEntrepreneursData];
                
            }else{
                // 显示失败信息
                [HDLoading showFailViewWithString:[response objectForKey:@"message"]];
            }
            
            LDLog(@"%@",response);
        }
    }];
}

- (void)loadEntrepreneursData{
    
    //---------------------企业名称-------------------
    if ([self.chuangyezheModel.corporation isEqualToString:@"(null)"] || [self.chuangyezheModel.corporation isEqualToString:@"<null>"] || self.chuangyezheModel.corporation == nil) {
        
        self.chuangyezheModel.corporation = @"";
        
    }else{
        //self.companyName.text = self.chuangyezheModel.corporation;
    }
    
    //--------------------企业电话-------------------
    if ([self.chuangyezheModel.corporationTelNo isEqualToString:@"(null)"] || [self.chuangyezheModel.corporationTelNo isEqualToString:@"<null>"] || self.chuangyezheModel.corporationTelNo == nil) {
        
        self.chuangyezheModel.corporationTelNo = @"";
    }else{
//        NSArray * phoneArray = [self.chuangyezheModel.corporationTelNo componentsSeparatedByString:@"-"];
//        //拉去信息时,该字符串含有分隔符才拆分
//        if (phoneArray.count == 2) {
//            
//            NSArray * phoneArray = [self.chuangyezheModel.corporationTelNo componentsSeparatedByString:@"-"];
//            self.companyPhone.text = [phoneArray lastObject];
//            self.companyQuHao.text = [phoneArray firstObject];
//            
//        }
    }
    
    //--------------------企业---省份------------
    if ([self.chuangyezheModel.corporationAddrProvince isEqualToString:@"(null)"] || [self.chuangyezheModel.corporationAddrProvince isEqualToString:@"<null>"] || self.chuangyezheModel.corporationAddrProvince == nil) {
        self.chuangyezheModel.corporationAddrProvince = @"";
    }
    
    //------------------企业-----市区-------------
    if ([self.chuangyezheModel.corporationAddrCounty isEqualToString:@"(null)"] || [self.chuangyezheModel.corporationAddrCounty isEqualToString:@"<null>"] || self.chuangyezheModel.corporationAddrCounty == nil) {
        self.chuangyezheModel.corporationAddrCounty = @"";
    }
    
//    self.companyPlace.text = [NSString stringWithFormat:@"%@ %@",self.chuangyezheModel.corporationAddrProvince,self.chuangyezheModel.corporationAddrCounty];
//    self.companyProvince = self.chuangyezheModel.corporationAddrProvince;
//    self.companyCityArea = self.chuangyezheModel.corporationAddrCounty;
    
    //------------------企业规模---------------
    if ([self.chuangyezheModel.corporationScale isEqualToString:@"(null)"] || [self.chuangyezheModel.corporationScale isEqualToString:@"<null>"] || self.chuangyezheModel.corporationScale == nil) {
        self.chuangyezheModel.corporationScale = @"";
    }else{
//        self.companySizeNum = self.chuangyezheModel.corporationScale;
//        NSArray * array = @[@"20人以下",@"50人(含)以下",@"50-100人",@"100-500人",@"500人以上",@"无",@"501-1000",@"1001-5000",@"5000人以上"];
//        self.companySize.text = array[[self.chuangyezheModel.corporationScale intValue]] ;
    }
    
    
    //---------------------企业年限--------------------
    if ([self.chuangyezheModel.corporationYear isEqualToString:@"(null)"] || [self.chuangyezheModel.corporationYear isEqualToString:@"<null>"] || self.chuangyezheModel.corporationYear == nil) {
        self.chuangyezheModel.corporationYear = @"";
    }else{
//        self.sumYearNum = self.chuangyezheModel.corporationYear;
//        NSArray * array = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
//        self.sumYear.text = array[[self.chuangyezheModel.corporationYear intValue]] ;
    }
    
    
    //-------------------企业详细地址-------------------
    if ([self.chuangyezheModel.corporationAddr isEqualToString:@"(null)"] || [self.chuangyezheModel.corporationAddr isEqualToString:@"<null>"] || self.chuangyezheModel.corporationAddr == nil) {
        self.chuangyezheModel.corporationAddr = @"";
    }else{
//        [self.companyDetailButton setTitle:@"" forState:UIControlStateNormal];
//        self.conmanyDetailPlace.text = self.chuangyezheModel.corporationAddr;
    }
    
    if (self.chuangyezheModel.corporation.length > 0 && self.chuangyezheModel.corporationTelNo.length > 0 && self.chuangyezheModel.corporationAddrProvince.length > 0  && self.chuangyezheModel.corporationAddrCounty.length > 0 && self.chuangyezheModel.corporationScale.length > 0 && self.chuangyezheModel.corporationYear.length > 0 && self.chuangyezheModel.corporationAddr.length > 0) {
        //企业名称
        self.companyName.text = self.chuangyezheModel.corporation;
        
        //企业电话呢
        NSArray * phoneArray = [self.chuangyezheModel.corporationTelNo componentsSeparatedByString:@"-"];
        if (phoneArray.count == 2) {
            
            NSArray * phoneArray = [self.chuangyezheModel.corporationTelNo componentsSeparatedByString:@"-"];
            self.companyPhone.text = [phoneArray lastObject];
            self.companyQuHao.text = [phoneArray firstObject];
            
        }
        
        //企业地址
        self.companyPlace.text = [NSString stringWithFormat:@"%@ %@",self.chuangyezheModel.corporationAddrProvince,self.chuangyezheModel.corporationAddrCounty];
        self.companyProvince = self.chuangyezheModel.corporationAddrProvince;
        self.companyCityArea = self.chuangyezheModel.corporationAddrCounty;

        //企业规模
        self.companySizeNum = self.chuangyezheModel.corporationScale;
        NSArray * array = @[@"20人以下",@"50人(含)以下",@"50-100人",@"100-500人",@"500人以上",@"无",@"501-1000",@"1001-5000",@"5000人以上"];
        self.companySize.text = array[[self.chuangyezheModel.corporationScale intValue]] ;

        //企业年限
        self.sumYearNum = self.chuangyezheModel.corporationYear;
        NSArray * array2 = @[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
        self.sumYear.text = array2[[self.chuangyezheModel.corporationYear intValue]] ;

        //企业详细地址
        [self.companyDetailButton setTitle:@"" forState:UIControlStateNormal];
        self.conmanyDetailPlace.text = self.chuangyezheModel.corporationAddr;

    }
    
    
    
}

@end
