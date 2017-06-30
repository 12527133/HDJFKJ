//
//  LDThirdViewController.m
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDThirdViewController.h"
#import "WHPayBackTopView.h"
#import "WHPayBackChooseView.h"
#import "WHPayBackCell.h"
#import "WHPayBackModel.h"
#import "WHChekListController.h"

#import "LDSignInViewController.h"
#import "HDPayBackCommodity.h"
#import "LDNavgationVController.h"
#import "HDPayBackMiddleView.h"
/** 请求账单模型*/
#import "HDOrderRepays.h"

@interface LDThirdViewController ()<UITableViewDataSource,UITableViewDelegate>
//顶部还款提示试图
@property (nonatomic, strong) WHPayBackTopView * topView;
/** 中间试图 */
@property (nonatomic, strong) HDPayBackMiddleView * middleView;
//还款状态选择视图
@property (nonatomic, strong) WHPayBackChooseView * chooseView;
//还款信息列表
@property (nonatomic, strong) UITableView * payBackTableView;
//账单状态TableView
@property (nonatomic, strong) UITableView * checkStatusTableView;
//还款状态：1:七日应还款   2:已结清   3:未到期  不传请求全部
@property (nonatomic, strong) NSString * payBackStatus;
/** 账单状态数组 */
@property (nonatomic, strong) NSArray * statusArray;
//订单模型数组
@property (nonatomic, strong) NSMutableArray * orderListArray;
//没有数据的试图
@property (nonatomic, strong) UIView * nullDataView;
//无账单提示内容
@property (nonatomic, strong) UILabel * nullDataLabel;
//无账单提示label
@property (nonatomic, strong) UILabel * bottomLabel;
//登录按钮
@property (nonatomic, strong) UIButton * loginButton;
/** 是否有请求过数据 */
@property (nonatomic, assign) BOOL isHaveRequest;
/** 付给在账单tableView 上的试图 */
@property (nonatomic, strong) UIView * payBackCoverView;
/** 当前选中的账单状态的Label */
@property (nonatomic, strong) UILabel * statuslabel;

/** 账单数据 */
@property (nonatomic, strong) HDOrderRepays * orderRepays;

@end

@implementation LDThirdViewController

- (NSMutableArray *)orderListArray{
    if (!_orderListArray) {
        _orderListArray = [[NSMutableArray alloc]init];
    }
    return _orderListArray;
}
- (UIView *)payBackCoverView{
    if (!_payBackCoverView) {
        _payBackCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _payBackTableView.frame.size.width, _payBackTableView.frame.size.height)];
        _payBackCoverView.backgroundColor = LDRGBColor(0, 0, 0, 0.5);
    }
    return _payBackCoverView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    /** 设置二级界面导航栏背景色为白色 */
    [self setNavgationBackgroundWight];
    
    /** 非一级界面添加侧滑功能 */
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (self.navigationController.childViewControllers.count == 1) {
        /** 一级界面取消侧滑返回  */
        if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                
            }
        }
    }
}
- (void)setNavgationBackground{
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /** 设置导航栏字体为白色 */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    /** 设置导航背景图 */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    
    /** 是否显示下划线 */
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    /** 设置导航栏背景 */
    [self setNavgationBackground];
    
    
    if ([LDUserInformation sharedInstance].UserId != nil && [LDUserInformation sharedInstance].token != nil) {
        
        
        
        self.nullDataLabel.text = @"暂无账单";
        self.loginButton.userInteractionEnabled = NO;
        self.bottomLabel.text = @"";
        
        
        self.isHaveRequest = YES;
        [self sendRequest];
        [self sendBillListRequest];
    }
    
}

