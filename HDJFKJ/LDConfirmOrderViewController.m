//
//  LDConfirmOrderViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/28.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDConfirmOrderViewController.h"
#import "LDConformOrderViewCell.h"
#import "LDMonthPayViewCell.h"
#import "LDGoodsDetailModel.h"
#import "LDHaveCardListModel.h"
#import "LDBaseInformationTableViewController.h"
#import "LDTypeViewController.h"
#import "LDContactInformationViewController.h"
#import "LDJobStudentInforController.h"
#import "LDGoodsIDAndZhuanAnId.h"
#import "LDJobTabbleViewController.h"
#import "LDEntrepreneursTableViewController.h"
#import "LDPostIDCardAdvancedInformation.h"
#import "LDtest2222ViewController.h"
#import "LDBankCardViewController.h"
#import "LDPaymentPasswordController.h"
#import "LDApplyForCreditViewController.h"
@interface LDConfirmOrderViewController ()
@property (nonatomic,strong) NSArray * cellDataArray;

@property (nonatomic,strong) NSArray * cases;

@end

@implementation LDConfirmOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.rowHeight = 90;
//    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    
//    self.tableView.tableHeaderView = [self creatHeaderView];
//    self.tableView.tableFooterView = [self creatFooterView];
//    
//    self.navigationItem.title = @"确认订单";
//    
//    
}

/**
 *  商品ID
 */
-(void)setGoodsID:(NSString *)goodsID{
    
    _goodsID = goodsID;
    
    [self OnceModresendRequest];
}
//网络请求(加载页面数据)
- (void)OnceModresendRequest{
    
    NSString * url = [NSString stringWithFormat:@"%@detail/commodity",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.goodsID forKey:@"id"];
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            LDLog(@"%@",error);
        }else{
            
            
            
            LDLog(@"%@",response);
          
            
            self.cases = [LDGoodsDetailIDModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"cases"]];
            
    
            
        }
    }];
}



- (NSArray *)cellDataArray
{
    if (!_cellDataArray) {
        
        _cellDataArray = [NSArray array];

    }
    
    return _cellDataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabbleView初始化方法,返回Group模式
-(instancetype)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    self.tableView.backgroundColor  =[UIColor whiteColor];

    return self;
}
/**
 *  全部商品  视图高度
 */
- (UIView *)creatHeaderView{
    //section头部view
    UIView * sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 235)];
    //上部imageView
    UIImageView * topImageView = [[UIImageView alloc] init];
    topImageView.image  =[UIImage imageNamed:@"daipingjia"];
    
    [sectionHeaderView addSubview:topImageView];
    
    [topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(sectionHeaderView).offset(LDPadding);
        make.height.equalTo(40);
        make.width.equalTo(40);
    }];
    
    //商户名称
    UILabel * bussnessName = [[UILabel alloc] init];
    [sectionHeaderView addSubview:bussnessName];
    
    //上个界面存储值,
    bussnessName.text = [LDGoodsIDAndZhuanAnId sharedInstance].businessname;
    //[[NSUserDefaults standardUserDefaults] objectForKey:@"bottomGoodsName"];
    
    bussnessName.font = [UIFont systemFontOfSize:17];
    [bussnessName makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(topImageView);
        
        make.left.equalTo(topImageView.right).offset(LDPadding);
        
        make.right.equalTo(sectionHeaderView).offset(LDPadding);
    }];
    
    //箭头imageView
    UIImageView * arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"返回"];
    [sectionHeaderView addSubview:arrowImageView];
    [arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topImageView);
        make.right.equalTo(sectionHeaderView).offset(-LDPadding);
    }];
    
    //商品详情view
    UIView * goodsView = [[UIView alloc] init];

    [sectionHeaderView addSubview:goodsView];
    
    [goodsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.bottom).offset(LDPadding);
        make.left.right.equalTo(sectionHeaderView);
        make.height.equalTo(150);
    }];
    
    //商品详情中的imageView
    UIImageView * goodsLeftImageView = [[UIImageView alloc] init];
    [goodsView addSubview:goodsLeftImageView];
    goodsLeftImageView.image = [UIImage imageNamed:@"header_cry_icon"];
    [goodsLeftImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(goodsView).offset(LDPadding);
        make.width.height.equalTo(130);
    }];
    
    //商品名称lable
    UILabel * goodsNameLable = [UILabel new];
    [goodsView addSubview:goodsNameLable];
