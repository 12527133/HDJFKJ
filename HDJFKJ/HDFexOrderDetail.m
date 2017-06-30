//
//  HDFexOrderDetail.m
//  MerchantEdition
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "HDFexOrderDetail.h"
#import "LDGoodsDetailModel.h"
#import "LDPersonInfor.h"
#import "LDBaseInformationTableViewController.h"
#import "LDContactInformationViewController.h"
#import "WHWorkViewController.h"
#import "LDGoodsIDAndZhuanAnId.h"
#import "AuthorizViewController.h"
#import "WHSendOtherMateriaController.h"
#import "LDSaoMaNewCell.h"
#import "LDClickButtonCell.h"
#import "LDGoodsInfor.h"
#import "HDQRCommodity.h"
#import "LDReViewInformation.h"
#import "LDNavgationVController.h"

/** 是否需要收取运营商模型 */
#import "HDForceAuthFlag.h"

@interface HDFexOrderDetail ()<UITableViewDelegate,UITableViewDataSource>
/** name  */
@property (nonatomic,strong) UITableView * tableView;


//支付密码的b半透明背景
@property (nonatomic,strong) UIView * backgroundView;
//密码框，半窗白色背景图
@property (nonatomic,strong) UIView * passwordBgView;

//展示更多商品
@property (nonatomic, assign) BOOL showMoreGoods;
@property (nonatomic, assign) int goodsCount;
@end

@implementation HDFexOrderDetail

static NSString * const LDClickButton = @"ClickButton";
static NSString * const LDpersonInfor = @"PersonInfor";
static NSString * const LDgoodsInfor = @"GoodsInfor";
static NSString * const LDSaoMaTopCell = @"SaoMaTopCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = LDBackroundColor;
    
    self.title = @"商品详情";
    
    self.showMoreGoods = NO;
    
    [self setupTableView];
    
    //已提交订单不在显示支付按钮
    if (![self.detailModel.status isEqualToString:@"1"] ) {
        [self createButton];
    }
    
    /** 删除缓存的下单数据 */
    [[HDSubmitOrder shardSubmitOrder] setAttributeNull];
}

