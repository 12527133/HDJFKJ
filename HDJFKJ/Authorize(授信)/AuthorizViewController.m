//
//  AuthorizViewController.m
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "AuthorizViewController.h"

#import "NetWorkOperaViewController.h"
#import "NetTaoBaoViewController.h"
#import "XinXinAuthViewController.h"
#import "LDtest2222ViewController.h"
#import "LDTabBarController.h"
#import "CashLoanController.h"
#import "WHSendOtherMateriaController.h"
#import "WHPaybackAndCreditView2.h"
#import "AuthorizCellView.h"
#import "LDGoodsDetailModel.h"
#import "WHCustomInfoInfoStepAll.h"
#import "LDNavgationVController.h"

/** 缓存信息模型 */
#import "HDGetUInfoModel.h"

@interface AuthorizViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) NSInteger               authType;      //授权类型，用于区分学信(_authType==2)和运营商授权(_authType==3)


//记录是否已授权
@property (nonatomic, strong) NSString * taobaoshouquan;
@property (nonatomic, strong) NSString * xuexinshouquan;
@property (nonatomic, strong) NSString * yunyinshangshouquan;

@property (nonatomic, strong) NSTimer * timer;

//2.0.4修改
@property (nonatomic, strong) UITableView * backgroundTable;
@property (nonatomic, strong) UIButton * nextButton;
//闪银可会ID
@property (nonatomic, strong) NSString * syCustId;

@end

@implementation AuthorizViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self sendGetShouXinRequest];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    
   
    self.title = @"申请授权";
    
    [self createBackgroundTableView];
    
}
- (void)createBackgroundTableView{
    self.backgroundTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, self.view.frame.size.height)];
    self.backgroundTable.backgroundColor = [UIColor clearColor];
    self.backgroundTable.delegate = self;
    self.backgroundTable.dataSource = self;
    self.backgroundTable.scrollEnabled = NO;
    self.backgroundTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.backgroundTable];
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        default:
            return 2;
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10.0;
            break;
        default:
            return 10.0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 90.0;
            break;
        default:
            return 45.0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    
    
    if (indexPath.section == 0){
        WHPaybackAndCreditView2 * cellView = [WHPaybackAndCreditView2 view];
        cellView.frame = CGRectMake(0, 0, LDScreenWidth, 90);
        cellView.titleLable.text = @"授权信息";
        cellView.goLoginLabel.hidden = YES;
        cellView.goImageView.hidden = YES;
        cellView.creditLabel.text = @"授权项越多，获取的额度越高";
        cellView.creditLabel.textColor = WHColorFromRGB(0x2b2b2b);
        cellView.iconImageView.image = [UIImage imageNamed:@"shouquan_shouquan"];
        [cell addSubview:cellView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else{
        AuthorizCellView * authorizView = [AuthorizCellView view];
        authorizView.frame = CGRectMake(0, 0, LDScreenWidth, 45);
        
        
        if (indexPath.row == 0) {
            authorizView.iconImageView.image = [UIImage imageNamed:@"shouquan_yunying"];
            authorizView.titleLabel.text = @"运营商";
            if (![self.yunyinshangshouquan isEqualToString:@"1"] ) {
                authorizView.statusLabel.text = @"去授权";
                authorizView.statusLabel.textColor = WHColorFromRGB(0xe84c3d);
            }
            else{
                authorizView.statusLabel.text = @"已授权";
                authorizView.statusLabel.textColor = WHColorFromRGB(0xc8c7cc);
            }
            UIView * selectBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45)];
            selectBgView.backgroundColor = WHColorFromRGB(0xd9d9d9);
            cell.selectedBackgroundView = selectBgView;
            [cell addSubview:authorizView];
            
            //4.上下连个线
            UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
            topLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:topLine];
            
            UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(15, 44.5, LDScreenWidth -15, 0.5)];
            bottomLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:bottomLine];
        }
        else if (indexPath.row == 1) {
            authorizView.iconImageView.image = [UIImage imageNamed:@"shouquan_xuexin"];
            authorizView.titleLabel.text = @"学信网";
            if (![self.xuexinshouquan isEqualToString:@"1"] ) {
                authorizView.statusLabel.text = @"去授权";
                authorizView.statusLabel.textColor = WHColorFromRGB(0xe84c3d);
                
                UIView * selectBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45)];
                selectBgView.backgroundColor = WHColorFromRGB(0xd9d9d9);
                cell.selectedBackgroundView = selectBgView;
                [cell addSubview:authorizView];
            }
            else{
                authorizView.statusLabel.textColor = WHColorFromRGB(0xc8c7cc);
                authorizView.statusLabel.text = @"已授权";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            
//            UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(15, 44.5, LDScreenWidth -15, 0.5)];
//            bottomLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
//            [cell addSubview:bottomLine];

            UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, LDScreenWidth, 0.5)];
            bottomLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:bottomLine];
            
        }else{
            authorizView.iconImageView.image = [UIImage imageNamed:@"shouquan_taobao"];
            authorizView.titleLabel.text = @"淘宝网";
            if (![self.taobaoshouquan isEqualToString:@"1"] ) {
                authorizView.statusLabel.text = @"去授权";
                authorizView.statusLabel.textColor = WHColorFromRGB(0xE84C3D);
                UIView * selectBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45)];
                selectBgView.backgroundColor = WHColorFromRGB(0xd9d9d9);
                cell.selectedBackgroundView = selectBgView;
                [cell addSubview:authorizView];
            }
            else{
                authorizView.statusLabel.text = @"已授权";
                authorizView.statusLabel.textColor = WHColorFromRGB(0xc8c7cc);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, LDScreenWidth, 0.5)];
            bottomLine.backgroundColor = WHColorFromRGB(0xd9d9d9);
            [cell addSubview:bottomLine];
            
        }
        [cell addSubview:authorizView];
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            self.authType = 3;
            
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            param[@"channel"] = @"ios";
            param[@"source"] = @"28092";
            param[@"custId"] = self.syCustId;
            
            
            NetWorkOperaViewController *xxVC = [[NetWorkOperaViewController alloc] initWithParam:param successBlk:^{
            }];
            
            xxVC.title = @"运营商授权";
            
            LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:xxVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
            xxVC.yunyingBlock = ^(NSString * yunying){
                self.yunyinshangshouquan = yunying;
                
            };
        }
        
        if (indexPath.row == 1 && ![self.xuexinshouquan isEqualToString:@"1"]) {
            self.authType = 2;
           
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            param[@"channel"] = @"ios";
            param[@"source"] = @"28092";
            param[@"custId"] = self.syCustId;
            
            XinXinAuthViewController * xinxin = [[XinXinAuthViewController alloc]initWithParam:param successBlk:^{
                
            }];
            
            LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:xinxin];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
            xinxin.xuexinBlock = ^(NSString * xuexin){
                self.xuexinshouquan = xuexin;
                
                
            };
        }
        
        
        
        if (indexPath.row == 2 && ![self.taobaoshouquan isEqualToString:@"1"]) {
            NetTaoBaoViewController * taobao = [[NetTaoBaoViewController alloc]init];
            
            LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:taobao];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            

            taobao.taobaoBlock = ^(NSString * taobaoName){
                self.taobaoshouquan = taobaoName;
                
                
            };
        }
    }
}