//    goodsNameLable.backgroundColor = [UIColor redColor];
    goodsNameLable.text = [LDGoodsIDAndZhuanAnId sharedInstance].name;
    //[[NSUserDefaults standardUserDefaults] objectForKey:@"goodsName"];
    
    goodsNameLable.font = [UIFont systemFontOfSize:17];
    goodsNameLable.numberOfLines = 0;
    [goodsNameLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsLeftImageView.right).offset(LDPadding);
        make.top.equalTo(goodsLeftImageView.top);
        make.right.equalTo(goodsView).offset(-LDPadding);
    }];
    
    
    //分类
    UILabel * classLable = [UILabel new];
    [goodsView addSubview:classLable];
    classLable.font = [UIFont systemFontOfSize:15];
    classLable.alpha = 0.5;
    classLable.text  =@"分类:";
    [classLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsLeftImageView.right).offset(LDPadding);
        make.width.equalTo(40);
        make.top.equalTo(goodsNameLable.bottom).offset(LDPadding);
    }];
    
    //分类内容,
    UILabel * classLableDetail = [UILabel new];
    [goodsView addSubview:classLableDetail];
    classLableDetail.font = [UIFont systemFontOfSize:15];
    classLableDetail.alpha = 0.5;
    
    classLableDetail.text = [LDGoodsIDAndZhuanAnId sharedInstance].category;
    
    
    [classLableDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(classLable.right).offset(LDPadding);
        make.right.equalTo(goodsView.right).offset(-LDPadding);
        make.centerY.equalTo(classLable);
    }];
    
    //总价: 标题lable
    UILabel * sumPrice = [UILabel new];
    [goodsView addSubview:sumPrice];
    sumPrice.text = @"总价:  ￥";
    [sumPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsLeftImageView.right).offset(100);
        make.width.equalTo(70);
        make.bottom.equalTo(goodsLeftImageView.bottom).offset(-10);
    }];
    
    //总价: 标题具体价格lable
    UILabel * sumPriceLable = [UILabel new];
    [goodsView addSubview:sumPriceLable];
    sumPriceLable.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"moneyCount"];
    
    [sumPriceLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sumPrice);
        make.left.equalTo(sumPrice.right);
        make.right.equalTo(goodsView);
        
    }];
    
    
    //间隔view
    UIView * headerLineView = [[UIView alloc] init];
    [sectionHeaderView addSubview:headerLineView];
    headerLineView.backgroundColor = LDBackroundColor;
    headerLineView.alpha = 0.2;
    [headerLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(sectionHeaderView);
        make.height.equalTo(20);
    }];
    
    [self.tableView reloadData];
    
    
    return sectionHeaderView;


}

- (UIView *)creatFooterView{

    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 500, LDScreenWidth, 70)];
//    footerView.backgroundColor  =[UIColor redColor];
    [self.tableView addSubview:footerView];

    
    //合计 标题
    UILabel * sumCount = [UILabel new];
    [footerView addSubview:sumCount];
    sumCount.text = @"合计:";
    [sumCount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(200);
        make.top.bottom.equalTo(footerView);
        make.width.equalTo(40);
    }];
    
    //合计 具体内容
    UILabel * sumCountDetail = [UILabel new];
    [footerView addSubview:sumCountDetail];
    sumCountDetail.textColor = [UIColor redColor];
    sumCountDetail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"moneyCount"];
    [sumCountDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sumCount.right);
        make.top.equalTo(sumCount.top);
        make.bottom.equalTo(sumCount.bottom);
        make.height.equalTo(sumCount);
    }];
    
    //确认
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:button];
    [button setTitle:@"确认" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView);
        make.centerY.equalTo(sumCountDetail);
        make.left.equalTo(sumCountDetail.right).offset(10);
        make.height.equalTo(sumCountDetail);
    }];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel * upLine = [UILabel new];
    upLine.backgroundColor = [UIColor brownColor];
    upLine.alpha = 0.2;
    UILabel * downLine = [UILabel new];
    downLine.backgroundColor = [UIColor brownColor];
    downLine.alpha = 0.2;
    [footerView addSubview:upLine];
    [footerView addSubview:downLine];
    
    [upLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(footerView);
        make.height.equalTo(1);
    }];
    
    [downLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(footerView);
        make.height.equalTo(1);
    }];
    
    return footerView;
}

