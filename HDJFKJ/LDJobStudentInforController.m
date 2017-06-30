//
//  LDJobStudentInforController.m
//  ceshi
//
//  Created by 石伟浩 on 16/5/18.
//  Copyright © 2016年 石伟浩. All rights reserved.
//

#import "LDJobStudentInforController.h"
#import "LDJobTabbleViewController.h"
#import "LDBasicGroupModel.h"
#import "LDBasicModel.h"
#import "LDBaseInformationCell.h"
#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"
#import "LDBaseInformationCell.h"
#import "WHStudentInfoModel.h"
#import "LDTabBarController.h"
#import "LDContactInformationViewController.h"
//#import "IQKeyboardManager.h"
@interface LDJobStudentInforController ()<UITextFieldDelegate, STPickerAreaDelegate, STPickerDateDelegate,UITextViewDelegate>
/**
 *  拆分学校地址--省市(参数)
 */
@property (nonatomic,strong) NSString * schoolProvince;
@property (nonatomic,strong) NSString * schoolCityArea;
//学生模型
@property (nonatomic, strong) WHStudentInfoModel * studentInfoModel;

@property (nonatomic, assign) BOOL isEnding;

@property (nonatomic, assign) float moveHeight;

@property (nonatomic, strong) UITextView * currentTextView;
@end

