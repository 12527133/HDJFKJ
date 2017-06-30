

#import "HDARZaixianzhifuController.h"
#import "WHCheckTopView.h"
#import "HDARZhifuCell.h"
#import "WHPayBackModel.h"
#import "HDARZhifufangshiView.h"
#import "HDARBankListVIew.h"
#import "WHBaseInfoModel.h"
#import "HDARAddBankCardController.h"
#import "HDArZhifuDetailController.h"
#import "HDARRepayConfirm.h"
@interface HDARZaixianzhifuController ()<UITableViewDelegate,UITableViewDataSource>
/** 顶部视图 */
@property (nonatomic, strong) WHCheckTopView * topView;

/** 详情按钮的箭头 */
@property (nonatomic, strong) UIImageView * arrowImageView;

/** 详情按钮的Label  */
@property (nonatomic, strong) UILabel * statusLabel;

/** 详情按钮  */
@property (nonatomic, strong) UIButton * xiangqingButton;

/** 账单tableView */
@property (nonatomic, strong) UITableView * arTableView;

/** 账单列表 */
@property (nonatomic, strong) NSArray * arListArray;

/** 支付方式视图 */
@property (nonatomic, strong) HDARZhifufangshiView * zhifuFangshi;

/** 下一步按钮 */
@property (nonatomic, strong) UIButton * nextButton;

/** 弹窗背景视图 */
@property (nonatomic, strong) UIView * tangChuangBGView;

/** 银行卡列表弹窗 */
@property (nonatomic, strong) HDARBankListVIew *bankListView;

/** 用户基本信息 */
@property (nonatomic, strong) WHBaseInfoModel * baseInfoModel;
@end

@implementation HDARZaixianzhifuController

/** 销毁主动还款在线支付控制器  */
- (void)dealloc{

    LDLog(@"销毁主动还款在线支付控制器");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付方式";
    self.view.backgroundColor = LDBackroundColor;
    
    /** 1.创建顶部视图 */
    [self createTopView];
    
    /** 2.创建tableView */
    [self createARTableView];
    
    /** 3.创建支付方式视图 */
    [self createZhifuFangshiView];
    
    /** 创建底部按钮 */
    [self createSureButton];
}




/** 1.创建顶部视图 ，这里复用账单二级界面的顶部视图  */
- (void)createTopView{
    
    /** 创建顶部视图 */
    self.topView = [[WHCheckTopView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 120*bili)];
    
    /** 创建顶部视图的子视图 */
    [self.topView createSubViews];
    
    /** 隐藏结清icon，滞纳金Label */
    self.topView.settledImageView.hidden = YES;
    self.topView.lateFeeLabel.hidden = YES;
    
    /** 顶部视图的添加到self.View */
    [self.view addSubview:self.topView];
    
    
    /** 赋值顶部视图  */
    self.topView.checkDateLabel.text = @"近7日应还款(元)";
    
    /** 赋值近7日还款金额 */
    self.topView.checkMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.sevenAmount floatValue]];
    //self.topView.checkMoneyLabel.text = self.sevenAmount;
    
    /** 在topView 上添加按钮 */
    /** 箭头图标 */
    self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 31*bili, 82*bili, 11*bili, 6*bili)];
    self.arrowImageView.image = [UIImage imageNamed:@"xiala_blue"];
    [self.topView addSubview:self.arrowImageView];
    
    /** 账单状态Label */
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth - 136*bili, 74*bili, 100*bili, 21*bili)];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textColor = WHColorFromRGB(0x4279d6);
    self.statusLabel.text = @"详情";
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    self.statusLabel.font = [UIFont systemFontOfSize:15*bili];
    [self.topView addSubview:self.statusLabel];
    
    /** 创建 右侧Button */
    self.xiangqingButton = [[UIButton alloc]initWithFrame:CGRectMake( LDScreenWidth - 136*bili, 60*bili, 136*bili, 50*bili)];
    [self.topView addSubview:self.xiangqingButton];
    [self.xiangqingButton addTarget:self action:@selector(clickChooseViewRightButton:) forControlEvents:UIControlEventTouchUpInside];
}
/** 点击“详情按钮”  */
- (void)clickChooseViewRightButton:(UIButton *)sender{
    
    /** 切换按钮选中状态 */
    sender.selected = !sender.selected;
    
    /** 按钮选中状态 */
    if (sender.selected) {
        
        /** 推出选择账单状态试图 */
        [UIView animateWithDuration:0.3f animations:^{
            
            /** 动画期间按钮不可用 */
            sender.userInteractionEnabled = NO;

            /** 旋转箭头 */
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            
            /** 切换详情标题 */
            self.statusLabel.text = @"收起详情";
            
        } completion:^(BOOL finished) {
            
            /** 动画结束按钮可用 */
            sender.userInteractionEnabled = YES;
            
        }];
        
        /** 刷新tableView */
        [UIView transitionWithView: self.arTableView duration: 0.35f options: UIViewAnimationOptionTransitionCrossDissolve animations: ^(void){
            
            float tableViewY = 0.0;
            if (self.arListArray.count > 3) {
                tableViewY = 2*80*bili;
                self.arTableView.scrollEnabled = YES;
            }
            else{
                tableViewY = self.arListArray.count*80*bili;
                self.arTableView.scrollEnabled = NO;
            }
            
            self.arTableView.frame = CGRectMake(0, 120*bili, LDScreenWidth, tableViewY);
            
            [self.arTableView reloadData];
            
            /** 重置支付方式的Frame*/
            self.zhifuFangshi.frame = CGRectMake(self.zhifuFangshi.frame.origin.x, 120*bili + self.arListArray.count*80*bili, self.zhifuFangshi.frame.size.width, self.zhifuFangshi.frame.size.height);
            
        }completion: ^(BOOL isFinished){
            
        }];
        
    }
    else{

        /** 推出选择账单状态试图 */
        [UIView animateWithDuration:0.3f animations:^{
            
            /** 动画期间按钮不可用 */
            sender.userInteractionEnabled = NO;
            
            /** 旋转箭头 */
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            
            /** 切换详情标题 */
            self.statusLabel.text = @"详情";
            
        } completion:^(BOOL finished) {

            /** 动画结束按钮可用 */
            sender.userInteractionEnabled = YES;
            
        }];
        
        /** 刷新tableView */
        [UIView transitionWithView: self.arTableView duration: 0.35f options: UIViewAnimationOptionTransitionCrossDissolve animations: ^(void){
            
            float tableViewY = 0.0;
            self.arTableView.frame = CGRectMake(0, 120*bili, LDScreenWidth, tableViewY);
            
            [self.arTableView reloadData];
            
            /** 重置支付方式的Frame*/
            self.zhifuFangshi.frame = CGRectMake(self.zhifuFangshi.frame.origin.x, 120*bili, self.zhifuFangshi.frame.size.width, self.zhifuFangshi.frame.size.height);
            
        }completion: ^(BOOL isFinished){
            
        }];
        
    }
}

