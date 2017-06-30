

#import "WHGoodsListController.h"
#import "WHSearchGoodCell.h"
#import "WHHomeGoodsModel.h"
#import "LDTaoBaoVC.h"
#import "WHNoneGoodsView.h"
#import "MJRefresh.h"
@interface WHGoodsListController ()<UITableViewDataSource,UITableViewDelegate>
//商品数组
@property (nonatomic, strong) NSMutableArray * goodListArray;
//搜索历史tableView
@property (strong, nonatomic) UITableView *mianTableView;

@property (nonatomic, strong) WHNoneGoodsView * noneGoodsView;
//页码
@property (nonatomic, assign) NSInteger pageIndex;
//商品数量
@property (nonatomic, assign) NSInteger pageSize;

//加载结果数组
@property (nonatomic, strong) NSArray * resultArray;

@end

@implementation WHGoodsListController

- (NSMutableArray *)goodListArray{
    if (!_goodListArray) {
        _goodListArray = [[NSMutableArray alloc]init];
    }
    return _goodListArray;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mianTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.创建tableView
    [self createTableView];
    
    
    self.pageIndex = 0;
    self.pageSize = 10;
    //2.发送网络请求
    [self sendRequest];
    
    //3.设置下拉刷新，上啦加载
    [self setupRefresh];
}


- (void)setupRefresh{
    
    //下拉刷新
    self.mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefersh)];
    self.mianTableView.mj_header.automaticallyChangeAlpha = YES;
    //[self.mianTableView.mj_header beginRefreshing];
    
    //上拉加载
    self.mianTableView.mj_footer.automaticallyChangeAlpha = YES;
    self.mianTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefersh)];
}
//下拉响应方法
- (void)headerRefersh{
    
    self.pageIndex = 0;
    [self sendRequest];
}
//上拉响应方法
- (void)footerRefersh{
    if (self.resultArray.count >= self.pageSize) {
        self.pageIndex ++;
        [self sendRequest];
    }
    else{
        [self.mianTableView.mj_footer endRefreshingWithNoMoreData];
    }

}

//创建列表
- (void)createTableView{
    
    
    self.mianTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.mianTableView];
    
    //self.mianTableView.backgroundColor = [UIColor redColor];
    self.mianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mianTableView.delegate = self;
    self.mianTableView.dataSource = self;
    
    //tableView上面的横线
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 0.5)];
    label.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [self.view addSubview:label];
    
}

