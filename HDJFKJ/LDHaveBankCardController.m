//
//  LDHaveBankCardController.m
//  HDJFKJ
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDHaveBankCardController.h"
#import "LDHaveCardListModel.h"
#import "LDBankCardViewCell.h"
#import "LDBankCardViewController.h"
#import "LDSubmitVCController.h"

@interface LDHaveBankCardController ()
@property (nonatomic,strong) NSArray * cellDataArray;
@property (nonatomic,strong) LDBankCardViewCell * bankCell;

@end

@implementation LDHaveBankCardController
- (NSArray *)cellDataArray
{
    if (!_cellDataArray) {
        
        _cellDataArray = [NSArray array];
        
    }
    
    return _cellDataArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor  = LDBackroundColor;
    self.navigationItem.title = @"选择银行卡";
    
    [self sendRequestHaveCard];
    
}

/**
 *  获取银行卡信息
 */
- (void)sendRequestHaveCard{
    
    NSString * url = [NSString stringWithFormat:@"%@person/bankcard/list",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"id"];
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            LDLog(@"%@",error);
            
        }else{
            
            LDLog(@"%@",response);
            
            self.cellDataArray = [LDHaveCardListModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"list"]];
            
            for (int i = 0; i < self.cellDataArray.count; i++) {
                LDHaveCardListModel * model = self.cellDataArray[i];
                LDLog(@"%@",model);
                [self.tableView reloadData];

            }
        }
 }];
    
    
    
}

/**
 *  cell高度
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;

}
/**
 *  底部视图高度
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerVeiw = [[UIView alloc] init];
    footerVeiw.backgroundColor  =LDBackroundColor;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerVeiw addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerVeiw);
    
    }];
    
    UILabel * lable = [UILabel new];
    
    lable.textAlignment = NSTextAlignmentCenter;
    [footerVeiw addSubview:lable];

    if (self.cellDataArray.count == 0) {
        
        lable.text = @"添加银行卡";
        
    }else{
    
        lable.text = @"提交订单";
    }
   
    
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerVeiw);
    }];
    
    return footerVeiw;

}
/**
 *  提交订单入口
 */
- (void)buttonClick{
    
    if (self.cellDataArray.count == 0) {//添加银行卡
    
    }else{
        
        //提交订单
        LDSubmitVCController * submitVC = [[LDSubmitVCController alloc] init];
        [self.navigationController pushViewController:submitVC animated:YES];
        LDLogFunc;
    
    }

}

/**
 *  提交订单网络请求
 */
- (void)submitOrderRequest{
    
    NSString * url = [NSString stringWithFormat:@"%@order/submit",KBaseUrl];

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    [params setObject:NULLSTR([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    //商品id
    [params setObject:NILSTR([[NSUserDefaults standardUserDefaults] objectForKey:@"commodityId"]) forKey:@"commodityId"];
    
    //专案id
    [params setObject:NILSTR([[NSUserDefaults standardUserDefaults] objectForKey:@"commodityCaseId"]) forKey:@"commodityCaseId"];
    //银行卡id
    
    //支付密码
//
//    LDLog(@"%@-%@",NILSTR([[NSUserDefaults standardUserDefaults] objectForKey:@"commodityId"]),[[NSUserDefaults standardUserDefaults] objectForKey:@"commodityCaseId"]);
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            LDLog(@"%@",error);
            
        }else{
            
            LDLog(@"%@",response);
            
            self.cellDataArray = [LDHaveCardListModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"list"]];
            for (int i = 0; i < self.cellDataArray.count; i++) {
                LDHaveCardListModel * model = self.cellDataArray[i];
                LDLog(@"%@",model);
                [self.tableView reloadData];
                
            }
        }
    }];
    
    
    
}


/**
 *  多少行cell
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    LDLog(@"%lu",(unsigned long)self.cellDataArray.count);
    
    return self.cellDataArray.count;

}

/**
 *  返回cell
 */
- (LDBankCardViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LDBankCardViewCell * cell = [[LDBankCardViewCell alloc] init];
    
    self.bankCell = cell;
    
    return cell;
}
/**
 *  cell监听事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LDLogFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
