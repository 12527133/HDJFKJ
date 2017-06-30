//
//  LDNewOrderDetailVC.m
//  HDJFKJ
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNewOrderDetailVC.h"
#import "LDNewOrderDetailCell.h"
#import "LDOrderDetailGoodsCell.h"
#import "LDOrderDetailModel.h"
#import "LDNewOrderDetailModel.h"
#import "WHZhiFuTanChuangView.h"
#import "WHCashSuccessController.h"
#import "LDThirdViewController.h"
#import "HDQRCommodity.h"
#import "LDReViewInformation.h"
#import "LDNavgationVController.h"
#import "HDNewOrderThirdCell.h"

#define LDSectionOneCellHeight 135*bili
#define LDOtherSectionCellHeight 80*bili
#define LDRepaymentLableHeight 60*bili
#define LDNavgationBarHeight 0


@interface LDNewOrderDetailVC ()<UITableViewDataSource,UITableViewDelegate>
/** tableView  */
@property (nonatomic,strong) UITableView * tableView;
/** 下单时间  */
@property (nonatomic,strong) UILabel * orderTimeLable;

/** 商品数量  */
@property (nonatomic,strong) UILabel * goodsNumLable;
/** 合计  */
@property (nonatomic,strong) UILabel * goodsSumPrice;
/** 月还款额  */
@property (nonatomic,strong) UILabel * monthPay;
/** 订单状态  */
@property (nonatomic,strong) UILabel * orderStatus;
/**
 *  订单详情模型
 */
@property (nonatomic,strong) LDNewOrderDetailModel * OrderDetailModel;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) BOOL isOpen;
/** button  */
@property (nonatomic,strong) UIButton * ClickButton;
/** smallArray  */
@property (nonatomic,strong) NSArray * smallArray;
/** 商品数量  */
@property (nonatomic,strong) UILabel * goodsNum;

//底部按钮高度
@property (nonatomic, assign) float LDBottomLableHeight ;

/** 打回原因，拒绝原因，取消原因Label*/
@property (nonatomic, strong) UILabel * reasonLabel;

/** 底部视图的背景视图 */
@property (nonatomic, strong) UIView * topBaseView;

@end

@implementation LDNewOrderDetailVC

- (UILabel *) reasonLabel{

    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, LDRepaymentLableHeight,LDScreenWidth - 30, 0)];
        _reasonLabel.textColor = [UIColor whiteColor];
        _reasonLabel.font = [UIFont systemFontOfSize:15*bili];
        _reasonLabel.numberOfLines = 0;
        _reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _reasonLabel;
}

- (NSArray *)smallArray{

    if (!_smallArray) {
        
        _smallArray = [NSArray array];
        
    }
    return _smallArray;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}
- (void)dealloc{

    LDLog(@"销毁订单详情控制器");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.title = @"订单详情";
    
    self.view.backgroundColor = LDBackroundColor;
    
    self.LDBottomLableHeight = 0;
    
    self.isOpen = NO;
    
    [self createLeftNavButton];
    
    
    /** 删除缓存的下单数据 */
    [[HDSubmitOrder shardSubmitOrder] setAttributeNull];
    
    
   
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
- (UIButton *)ClickButton{
    if (!_ClickButton) {
        _ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _ClickButton;
}
/**
 *  set方法  触发 网络请求
 */
-(void)setApplyId:(NSString *)applyId{
    
    _applyId = applyId;//2147483647,2147483647
    
    [self sendOrderDetetailRequest];
}


/**
 *  订单详情网络请求
 */
- (void)sendOrderDetetailRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * url = [NSString stringWithFormat:@"%@order/detail",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.applyId forKey:@"applyId"];
    
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
                    self.OrderDetailModel = [LDNewOrderDetailModel mj_objectWithKeyValues:backInfo.result];
                    
                    if (self.OrderDetailModel.feedback == nil) {
                        self.OrderDetailModel.feedback = @"暂无原因，如有需要请联系客服";
                    }
                    
                    
                    self.reasonLabel.text = [NSString stringWithFormat:@"原因：%@",self.OrderDetailModel.feedback];
                    CGSize size = [self.reasonLabel sizeThatFits:CGSizeMake(self.reasonLabel.frame.size.width, MAXFLOAT)];
                    self.reasonLabel.frame =CGRectMake(self.reasonLabel.frame.origin.x, self.reasonLabel.frame.origin.y, self.reasonLabel.frame.size.width, size.height);
                    
                    
                    
                    /** 解析商品 */
                    self.dataArray = [LDSmallNewOrderDetailModel mj_objectArrayWithKeyValuesArray:self.OrderDetailModel.orderCommoditys];
                    
                    if (self.dataArray.count >2 ) {
                        self.smallArray = @[[self.dataArray objectAtIndex:0],[self.dataArray objectAtIndex:1]];
                    }else{
                        self.smallArray = self.dataArray;
                    }
                    
                    
                    
                    /** 订单状态，时间，原因 视图 */
                    [self setUpTopView];

                }
                
            }else{
                
                [self showFailViewWithString:backInfo.message];
            }
        
            

        }
    }];
}
static NSString * const NewOrderDetailCell = @"NewOrderDetailCell";
static NSString * const OrderDetailCell = @"OrderDetailCell";
static NSString * const OrderThirdCell = @"OrderThirdCell";

