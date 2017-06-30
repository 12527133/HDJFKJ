

#import "WHChekListController.h"
#import "WHCheckTopView.h"
#import "HDCheckDetailCell.h"
#import "WHCheckListModel.h"
#import "HDPayBackCommodity.h"
#import "HDCheckOrderController.h"

#import "LDNewOrderDetailModel.h"
#import "LDOrderDetailModel.h"


@interface WHChekListController ()<UITableViewDataSource,UITableViewDelegate>
//订单详情试图
@property (nonatomic, strong) WHCheckTopView * topView;
//订单列表试图
@property (nonatomic, strong) UITableView * checkListTableView;
//还款详情列表数组
@property (nonatomic, strong) NSMutableArray * checkListArray;


@property (nonatomic, strong) NSArray * sectionFirstLeftArray;
@property (nonatomic, strong) NSArray * sectionFirstRightArray;

@property (nonatomic, strong) NSArray * sectionSectionLeftArray;
@property (nonatomic, strong) NSArray * sectionSectionRightArray;

@property (nonatomic, strong) NSArray * sectionThreeLetfArray;
@property (nonatomic, strong) NSArray * sectionThreeRightArray;

@end

@implementation WHChekListController

- (NSMutableArray *)checkListArray{
    if (!_checkListArray) {
        _checkListArray = [[NSMutableArray alloc]init];
    }
    return _checkListArray;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //设置导航栏字体为白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏的前景色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    /** 去掉导航栏下面的线 */
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏的前景色为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //设置导航栏字体颜色为黑色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /** 显示导航栏下面的线 */
    self.navigationController.navigationBar.shadowImage = nil;

}
- (void)dealloc{

    LDLog(@"销毁账单详情控制器 ");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单详情";
    self.view.backgroundColor = LDBackroundColor;
    
    //1.创建顶部订单详情试图
    [self createTopView];
    
    //2.创建还款详情列表
    [self createCheckListTableView];
    
    //3.请求数据
    [self createLeftNavButton];
}


//3.创建导航栏左侧按钮
- (void)createLeftNavButton{
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(clickNavLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftItem, nil];
    
}
- (void)clickNavLeftButton:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//1.创建顶部订单详情试图
- (void)createTopView{
    
    self.topView = [[WHCheckTopView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 120*bili)];
    [self.topView createSubViews];
    
    
    self.topView.settledImageView.hidden = YES;
    self.topView.lateFeeLabel.hidden = YES;
    
    [self.topView setSubViewsFrame];
    
    
    [self.view addSubview:self.topView];
    
    
    /** 赋值顶部视图  */
    self.topView.checkDateLabel.text = [NSString stringWithFormat:@"%@应还款(元)",self.checkModel.curDate];
    
    self.topView.checkMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.checkModel.psInstmAmt floatValue]];
    
    [self.topView setSubViewsFrame];
    
}
/** 2.创建还款列表 */
- (void)createCheckListTableView{
    
    /** checkModel.status 1：待还款  0：已还清  -1：逾期*/
    /** 转换订单详情状态 checkStatus  1:逾期，2:结清，3:失败，4:待还款 */
    if ([self.checkModel.status isEqualToString:@"1"]){
    
        /** 待还款 */
        self.checkStatus = 4;
    }
    else if ([self.checkModel.status isEqualToString:@"0"]){
    
        /** 已结清 */
        self.checkStatus = 2;
        
        /** 显示结清图片 */
        self.topView.settledImageView.hidden = NO;
        
    }
    else{
        if ([self.checkModel.lateDays integerValue] > 0){
            
            /** 逾期 */
            self.checkStatus = 1;
            
            /** 显示逾期条 */
            self.topView.lateFeeLabel.hidden = NO;
            self.topView.lateFeeLabel.text = [NSString stringWithFormat:@"（含滞纳金%.2f）",[self.checkModel.lateFee floatValue]];
            
            [self.topView setSubViewsFrame];
        }
        if ([self.checkModel.lateDays integerValue] == 0) {
            
            /** 扣款失败 */
            self.checkStatus = 3;
        }
    
    }
    
    
    
    self.sectionFirstLeftArray = @[@"最后还款日",@"期数",@"交易银行卡"];
    
    /** 第一个section的数据 */
    if (self.checkModel.dueDate == nil) {
        self.checkModel.dueDate = @"  ";
    }
    NSString * qici = @"  ";
    if (self.checkModel.curPeriod != nil && self.checkModel.duration != nil) {
        qici = [NSString stringWithFormat:@"%@/%@",self.checkModel.curPeriod,self.checkModel.duration];
    }
    
    if (self.checkModel.bankCard == nil) {
        self.checkModel.bankCard = @"  ";
    }
    
    self.sectionFirstRightArray = @[self.checkModel.dueDate, qici, self.checkModel.bankCard];
    
    /** 第三个Section的数据 */
    if (self.checkStatus == 2) {
        
//        self.sectionThreeLetfArray = @[@"交易方式",@"交易完成时间",@"交易流水号",@"交易金额",@"还款卡",@"支付方式"];
//        
//        self.sectionThreeRightArray = @[@"主动还款", @"2016-09-12 17:33", @"20161222170822hd002", @"392.40", @"北京银行储蓄卡(6228)", @"京东支付"];
    }
    else{
        self.sectionThreeLetfArray = @[@"逾期天数",@"滞纳金(元)"];
        
        if (self.checkModel.lateDays == nil) {
            self.checkModel.lateDays = @"  ";
        }
        if (self.checkModel.lateFee == nil) {
            self.checkModel.lateFee = @"  ";
        }
        self.sectionThreeRightArray = @[self.checkModel.lateDays, self.checkModel.lateFee];
    
    }
    
   
    
    
    
    
    
    /** 第二个Section的数据 */
    if (self.checkModel.settleDate == nil) {
        self.checkModel.settleDate = @"  ";
    }
    if (self.checkModel.settleStatus == nil) {
        self.checkModel.settleStatus = @"  ";
    }
    if (self.checkModel.failReson == nil) {
        self.checkModel.failReson = @"  ";
    }
    
    self.sectionSectionRightArray = @[self.checkModel.settleDate, self.checkModel.settleStatus, self.checkModel.failReson];
    
    
    
    switch (self.checkStatus) {
        case 2:
            
            self.sectionSectionLeftArray = @[@"交易日期",@"交易状态"];
            break;
            
        default:
            
            self.sectionSectionLeftArray = @[@"交易日期",@"交易状态",@"失败原因"];
            break;
    }
    
    self.checkListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120*bili, LDScreenWidth, LDScreenHeight - 64 - 120*bili)];
    self.checkListTableView.backgroundColor = [UIColor clearColor];
    self.checkListTableView.delegate = self;
    self.checkListTableView.dataSource = self;
    self.checkListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.checkListTableView];
    
    
}

