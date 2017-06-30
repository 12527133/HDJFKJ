

#import "WHOrderListController.h"
#import "LDNewOrderDetailVC.h"
#import "LDNewOrderListModel.h"
#import "HDLoanOrderView.h"

@interface WHOrderListController ()

@property (nonatomic, strong) HDLoanOrderView * leftView;

@end

@implementation WHOrderListController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //设置导航栏的背景色
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.parentViewController.tabBarController.tabBar.hidden = YES;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    
    self.view.backgroundColor = LDBackroundColor;
    
    [self createOrderView];
    
}
- (void)createOrderView{

    if (self.orderStatus == nil) {
       self.orderStatus = @"0";
    }
    
    
    /** 创建贷款订单视图 */
    self.leftView = [[HDLoanOrderView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 64)];
    
    self.leftView.orderStatus = self.orderStatus;
    self.leftView.orderType = 0;
    self.leftView.statusArray = @[@"全部",@"审核中",@"已打回",@"已通过",@"还款中",@"已完成",@"已取消",@"已拒绝"];
    [self.leftView createView];
    
    [self.leftView getOrderRequest];
    [self.view addSubview:self.leftView];
    
    __weak typeof(self) weakSelf = self;
    
    
    
    
    self.leftView.completionBlock = ^(LDNewOrderListModel * orderModel){
        
        LDNewOrderDetailVC * orderDetail = [[LDNewOrderDetailVC alloc]init];
        
        orderDetail.applyId = [NSString stringWithFormat:@"%@",orderModel.id];
        
        [weakSelf.navigationController pushViewController:orderDetail animated:YES];
    };
}

@end