- (void)dealloc{

    LDLog(@"销毁账单以及控制器 ");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"账单";
    self.payBackStatus = @"1";
    
    self.isHaveRequest = NO;
    
    self.view.backgroundColor = LDBackroundColor;
    
    /** 作为二级界面时创建返回按钮 */
    if (self.navigationController.childViewControllers.count > 1) {
        /** 创建左侧导航返回按钮  */
        [self createLeftNavButton];
    }
    
   
    
    
    //3.还款列表
    [self createPayBackTableView];
    
    //4.创建无数据试图
    [self createNullDataView];
    /** 创建账单状态试图 */
    [self createCheckStatusTableView];
    
    /** 1.顶部的还款提示视图*/
    [self createTopView];
    
    /** 2.创建中间试图 */
    [self createMiddelView];
    
    /** 3.还款状态选择视图 */
    [self createChooseView];

    
    
    if ([LDUserInformation sharedInstance].token == nil || [LDUserInformation sharedInstance].UserId == nil) {
        self.nullDataView.hidden = NO;
        self.nullDataLabel.text = @"您还未登录";
        self.loginButton.userInteractionEnabled = YES;
        self.bottomLabel.text = @"点击登录获取数据";
        
    }else{
        
        self.isHaveRequest = YES;
        
        [self sendRequest];
        [self sendBillListRequest];
    }
    
}
/** 创建导航栏左侧按钮 */
- (void)createLeftNavButton{
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [leftButton setImage:[UIImage imageNamed:@"nav_back_3.0"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(clickNavLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftItem, nil];
    
}
- (void)clickNavLeftButton:(UIButton *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/** 1.创建顶部还款提示试图 */
- (void)createTopView{
    
    self.topView = [[WHPayBackTopView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 140*bili)];
    [self.view addSubview:self.topView];
    [self.topView createSubViews];
}

/** 2.创建中间显示结清，未结清的试图 */
- (void)createMiddelView{

    self.middleView = [[HDPayBackMiddleView alloc]initWithFrame:CGRectMake(0, 140*bili, LDScreenWidth, 95*bili)];
    [self.view addSubview:self.middleView];
    [self.middleView createSubViews];

}

/** 3.创建选择还款状态视图 */
- (void)createChooseView{

    self.chooseView  = [[WHPayBackChooseView alloc]initWithFrame:CGRectMake(0,  self.topView.frame.size.height + self.middleView.frame.size.height, LDScreenWidth, 50*bili)];
    [self.view addSubview:self.chooseView];
    [self.chooseView createSubViews];
    
    [self.chooseView.rightButton addTarget:self action:@selector(clickChooseViewRightButton:) forControlEvents:UIControlEventTouchUpInside];
}
/** 3.2.点击选择账单状态  */
- (void)clickChooseViewRightButton:(UIButton *)sender{
    
    /** 切换按钮选中状态 */
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.payBackTableView addSubview:self.payBackCoverView];
        
        /** 推出选择账单状态试图 */
        [UIView animateWithDuration:0.3f animations:^{
            
            self.checkStatusTableView.frame = CGRectMake(0, 285*bili, self.checkStatusTableView.frame.size.width, self.checkStatusTableView.frame.size.height);
            self.payBackTableView.frame = CGRectMake(0, 285*bili+self.checkStatusTableView.frame.size.height, self.payBackTableView.frame.size.width, self.payBackTableView.frame.size.height);
            
            self.chooseView.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            
        } completion:^(BOOL finished) {
            self.payBackTableView.scrollEnabled = NO;
        }];
        
    }
    else{
        
        
        /** 推出选择账单状态试图 */
        [UIView animateWithDuration:0.3f animations:^{
            
            self.checkStatusTableView.frame = CGRectMake(0, 285*bili - 180*bili, self.checkStatusTableView.frame.size.width, self.checkStatusTableView.frame.size.height);
            self.payBackTableView.frame = CGRectMake(0, 285*bili, self.payBackTableView.frame.size.width, self.payBackTableView.frame.size.height);
            
             self.chooseView.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            
            self.payBackTableView.scrollEnabled = YES;
            
             [self.payBackCoverView removeFromSuperview];
            
        }];
        
    }
}

/** 4.创建还款列表 */
- (void)createPayBackTableView{
    self.payBackTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 285*bili , LDScreenWidth, self.view.frame.size.height - (285*bili + 60))];
    self.payBackTableView.tag = 1;
    self.payBackTableView.backgroundColor = LDBackroundColor;
    self.payBackTableView.delegate = self;
    self.payBackTableView.dataSource = self;
    self.payBackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.payBackTableView];

    
}