#pragma mark ---  tableVIew的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    switch (self.checkStatus) {
        case 1:
            return 4;
            break;
        case 2:
            return 4;
            break;
            
        case 3:
            return 3;
            break;
        default:
            return 2;
            break;
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /** 1:逾期，2:结清，3:失败，4:待还款 */
    if (section == 0) {
        return self.sectionFirstLeftArray.count;
    }
    else if (section == 1){
        
        if (self.checkStatus == 4) {
            return 1;
        }
        
        return self.sectionSectionLeftArray.count;
        
    }
    else if (section == 2){
    
        if (self.checkStatus == 1 || self.checkStatus == 2) {
            return self.sectionThreeLetfArray.count;
        }
        else{
            return 1;
        }
    }
    else{
    
        return 1;
    }
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45*bili;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return (self.checkStatus == 2 && section == 2 && self.sectionThreeLetfArray.count > 0) ? 40*bili : 10*bili;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (self.checkStatus == 2 && section == 2 && self.sectionThreeLetfArray.count > 0) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 40*bili)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 40*bili)];
        label.text = @"交易信息";
        label.font = [UIFont systemFontOfSize:13*bili];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = WHColorFromRGB(0x8a929d);
        
        [headerView addSubview:label];
        return headerView;
    }
    else{
    
        return nil;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 0) {
        HDCheckDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(cell == nil)
        {
            cell = [[HDCheckDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.size = CGSizeMake(LDScreenWidth, 45*bili);
            [cell createSubViews];
            
        
            
            if (indexPath.row == self.sectionFirstLeftArray.count - 1) {
                /** 创建横线Label */
                UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*bili - 0.5, LDScreenWidth, 0.5)];
                lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                [cell addSubview:lineLabel];
            }
            else{
            
                /** 创建横线Label */
                UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 45*bili - 0.5, LDScreenWidth, 0.5)];
                lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                [cell addSubview:lineLabel];
            }
            
            if (indexPath.row == 0) {
                /** 创建横线Label */
                UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
                lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                [cell addSubview:lineLabel];
            }
            
        }
        cell.leftlabel.text = self.sectionFirstLeftArray[indexPath.row];
        cell.rightLabel.text= self.sectionFirstRightArray[indexPath.row];
        return cell;
        
    }
    else if (indexPath.section == 1){
    
        
        if (self.checkStatus == 4) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                cell.backgroundColor = [UIColor clearColor];
                
                UIButton * checkOrderButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45*bili)];
                [checkOrderButton setImage:[UIImage imageNamed:@"check_yiwen"] forState:UIControlStateNormal];
                [checkOrderButton setTitle:@" 查看订单信息" forState:UIControlStateNormal];
                [checkOrderButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
                [checkOrderButton addTarget:self action:@selector(clickCheckOrder:) forControlEvents:UIControlEventTouchUpInside];
                checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:13*bili];
                
                [cell addSubview:checkOrderButton];
            }
            
            return cell;
        }
        else{
            HDCheckDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if(cell == nil)
            {
                cell = [[HDCheckDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell.size = CGSizeMake(LDScreenWidth, 45*bili);
                
                [cell createSubViews];
                
                
                
                if (indexPath.row == self.sectionSectionLeftArray.count - 1) {
                    /** 创建横线Label */
                    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*bili - 0.5, LDScreenWidth, 0.5)];
                    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                    [cell addSubview:lineLabel];
                }
                else{
                    
                    /** 创建横线Label */
                    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 45*bili - 0.5, LDScreenWidth, 0.5)];
                    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                    [cell addSubview:lineLabel];
                }
                
                if (indexPath.row == 0) {
                    /** 创建横线Label */
                    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
                    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                    [cell addSubview:lineLabel];
                }
            }
            
            cell.leftlabel.text = self.sectionSectionLeftArray[indexPath.row];
            cell.rightLabel.text= self.sectionSectionRightArray[indexPath.row];
            
            return cell;
        
        }
    }
    else if (indexPath.section == 2){
    
        if (self.checkStatus == 1 || self.checkStatus == 2) {
            HDCheckDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if(cell == nil)
            {
                cell = [[HDCheckDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell.size = CGSizeMake(LDScreenWidth, 45*bili);
                
                [cell createSubViews];
                
                
                
                if (indexPath.row == self.sectionSectionLeftArray.count - 1) {
                    /** 创建横线Label */
                    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*bili - 0.5, LDScreenWidth, 0.5)];
                    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                    [cell addSubview:lineLabel];
                }
                else{
                    
                    /** 创建横线Label */
                    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 45*bili - 0.5, LDScreenWidth, 0.5)];
                    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                    [cell addSubview:lineLabel];
                }
                
                if (indexPath.row == 0) {
                    /** 创建横线Label */
                    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0.5)];
                    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
                    [cell addSubview:lineLabel];
                }
            }
            
            cell.leftlabel.text = self.sectionThreeLetfArray[indexPath.row];
            cell.rightLabel.text= self.sectionThreeRightArray[indexPath.row];
            
            return cell;
        }
        else{
        
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                cell.backgroundColor = [UIColor clearColor];
                
                UIButton * checkOrderButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45*bili)];
                [checkOrderButton setImage:[UIImage imageNamed:@"check_yiwen"] forState:UIControlStateNormal];
                [checkOrderButton setTitle:@"查看订单信息" forState:UIControlStateNormal];
                [checkOrderButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
                [checkOrderButton addTarget:self action:@selector(clickCheckOrder:) forControlEvents:UIControlEventTouchUpInside];
                checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:13*bili];
                
                [cell addSubview:checkOrderButton];
            }
            
            return cell;
        
        
        }
        
    }
    
    else{
    
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            cell.backgroundColor = [UIColor clearColor];
            
            UIButton * checkOrderButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45*bili)];
            [checkOrderButton setImage:[UIImage imageNamed:@"check_yiwen"] forState:UIControlStateNormal];
            [checkOrderButton setTitle:@"查看订单信息" forState:UIControlStateNormal];
            [checkOrderButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
            [checkOrderButton addTarget:self action:@selector(clickCheckOrder:) forControlEvents:UIControlEventTouchUpInside];
            checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:13*bili];
            
            [cell addSubview:checkOrderButton];
        }
    
        return cell;
    }
   
    
}

