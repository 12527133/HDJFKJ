//
//  LDReViewInformation.m
//  HDJFKJ
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDReViewInformation.h"
#import "LDReviewInforCell.h"
#import "LDCardInforCell.h"
#import "LDReviewContactCell.h"
#import "LDAnotherInforCell.h"
#import "LDOtherInforCell.h"
#import "LDGoodsDetailModel.h"
#import "LDPostIDCard.h"
#import "WHWorkViewController.h"
#import "LDContactInformationViewController.h"
#import "WHSendOtherMateriaController.h"
#import "AuthorizViewController.h"
#import "HDHalfBgView.h"
#import "HDBankResult.h"
#import "LDHaveCardListModel.h"
#import "LDBankCardViewController.h"

#import "WHCustomInfoInfoStepAll.h"
#import "LDPaymentPasswordController.h"
#import "HDMaterialOperate.h"
#import "HDSumitOrderBack.h"
#import "LDSubmitVCController.h"
#import "HDForceAuthFlag.h"
#import "HDPictureModel.h"
#import "WHBaseInfoModel.h"

#import "HDAccessToken.h"
#import "HDBaseInfoNextVC.h"

@interface LDReViewInformation ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *inforTableView;

/** 银行卡列表 */
@property (nonatomic, strong) NSArray * bankCardArr;

@property (nonatomic, strong) HDHalfBgView * halfBgView;

/** 授权信息 */
@property (nonatomic, strong)  HDForceAuthFlag * force;

/** 信息完成程度 */
@property (nonatomic, strong) WHCustomInfoInfoStepAll * customInfo;

@end

@implementation LDReViewInformation

- (NSMutableArray *)pictureArr{
    
    if (!_pictureArr) {
        _pictureArr = [[NSMutableArray alloc]init];
    }
    return _pictureArr;
}



static NSString * const ReViewSection0 = @"LDReViewInfor0";
static NSString * const ReViewSection1 = @"LDReViewInfor1";
static NSString * const ReViewSection2 = @"LDReViewInfor2";
static NSString * const ReViewSection3 = @"LDReViewInfor3";
static NSString * const ReViewSection4 = @"LDReViewInfor4";



- (IBAction)subMitReviewAllInfor:(id)sender {
    
    
    if (![self.customInfo.basicInfo isEqualToString:@"1"] ) {
        [self showFailViewWithString:@"请将基本信息补充完整!"];
    }
    else if (![self.customInfo.workInfo isEqualToString:@"1"]){
        
        [self showFailViewWithString:@"请将身份信息补充完整!"];
    }
    else if (![self.customInfo.contactInfo isEqualToString:@"1"]){
        
        [self showFailViewWithString:@"请将联系人信息补充完整!"];
    }
    else if (![self.customInfo.operatorAuthInfo isEqualToString:@"1"] && ![self.force.authFlag isEqualToString:@"0"]){
        /** 验证是否需要授权运行商  */
        //[self panDuanShiFouXuYaoShouXin];
        [self showFailViewWithString:@"请先授权运营商"];
    }
    else{
        
        /** 获取银行卡列表  */
        [self sendRequestHaveCard:YES];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    /** 发送网络请求  */
    [self sendRequestCustomInfo];
    
   
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = NO;
}
/** 设置二级界面导航栏背景色为白色 */
- (void)setNavgationBackgroundWight{
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    /** 设置导航栏字体为白色 */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHColorFromRGB(0x323232)}];
    
    /** 设置导航背景图 */
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    
    /** 是否显示下划线 */
    self.navigationController.navigationBar.shadowImage = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"审核信息";
    
    self.view.backgroundColor = LDBackroundColor;
    
    [self setNavgationBackgroundWight];
    
    /** 如果不是打回修改，创建左侧导航栏按钮 */
    if ([self.fromWhere isEqualToString:@"xiugai"]) {
        
    }else
    {
        [self createGobackHomePageButton];
    }
    
    /** 注册cell*/
    [self registerCell];
    
    
    /** 删除本地存储的图片  */
    [HDMaterialOperate deleteGroup];
    
}
- (void)dealloc{
    LDLog(@"销毁审核信息控制器");
}


/**
 *  获取用户信息完成程度
 */