/**
 *  确认按钮点击事件
 */
- (void)buttonClick{
//    LDLogFunc;
    
    [self sendRequest];
}

/**
 *  跳转到未完善页面
 */
- (void)sendRequest{
    NSString * url = [NSString stringWithFormat:@"%@order/confirm",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NILSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NILSTR([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    LDLog(@"token%@--ID%@",[params objectForKey:@"token"],[params objectForKey:@"id"]);
 
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            LDLog(@"%@",error);
            
            
        }else{
  
   
            LDLog(@"%@",response);
          
            LDGoodsDetailModel * model = [LDGoodsDetailModel mj_objectWithKeyValues:response];
            
            
            
            switch ([model.code intValue]) {
                    
                case 0://信息已经完善,(有无添加银行卡)
                {
                    
                    
                LDtest2222ViewController * bankCard = [[LDtest2222ViewController alloc] init];
                    
                [self.navigationController pushViewController:bankCard animated:YES];
 
                }
                    break;
                case -1://服务器错误
                    [MBProgressHUD showError:model.message];
                    
                    break;
                    
                case -2://请完善支付密码
                {
                    LDPaymentPasswordController * vc = [[LDPaymentPasswordController alloc] init];
                    vc.fromeWhere = @"xiadan";
                    [MBProgressHUD showError:model.message];
                    break;
                }
                case -3://请完善基本信息
                {//学生.工人,创业者,跳转到不同页面.
                    
                    LDTypeViewController * vc = [[LDTypeViewController alloc] init];
                    vc.fromeWhere = @"xiadan";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case -41://请完善上班族工作信息
                {

                    
                    
                    LDJobTabbleViewController * vc = [[LDJobTabbleViewController alloc] init];
                    vc.fromeWhere = @"xiadan";

                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;

                case -42://完善学生工作信息
                {

                    
                    LDJobStudentInforController * vc = [[LDJobStudentInforController alloc] init];
                    vc.fromeWhere = @"xiadan";

                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;

                case -43://完善创业者工作信息
                {

                    
                    [MBProgressHUD showError:model.message];
                    
                    
                    LDEntrepreneursTableViewController * vc = [[LDEntrepreneursTableViewController alloc] init];
                    vc.fromeWhere = @"xiadan";

                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case -5://请完善高级信息
                {
                    [MBProgressHUD showError:model.message];
                    
                    LDPostIDCardAdvancedInformation * vc = [[LDPostIDCardAdvancedInformation alloc] init];
                    vc.fromeWhere = @"xiadan";

                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case -6://请完善联系人信息
                {
                    [MBProgressHUD showError:model.message];
                    

                    LDContactInformationViewController * vc = [[LDContactInformationViewController alloc] init];
                    vc.fromeWhere = @"xiadan";
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    break;
                }
                case -7://请完善联系人信息
                {
                    [MBProgressHUD showError:model.message];
                    
                    
                    LDApplyForCreditViewController * vc = [[LDApplyForCreditViewController alloc] init];
                    vc.fromeWhere = @"xiadan";
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    break;
                }
                
            }
        
            
        
        
            }
     
    }];
    
    
}
/**
 *  每组多少行
 *
 *  @param tableView
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
/**
 *  返回多少组
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
/**
 *  返回cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = (UITableViewCell *)[[LDConformOrderViewCell alloc] init];
        cell.userInteractionEnabled = NO;
        
        return cell;

    }else{
        
        LDMonthPayViewCell * cell = (UITableViewCell *)[[LDMonthPayViewCell alloc] init];
//        cell.userInteractionEnabled = NO;
        cell.moneyCount.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastMoneyCount"];
        
        return cell;
    
    }
}
//cell高度,第一组和第二组cell高度不同.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 60;
    }

}
     
     
@end
