//
//  LDTest111ViewController.m
//  HDJFKJ
//
//  Created by apple on 16/4/2.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDTest111ViewController.h"
#import "LDHaveCardListModel.h"
#import "LDBankCardViewCell.h"
#import "LDBankCardViewController.h"
#import "LDSubmitVCController.h"

@interface LDTest111ViewController ()
@property (nonatomic,strong) NSArray * cellDataArray;
@property (nonatomic,strong) LDBankCardViewCell * bankCell;

@end

@implementation LDTest111ViewController

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
    self.tableView.rowHeight = 100;
    [self sendRequestHaveCard];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;

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
    
    return  3;//self.cellDataArray.count;
    
}

/**
 *  返回cell
 */
- (LDBankCardViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LDBankCardViewCell * cell = [[LDBankCardViewCell alloc] init];
    
    self.bankCell = cell;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerVeiw = [[UIView alloc] init];
    footerVeiw.backgroundColor = [UIColor whiteColor];

    UIView * cellView = [UIView new];
    cellView.backgroundColor = [UIColor clearColor];
    [footerVeiw addSubview:cellView];
    [cellView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(footerVeiw);
        make.height.equalTo(40);
        make.top.equalTo(footerVeiw).offset(200);
    }];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shangchuan"]];
    [cellView addSubview:image];
    [image makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cellView);
        make.left.equalTo(cellView).offset(LDPadding);
    }];
    UILabel * note = [UILabel new];
    [cellView addSubview:note];
    note.text = @"添加银行卡";
    [note makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.right).offset(LDPadding);
        make.centerY.equalTo(cellView);
    }];
    
    UIImageView * rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回"]];
    [cellView addSubview:rightImage];
    [rightImage makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cellView).offset(-LDPadding);
        make.centerY.equalTo(cellView);
    }];
    
    UILabel * note1 = [UILabel new];
    note1.numberOfLines = 0;
    [footerVeiw addSubview:note1];
    note1.text = @"选择银行卡用于还款,提交订单后不可修改银行卡,如需修改请联系客服";
    [note1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerVeiw).offset(2*LDPadding);
        make.right.equalTo(footerVeiw).offset(-2*LDPadding);
        make.top.equalTo(cellView.bottom).offset(2*LDPadding);
    }];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [footerVeiw addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"friendsTrend_login"] forState:UIControlStateNormal];
    [button setTitle:@"提交订单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerVeiw).offset(LDPadding);
        make.right.equalTo(footerVeiw).offset(-LDPadding);
        make.height.equalTo(50);
        make.top.equalTo(note1.bottom).offset(LDPadding);
    }];
    

    return footerVeiw;
    
}

- (void)buttonClick{
    
    
    LDLogFunc;
    
}
/**
 *  获取银行卡信息
 */
- (void)sendRequestHaveCard{
    
    NSString * url = [NSString stringWithFormat:@"%@person/bankcard/list",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:@"90291" forKey:@"id"];
    
    
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