- (void)sendRequestCustomInfo{
    
    [MBProgressHUD showMessage:@"正在加载"];
    NSString * url = [NSString stringWithFormat:@"%@customInfo/infoStepAll",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            /** 1.解析返回信息*/
            LDBackInformation * model = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            if ([model.code isEqualToString:@"0"]) {
                
                /** 2.解析完善程度数据 */
                if (model.result != nil)
                {
                    self.customInfo = [WHCustomInfoInfoStepAll mj_objectWithKeyValues:model.result];
                    
                    
                    /** 判断是否需要授权运营商*/
                    [self panDuanShiFouXuYaoShouXin];
                    
                    
                }
                
            }
            else{
                [MBProgressHUD showError:model.message];
            }
            
            
            LDLogFunc;
            
        }
        
    }];
    
    
}


//网络请求(加载页面数据)
- (void)sendRequest{
    
    
    NSString * url = [NSString stringWithFormat:@"%@order/auditInformation",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"custId"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].token) forKey:@"token"];
    [params setObject:[HDSubmitOrder shardSubmitOrder].businessId forKey:@"businessId"];
    
    if ([HDSubmitOrder shardSubmitOrder].orderNo != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].orderNo forKey:@"applyId"];
    }
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            [MBProgressHUD showError:@"网络错误"];
            LDLog(@"%@",error);
        }else{
            
            [MBProgressHUD hideHUD];
            
            LDLog(@"%@",response);
            LDBackInformation * model = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([model.code isEqualToString:@"0"]) {
                
                self.reviewModel = [LDReviewModel mj_objectWithKeyValues:model.result];
                [self.inforTableView reloadData];
            }
            
        }
    }];
}



/**
 * 创建导航栏右侧关闭按钮
 **/
- (void)createGobackHomePageButton{
    
    
    UIButton * backPage = [[UIButton alloc]init];
    
    backPage.frame =CGRectMake(0, 0, 30, 30);
    
    [backPage setImage:[UIImage imageNamed:@"shenhe_arrow_down"] forState:UIControlStateNormal];
    
    
    [backPage addTarget:self action:@selector(ClickdismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backPage];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftItem, nil];
    
}
/**
 * 关闭控制器
 **/