#pragma mark -- tableView协议方法
//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
//设置cell的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodListArray.count;
}
//加载cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WHSearchGoodCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell2"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"WHSearchGoodCell" owner:nil options:nil].lastObject;
    }
    
    WHHomeGoodsModel * good = self.goodListArray[indexPath.row];
    
    //1.加载图片
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:good.pic] placeholderImage:[UIImage imageNamed:@"商品 1:1"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        LDLog(@"下载进度：%f", 1.0 * receivedSize / expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        LDLog(@"下载完成");
    }];
    cell.picImageView.layer.cornerRadius = 0.0;
    cell.picImageView.layer.borderColor = [WHColorFromRGB(0xf0f0f0) CGColor];
    cell.picImageView.layer.borderWidth = 0.5f;

    
    
    //2.商品名称
    cell.nameLabel.text = good.name;
    
    //4.购买人数
    cell.saleLabel.text = [NSString stringWithFormat:@"已有%ld人购买",(long)good.sale];
    //5.商户名称
    cell.businessnameLabel.text = good.businessname;
    
    //6.优惠标示,分期描述，星级设置
    [self setGoodCellSubView:cell googModel:good];
    
    return cell;
    
    
    
    
}
- (void)setGoodCellSubView:(WHSearchGoodCell *)cell googModel:(WHHomeGoodsModel *)good{
    if (good.star == 0) {//评分0
        cell.stariImageView.hidden = YES;
        cell.starImageView2.hidden = YES;
        cell.starImageView3.hidden = YES;
        cell.starImageView4.hidden = YES;
        cell.staImageView5.hidden = YES;
        
        cell.saleLabel.frame = CGRectMake(86, 40, 150, 11);
    }
    if (good.sale > 0 && good.star < 1.0) {//评分0.5
        
    }
    if (good.star == 1.0){//评分1
        cell.stariImageView.hidden = NO;
        cell.starImageView2.hidden = YES;
        cell.starImageView3.hidden = YES;
        cell.starImageView4.hidden = YES;
        cell.staImageView5.hidden = YES;
        cell.saleLabel.frame = CGRectMake(111, 40, 150, 11);
    }
    if (good.star > 1.0 && good.star < 2.0){//评分1.5
        
    }
    if (good.star == 2.0) {//评分2
        cell.stariImageView.hidden = NO;
        cell.starImageView2.hidden = NO;
        cell.starImageView3.hidden = YES;
        cell.starImageView4.hidden = YES;
        cell.staImageView5.hidden = YES;
        
        cell.saleLabel.frame = CGRectMake(126, 40, 150, 11);
    }
    if (good.star >2.0 && good.star < 3.0){//评分2.5
        cell.stariImageView.hidden = NO;
        cell.starImageView2.hidden = NO;
        cell.starImageView3.hidden = NO;
        cell.starImageView4.hidden = YES;
        cell.staImageView5.hidden = YES;
        cell.saleLabel.frame = CGRectMake(141, 40, 150, 11);
    }
    if (good.star == 3.0) {//评分3
        cell.stariImageView.hidden = NO;
        cell.starImageView2.hidden = NO;
        cell.starImageView3.hidden = NO;
        cell.starImageView4.hidden = YES;
        cell.staImageView5.hidden = YES;
        cell.saleLabel.frame = CGRectMake(141, 40, 150, 11);
    }
    if (good.star > 3.0 && good.star < 4.0 ){//评分3.5
        cell.stariImageView.hidden = NO;
        cell.starImageView2.hidden = NO;
        cell.starImageView3.hidden = NO;
        cell.starImageView4.hidden = NO;
        cell.staImageView5.hidden = YES;
        cell.saleLabel.frame = CGRectMake(156, 40, 150, 11);
    }
    if (good.star == 4.0) {//评分4.0
        cell.stariImageView.hidden = NO;
        cell.starImageView2.hidden = NO;
        cell.starImageView3.hidden = NO;
        cell.starImageView4.hidden = NO;
        cell.staImageView5.hidden = YES;
        cell.saleLabel.frame = CGRectMake(156, 40, 150, 11);
    }
    if (good.star > 4.0 && good.star < 5.0){//评分4.5
        cell.stariImageView.hidden = NO;
        cell.starImageView2.hidden = NO;
        cell.starImageView3.hidden = NO;
        cell.starImageView4.hidden = NO;
        cell.staImageView5.hidden = NO;
        cell.saleLabel.frame = CGRectMake(171, 40, 150, 11);
    }
    if (good.star == 5.0){//评分5
        cell.stariImageView.hidden = NO;
        cell.starImageView2.hidden = NO;
        cell.starImageView3.hidden = NO;
        cell.starImageView4.hidden = NO;
        cell.staImageView5.hidden = NO;
        cell.saleLabel.frame = CGRectMake(171, 40, 150, 11);
    }
    
    if (good.downpayment == 0) {
        cell.fenqiDetailLabel.text = [NSString stringWithFormat:@"0首付 + ¥%.2f x %ld期",good.periodamount,(long)good.duration];
    }else{
        cell.fenqiDetailLabel.text = [NSString stringWithFormat:@"首付%.2f + ¥%.2f x %ld期",good.downpayment,good.periodamount,(long)good.duration];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WHHomeGoodsModel * good = self.goodListArray[indexPath.row];
    
    LDTaoBaoVC * goodVC = [[LDTaoBaoVC alloc]init];
    
    goodVC.goodsID = good.id;
    
    [self.navigationController pushViewController:goodVC animated:YES];
}
//网络请求
- (void)sendRequest{
    
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@commodityList/",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:self.title forKey:@"category"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageIndex] forKey:@"pageIndex"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageSize] forKey:@"pageSize"];
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        [self.mianTableView.mj_footer endRefreshing];
        [self.mianTableView.mj_header endRefreshing];
        
        if (error != nil) {
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            NSLog(@"%@",response);
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                /** 4.解析返回结果 */
                
                [self analysisResponse:backInfo.result];
                
            }else{
                // 显示失败信息
                [self showFailViewWithString:[response objectForKey:@"message"]];
            }
            LDLog(@"%@",response);
        }
    }];
}
//解析返回数据
- (void)analysisResponse:(id)result{
    self.resultArray = result;
    if (self.pageIndex == 0) {
        [self.goodListArray removeAllObjects];
    }
    
    
    if (self.resultArray.count > 0) {
        
        self.goodListArray = [WHHomeGoodsModel mj_objectArrayWithKeyValuesArray:self.resultArray];

        [self.mianTableView reloadData];
    }else{
        if (self.pageIndex == 0) {
            [self createNoneGoodsView];
        }
        
    }
    
    
}

- (void)createNoneGoodsView{
    self.noneGoodsView = [WHNoneGoodsView view];
    self.noneGoodsView.frame = self.mianTableView.frame;
    self.noneGoodsView.TishiLabel.text = @"该分类下暂无商品";
    [self.view addSubview:self.noneGoodsView];
    
}
@end