/**
 * 订单详情,tableView
 */
- (void)setUpTableView{
    
    self.tableView = [[UITableView alloc] init];
    //WithFrame:CGRectMake(0,self.topBaseView.frame.size.height , LDScreenWidth, LDScreenHeight-64 - self.topBaseView.frame.size.height)];

    
    /* 有以下订单状态，显示底部的按钮，重置tableView的frame，
     * 现金贷订单并且已通过，点击按钮显示北银电子签名界面 (已失效);
     * 已完成，点击按钮查看账单，（贷款已还完）；
     * 还款中，点击按钮查看账单，（贷款在还，未还完）；
     * 已打回，点击按钮到审核新界面，（提交的审核信息有误需要修改重新体检订单）;
     */
    if (([self.OrderDetailModel.status isEqualToString:@"已通过"] && [self.OrderDetailModel.loanType isEqualToString:@"1"]) || [self.OrderDetailModel.status isEqualToString:@"已完成"] || [self.OrderDetailModel.status isEqualToString:@"已打回"] || [self.OrderDetailModel.status isEqualToString:@"还款中"]){
        
        /** 按钮高度 */
        self.LDBottomLableHeight = 50;
        
        
        if([self.OrderDetailModel.status isEqualToString:@"已完成"] ||[self.OrderDetailModel.status isEqualToString:@"还款中"]){
            [self setUpOrderViewWithTitle:@"查看账单"];
            
        }
        else if ([self.OrderDetailModel.status isEqualToString:@"已打回"]){
            [self setUpOrderViewWithTitle:@"修改信息"];
        
        }
        else{
            [self setUpOrderViewWithTitle:@"去支付"];
        }
        
        self.tableView.frame = CGRectMake(0, LDNavgationBarHeight+ self.topBaseView.frame.size.height , LDScreenWidth, LDScreenHeight - 64 - self.topBaseView.frame.size.height - self.LDBottomLableHeight);
        
    }
    else{
        self.tableView.frame = CGRectMake(0, LDNavgationBarHeight+self.topBaseView.frame.size.height , LDScreenWidth, LDScreenHeight-64 - self.topBaseView.frame.size.height);
    }
    
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    //self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDNewOrderDetailCell class]) bundle:nil] forCellReuseIdentifier:NewOrderDetailCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDOrderDetailGoodsCell class]) bundle:nil] forCellReuseIdentifier:OrderDetailCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDNewOrderThirdCell class]) bundle:nil] forCellReuseIdentifier:OrderThirdCell];
}
/**
 *  UITableViewDataSource  UITableViewDelegate
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section == 0 && self.dataArray.count > 2) {
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 0)];
        footerView.backgroundColor = [UIColor whiteColor];
        if (self.dataArray.count > 2) {
            footerView.frame = CGRectMake(0, 0, LDScreenWidth, 40*bili);
        }

        self.goodsNumLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70*bili, 40*bili)];
        
        self.goodsNumLable.font = [UIFont systemFontOfSize:12];
        
        self.goodsNumLable.textColor = WHColorFromRGB(0x6f7179);
        
        NSInteger count = 0;
        
        for (int i = 0;i < self.dataArray.count; i++) {
            
            LDSmallNewOrderDetailModel * model = self.dataArray[i];
            
            count += [model.commodityCount intValue];
        }
        
        //共多少件商品
        self.goodsNumLable.text = [NSString stringWithFormat:@"共%lu件商品",(long)count];
        
        [footerView addSubview:self.goodsNumLable];
    
        
        [self.ClickButton setTitleColor:WHColorFromRGB(0x6f7179) forState:UIControlStateNormal];
        [self.ClickButton setTitleColor:WHColorFromRGB(0x6f7179) forState:UIControlStateSelected];
        
        [self.ClickButton setTitle:@"展开" forState:UIControlStateNormal];
        [self.ClickButton setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
       
        [self.ClickButton setTitle:@"收起" forState:UIControlStateSelected];
        [self.ClickButton setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateSelected];

        self.ClickButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [footerView addSubview:self.ClickButton];
        
        self.ClickButton.frame = CGRectMake(15+70*bili, 0, 60, 40*bili);
        // 交换button中title和image的位置
        self.ClickButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5*bili, 0, -40*bili);
        self.ClickButton.titleEdgeInsets = UIEdgeInsetsMake(0, -35*bili, 0, 0);
        [self.ClickButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        
        self.monthPay = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth - 160, 0, 160, 40*bili)];
        NSString * str1 = [NSString stringWithFormat:@"合计: ￥%.2f",[self.OrderDetailModel.totalPrice floatValue]];
        NSRange rang1 = [str1  rangeOfString:@"合计: "];
        
        NSRange rang2 = [str1 rangeOfString:[NSString stringWithFormat:@"￥%.2f",[self.OrderDetailModel.totalPrice floatValue]]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:str1];
        [str addAttribute:NSForegroundColorAttributeName value:WHColorFromRGB(0x6f7179) range:rang1];
        [str addAttribute:NSForegroundColorAttributeName value:WHColorFromRGB(0xffa811) range:rang2];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:rang1];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rang2];
        self.monthPay.attributedText = str;
        
        CGSize size = [self.monthPay sizeThatFits:CGSizeMake(MAXFLOAT, self.monthPay.frame.size.height)];
        
        
        self.monthPay.frame = CGRectMake(LDScreenWidth - size.width -15, 0, size.width, self.monthPay.frame.size.height);
        self.monthPay.textAlignment = NSTextAlignmentRight;
        [footerView addSubview:self.monthPay];
        
        
        
        return footerView;
    }else{
        return nil;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 0) {
        if (self.dataArray.count > 2) {
            return 40.0 * bili;
        }
        else{
            return 0;
        }
        
    }
    else{
        return 0;
    }
    
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.0;
    }
    else{
        return 10.0*bili;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {

        if (self.isOpen) {
            
            return self.dataArray.count;
        
            
        }else{
        
            
            return self.smallArray.count;
        }
            
        
    }else{
    
        return 1;
    }
    
}
/**
 *  展开 & 收起 触发事件
 */