- (void)ClickdismissButton:(UIButton *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)dismissButtonClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)registerCell{
    
    [self.inforTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDReviewInforCell  class]) bundle:nil] forCellReuseIdentifier:ReViewSection0];
    
    [self.inforTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDCardInforCell  class]) bundle:nil] forCellReuseIdentifier:ReViewSection1];
    
    [self.inforTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDReviewContactCell  class]) bundle:nil] forCellReuseIdentifier:ReViewSection2];
    
    [self.inforTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDAnotherInforCell  class]) bundle:nil] forCellReuseIdentifier:ReViewSection3];
    
    [self.inforTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDOtherInforCell  class]) bundle:nil] forCellReuseIdentifier:ReViewSection4];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        
        LDReviewInforCell * cell = [tableView dequeueReusableCellWithIdentifier:ReViewSection0];
        cell.customInfo = self.customInfo;
        cell.reviewModel = self.reviewModel;
        
        return cell;
        
        
    }else if (indexPath.section == 1){
        
        LDCardInforCell * cell = [tableView dequeueReusableCellWithIdentifier:ReViewSection1];
        cell.customInfo = self.customInfo;
        cell.reviewModel = self.reviewModel;
        
        return cell;
    }else if (indexPath.section == 2){
        LDReviewContactCell * cell = [tableView dequeueReusableCellWithIdentifier:ReViewSection2];
        cell.customInfo = self.customInfo;
        cell.reviewModel = self.reviewModel;
        
        return cell;
        
    }else if (indexPath.section == 3){
        
        LDAnotherInforCell * cell = [tableView dequeueReusableCellWithIdentifier:ReViewSection3];
        
        if (self.pictureArr.count > 0) {
            cell.picArray = self.pictureArr;
        }else{
            cell.picArray = self.reviewModel.picList;
        }
        
        
        return cell;
    }else{
        
        LDOtherInforCell * cell = [tableView dequeueReusableCellWithIdentifier:ReViewSection4];
        cell.force = self.force;
        cell.customInfo = self.customInfo;
        cell.reviewModel = self.reviewModel;
        
        return cell;
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        
        return 160;
        
    }else{
        
        return 130;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 14;
        
    }else{
        
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        
        if (self.reviewModel.fundDescription != nil) {
            return 44;
        }else{
            return 14;
        }
        
    }else{
        
        
        return 0.001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = nil;
    if (section == 4 && self.reviewModel.fundDescription != nil) {
        footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 40)];
        footerView.backgroundColor = WHColorFromRGB(0xf0f0f0);
        
        UILabel * label = [[UILabel alloc]init];
        label.text = self.reviewModel.fundDescription;
        
        
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, 24)];
        
        UIImageView * herImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 24)];
        [herImageView sd_setImageWithURL:[NSURL URLWithString:self.reviewModel.fundLogoUrl] placeholderImage:[UIImage imageNamed:@"banner_zhanwei"]];
        
        float distace = (LDScreenWidth-herImageView.frame.size.width - size.width)/2;
        
        herImageView.frame = CGRectMake(distace, 10, herImageView.frame.size.width, herImageView.frame.size.height);
        
        label.frame = CGRectMake(distace + herImageView.frame.size.width + 8, 10, size.width, size.height);
        label.textColor = WHColorFromRGB(0x4279d6);
        label.font = [UIFont systemFontOfSize:13];
        
        [footerView addSubview:label];
        [footerView addSubview:herImageView];
        
        
        
    }
    return footerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LDLogFunc;
    self.fromWhere = @"shenhe";
    
    if (![self.customInfo.basicInfo isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            LDPostIDCard * postIDCard = [[LDPostIDCard alloc]init];
            postIDCard.fromeWhere = self.fromWhere;
            if ([self.customInfo.advancedInfo isEqualToString:@"1"]) {
                postIDCard.requestImage = YES;
            }
            else{
                postIDCard.requestImage = NO;
            }
            [self.navigationController pushViewController:postIDCard animated:YES];
        }
        else{
            [MBProgressHUD showError:@"请先完善身份信息!"];
            [self.inforTableView reloadData];
            
        }
    }else{
        
        if (indexPath.section == 0) {
            LDPostIDCard * postIDCard = [[LDPostIDCard alloc]init];
            postIDCard.fromeWhere = self.fromWhere;
            
            if ([self.customInfo.advancedInfo isEqualToString:@"1"]) {
                postIDCard.requestImage = YES;
            }
            else{
                postIDCard.requestImage = NO;
            }
            [self.navigationController pushViewController:postIDCard animated:YES];
        }
        if (indexPath.section == 1) {
            WHWorkViewController * workVC = [[WHWorkViewController alloc]init];
            workVC.fromeWhere  = self.fromWhere;
            workVC.workInfo = self.customInfo.workInfo;
            [self.navigationController pushViewController:workVC animated:YES];
        }
        if (indexPath.section == 2) {
            LDContactInformationViewController * contactInfo = [[LDContactInformationViewController alloc]init];
            contactInfo.fromeWhere  = self.fromWhere;
            contactInfo.isFinsh = self.customInfo.contactInfo;
            [self.navigationController pushViewController:contactInfo animated:YES];
        }
        if (indexPath.section == 3) {
            WHSendOtherMateriaController * sendMaterial = [[WHSendOtherMateriaController alloc]init];
            sendMaterial.fromWhere  = self.fromWhere;
            
            if (self.pictureArr.count>0) {
                [sendMaterial.otherArray addObjectsFromArray:[self.pictureArr copy]];
            }
            else{
                [sendMaterial.otherArray addObjectsFromArray:[self.reviewModel.picList copy]];
            }
            
            sendMaterial.reviewInfonmation = self;
            
            [self.navigationController pushViewController:sendMaterial animated:YES];
        }
        if (indexPath.section == 4) {
            AuthorizViewController * author = [[AuthorizViewController alloc]init];
            author.fromWhere  = self.fromWhere;
            [self.navigationController pushViewController:author animated:YES];
        }
    }
    
}
/**
 * 判断是否需要授权运营商请求
 **/
