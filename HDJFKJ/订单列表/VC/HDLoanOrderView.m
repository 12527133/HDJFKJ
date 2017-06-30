

#import "HDLoanOrderView.h"
#import "HDOrderListCell.h"
#import "MJRefresh.h"
#import "HDNullOrderCell.h"
#import "HDOrderListTopCell.h"

@interface HDLoanOrderView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray * dataSourceArray;

@property (nonatomic, strong) NSMutableArray * rootArray;

@property (nonatomic, strong) NSMutableArray * tableViewArray;

@property (nonatomic, strong) NSMutableArray * pageIndexArray;

@property (nonatomic, strong) HDOrderListTopCell * currentTopCell;

@property (nonatomic, assign) BOOL isTapCollection;

@end
@implementation HDLoanOrderView


- (NSMutableArray *)pageIndexArray{

    if (!_pageIndexArray) {
        _pageIndexArray = [[NSMutableArray alloc]init];
    }
    return _pageIndexArray;
}

- (NSMutableArray *)tableViewArray{

    if (!_tableViewArray) {
        _tableViewArray = [[NSMutableArray alloc]init];
    }
    return _tableViewArray;
}

- (NSMutableArray *)rootArray{

    if (!_rootArray) {
        _rootArray = [[NSMutableArray alloc]init];
    }
    return _rootArray;
}

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = LDBackroundColor;
    
    return self;
}

- (void)createView{
    
    self.pageSize = 20;

    self.isTapCollection = NO;
    
    [self createSrollView];
    
     [self creatCollectionView];
}

- (void)creatCollectionView{

    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45*bili)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    /** 创建加载图片的CollectionView  */
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
    
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45*bili) collectionViewLayout:layout];
    
    if (self.orderType == 1) {
        self.collectionView.frame = CGRectMake(LDScreenWidth/5, 0, LDScreenWidth/5*3, 45*bili);
        self.collectionView.scrollEnabled = NO;
    }
    self.collectionView.tag = self.statusArray.count *3;
    [backView addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = FALSE; // 去掉滚动条
    self.collectionView.pagingEnabled = NO;
   
    [self.collectionView registerClass:[HDOrderListTopCell class] forCellWithReuseIdentifier:@"topCell"];
    
    
}

#pragma mark -- collectionViewDateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.statusArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UINib *nib = [UINib nibWithNibName:@"HDOrderListTopCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"topCell"];
    HDOrderListTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"topCell" forIndexPath:indexPath];
    
    NSInteger index = [self.orderStatus integerValue];
    if (self.orderType == 0) {
        index = [self getIndexWithOrderStatus:self.orderStatus];
    }
    
    if (index == indexPath.row) {
        cell.titleLabel.textColor = WHColorFromRGB(0x3492e9);
        self.currentTopCell = cell;
    }
    else{
        cell.titleLabel.textColor = WHColorFromRGB(0x323232);
    }
    
    cell.titleLabel.text = self.statusArray[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentTopCell.titleLabel.textColor = WHColorFromRGB(0x323232);
    
    HDOrderListTopCell * cell = (HDOrderListTopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.titleLabel.textColor = WHColorFromRGB(0x3492e9);
    
    self.currentTopCell = cell;
    
    if (self.orderType == 0) {
        [self setOrderStatusWithIndex:indexPath.row];
    }
    else{
        self.orderStatus = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    }

    self.isTapCollection = YES;
    
    self.scrollView.contentOffset = CGPointMake(LDScreenWidth*indexPath.row, 0);
  
    self.tableView = self.tableViewArray[indexPath.row];

    self.dataSourceArray = self.rootArray[indexPath.row];
    
    self.pageIndex = [self.pageIndexArray[indexPath.row] integerValue];
    
    if (self.dataSourceArray.count == 0) {
         [self getOrderRequest];
    }
    
   
    
}

- (void)setOrderStatusWithIndex:(NSInteger)index{

    switch (index) {
        case 0:
            self.orderStatus = @"0";
            break;
        case 1:
            self.orderStatus = @"1";
            break;
        case 2:
            self.orderStatus = @"3";
            break;
        case 3:
            self.orderStatus = @"2";
            break;
        case 4:
            self.orderStatus = @"7";
            break;
        case 5:
            self.orderStatus = @"8";
            break;
        case 6:
            self.orderStatus = @"4";
            break;
        case 7:
            self.orderStatus = @"5";
            break;
        default:
            self.orderStatus = @"0";
            break;
    }
}

#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(LDScreenWidth/5, 45*bili);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0,0);
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


- (void)createSrollView{

    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50*bili, LDScreenWidth, self.frame.size.height - 50*bili)];
    self.scrollView.contentSize = CGSizeMake(LDScreenWidth * self.statusArray.count, 0);
    self.scrollView.bounces = YES;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.tag = self.statusArray.count*2;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.backgroundColor = LDBackroundColor;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < self.statusArray.count; i++) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(i*LDScreenWidth, 0, LDScreenWidth, self.scrollView.frame.size.height)];
        tableView.tag = i;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor= LDBackroundColor;
        tableView.showsVerticalScrollIndicator=NO;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDOrderListCell  class]) bundle:nil] forCellReuseIdentifier:@"orderCell"];
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDNullOrderCell class]) bundle:nil] forCellReuseIdentifier:@"nullCell"];
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefersh)];
        
        tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefersh)];
        
        
        [self.scrollView addSubview:tableView];
        [self.tableViewArray addObject:tableView];
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        
        [self.rootArray addObject:array];
        
        [self.pageIndexArray addObject:@"0"];
        
    }
    
    /** 初始化数据  */
    
    NSInteger index = 0;
    
    if (self.orderStatus != nil){
        
        index = [self getIndexWithOrderStatus:self.orderStatus];
        
    }
    self.scrollView.contentOffset = CGPointMake(LDScreenWidth *index, 0);
    
    self.tableView = self.tableViewArray[index];
    
    self.dataSourceArray = self.rootArray[index];
    
    self.pageIndex = [self.pageIndexArray[index] integerValue];

}

