

#import "WHWithOutOrderController.h"

#import "HDFexOrderDetail.h"
#import "WHWithOutOrderCell.h"
#import "WHQROrderModel.h"

/** 扫码记录模型（包括数组）*/
#import "HDScanListModel.h"
#import "HDQRCommodity.h"
#import "HDZuFangOrderController.h"


@interface WHWithOutOrderController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

//展示扫码记录的列表
@property (nonatomic, strong) UITableView * saomaTableView;

//列表数据列表
@property (nonatomic, strong) NSMutableArray * dataSourceArray;

//页码
@property (nonatomic, assign) NSInteger pageIndex;

//每页请求数据的个数
@property (nonatomic, assign) NSInteger pageSize;

//结束指示器的时间
@property (nonatomic, weak) NSTimer * timer;


//searchBar
@property (nonatomic, strong) UISearchBar * mySearchBar;

/** 无记录视图  */
@property (nonatomic, strong) UIView * nullOrderView;


@end

@implementation WHWithOutOrderController
static NSString * const LDOrderId = @"LDOrderId";

/** 延迟加载无订单视图  */
- (UIView *)nullOrderView{
    if (!_nullOrderView) {
        _nullOrderView = [[UIView alloc]initWithFrame:self.view.bounds];
        _nullOrderView.backgroundColor =WHColorFromRGB(0xf5f5f9);
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((LDScreenWidth - 71)/2, (self.view.frame.size.height - 73)/2 - 57, 71, 73)];
        imageView.image = [UIImage imageNamed:@"firstpage_noLogin"];
        [_nullOrderView addSubview:imageView];
        
        UILabel * nullOrerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height+10 , LDScreenWidth, 20)];
        nullOrerLabel.text = @"暂无扫码记录";
        nullOrerLabel.textColor = WHColorFromRGB(0x979797);
        nullOrerLabel.textAlignment = NSTextAlignmentCenter;
        nullOrerLabel.font = [UIFont systemFontOfSize:13];
        [_nullOrderView addSubview:nullOrerLabel];
    }
    return _nullOrderView;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"扫码记录";
    
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    
    
    self.pageIndex = 1;
    
    self.pageSize = 10;
    
    // [self createSearchView];
    
    [self createTableView];
    
    [self requestWithOutOrder];
}

//获取扫码未下单记录
- (void)requestWithOutOrder{
    
    [MBProgressHUD showMessage:@"正在加载"];
    
    NSString * urlString = [NSString stringWithFormat:@"%@package/scanList",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    
    
    [[LDNetworkTools sharedTools] request:POST url:urlString params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
            LDLog(@"resonse%@",response);
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUD];
                
                /** 4.解析扫码记录 */
                if (backInfor.result != nil){
                    
                    HDScanListModel * scanList = [HDScanListModel mj_objectWithKeyValues:backInfor.result];
                    
                    self.dataSourceArray = scanList.list;
                }
                
                /** 有数据刷新数据  */
                if (self.dataSourceArray.count > 0) {
                    [self.saomaTableView reloadData];
                }
                /** 无订单视图  */
                else{

                    [self.view addSubview:self.nullOrderView];
                }
                
                
                
            }else{
                
                [MBProgressHUD showError:@"暂无更多数据"];
                
            }
            
        }
        
    }];
    
}
- (void)createSearchView{
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(15, 5, LDScreenWidth - 30, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    self.mySearchBar = [[UISearchBar alloc]init];
    
    self.mySearchBar.backgroundColor = [UIColor whiteColor];
    
    self.mySearchBar.barTintColor = [UIColor whiteColor];
    self.mySearchBar.delegate=self;
    self.mySearchBar.frame= searchView.frame;
    
    self.mySearchBar.layer.cornerRadius=18;
    self.mySearchBar.layer.masksToBounds=YES;
    //边框线粗细
    [self.mySearchBar.layer setBorderWidth:6];
    self.mySearchBar.backgroundColor = [UIColor clearColor];
    //设置边框为白色是为了盖住UISearchBar上的灰色
    [self.mySearchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.mySearchBar.placeholder= @"输入客户手机号";
    
    [self.view addSubview:self.mySearchBar];
    
}
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    NSLog(@"---%@",searchBar.text);
    
    [self.mySearchBar resignFirstResponder];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.mySearchBar.text = nil;
    
    [self.mySearchBar resignFirstResponder];
}

- (void)createTableView{
    
    
    self.saomaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, self.view.frame.size.height - 64 )];
    
    self.saomaTableView.delegate = self;
    self.saomaTableView.dataSource = self;
    
    self.saomaTableView.backgroundColor = [UIColor clearColor];
    self.saomaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.saomaTableView];
    
    [self.saomaTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WHWithOutOrderCell class]) bundle:nil] forCellReuseIdentifier:LDOrderId];
    self.saomaTableView.rowHeight = 140;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * fotter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 10)];
    
    fotter.backgroundColor = [UIColor clearColor];
    
    return fotter;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WHQROrderModel * model = self.dataSourceArray[indexPath.section];
    
    WHWithOutOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:LDOrderId];
    
    
    cell.orderModel = model;
    
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    WHQROrderModel * model = self.dataSourceArray[indexPath.section];
    if (model.commoditys.count > 0) {
        HDQRCommodity * qrComm = model.commoditys[0];
        
        if (qrComm.addrArea != nil || qrComm.addrCounty != nil || qrComm.addrDetail != nil || qrComm.addrProvince != nil) {
            HDZuFangOrderController * zufang = [[HDZuFangOrderController alloc]init];
            zufang.detailModel = model;
            [self.navigationController pushViewController:zufang animated:YES];

        }
        else{
        
            HDFexOrderDetail * detail = [[HDFexOrderDetail alloc] init];
            detail.detailModel = model;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
    else{
        HDFexOrderDetail * detail = [[HDFexOrderDetail alloc] init];
        detail.detailModel = model;
        [self.navigationController pushViewController:detail animated:YES];
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