-(void)tijiaodingdan{
    
    if (![self.yunyinshangshouquan isEqualToString:@"1"]) {
        
        [MBProgressHUD showError:@"必选申请运营商授权!"];
        
    }else{
        
        
        //现金贷流程
        if ([self.fromWhere isEqualToString:@"xianjindai"]){
            LDtest2222ViewController * vc = [[LDtest2222ViewController alloc] init];
            
            vc.params = self.params;
            
            vc.fromWhewe = self.fromWhere;
            [self.navigationController pushViewController:vc animated:YES];
        
        }
        
        //打回修改流程
        if ([self.fromWhere isEqualToString:@"xiugai"]) {
            
            //打回修改提价订类型，0表示受托支付，1表示现金贷
            NSString * loantype = [NSKeyedUnarchiver unarchiveObjectWithFile:LoanType];
            
            if ([loantype isEqualToString:@"0"]) {
                WHSendOtherMateriaController * sendMateria = [[WHSendOtherMateriaController alloc]init];
                
                sendMateria.fromWhere = self.fromWhere;
                
                [self.navigationController pushViewController:sendMateria animated:YES];
            }
            else{
            
                LDtest2222ViewController * vc = [[LDtest2222ViewController alloc] init];
                
                vc.params = self.params;
                
                vc.fromWhewe = self.fromWhere;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        
    }
 
}




/**
 * 4.3.5. 获取用户缓存信息
 **/
- (void)sendGetShouXinRequest{
    
    [MBProgressHUD showMessage:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@getUInfo/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印请求错误信息 */
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
        }else{
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"])
            {
                
                /** 4.解析缓存信息 */
                if (backInfo.result != nil) {
                    HDGetUInfoModel * getUserInfo = [HDGetUInfoModel mj_objectWithKeyValues:backInfo.result];
                    
                    self.syCustId = getUserInfo.syCustId;
                    
                    /** 5.获取用户授权信息  */
                    [self getAuthMessageRequest];
                }
            }
        }
    }];
}

/**
 * 获取用户授权信息
 **/
- (void)getAuthMessageRequest{
    
    NSString * url = [NSString stringWithFormat:@"%@customInfo/authorizeInfo",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            /** 1.打印请求错误信息 */
            LDLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
            [MBProgressHUD hideHUD];
            LDLog(@"%@",response);
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 4.解析授权数据 */
                if (backInfo.result != nil){
                
                    WHCustomInfoInfoStepAll * customInfo = [WHCustomInfoInfoStepAll mj_objectWithKeyValues:backInfo.result];
                    
                    self.yunyinshangshouquan = customInfo.OperatorAuth;
                    
                    self.xuexinshouquan = customInfo.xuexinName;
                    
                    self.taobaoshouquan = customInfo.taobaoName;
                }
        
                /** 5.刷新界面  */
                [self.backgroundTable reloadData];
            }
            else
            {
                /** 6.请求异常提示 */
                [MBProgressHUD showError:backInfo.message];
            }
            
        }
        
    }];
    
    
}

@end