- (void)panDuanShiFouXuYaoShouXin{
    
    
    
    NSString * str = [NSString stringWithFormat:@"%@forceAuthFlag",KBaseUrl ];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:[HDSubmitOrder shardSubmitOrder].businessId forKey:@"businessId"];
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([HDSubmitOrder shardSubmitOrder].caseId == nil) {
                //给提交订单模型，赋值
                [[HDSubmitOrder shardSubmitOrder] setCaseId:[LDGoodsIDAndZhuanAnId sharedInstance].zhuanAnID];
            }
            
            /** 4.code == 0请求成功 */
            if ([backInfo.code isEqualToString:@"0"]) {
                
                
                /** 5.解析返回信息 */
                if (backInfo.result != nil) {
                    self.force = [HDForceAuthFlag mj_objectWithKeyValues:backInfo.result];
                    
                    
                    /** 3.获取审核信息 */
                    [self sendRequest];
                    
                }else{
                    
                    [MBProgressHUD showError:@"请先授权运营商"];
                }
                
            }else{
                
                /** 6.请求异常提示 */
                [MBProgressHUD showError:backInfo.message];
                
            }
            
            LDLog(@"%@",response);
        }
    }];
    
}

/**
 *  获取银行卡信息
 */
- (void)sendRequestHaveCard:(BOOL)isCreatehalf{
    
    if (isCreatehalf) {
        [self showWithImageWithString:@"请稍后..."];
    }
    
    
    NSString * url = [NSString stringWithFormat:@"%@person/bankcard/list",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
        }else{
            
            NSLog(@"=================%@",response);
            [self dismissHDLoading];
            
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 4.解析银行卡信息 */
                if (backInfo.result != nil){
                    
                    HDBankResult * bankResult = [HDBankResult mj_objectWithKeyValues:backInfo.result];
                    
                    self.bankCardArr = [LDHaveCardListModel mj_objectArrayWithKeyValuesArray:bankResult.list];
                }
                
                
                /** 判断银行卡是否为空，没有银行卡提示添加，有银行卡直接弹窗 */
                if (self.bankCardArr.count == 0) {
                    
                    [self performSelector:@selector(noBankAlert) withObject:nil afterDelay:0.2];
                    
                    
                }
                else{
                    
                    
                    if (self.halfBgView != nil) {
                        [self.halfBgView reloadAddBankTableViewWith:self.bankCardArr];
                    }
                    else{
                        [self createHalfView];
                    }
                }
                
            }else{
                
                [MBProgressHUD showError:backInfo.message];
            }
        }
    }];
}

- (void)noBankAlert{
    
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"您还没有绑定银行卡，请添加!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alertView.tag = 119;
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 119) {
        if (buttonIndex == 1) {
            
            
            /** 获取用户基本信息，添加银行卡基恩 */
            [self requestBasicMessageRequest];
            
        }
    }
    
}
/**
 * 网络请求,获取用户的基本信息
 **/
- (void)requestBasicMessageRequest{
    
    [self showWithImageWithString:@"请稍后..."];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    
    __weak typeof(self) weakSelf = self;
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
                
                /** 5.解析基本信息 */
                if (backInfo.result != nil){
                    
                    WHBaseInfoModel * baseInfoModel = [WHBaseInfoModel mj_objectWithKeyValues:backInfo.result];
                    
                    /** 推出添加银行卡界面 */
                    [self sendRegisterGetNHAccessTokenRequest:baseInfoModel];
                }
                
            }else{
                
                /** 6.请求异常提示 */
                [self showFailViewWithString:backInfo.message];
            }
            
            LDLog(@"%@",response);
        }
    }];
}

/**
 *  获取token
 */
- (void)sendRegisterGetNHAccessTokenRequest:(WHBaseInfoModel *)baseInfoModel{
    
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
                
                if ([accessToken.status isEqualToString:@"4"]) {
                    
                    [self sendRequestHaveCard:YES];
                }
                else{
                    
                    HDBaseInfoNextVC * nextVC = [[HDBaseInfoNextVC alloc]init
                                                 ];
                    nextVC.accessToken = accessToken;
                    nextVC.userName = baseInfoModel.idName;
                    nextVC.userNo = baseInfoModel.idNo;
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                
                
                
                
            }else
            {
                /** 7.请求异常提示  */
                [self showFailViewWithString:backInfor.message];
            }
        }
    }];
    
}