- (void)createButton{
    
    if (![self.withOutOrder.status isEqualToString:@"1"]) {
        
        UIButton * nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50*LDScreenWidth/375 - 64, LDScreenWidth, 50*LDScreenWidth/375)];
        
        [nextButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
        [nextButton setTitle:@"确认分期" forState:UIControlStateNormal];
        [nextButton setTitleColor:WHColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextButton];
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        LDSaoMaNewCell * cell = [tableView dequeueReusableCellWithIdentifier:LDSaoMaTopCell];
        HDQRCommodity * commodity = self.detailModel.commoditys[indexPath.row];
        
        //商品名称
        cell.commodityCountLabel.text = [NSString stringWithFormat:@"x%@",commodity.commodityCount];
        
        //商品价格
        cell.commodityPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[commodity.commodityPrice floatValue]];
        
        //商品名称
        cell.commodityNameLabel.text = commodity.commodityName;
        
        
        if (indexPath.row != 0) {
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(13, 0, LDScreenWidth -13, 1)];
            lineView.backgroundColor = LDBackroundColor;
            [cell addSubview:lineView];
        }
        
        return cell;

    }else if (indexPath.section == 1){
        
        LDClickButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:LDClickButton];
        [cell.moreButton addTarget:self action:@selector(showMoreGoods:) forControlEvents:UIControlEventTouchUpInside];
        
        if (!self.showMoreGoods) {
            
            cell.arrowImageView.image = [UIImage imageNamed:@"下拉"];
            cell.contentLabel.text = [NSString stringWithFormat:@"共%d件商品,点击查看更多",self.goodsCount];

        }else{
            
            cell.arrowImageView.image = [UIImage imageNamed:@"收起"];
            cell.contentLabel.text = [NSString stringWithFormat:@"共%d件商品,点击收起",self.goodsCount];
            
        }
        
        if (self.detailModel.commoditys.count<3) {
            cell.transform =CGAffineTransformMakeScale(0.0, 0.0);
        }
        
        return cell;

    }else if (indexPath.section == 2){
        
        LDGoodsInfor * cell = [tableView dequeueReusableCellWithIdentifier:LDgoodsInfor];
        
        //总价
        cell.totalPriceLabel.text = [NSString stringWithFormat:@"总价：¥%.2f",[self.detailModel.totalPrice floatValue]];
        
        //首付
        cell.shoufuLabel.text = [NSString stringWithFormat:@"首付金额：¥%.2f",[self.detailModel.downpayment floatValue]];
        
        //期供金额
        cell.fenqiLabel.text = [NSString stringWithFormat:@"分期金额：¥%.2fx%@",[self.detailModel.periodAmount floatValue],self.detailModel.duration];
        
        return cell;

    }else{
        
        LDPersonInfor * cell = [tableView dequeueReusableCellWithIdentifier:LDpersonInfor];
        
        cell.packageIdLabel.text = [NSString stringWithFormat:@"申请编号：%@",self.detailModel.packageId] ;
        
        if (self.detailModel.scanTime != nil) {
            cell.timeLabel.text = [NSString stringWithFormat:@"申请日期：%@",self.detailModel.scanTime];
        }
        else{
            cell.timeLabel.text = [NSString stringWithFormat:@"申请日期：%@",self.detailModel.scanDate];
        }
        
        if (self.detailModel.saleMan != nil) {
            cell.yewuyuanLabel.text = [NSString stringWithFormat:@"业务员：%@",self.detailModel.saleMan];
        }else{
            cell.yewuyuanLabel.text = [NSString stringWithFormat:@"业务员：%@",@"无"];
        }
        
        
        
        
        if (self.detailModel.businessName != nil) {
            cell.businessNameLabel.text =[NSString stringWithFormat:@"商家名称：%@",self.detailModel.businessName] ;
        }else{
            cell.businessNameLabel.text =[NSString stringWithFormat:@"商家名称：%@",self.detailModel.bussinessName] ;
        }
        
        
        
        
        return cell;

    }
}

//展示更多商品
- (void)showMoreGoods:(UIButton *)sender{
    
    self.showMoreGoods = !self.showMoreGoods;
    
    [UIView transitionWithView: self.tableView duration: 0.35f options: UIViewAnimationOptionTransitionCrossDissolve animations: ^(void){
         [self.tableView reloadData];
        
     }completion: ^(BOOL isFinished){
         
     }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.detailModel.commoditys.count > 2 && !self.showMoreGoods) {
            return 2;
        }
        return self.detailModel.commoditys.count;
        
    }else{
    
        return 1;
    
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;

    }else if (indexPath.section == 1){
        if (self.detailModel.commoditys.count <3) {
            return 0;
        }
        
        return 45;

    }else if (indexPath.section == 2){
        
        return 90;
      
    }else{
    
        return 170;
    }
    
    
}
- (void)setupTableView{
    
    self.goodsCount = 0;
    
    if (self.detailModel.commoditys.count > 2) {
        for (HDQRCommodity * commodity in self.detailModel.commoditys) {
            self.goodsCount += [commodity.commodityCount intValue];
        }
    }
    
    
    
    self.tableView =
    [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 50*LDScreenWidth/375 - 64) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDSaoMaNewCell class]) bundle:nil] forCellReuseIdentifier:LDSaoMaTopCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDClickButtonCell class]) bundle:nil] forCellReuseIdentifier:LDClickButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDGoodsInfor class]) bundle:nil] forCellReuseIdentifier:LDgoodsInfor];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDPersonInfor class]) bundle:nil] forCellReuseIdentifier:LDpersonInfor];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    if (section == 2){
        return 10.001;
    }
    else{
        return 0.001;
    }
 
}

- (void)nextButtonClick:(UIButton *)sender{
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:self.detailModel.packageId oprType:ZFSPB];
    
    [self sendRequestBuyNow];
    
   
    
}




/**
 *  网络请求,立即购买,购买验证
 */