/** 2.创建账单列表TableView */
- (void)createARTableView{
    
    /** 解析数据 */
    self.arListArray = [WHPayBackModel mj_objectArrayWithKeyValuesArray:self.orderRepays.list];
    
    /** 创建tableView */
    self.arTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120*bili , LDScreenWidth, 0)];
    self.arTableView.tag = 1;
    self.arTableView.backgroundColor = LDBackroundColor;
    self.arTableView.delegate = self;
    self.arTableView.dataSource = self;
    self.arTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.arTableView];
}
#pragma mark ---  tableVIew的协议方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.xiangqingButton.selected ? self.arListArray.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80*bili;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDARZhifuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[HDARZhifuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell createSubViews];
        /** 创建横线Label */
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*bili - 0.5, LDScreenWidth, 0.5)];
        lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
        [cell addSubview:lineLabel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /** cell 赋值 */
    WHPayBackModel * payBack = self.arListArray[indexPath.row];
    
    /** 到期日期 */
    if (payBack.lateFee != nil) {
        cell.lateFreeLabel.text = [NSString stringWithFormat:@"（含滞纳金%@元）",payBack.lateFee];
        cell.lateFreeLabel.hidden = NO;
    }
    else{
        cell.lateFreeLabel.hidden = YES;
    }
    
    /** 期数 */
    cell.periodCountLabel.text = [NSString stringWithFormat:@"第%@/%@期",payBack.period,self.orderRepays.duration];
    /** 期供金额 */
    cell.periodPriceLabel.text = [NSString stringWithFormat:@"%.2f",[payBack.periodAmt floatValue]];
    //cell.periodPriceLabel.text = payBack.periodAmt;
    
    if ([payBack.status integerValue] == 1) {
        cell.yuqiLabel.text = @"待还款";
        cell.yuqiLabel.textColor = WHColorFromRGB(0x9fa8b7);
        //cell.lateFreeLabel.hidden = YES;
    }
    if ([payBack.status integerValue] == -1) {
        cell.yuqiLabel.text = @"逾期";
        cell.yuqiLabel.textColor = WHColorFromRGB(0xc75e5f);
        //cell.lateFreeLabel.hidden = NO;
        
    }
    return cell;
}


/** 创建支付方式视图  */
- (void)createZhifuFangshiView{
    
    self.zhifuFangshi = [[HDARZhifufangshiView alloc]initWithFrame:CGRectMake(0, 120*bili, LDScreenWidth, 95*bili)];
    [self.zhifuFangshi createSubViews];

    [self.view addSubview:self.zhifuFangshi];
}

/** 创建确认按钮  */
- (void)createSureButton{

    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(16*bili, LDScreenHeight - 64 - 70*bili, LDScreenWidth- 32*bili, 50*bili)];
    [self.view addSubview:self.nextButton];
    self.nextButton.backgroundColor = WHColorFromRGB(0x4279d6);
    [self.nextButton setTitle:@"快捷支付" forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 5.0;
    self.nextButton.layer.borderWidth = 0.0;
    [self.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickNextButton:(UIButton *)sender{

    
    [self sendZhifuRequest];
    
    
}


/** 请求支付数据  */
- (void)sendZhifuRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@payment/repayConfirm",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:self.orderRepays.orderNo forKey:@"applyId"];//贷款id
    
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
                
                [self dismissHDLoading];
                
                /** 4.解析账单 */
                HDARRepayConfirm * repayConfirm = [HDARRepayConfirm mj_objectWithKeyValues:backInfo.result];
                
                HDArZhifuDetailController * zhifuDetal = [[HDArZhifuDetailController alloc]init];
                zhifuDetal.repayConfirm = repayConfirm;
                zhifuDetal.orderRepays = self.orderRepays;
                [self.navigationController pushViewController:zhifuDetal animated:YES];
            }else{
                [self showFailViewWithString:backInfo.message];
            }
            
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