- (void)buttonClick:(UIButton *)button{
    
    
    button.selected = !button.selected;
    self.isOpen = !self.isOpen;
    
    [UIView transitionWithView: self.tableView duration: 0.35f options: UIViewAnimationOptionTransitionCrossDissolve animations: ^(void){
        [self.tableView reloadData];
        
    }completion: ^(BOOL isFinished){
        
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        
        return LDSectionOneCellHeight;
        
    }else if (indexPath.section == 0){
        
        return LDOtherSectionCellHeight;
        
    }
    else {
        return 128*bili;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 1) {
        
        LDNewOrderDetailCell * cell = [self.tableView dequeueReusableCellWithIdentifier:NewOrderDetailCell];
        
        cell.orderDetailModel = self.OrderDetailModel;
        return cell;
        
        
    }else if(indexPath.section == 0){
    
        LDSmallNewOrderDetailModel * model = self.dataArray[indexPath.row];
        
        LDOrderDetailGoodsCell * cell = [self.tableView dequeueReusableCellWithIdentifier:OrderDetailCell];
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*bili - 0.5, LDScreenWidth, 0.5)];
        label.backgroundColor = WHColorFromRGB(0xdddddd);
        [cell addSubview:label];
        cell.smallDetailModel = model;
        
        return cell;
        
    }else{
        
        HDNewOrderThirdCell * cell = [self.tableView dequeueReusableCellWithIdentifier:OrderThirdCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderDetailModel = self.OrderDetailModel;
        return cell;
    
    }
    
}

/**
 *  底部:打回修改，查看账单按钮；
 */