- (void)sendRequestBuyNow{
    
    [MBProgressHUD showMessage:@"正在验证"];
    
    
    NSString * url = [NSString stringWithFormat:@"%@order/buyCheck",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].phoneNumber) forKey:@"phoneNo"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                
                /** 设置提交订单需要的数据 */
                [self setShareModelValue];
                
                LDReViewInformation * reView = [[LDReViewInformation alloc] init];
                
                LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:reView];
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
                
            }else if ([backInfor.code intValue] == -100){
                
                //服务器异常
                [MBProgressHUD showError:backInfor.message];
                
                return ;
            }
            else if([backInfor.code intValue] == -3) {
                //有未完结订单,无法购买
                [MBProgressHUD showError:backInfor.message];
                return;
                
            }else if([backInfor.code intValue] == -4) {
                
                //三个月内有被拒绝订单,无法购买.
                [MBProgressHUD showError:backInfor.message];
                return;
                
            }else{
                [MBProgressHUD showError:backInfor.message];
            }
            
        }
    }];
    
}








- (void)setShareModelValue{
    
    if (self.detailModel != nil) {
        
        //商品包id
        [[HDSubmitOrder shardSubmitOrder] setPackageId:self.detailModel.packageId];
        
        //申请价格
        [[HDSubmitOrder shardSubmitOrder] setApplyAmount:self.detailModel.applyAmount];
        
        //首付款
        [[HDSubmitOrder shardSubmitOrder] setDownpayment:self.detailModel.downpayment];
        
        //总价
        [[HDSubmitOrder shardSubmitOrder] setTotalAmount:self.detailModel.totalPrice];
        
        //专案id
        if (self.detailModel.casesId != nil) {
            [[HDSubmitOrder shardSubmitOrder] setCaseId:self.detailModel.casesId];
        }
        else{
            [[HDSubmitOrder shardSubmitOrder] setCaseId:self.detailModel.caseId];
        }
        
        
        //商户id
        if (self.detailModel.businessId != nil) {
            [[HDSubmitOrder shardSubmitOrder] setBusinessId:self.detailModel.businessId];
        }else{
            [[HDSubmitOrder shardSubmitOrder] setBusinessId:self.detailModel.bussinessId];
        }
        /** 分期详情 */
        [[HDSubmitOrder shardSubmitOrder] setCaseDetail:[NSString stringWithFormat:@"¥%@ x %@期",self.detailModel.periodAmount,self.detailModel.duration]];
        
        //商品列表
        [[HDSubmitOrder shardSubmitOrder] setCommoditys:[self returnCommoditys]];
        
        //商品名称
        [[HDSubmitOrder shardSubmitOrder] setGoodsName:[self returnGoodsName]];
        
        
    }
    else{
        [[LDGoodsIDAndZhuanAnId sharedInstance] setId:self.withOutOrder.commodityId];
        
        [[LDGoodsIDAndZhuanAnId sharedInstance] setZhuanAnID:self.withOutOrder.caseId];
        
        [[LDGoodsIDAndZhuanAnId sharedInstance] setBusinessname:self.withOutOrder.bussinessName];
        
        [[LDGoodsIDAndZhuanAnId sharedInstance] setName:self.withOutOrder.commodityName];
        
        [[LDGoodsIDAndZhuanAnId sharedInstance] setBusnessID:self.withOutOrder.bussinessId];
        
    }
    
    
    
}


- (NSMutableString *)returnGoodsName{

    NSMutableString * string = [[NSMutableString alloc]init];
    
    for (HDQRCommodity * commoditys in self.detailModel.commoditys) {
        
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

//返回商品类别
- (NSString *)returnCommoditys{
    
    NSMutableArray * commoditys = [NSMutableArray array];
    
    for (HDQRCommodity * commodity in self.detailModel.commoditys) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setObject:commodity.commodityCount forKey:@"commodityCount"];
        [dict setObject:commodity.commodityId forKey:@"commodityId"];
        
        [commoditys addObject:dict];
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:commoditys options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* sInvalid = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 从服务器收到的类似上一行的数据 // 转换
    NSString*sValid = [sInvalid stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData * data =[sValid dataUsingEncoding:NSUTF8StringEncoding];

    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



@end