- (void)clickCheckOrder:(UIButton *)sender{
    
    [sender setBackgroundColor:WHColorFromRGB(0xdddddd)];
    
    [self performSelector:@selector(buttonColor:) withObject:sender afterDelay:0.2];
    
    
    [self sendOrderDetetailRequest];
    
}
- (void)buttonColor:(UIButton *)sender{

    [sender setBackgroundColor:[UIColor clearColor]];
}


/** 获取订单详情  */
- (void)sendOrderDetetailRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * url = [NSString stringWithFormat:@"%@order/detail",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.orderID forKey:@"applyId"];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        
        if(error != nil){
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            [self dismissHDLoading];
            
            LDLog(@"%@",response);
            
            /** 3.解析返回结果 */
            
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 4.解析订单详情 */
                if (backInfo.result != nil){
                    
                    /** 解析订单模型 */
                    LDNewOrderDetailModel *OrderDetailModel = [LDNewOrderDetailModel mj_objectWithKeyValues:backInfo.result];
                    
                    HDCheckOrderController * checkOrder = [[HDCheckOrderController alloc]init];
                    checkOrder.orderDetail = OrderDetailModel;
                    [self.navigationController pushViewController:checkOrder animated:YES];
                    
                }
                
            }else{
                
                [self showFailViewWithString:backInfo.message];
            }
            
            
            
        }
    }];
}










@end
