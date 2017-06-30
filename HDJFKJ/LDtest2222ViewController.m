
//
//  LDtest2222ViewController.m
//  HDJFKJ
//
//  Created by apple on 16/4/2.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDtest2222ViewController.h"
#import "LDHaveCardListModel.h"
#import "LDBankCardViewCell.h"
#import "LDBankCardViewController.h"
#import "WHBaseInfoModel.h"
/** 请求银行卡结果模型 */
#import "HDBankResult.h"
#import "HDBankChooseView.h"
#import "LDPostIDCard.h"

#import "HDAccessToken.h"
#import "HDBaseInfoNextVC.h"

@interface LDtest2222ViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 显示银行卡的列表 */
@property (nonatomic,strong) UITableView * tableview;

/** 银行卡显示数据数组  */
@property (nonatomic,strong) NSMutableArray * cellDataArray;

/** 用户基本信息 */
@property (nonatomic,strong) WHBaseInfoModel * baseInfoModel;

/** 筛选银行卡视图  */
@property (nonatomic, strong) HDBankChooseView * bankChooseView;

/** 筛选卡标识 */
@property (nonatomic, strong) NSString * channel;

/** 底部提示内容用按钮代替 */
@property (nonatomic, strong) UIButton * bottomButton;

/** 还款卡无卡提示 */
@property (nonatomic, strong) UILabel * noHuankuanLabel;

@end

@implementation LDtest2222ViewController



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self sendRequestHaveCard];
}

/** 控制器销毁时打印 */
- (void)dealloc{
    
    LDLog(@"销毁银行卡列表控制器");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的银行卡";
    
    self.view.backgroundColor  = LDBackroundColor;

    self.channel = @"0";
    
    /** 1.获取银行卡请求 */
    //[self sendRequestHaveCard];
    
    /** 2.创建选择银行卡 */
    [self createChooseBankView];
    
    /** 3.创建tableView */
    [self createTabelView];

    /** 4.创建底部银行卡提示 */
    [self createBottom];
   
}

/** 创建提示  */
- (void)createBottom{

    float buttonX = 0.0;
    
    if (Is_Iphone5 || Is_Iphone4) {
        buttonX = 50*bili;
    }
    else{
        buttonX = 60*bili;
    }
    
    self.bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(50*bili, LDScreenHeight - 64 - 50*bili, LDScreenWidth - 100*bili, 30*bili)];
    [self.bottomButton setImage:[UIImage imageNamed:@"check_yiwen"] forState:UIControlStateNormal];
    self.bottomButton.titleLabel.numberOfLines = 2;
    
    [self.bottomButton setTitle:@" 如需更换银行卡，请您和业务员联系或\n 拨打我们的客服热线010-400 963 6639" forState:UIControlStateNormal];
    [self.bottomButton setTitleColor:WHColorFromRGB(0x9fa8b7) forState:UIControlStateNormal];
    self.bottomButton.titleLabel.font = [UIFont systemFontOfSize:13*bili];
    [self.view addSubview:self.bottomButton];
}


/** 创建右侧按钮  */
- (void)createRightNavButton{
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [leftButton setTitle:@"···" forState:UIControlStateNormal];
    
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:30*bili];
    
    [leftButton addTarget:self action:@selector(clickNavLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setTitleColor:WHColorFromRGB(0x323232) forState:UIControlStateNormal];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftItem, nil];
    
}
- (void)clickNavLeftButton:(UIButton *)sender{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"银行卡提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    if (self.cellDataArray.count == 1) {
        [alertVC addAction:[UIAlertAction actionWithTitle:@"解绑银行卡" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定解绑银行卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            
        }]];
    }
    
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"添加银行卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        if (self.baseInfoModel.idName != nil && self.baseInfoModel.idNo != nil) {
//            LDBankCardViewController * bankCard = [[LDBankCardViewController alloc] init];
//            bankCard.baseInfo = self.baseInfoModel;
//            bankCard.fromBankCard = @"银行卡列表";
//            [bankCard setGobackBlock:^{
//                //发送网络请求
//               // [self sendRequestHaveCard];
//            }];
//            
//            [self.navigationController pushViewController:bankCard animated:YES];
//        }
//        else{
//            
//            [self showFailViewWithString:@"先实名验证后才可绑定银行卡哦"];
//        }
       // [self sendRegisterGetNHAccessTokenRequest];
    }]];
    
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/** 确定删除银行卡选择 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteBankCard];
    }
    
}

/** 删除银行卡请求 */
- (void)deleteBankCard{

    [self showWithImageWithString:@"请稍后"];
    
    NSString * url = [NSString stringWithFormat:@"%@person/bankcard/remove",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    LDHaveCardListModel * model = self.cellDataArray[0];
    [params setObject:model.id forKey:@"cardId"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        
        if(error != nil){
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [HDLoading showFailViewWithString:@"网络错误"];
            
            
        }else{
            
            
            NSLog(@"=================%@",response);
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                
                [self showSuccessViewWithString:@"删除成功"];
                
                /** 删除模型*/
                [self.cellDataArray removeAllObjects];
                
                /** 刷新列表 */
                [self.tableview reloadData];
                
                self.navigationItem.rightBarButtonItems = nil;
  
            }else if ([backInfor.code isEqualToString:@"-3"]){
                
                [self showFailViewWithString:@"该银行卡已绑定还款不可删除"];
                
            }else{
                
                [self showFailViewWithString:backInfor.message];
                
            }
        }
    }];

}