- (void)setUpOrderViewWithTitle:(NSString *)title{
    UIButton * bottomLable = [UIButton new];
    [bottomLable setBackgroundColor: WHColorFromRGB(0x4279d6)];
    [self.view addSubview:bottomLable];
    
    [bottomLable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomLable setTitle:title forState:UIControlStateNormal];
   
    [bottomLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(self.LDBottomLableHeight);
    }];
    [bottomLable addTarget:self action:@selector(bottomLableClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}
/**
 *  查看账单响应方法
 */
- (void)bottomLableClick:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"修改信息"]) {
        
        
        [[HDSubmitOrder shardSubmitOrder] setBusinessId:self.OrderDetailModel.businessId];
        
        
        //申请价格
        [[HDSubmitOrder shardSubmitOrder] setApplyAmount:self.OrderDetailModel.applyAmount];
        
        //首付款
        [[HDSubmitOrder shardSubmitOrder] setDownpayment:self.OrderDetailModel.downpayment];
        
        //总价
        [[HDSubmitOrder shardSubmitOrder] setTotalAmount:self.OrderDetailModel.totalPrice];
        
        //专案id
        //[[HDSubmitOrder shardSubmitOrder] setCaseId:self.OrderDetailModel.casesId];
        
        /** 分期详情 */
        [[HDSubmitOrder shardSubmitOrder] setCaseDetail:[NSString stringWithFormat:@"¥%@ x %@期",self.OrderDetailModel.periodAmount,self.OrderDetailModel.duration]];

        
        //订单号
        [[HDSubmitOrder shardSubmitOrder] setOrderNo:self.OrderDetailModel.orderNo];
        
        //商品名称
        [[HDSubmitOrder shardSubmitOrder] setGoodsName:[self returnGoodsName]];
        
        
        
        LDReViewInformation * reviewInfo = [[LDReViewInformation alloc]init];
        
        LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:reviewInfo];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
       
        
    }
    if ([sender.titleLabel.text isEqualToString:@"去支付"]) {
        //统计买点
        [WHTongJIRequest sendTongjiRequestWithBusinessId:self.OrderDetailModel.orderNo oprType:QRDDXQ];
        
        
        WHZhiFuTanChuangView * tanchuang = [WHZhiFuTanChuangView view];
        
        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
        
        [appWindow addSubview:tanchuang];
        
        tanchuang.frame = CGRectMake(0, 0, LDScreenWidth, LDScreenHeight);
        
        [tanchuang.sureButton addTarget:self action:@selector(clickTanChuangSureButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([sender.titleLabel.text isEqualToString:@"查看账单"]) {
        LDThirdViewController * checkController = [[LDThirdViewController alloc]init];
        
        //checkController.payBackID = self.OrderDetailModel.orderNo;
        
        [self.navigationController pushViewController:checkController animated:YES];
    }
    
}
/** 返回拼接商品名称  */
- (NSMutableString *)returnGoodsName{
    
    NSMutableString * string = [[NSMutableString alloc]init];
    
    for (LDSmallNewOrderDetailModel * commoditys in self.self.dataArray) {
        
        if (string.length == 0) {
            [string appendString:commoditys.commodityName];
        }
        else{
            [string appendString:@","];
            [string appendString:commoditys.commodityName];
        }
        
    }
    return string;
}


#pragma mark -- 确认支付弹窗的按钮响应方法
- (void)clickTanChuangCancelButton:(UIButton *)sender{
    
    [sender.superview removeFromSuperview];
    
}

- (void)clickTanChuangSureButton:(UIButton *)sender{
    
    [sender.superview removeFromSuperview];
    
    
    WHCashSuccessController * cashSucess = [[WHCashSuccessController alloc]init];
    
    cashSucess.applyId = self.OrderDetailModel.orderNo;
    
    [self.navigationController pushViewController:cashSucess animated:YES];
    
}


/**
 * 订单状态，原因视图，放在视图顶部。
 */
- (void)setUpTopView{
    
    
    /** 顶部视图的北京视图 */
    self.topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDRepaymentLableHeight)];
    
    
    self.topBaseView.backgroundColor =WHColorFromRGB(0x4279d6);
    [self.view addSubview:self.topBaseView];
    
    /** 订单状态Label */
    self.orderStatus = [[UILabel alloc]init];
    self.orderStatus.text = self.OrderDetailModel.status;
    self.orderStatus.textColor = [UIColor whiteColor];
    self.orderStatus.font = [UIFont systemFontOfSize:20*bili];
    [self.topBaseView addSubview:self.orderStatus];
    self.orderStatus.frame = CGRectMake(15, 0, 70*bili, LDRepaymentLableHeight);

    /**订单更新时间  **/
    self.orderTimeLable = [[UILabel alloc]init];
    self.orderTimeLable.font = [UIFont systemFontOfSize:13*bili];
    self.orderTimeLable.textColor = [UIColor whiteColor];
    self.orderTimeLable.text = [NSString stringWithFormat:@"更新时间:%@",self.OrderDetailModel.time];
    self.orderTimeLable.frame = CGRectMake(self.orderStatus.frame.origin.x+self.orderStatus.frame.size.width, 0, 200*bili, LDRepaymentLableHeight);
    [self.topBaseView addSubview:self.orderTimeLable];
    
    /** 订单状态对应原因不为空 增加高度 显示原因 */
    if ([self.OrderDetailModel.status isEqualToString:@"已打回"] || [self.OrderDetailModel.status isEqualToString:@"已取消"] || [self.OrderDetailModel.status isEqualToString:@"已拒绝"]) {
        
        self.topBaseView.frame = CGRectMake(0, 0, LDScreenWidth, LDRepaymentLableHeight+self.reasonLabel.frame.size.height + 10);
    
        [self.topBaseView addSubview:self.reasonLabel];
    }
    
    if (self.reasonLabel.frame.size.height != 0.0) {
        
    }
    
    //订单详情,tableView
    [self setUpTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
