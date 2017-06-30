

#import "HDChooseBankController.h"
#import "HDBankNameCell.h"
#import "HDBankListModel.h"

@interface HDChooseBankController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * bankTableView;

@property (nonatomic,strong) NSArray * resultArray;

@end

@implementation HDChooseBankController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择银行卡";
    self.view.backgroundColor = LDBackroundColor;
    
    /** 设置导航栏  */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"矩形-29"] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏的前景色为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //设置导航栏字体颜色为黑色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHColorFromRGB(0x323232)}];
    /** 显示导航栏下面的线 */
    self.navigationController.navigationBar.shadowImage = nil;
    
    
    
    
    /** 创建关闭按钮  */
    [self createLeftNavButton];
    
    /** 创建tableView */
    [self createBankTableView];
    
    /** 获取银行 */
    [self requestBankList];
    
    
    
}


//3.创建导航栏左侧按钮
- (void)createLeftNavButton{
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(ClickdismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftItem, nil];
    
}
- (void)ClickdismissButton:(UIButton *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)createBankTableView{
    
    self.bankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight)];
    self.bankTableView.backgroundColor = [UIColor clearColor];
    self.bankTableView.delegate = self;
    self.bankTableView.dataSource = self;
    self.bankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.bankTableView];
    
}

#pragma mark ---  tableVIew的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.resultArray.count;
    

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 80*bili;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDBankNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if(cell == nil)
    {
        cell = [[HDBankNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.size = CGSizeMake(LDScreenWidth, 80*bili);
        
        [cell createSubViews];
        
        
        /** 创建横线Label */
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 80*bili - 0.5, LDScreenWidth, 0.5)];
        lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
        [cell addSubview:lineLabel];
    
    }
    
    HDBankListModel * listModel = self.resultArray[indexPath.row];
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:listModel.pic] placeholderImage:[UIImage imageNamed:@"wode_yinhangka_2.0.4"]];
    [cell.iconImage setContentMode:UIViewContentModeScaleAspectFit];
    cell.bankNameLabel.text = listModel.bankName;
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.bankCard.bankModel = self.resultArray[indexPath.row];
    self.arBankCard.bankModel = self.resultArray[indexPath.row];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}



/** 获取银行列表 */
- (void)requestBankList{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * url = [NSString stringWithFormat:@"%@person/getBankList",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    if ([HDSubmitOrder shardSubmitOrder].businessId != nil) {
        [params setObject:[HDSubmitOrder shardSubmitOrder].businessId forKey:@"businessId"];
    }
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
        }else{
            
            NSLog(@"%@",response);
            
            //返回码,状态码信息.
            LDBackInformation * model = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([model.code isEqualToString:@"0"]) {
                [self dismissHDLoading];
                
                if (model.result != nil) {
                    self.resultArray = [HDBankListModel mj_objectArrayWithKeyValuesArray:[model.result objectForKey:@"list"]];
                }
                
                [self.bankTableView reloadData];
            }else{
                [self showFailViewWithString:model.message];
                
            }
            
            
            
            
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