/** 创建选择银行卡试图 */
- (void)createChooseBankView{

    self.bankChooseView = [[HDBankChooseView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 50*bili)];
    [self.bankChooseView createSubView];
    
    [self.view addSubview:self.bankChooseView];

    [self.bankChooseView.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bankChooseView.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickRightButton:(UIButton *)sender{
    self.navigationItem.rightBarButtonItems = nil;
    
    self.channel = @"1";

    [self sendRequestHaveCard];
}
- (void)clickLeftButton:(UIButton *)sender{
    self.channel = @"0";
    
    [self sendRequestHaveCard];

}

/** 创建tableView **/
- (void)createTabelView{

    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 50*bili, LDScreenWidth, LDScreenHeight - 64 - 50*bili)];
    [self.view addSubview:self.tableview];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = LDBackroundColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200*bili;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 30*bili;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.cellDataArray.count > 0 && [self.channel isEqualToString:@"0"]) {
        self.bottomButton.hidden = NO;
    }
    else{
        self.bottomButton.hidden = YES;
    }
    
    
    
    if ([self.channel isEqualToString:@"1"] || self.cellDataArray.count > 0) {
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(60*bili, 0, LDScreenWidth - 120*bili, 40*bili)];
        if (Is_Iphone5) {
            view.frame = CGRectMake(50*bili, 0, LDScreenWidth - 100*bili, 40*bili);
        }
        view.backgroundColor = [UIColor clearColor];
        
        return view;
    }
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(60*bili, 0, LDScreenWidth - 120*bili, 40*bili)];
    if (Is_Iphone5) {
        view.frame = CGRectMake(50*bili, 0, LDScreenWidth - 100*bili, 40*bili);
    }
    view.backgroundColor = [UIColor clearColor];
    UIButton * checkOrderButton = [[UIButton alloc]initWithFrame:view.frame];
    [checkOrderButton setImage:[UIImage imageNamed:@"check_yiwen"] forState:UIControlStateNormal];
    checkOrderButton.titleLabel.numberOfLines = 2;
    
    [checkOrderButton setTitle:@" 先实名验证后才可绑定银行卡哦" forState:UIControlStateNormal];
    
    
    
    
    [checkOrderButton setTitleColor:WHColorFromRGB(0x9fa8b7) forState:UIControlStateNormal];
    checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:13*bili];
    [view addSubview:checkOrderButton];
    return view;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    if (self.cellDataArray.count == 0 && [self.channel isEqualToString:@"0"]) {
        return 1;
    }
    else{
        return self.cellDataArray.count;
    }
    
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellDataArray.count > 0) {
        LDHaveCardListModel * model = self.cellDataArray[indexPath.row];
        
        LDBankCardViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[LDBankCardViewCell alloc] init];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bankName.text = model.bank;
        cell.bankNumber.text = model.cardtailno;
        cell.bankType.text = model.type;
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else{
    
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell== nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView * addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20*bili, 17*bili, LDScreenWidth - 39*bili, 166*bili)];
            addImageView.image = [UIImage imageNamed:@"addbackcard"];
            [cell addSubview:addImageView];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 125*bili, LDScreenWidth, 18*bili)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = WHColorFromRGB(0x9fa8b7);
            label.text = @"添加银行卡";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13*bili];
            [cell addSubview:label];
   
        }
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellDataArray.count == 0) {
        
        
        if (self.baseInfoModel.idName != nil && self.baseInfoModel.idNo != nil) {
            [self sendRegisterGetNHAccessTokenRequest ];
        }
        else{
            [self showFailViewWithString:@"先实名验证后才可绑定银行卡哦"];
            
            LDPostIDCard * postIdCard = [[LDPostIDCard alloc]init];
            postIdCard.fromeWhere = @"addBankCard";
            postIdCard.requestImage = NO;
            [self.navigationController pushViewController:postIdCard animated:YES];
            
            
        }
        
    }
}