- (NSInteger)getIndexWithOrderStatus:(NSString *)orderStatus{
    
    int index = [orderStatus intValue];
    
    switch (index) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 7:
            return 4;
            break;
        case 8:
            return 5;
            break;
        case 4:
            return 6;
            break;
        case 5:
            return 7;
            break;
        default:
            return 0;
            break;
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.tag == self.statusArray.count*2) {
        
    
        
        int page = floor((scrollView.contentOffset.x - LDScreenWidth / 2) / LDScreenWidth) + 1;
        NSLog(@"%d",page);
        
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:page inSection:0];
        
        if (!self.isTapCollection) {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        
        if (self.isTapCollection) {
            self.isTapCollection = NO;
        }
        
        
        HDOrderListTopCell * cell = (HDOrderListTopCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        self.currentTopCell.titleLabel.textColor = WHColorFromRGB(0x323232);
        
        cell.titleLabel.textColor = WHColorFromRGB(0x3492e9);
        
        self.currentTopCell = cell;
        
        if (self.orderType == 0) {
            [self setOrderStatusWithIndex:indexPath.row];
        }
        else{
            self.orderStatus = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        }
        
        self.tableView = self.tableViewArray[indexPath.row];
        
        self.dataSourceArray = self.rootArray[indexPath.row];
        
        self.pageIndex = [self.pageIndexArray[indexPath.row] integerValue];
    }
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == self.statusArray.count * 2) {
        if (self.dataSourceArray.count == 0) {
            [self getOrderRequest];
        }

    }

}


/** 下拉刷新 */
- (void)headerRefersh{
    
    [self.dataSourceArray removeAllObjects];
    
    self.pageIndex = 0;
    [self getOrderRequest];
}

/** 上啦加载 */
- (void)footerRefersh{
    self.pageIndex ++;
    [self getOrderRequest];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataSourceArray.count == 0) {
        
        self.tableView.scrollEnabled = NO;
        return 1;
        
    }
    else{
        
        self.tableView.scrollEnabled = YES;
        
        return self.dataSourceArray.count;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSourceArray.count == 0) {
        return self.tableView.frame.size.height;
    }
    else{
        return 100.0 * bili;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSourceArray.count == 0) {
        HDNullOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"nullCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        HDOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        
        cell.listModel = self.dataSourceArray[indexPath.row];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSourceArray.count > 0) {
        if (self.orderType == 1) {
//            HDBSYOrderListModel * bsyModel = self.dataSourceArray[indexPath.row];
//            
//            self.completionBlock(bsyModel);
        }
        else{
            LDNewOrderListModel * model = self.dataSourceArray[indexPath.row];
            
            self.completionBlock(model);
            
            
        }
    }
     
}

- (void)getOrderRequest{

    if (self.orderType == 0) {
        [self sendOrderRequest];
    }
    else{
        //[self sendBSYOrderListRequest];
    }
}


//(订单列表)下单记录
- (void)sendOrderRequest{
    
    //显示指示器
    [self showWithImageWithString:@"正在加载"];
    
    NSString * urlString = [NSString stringWithFormat:@"%@order/list",KBaseUrl ];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:self.orderStatus forKey:@"status"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    //所有订单
    [params setObject:self.orderStatus forKey:@"status"];
    
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageIndex] forKey:@"pageIndex"];
    
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageSize] forKey:@"pageSize"];
    
    [[LDNetworkTools sharedTools] request:POST url:urlString params:params callback:^(id response, NSError *error) {
        
        
        
        if (error != nil) {//失败
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            LDLog(@"error%@",error);
            
            [self showFailViewWithString:@"网络错误"];
            
            
        }else{//成功
            
            LDLog(@"%@",response);
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                NSArray * pageArray = [LDNewOrderListModel mj_objectArrayWithKeyValuesArray:backInfor.result];
                
                [self.dataSourceArray addObjectsFromArray:pageArray];
                
                [self reloadTableViewData];
                
                
            }else if ([backInfor.code isEqualToString:@"-2"]){
                
                [self showFailViewWithString:@"请登录"];
                
               
                
            }else{
                self.pageIndex -= 1;
                
                [self showFailViewWithString:backInfor.message];
                
                
            }
            
            if (self.dataSourceArray.count < self.pageSize) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                [self.tableView.mj_footer endRefreshing];
                
                
            }
        }
    }];
    
}

/** 刷新数据 */
- (void)reloadTableViewData{
    
    if (self.dataSourceArray.count == 0) {
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}












/** 错误提示 */
- (void)showFailViewWithString:(NSString *)error{
    
    [MBProgressHUD showError:error];
}

/** 加载提示 */
- (void)showWithImageWithString:(NSString *)message{
    [MBProgressHUD showMessage:message];
}

/** 成功提示 */
- (void)showSuccessViewWithString:(NSString *)success{
    [MBProgressHUD showSuccess:success];
}
/** 取消加载 */
- (void)dismissHDLoading{
    [MBProgressHUD hideHUD];
}


@end