/** 5.创建账单选择tableView */
- (void)createCheckStatusTableView{

    self.statusArray = @[@"全部",@"近7日应还款",@"已结清",@"未到期"];
    
    self.checkStatusTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 285*bili - 180 *bili, LDScreenWidth, 180*bili)];
    self.checkStatusTableView.tag = 2;
    self.checkStatusTableView.backgroundColor = [UIColor whiteColor];
    self.checkStatusTableView.delegate = self;
    self.checkStatusTableView.dataSource = self;
    self.checkStatusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.checkStatusTableView];

}

/** 创建无账单的试图 */
- (void)createNullDataView{
    self.nullDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 285*bili , self.view.frame.size.width, self.payBackTableView.frame.size.height)];
    
    self.nullDataView.backgroundColor = WHColorFromRGB(0xf5f5f9);

    
    UIImageView * nullImageView = [[UIImageView alloc]initWithFrame:CGRectMake((LDScreenWidth-80)/2, (self.nullDataView.frame.size.height - 80)/2-57, 80, 80)];
    NSLog(@"%f",nullImageView.frame.origin.y);
    nullImageView.image = [UIImage imageNamed:@"firstpage_noLogin"];
    [self.nullDataView addSubview:nullImageView];
    self.nullDataView.hidden = YES;
    
    self.nullDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nullImageView.frame.origin.y + 80 + 16, LDScreenWidth, 17)];
    self.nullDataLabel.text = @"暂无账单";
    self.nullDataLabel.font = [UIFont systemFontOfSize:13];
    self.nullDataLabel.textAlignment = NSTextAlignmentCenter;
    self.nullDataLabel.textColor = WHColorFromRGB(0x051b28);
    [self.nullDataView addSubview:self.nullDataLabel];
    
    self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nullImageView.frame.origin.y + 80 + 16 + 17 +15, LDScreenWidth, 13)];
    self.bottomLabel.text = @"";
    self.bottomLabel.font = [UIFont systemFontOfSize:13];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.textColor = WHColorFromRGB(0xc8c7cc);
    [self.nullDataView addSubview:self.bottomLabel];
    
    [self.view addSubview:self.nullDataView];
    
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake((LDScreenWidth-80)/2, (self.nullDataView.frame.size.height - 80- 57)/2, 80,137)];
    [self.loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.nullDataView addSubview:self.loginButton];
    self.loginButton.userInteractionEnabled = NO;
}
- (void)clickLoginButton{
    LDSignInViewController * loginVC = [[LDSignInViewController alloc]init];
    
    LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:loginVC];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    

}

#pragma mark ---  tableVIew的协议方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return tableView.tag == 1 ? self.orderListArray.count : self.statusArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return tableView.tag == 1 ? 80*bili : 45*bili;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        WHPayBackCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[WHPayBackCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            [cell createSubViews];
            /** 创建横线Label */
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*bili - 0.5, LDScreenWidth, 0.5)];
            lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
            [cell addSubview:lineLabel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /** cell 赋值 */
        WHPayBackModel * payBack = self.orderListArray[indexPath.row];
        /** 到期日期 */
        cell.checkTimeLabel.text = [NSString stringWithFormat:@"最后还款日：%@",payBack.dueDate];
        /** 期数 */
        cell.periodCountLabel.text = [NSString stringWithFormat:@"第%@/%@期",payBack.period,self.orderRepays.duration];
        /** 期供金额 */
        cell.periodPriceLabel.text = [NSString stringWithFormat:@"%.2f",[payBack.periodAmt floatValue]];
        if ([payBack.status integerValue] == 0) {
            cell.yuqiLabel.text = @"已结清";
            cell.yuqiLabel.textColor = WHColorFromRGB(0x292929);
        }
        if ([payBack.status integerValue] == 1) {
            cell.yuqiLabel.text = @"待还款";
            cell.yuqiLabel.textColor = WHColorFromRGB(0x9fa8b7);
        }
        if ([payBack.status integerValue] == -1) {
            cell.yuqiLabel.text = @"逾期";
            cell.yuqiLabel.textColor = WHColorFromRGB(0xc75e5f);
            
        }
        if ([payBack.status integerValue] == 2) {
        
            cell.yuqiLabel.textColor = WHColorFromRGB(0x9fa8b7);
            cell.yuqiLabel.text = @"未到期";
        }
        
        
        
        
        
        return cell;
    }
    else{
    
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            
            /** 创建横线Label */
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*bili - 0.5, LDScreenWidth, 0.5)];
            lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
            [cell addSubview:lineLabel];
            
            /** 创建承载内容的Label*/
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45*bili)];
            label.text = self.statusArray[indexPath.row];
            label.textColor = WHColorFromRGB(0x070707);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14*bili];
            [cell addSubview:label];
            
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                label.textColor = WHColorFromRGB(0x4279d6);
                self.statuslabel = label;
            }
        }
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag == 1) {

        /** 获取账单详情，推出订单详情界面 */
         WHPayBackModel * payBack = self.orderListArray[indexPath.row];
        [self sendBillDetailRequest:payBack];
       

    }
    else{
    
        self.statuslabel.textColor = WHColorFromRGB(0x070707);
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        self.statuslabel = [cell.subviews lastObject];
        self.statuslabel.textColor = WHColorFromRGB(0x4279d6);
        
        self.chooseView.statusLabel.text = self.statusArray[indexPath.row];
    
        self.payBackStatus = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        
        [self clickChooseViewRightButton:self.chooseView.rightButton];
        
        
        if ([LDUserInformation sharedInstance].token != nil && [LDUserInformation sharedInstance].UserId != nil) {
            [self sendBillListRequest];
        }
  
    }
    
}