- (void)createHalfView{
    
    self.halfBgView= [HDHalfBgView createHDHalfBgViewWithView:self.view];
    self.halfBgView.bankCardArray = self.bankCardArr;
    [self.halfBgView addComfimComiteView];
    
    
    [self.halfBgView.comfimView.closeButton addTarget:self action:@selector(clickCloseHalfButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    __weak typeof(self) weakSelf = self;
    
    self.halfBgView.addbankCard = ^{
        
        [weakSelf requestBasicMessageRequest];
        
    };
    
    
    
    self.halfBgView.successBlock = ^(NSString * bankCardID){
        
        [weakSelf submitOrderRequest:bankCardID];
        

        
    };
    
}
- (void)clickCloseHalfButton:(UIButton *)sender{

    self.halfBgView.comfimView = nil;
    
    self.halfBgView = nil;
}

/**
 *  提交订单网络请求
 */
- (void)submitOrderRequest:(NSString *)bankCardID{
    
    [self showWithImageWithString:@"正在提交订单"];
    
    
    NSString * url = [NSString stringWithFormat:@"%@order/submit",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    /**
     * token  YES
     **/
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    /**
     * id     YES
     **/
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    /**
     * 申请价格   YES
     **/
    if ([HDSubmitOrder shardSubmitOrder].applyAmount != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].applyAmount forKey:@"applyAmount"];
    }
    
    
    /**
     * 首付金额    YES
     **/
    if ([HDSubmitOrder shardSubmitOrder].downpayment != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].downpayment forKey:@"downpayment"];
    }
    
    
    /**
     * 总价    YES
     **/
    if ([HDSubmitOrder shardSubmitOrder].totalAmount != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].totalAmount forKey:@"totalAmount"];
    }
    
    
    /**
     * 商品包id
     **/
    if ([HDSubmitOrder shardSubmitOrder].packageId != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].packageId forKey:@"packageId"];
    }
    
    /**
     * 专案id    YES
     **/
    if ([HDSubmitOrder shardSubmitOrder].caseId != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].caseId forKey:@"caseId"];
    }
    
    
    /**
     * 商户id    YES
     **/
    if ([HDSubmitOrder shardSubmitOrder].businessId != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].businessId forKey:@"businessId"];
    }
    
    /**
     * 商品列表    YES
     **/
    if ([HDSubmitOrder shardSubmitOrder].commoditys != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].commoditys forKey:@"commoditys"];
    }
    
    /**
     * 银行卡id    YES
     **/
    [params setObject:bankCardID forKey:@"bankcardId"];
    
    
    /**
     * 线下渠道
     **/
    if ([HDSubmitOrder shardSubmitOrder].termial != nil) {
        [params setObject:@"termail" forKey:@"termial"];
    }
    
    /** 图片url*/
    if (self.reviewModel.picList.count > 0 || self.pictureArr.count > 0) {
        [params setObject:[self getPicArrUrlJsonOtherArray:self.reviewModel.picList arrar:self.pictureArr] forKey:@"picList"];
    }
    
    
    /** 打回修改订单号 */
    if ([HDSubmitOrder shardSubmitOrder].orderNo != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].orderNo forKey:@"orderNo"];
    }
    
    
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                
                [self dismissHDLoading];
                /** 4.解析订单id */
                if (backInfo.result != nil) {
                    HDSumitOrderBack * orderBack = [HDSumitOrderBack mj_objectWithKeyValues:backInfo.result];
                    
                    LDSubmitVCController * vc = [[LDSubmitVCController alloc] init];
                    vc.applyId = orderBack.applyId;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                else{
                    [self showFailViewWithString:@"提交失败"];
                }
                
            }else{
                [self showFailViewWithString:backInfo.message];
            }
        }
    }];
}

- (NSString *)getPicArrUrlJsonOtherArray:(NSArray *)otherArray arrar:(NSArray *)array{
    
    NSMutableArray * picUrlArr = [[NSMutableArray alloc]init];
    
    if (array.count == 0) {
        for (HDPictureModel * picModel in otherArray) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            
            
            [dict setValue:picModel.picUrl forKey:@"relativePath"];
            
            
            [picUrlArr addObject:dict];
        }
    }
    else{
        
        for (HDPictureModel * picModel in array) {
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setValue:picModel.picUrl forKey:@"relativePath"];
            
            
            [picUrlArr addObject:dict];
        }
    }
    
    
    
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:picUrlArr options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString* sInvalid = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 从服务器收到的类似上一行的数据 // 转换
    NSString*sValid = [sInvalid stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData * data =[sValid dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    
    
    return jsonString;
    
}





@end
