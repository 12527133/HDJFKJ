

#import "HDCheckOrderController.h"
#import "HDCheckDetailCell.h"
@interface HDCheckOrderController ()<UITableViewDelegate,UITableViewDataSource>

//订单列表试图
@property (nonatomic, strong) UITableView * checkListTableView;

/** 商品Label */
@property (nonatomic, strong) UILabel * goodsLabel;
@end

@implementation HDCheckOrderController


- (UILabel *)goodsLabel{

    if (!_goodsLabel) {
        _goodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth/2, 12*bili, LDScreenWidth/2 - 15*bili, 21*bili)];
        _goodsLabel.textColor = WHColorFromRGB(0x969696);
        _goodsLabel.textAlignment = NSTextAlignmentRight;
        _goodsLabel.numberOfLines = 3;
        _goodsLabel.backgroundColor = [UIColor clearColor];
        _goodsLabel.font = [UIFont systemFontOfSize:15*bili];
    }
    return _goodsLabel;
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
    self.title = @"订单详情";
    self.view.backgroundColor = LDBackroundColor;
    [self createLeftNavButton];
    
    [self setgoosLabelFrame];
    
    [self createCheckListTableView];
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
/** 根据商品信心重置商品信息Label 的 Frame*/
- (void)setgoosLabelFrame{
    
    NSArray * dataArray = [LDSmallNewOrderDetailModel mj_objectArrayWithKeyValuesArray:self.orderDetail.orderCommoditys];
    
    NSMutableString * string = [[NSMutableString alloc]init];
    
    for (LDSmallNewOrderDetailModel * commoditys in dataArray) {
        [string appendString:commoditys.commodityName];
    }
    
    self.goodsLabel.text = string;
    
    CGSize size = [self.goodsLabel sizeThatFits:CGSizeMake(self.goodsLabel.frame.size.width, MAXFLOAT)];
    
    if (size.height < 21*bili) {
        size.height = 21*bili;
    }
    
    CGSize size2 = [self.goodsLabel sizeThatFits:CGSizeMake( MAXFLOAT, self.goodsLabel.frame.size.height)];
    if (size2.width > self.goodsLabel.frame.size.width) {
        self.goodsLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    self.goodsLabel.frame =CGRectMake(self.goodsLabel.frame.origin.x, self.goodsLabel.frame.origin.y, self.goodsLabel.frame.size.width, size.height);

}


//2.创建还款列表
- (void)createCheckListTableView{
    
    self.checkListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 64)];
    self.checkListTableView.backgroundColor = [UIColor clearColor];
    self.checkListTableView.delegate = self;
    self.checkListTableView.dataSource = self;
    self.checkListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.checkListTableView];
    
    
    self.checkListTableView.scrollEnabled = NO;
  
    
}

#pragma mark ---  tableVIew的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 1) {
        return 45*bili;
    }
    else{
        return self.goodsLabel.frame.size.height+24*bili;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10*bili;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != 1){
        
        
        HDCheckDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(cell == nil)
        {
            cell = [[HDCheckDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.size = CGSizeMake(LDScreenWidth, 45*bili);
            
            [cell createSubViews];
            
            
            
            if (indexPath.row == 3) {
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
        switch (indexPath.row) {
            case 0:
                cell.leftlabel.text = @"订单编号";
                cell.rightLabel.text = self.orderDetail.orderNo;
                break;
            case 2:
                cell.leftlabel.text = @"业务员";
                cell.rightLabel.text = self.orderDetail.ownSaleMan;
                break;
            default:
                cell.leftlabel.text = @"商家名称";
                cell.rightLabel.text = self.orderDetail.businessName;
                break;
        }
        
        return cell;
        
    }
    
    else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            /** 创建账单时间  */
            UILabel * leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 12*bili, 65*bili, 21*bili)];
            leftlabel.backgroundColor = [UIColor clearColor];
            leftlabel.textColor = WHColorFromRGB(0x1b1b1b);
            leftlabel.text = @"商品名称";
            leftlabel.textAlignment = NSTextAlignmentLeft;
            leftlabel.font = [UIFont systemFontOfSize:15*bili];
            [cell addSubview:leftlabel];
            
            [cell addSubview:self.goodsLabel];
            
            /** 创建横线Label */
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, self.goodsLabel.frame.size.height + 24*bili - 0.5, LDScreenWidth, 0.5)];
            lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
            [cell addSubview:lineLabel];
        }
        
        return cell;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