/**
 *  获取银行卡信息
 */
- (void)sendRequestHaveCard{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * url = [NSString stringWithFormat:@"%@person/bankcard/list",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    [params setObject:self.channel forKey:@"channel"];
    
    
    __block  typeof(self) blockSelf = self;
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
                         /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
        }else{
           
            NSLog(@"%@",response);
            
            
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 请求基本信息 */
                if (self.baseInfoModel.idName == nil || self.baseInfoModel.idNo == nil) {
                    [self requestBasicMessageRequest];
                }
                else{
                    [self dismissHDLoading];
                }
                
                
                /** 4.解析银行卡信息 */
                if (backInfo.result != nil){
                    
                    HDBankResult * bankResult = [HDBankResult mj_objectWithKeyValues:backInfo.result];

                    self.cellDataArray = [LDHaveCardListModel mj_objectArrayWithKeyValuesArray:bankResult.list];
                    

                    [self showHiddenNoHuankuanLabel];
                    
                    
                    /** 重置frame */
                    if (self.cellDataArray.count > 2) {
                        self.tableview.scrollEnabled = YES;
                    }
                    else{
                        self.tableview.scrollEnabled = NO;
                    }
                    
                    /** 重新计算tableView高度 */
                    if (self.cellDataArray.count == 0) {
                        self.tableview.frame = CGRectMake(0, 50*bili, LDScreenWidth, 230*bili);
                        
                       
                    }
                    else{
                        if (self.cellDataArray.count > 0 && [self.channel isEqualToString:@"0"]){
                            /** 3.创建右侧按钮 */
                            [self createRightNavButton];
                        }
                        else{
                        
                            //self.navigationItem.rightBarButtonItems = nil;
                        }
                        
                        [self dismissHDLoading];
                        
                        if (self.cellDataArray.count*200*bili+30*bili < LDScreenHeight - 64 - 50*bili - 50*bili) {
                            self.tableview.frame = CGRectMake(0, 50*bili, LDScreenWidth, self.cellDataArray.count*200*bili+30*bili);
                        }
                        else{
                            self.tableview.frame = CGRectMake(0, 50*bili, LDScreenWidth, LDScreenHeight - 64 - 50*bili - 50*bili);
                        }
                    }
                    [self.tableview reloadData];
                }
            
            }else{
            
                [self showFailViewWithString:backInfo.message];
            }
        }
    }];
}

- (void)showHiddenNoHuankuanLabel{

    /** 无还款卡提示 */
    if ([self.channel isEqualToString:@"1"] && self.cellDataArray.count == 0) {
        
        if (!_noHuankuanLabel) {
            _noHuankuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*bili,  50*bili, LDScreenWidth - 60*bili, 100*bili)];
            _noHuankuanLabel.backgroundColor = [UIColor clearColor];
            
            _noHuankuanLabel.textColor = WHColorFromRGB(0x4279d6);
            
            _noHuankuanLabel.text = @"主动还款时添加还款卡，此处暂不支持添加";
            
            _noHuankuanLabel.textAlignment = NSTextAlignmentCenter;
            
            _noHuankuanLabel.font = [UIFont systemFontOfSize:15];
        }
        
       
        
        [self.view addSubview:self.noHuankuanLabel];
    }
    else{
        [self.noHuankuanLabel removeFromSuperview];
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
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** 4.code == 0请求成功  */
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUD];
                
                /** 5.解析基本信息 */
                if (backInfo.result != nil){
                    
                    self.baseInfoModel = [WHBaseInfoModel mj_objectWithKeyValues:backInfo.result];
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
 *  获取token
 */
- (void)sendRegisterGetNHAccessTokenRequest{
    
    [self showWithImageWithString:@"请稍后"];
    
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
                    
                    [self sendRequestHaveCard];
                }
                else{
                
                    HDBaseInfoNextVC * nextVC = [[HDBaseInfoNextVC alloc]init
                                                 ];
                    nextVC.accessToken = accessToken;
                    nextVC.userName = self.baseInfoModel.idName;
                    nextVC.userNo = self.baseInfoModel.idNo;
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

@end