@implementation LDJobStudentInforController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [IQKeyboardManager sharedManager].enable = NO;

    self.title = @"学校信息";
    
    [self.schoolButton addTarget:self action:@selector(clickSchoolButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.schoolDetailButton addTarget:self action:@selector(clickSchoolDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.dormitoryButton addTarget:self action:@selector(clickDormitoryButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nextbutton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.money.keyboardType = UIKeyboardTypeDecimalPad;
    self.money.delegate = self;
    
    self.schoolName.delegate = self;
    self.schoolName.tag = 1;
    
    self.faculty.delegate = self;
    self.faculty.tag = 2;
    
    self.money.delegate = self;
    self.money.tag = 3;
    
    self.isEnding = YES;
    
    self.schoolDetailTextView.delegate = self;
    self.schoolDetailTextView.tag = 1;
    self.dormitoryTextView.delegate = self;
    self.dormitoryTextView.tag = 2;
    
    self.moveHeight = 0;
    if (LDScreenHeight > 667) {
        self.moveHeight = 0;
    }
    else if (LDScreenHeight == 667)
    {
        self.moveHeight = - 140;
    }
    else{
        self.moveHeight = -216;
    }
    
    if ([self.fromeWhere isEqualToString:@"wode"] || [self.fromeWhere isEqualToString:@"xiugai"]) {
        [self requestStudentMessageRequest];
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
    
    //4.添加动画
    if (self.currentTextView.tag == 2) {
        [UIView animateWithDuration:0.35f animations:^{
            
            self.view.frame = CGRectMake( 0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    NSLog(@"%@",NSStringFromCGSize(self.view.frame.size));
    
}

//键盘收起时
- (void)closeKeyboard:(NSNotification *)notification{
    
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
    
}
- (void)clickSchoolButton:(UIButton *)sender{
    
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    [self selfViewEnding];
    [[[STPickerArea alloc]initWithDelegate:self]show];

}

- (void)clickSchoolDetailButton:(UIButton *)sender{
    
    self.currentTextView = self.schoolDetailTextView;
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.schoolDetailTextView becomeFirstResponder];
    
    
    if (self.dormitoryTextView.text.length == 0) {
        [self.dormitoryButton setTitle:@"宿舍详细地址" forState:UIControlStateNormal];
    }
    
}
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    
    
    
    self.schoolSity.text = text;
        
        self.schoolProvince = province;
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
        self.schoolCityArea = [NSString stringWithFormat:@"%@ %@",city,area];
        
    
    
}
- (void)clickDormitoryButton:(UIButton *)sender{
    self.currentTextView = self.dormitoryTextView;
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.dormitoryTextView becomeFirstResponder];
    
    if (self.schoolDetailTextView.text.length == 0) {
        [self.schoolDetailButton setTitle:@"学校详细地址" forState:UIControlStateNormal];
    }
}

//校验信息，发送请求
- (void)clickNextButton:(UIButton *)sender{
    if (self.schoolName.text.length == 0 || self.faculty.text.length == 0 || self.schoolSity.text.length == 0 || self.schoolDetailTextView.text.length == 0 || self.dormitoryTextView.text.length == 0 || self.money.text.length == 0) {
        [HDLoading showFailViewWithString:@"请将信息填写完整"];
    }
    else {
        [self sendRequest];
    
    }
}

#pragma mark -- textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ( textField.tag == 3) {
        [UIView animateWithDuration:0.35f animations:^{
            
            self.view.frame = CGRectMake(0, self.moveHeight, self.view.frame.size.width, self.view.frame.size.height);
        }];
        
    }
    else{
        [UIView animateWithDuration:0.35f animations:^{
            
            self.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    if (self.schoolDetailTextView.text.length == 0) {
        [self.schoolDetailButton setTitle:@"学校详细地址" forState:UIControlStateNormal];
    }
    if (self.dormitoryTextView.text.length == 0) {
        [self.dormitoryButton setTitle:@"宿舍详细地址" forState:UIControlStateNormal];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (!self.isEnding) {
        
    }else{
        [UIView animateWithDuration:0.35f animations:^{
            
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    self.isEnding = YES;
    
    
}


//发送学生信息请求
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
               
                
                
                
            }else{
                [HDLoading showFailViewWithString:backInfor.message];
            }
        }
    }];
}

#pragma mark - 拼接参数
- (NSMutableDictionary *)getParameters{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    //学校名称
    [parameters setObject:NILSTR(self.schoolName.text) forKey:@"school"];
    //学院名称
    [parameters setObject:NILSTR(self.faculty.text) forKey:@"academy"];
    //学校省
    [parameters setObject:NILSTR(self.schoolProvince) forKey:@"schoolAddressProvince"];
    //市区
    [parameters setObject:NILSTR(self.schoolCityArea) forKey:@"schoolAddressCounty"];
    
    //详细地址
    [parameters setObject:NILSTR(self.schoolDetailTextView.text) forKey:@"schoolAddressDetail"];
    //宿舍地址
    [parameters setObject:NILSTR(self.dormitoryTextView.text) forKey:@"domitory"];
    //还款金额
    [parameters setObject:NILSTR(self.money.text) forKey:@"periodUndertake"];

    return parameters;
}





//**************请求学生数据*****************
- (void)requestStudentMessageRequest{
    
    [HDLoading showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/work",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            [HDLoading showFailViewWithString:@"网络错误"];
        }else{
            
            NSString * code = [response objectForKey:@"code"] ;
            
            
            //code == 0请求成功
            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
                [HDLoading dismissHDLoading];
                
                
                
                NSDictionary * dict = [response objectForKey:@"result"];
                self.studentInfoModel = [WHStudentInfoModel paresStudentInfoModelWithDictionary:dict];
                //给控件赋值
                [self loadStudentData];
                
            }else{
                [HDLoading showFailViewWithString:[response objectForKey:@"message"]];
            }
            
            LDLog(@"%@",response);
        }
    }];
}
//加载学生信息
- (void)loadStudentData{
    //-----------------------学校名称----------------------
    if ([self.studentInfoModel.school isEqualToString:@"(null)"] || [self.studentInfoModel.school isEqualToString:@"<null>"] || self.studentInfoModel.school == nil) {
        
        self.studentInfoModel.school = @"";
        
    }else{
        //self.schoolName.text = self.studentInfoModel.school;
    }

    //----------------------学院名称--------------------
    if ([self.studentInfoModel.academy isEqualToString:@"(null)"] || [self.studentInfoModel.academy isEqualToString:@"<null>"] || self.studentInfoModel.academy == nil) {
        self.studentInfoModel.academy = @"";
    }else{
        //self.faculty.text = self.studentInfoModel.academy;
    }
    
    
    //------------------学校地址省份--------------------
    if ([self.studentInfoModel.schoolAddressProvince isEqualToString:@"(null)"] || [self.studentInfoModel.schoolAddressProvince isEqualToString:@"<null>"] || self.studentInfoModel.schoolAddressProvince == nil) {
         self.schoolProvince = @"";
    }else{
        
         self.schoolProvince = self.studentInfoModel.schoolAddressProvince;
    }
    
    
    //---------------------学校地址市区-----------------
    if ([self.studentInfoModel.schoolAddressCounty isEqualToString:@"(null)"] || [self.studentInfoModel.schoolAddressCounty isEqualToString:@"<null>"] || self.studentInfoModel.schoolAddressCounty == nil) {
        self.schoolCityArea = @"";
    }else{
        
        self.schoolCityArea = self.studentInfoModel.schoolAddressCounty;
    }
//    if (self.schoolProvince.length > 0 && self.schoolCityArea.length > 0) {
//        self.schoolSity.text = [NSString stringWithFormat:@"%@ %@",self.studentInfoModel.schoolAddressProvince,self.studentInfoModel.schoolAddressCounty];
//    }
    
    //-------------------学校详细地址-----------------
    if ([self.studentInfoModel.schoolAddressDetail isEqualToString:@"(null)"] || [self.studentInfoModel.schoolAddressDetail isEqualToString:@"<null>"] || self.studentInfoModel.schoolAddressDetail == nil) {
        
        self.studentInfoModel.schoolAddressDetail = @"";
        
    }else{
//        [self.schoolDetailButton setTitle:@"" forState:UIControlStateNormal];
//        self.schoolDetailTextView.text = self.studentInfoModel.schoolAddressDetail;
    }
   
    //----------------宿舍地址-------------------
    if ([self.studentInfoModel.domitory isEqualToString:@"(null)"] || [self.studentInfoModel.domitory isEqualToString:@"<null>"] || self.studentInfoModel.domitory == nil) {
        self.studentInfoModel.domitory = @"";
    }else{
//        [self.dormitoryButton setTitle:@"" forState:UIControlStateNormal];
//        self.dormitoryTextView.text = self.studentInfoModel.domitory;
    }
    
    //------------------偿还能力-----------
    if ([self.studentInfoModel.periodUndertake isEqualToString:@"(null)"] || [self.studentInfoModel.periodUndertake isEqualToString:@"<null>"] || self.studentInfoModel.periodUndertake == nil) {
        
        self.studentInfoModel.periodUndertake = @"";
        
    }else{
        //self.money.text = self.studentInfoModel.periodUndertake;
    }
    
    
    if (self.studentInfoModel.school.length > 0 && self.studentInfoModel.academy.length > 0 && self.schoolProvince.length > 0 && self.schoolCityArea.length > 0 &&  self.studentInfoModel.schoolAddressDetail.length > 0 && self.studentInfoModel.domitory.length > 0 && self.studentInfoModel.periodUndertake.length > 0){
    
    
        //学校名称
        self.schoolName.text = self.studentInfoModel.school;
        
        //学院名称
        self.faculty.text = self.studentInfoModel.academy;
        
        //学校地址
        self.schoolSity.text = [NSString stringWithFormat:@"%@ %@",self.studentInfoModel.schoolAddressProvince,self.studentInfoModel.schoolAddressCounty];
        
        //学校详细地址
        [self.schoolDetailButton setTitle:@"" forState:UIControlStateNormal];
        self.schoolDetailTextView.text = self.studentInfoModel.schoolAddressDetail;
        
        //宿舍地址
        [self.dormitoryButton setTitle:@"" forState:UIControlStateNormal];
        self.dormitoryTextView.text = self.studentInfoModel.domitory;

        //偿还能力
        self.money.text = self.studentInfoModel.periodUndertake;

    }
    
}













- (void)selfViewEnding{
    [self.view endEditing:YES];
    if (self.schoolDetailTextView.text.length == 0) {
        [self.schoolDetailButton setTitle:@"学校详细地址" forState:UIControlStateNormal];
    }
    if (self.dormitoryTextView.text.length == 0) {
        [self.dormitoryButton setTitle:@"宿舍详细地址" forState:UIControlStateNormal];
    }
    
}

@end
