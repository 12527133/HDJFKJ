

#import "HDZuFangOrderController.h"
#import "LDZuFangFirstCell.h"
#import "HDZuFangScondCell.h"
#import "HDZuFangThreeCell.h"
#import "LDReViewInformation.h"
#import "LDNavgationVController.h"
#import "WHXinYongFenAgreementController.h"
#import "HDQRCommodity.h"

@interface HDZuFangOrderController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * zufangxieyi;

@property (nonatomic, strong) UIButton * xieyilabel;

@end

@implementation HDZuFangOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    self.view.backgroundColor = WHColorFromRGB(0xf5f5f9);
    
    
    [self createTableView];
}

/**
 * 创建tableView
 **/
- (void)createTableView{
    
    float distance = 50;
    if ([self.detailModel.status isEqualToString:@"1"]) {
        distance = 0.0;
    }
    else{
        distance = 50;
    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - distance - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDZuFangFirstCell  class]) bundle:nil] forCellReuseIdentifier:@"Cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDZuFangScondCell  class]) bundle:nil] forCellReuseIdentifier:@"Cell2"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDZuFangThreeCell  class]) bundle:nil] forCellReuseIdentifier:@"Cell3"];
    
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, LDScreenHeight - 50 -64, LDScreenWidth, 50)];
    [button setTitle:@"确认分期" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:WHColorFromRGB(0x4279d6)];
    [button addTarget:self action:@selector(querenfenqi:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    if ([self.detailModel.status isEqualToString:@"1"]) {
        
        
        button.hidden = YES;
    }
    else{
        
        button.hidden = NO;
    
    }
    
}

- (void)checkxieyi:(UIButton *)sender{

    WHXinYongFenAgreementController * vc = [[WHXinYongFenAgreementController alloc]initWithURL:zufangxieyiUrl title:@"用户租房协议"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)querenfenqi:(UIButton *)sender{

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
    [[HDSubmitOrder shardSubmitOrder] setCaseDetail:[NSString stringWithFormat:@"¥%.2f x %@期",[self.detailModel.periodAmount floatValue],self.detailModel.duration]];
    
    //商品列表
    [[HDSubmitOrder shardSubmitOrder] setCommoditys:[self returnCommoditys]];
    
    //商品名称
    [[HDSubmitOrder shardSubmitOrder] setGoodsName:[self returnGoodsName]];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 210.0;
            break;
        case 1:
            return 230.0;
            break;
        default:
            return 250.0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return 10;
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LDZuFangFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        return cell;
    }
    else if (indexPath.section == 1){
    
        HDZuFangScondCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        return cell;
    }
    else{
        HDZuFangThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        [cell.xieyiButton addTarget:self action:@selector(checkxieyi:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
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
