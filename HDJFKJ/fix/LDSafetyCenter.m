//
//  LDSafetyCenter.m
//  MerchantEdition
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDSafetyCenter.h"
#import "LDFixVC.h"
#import "LDGoodsDetailModel.h"
#import "LDPaymentPasswordController.h"

@interface LDSafetyCenter ()<UITableViewDelegate,UITableViewDataSource>
/** <#name#>  */
@property (nonatomic,strong) UITableView * table;

@end

@implementation LDSafetyCenter
static NSString * const SafetyCell = @"LDSafetyCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    [self setupTableView];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        //统计买点
//        [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:XGZFMM];
//        
//        [self sendRequest];
        //统计买点
        [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:XGDLMM];
        
        LDFixVC * fix = [[LDFixVC alloc] init];
        
        fix.ISPay = NO;
        
        [self.navigationController pushViewController:fix animated:YES];
        
    }else{
        
        //统计买点
        [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:XGDLMM];
        
        LDFixVC * fix = [[LDFixVC alloc] init];
        
        fix.ISPay = NO;

        [self.navigationController pushViewController:fix animated:YES];
    
    }
    
}
/**
 *  跳转到未完善页面
 */
- (void)sendRequest{
    [MBProgressHUD showMessage:@"正在加载"];
    NSString * url = [NSString stringWithFormat:@"%@customInfo/infoStep",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
        }else{
            
            
            LDLog(@"%@",response);
            
            LDBackInformation * model = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            if ([model.code intValue] == -100) {
                
                [MBProgressHUD showError:model.message];
                
            }else if ([model.code intValue] == -21){
                [MBProgressHUD showError:@"您还未设置支付密码"];
              
                LDPaymentPasswordController * vc = [[LDPaymentPasswordController alloc] init];
                vc.fromeWhere = @"anquanzhongxin";
                
                [self.navigationController pushViewController:vc animated:YES];
                
            
            }else{
                
                [MBProgressHUD hideHUD];
                
                //支付密码
                LDFixVC * fix = [[LDFixVC alloc] init];
                fix.ISPay = YES;
                [self.navigationController pushViewController:fix animated:YES];
            
            }
      
        }
        
    }];
    
}
- (void)setupTableView{
    

    self.title  =@"安全中心";
    UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, LDScreenWidth, 45) style:UITableViewStylePlain];
    table.autoresizesSubviews = NO;


    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    table.delegate  = self;
    
    table.dataSource = self;
    
    self.table = table;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"修改登录密码";
    }else{
        cell.textLabel.text = @"修改登录密码";
    
    }
//    if (indexPath.row == 0) {
//        UIView * line = [[UIView alloc] init];
//        line.alpha = 0.2;
//        line.backgroundColor = [UIColor blackColor];
//        [cell addSubview:line];
//        [line makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cell).offset(LDPadding);
//            make.right.equalTo(cell);
//            make.height.equalTo(0.5);
//            make.bottom.equalTo(cell);
//        }];
//    }
    
    return cell;
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