/** 获取账单金额Label */
- (void)sendRequest{
    
//    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@order/billInfo",KBaseUrl ];
    
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
            

            
            LDLog(@"billInfo == %@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 4.解析账单 */
                HDOrderRepays * checRepays = [HDOrderRepays mj_objectWithKeyValues:backInfo.result];
               
                [self setValueForSubViews:checRepays];
                
            }else{
            
            }
     
        }
    }];
}
/** 给控件赋值  */
- (void)setValueForSubViews:(HDOrderRepays *)checRepays{

    /** 近七日 待还 */
    self.topView.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",[checRepays.sevenAmount floatValue]];

    /**  已结清总额 */
    self.middleView.leftBottomLabel.text = [NSString stringWithFormat:@"%.2f",[checRepays.settledAmount floatValue]];
    
    /** 未到期总额 */
    self.middleView.rightBottomLabel.text = [NSString stringWithFormat:@"%.2f",[checRepays.unDueAmount floatValue]];
}

/** 获取账单列表 */
- (void)sendBillListRequest{
    
    if (self.isHaveRequest == NO) {
        [self showWithImageWithString:@"正在加载"];
    }

    NSString * str = [NSString stringWithFormat:@"%@order/billList",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    if (![self.payBackStatus isEqualToString:@"0"]){
        [params setObject:self.payBackStatus forKey:@"status"];
    }
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            self.nullDataView.hidden = NO;
            
        }else{
            
            [self dismissHDLoading];
            
            LDLog(@"billList == %@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 4.解析账单 */
               self.orderRepays = [HDOrderRepays mj_objectWithKeyValues:backInfo.result];
                
               
                
                self.orderListArray = [WHPayBackModel mj_objectArrayWithKeyValuesArray:self.orderRepays.list];
                
                
                //如果账单数量大于0，隐藏无账单试图
                if (self.orderListArray.count > 0) {
                
                    self.nullDataView.hidden = YES;
                    [self.payBackTableView reloadData];
                
                }
                //如果
                else{
                
                
                    self.nullDataView.hidden = NO;
                }
                
            }else{
                
                self.nullDataView.hidden = NO;
                
            }
            
        }
    }];
}


/** 获取账单详情 */
- (void)sendBillDetailRequest:(WHPayBackModel *)payBack{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@order/billDetail",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [params setObject:payBack.loanNo forKey:@"loanNo"];//账单Id
    [params setObject:payBack.period forKey:@"period"];//当前期数
    [params setObject:self.orderRepays.orderNo forKey:@"orderNo"];//贷款id
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            
            
            LDLog(@"%@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                /** 4.解析账单 */
                WHCheckModel * checkModel = [WHCheckModel mj_objectWithKeyValues:backInfo.result];
                
                WHChekListController * checkController = [[WHChekListController alloc]init];
                checkController.orderID = self.orderRepays.orderNo;
                checkController.checkModel = checkModel;
                [self.navigationController pushViewController:checkController animated:YES];
                
 
            }else{
            
                [self showFailViewWithString:backInfo.message];
            }
            
        }
    }];
}






@end
