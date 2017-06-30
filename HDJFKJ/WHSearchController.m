

#import "WHSearchController.h"
#import "WHSearchTopView.h"
#import "WHSearchViewCell.h"
#import "WHSearchGoodCell.h"
#import "WHHomeGoodsModel.h"
#import "WHNoneGoodsView.h"
#import "MJRefresh.h"
#import "LDTaoBaoVC.h"

#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.5]
@interface WHSearchController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

//搜索历史tableView
@property (strong, nonatomic) UITableView *mianTableView;

@property (strong ,nonatomic) WHSearchTopView * searchView;

@property (nonatomic, strong) NSMutableArray * searchArray;

@property (nonatomic, strong) NSMutableArray * baseArray;

//判断是否显示搜索历史记录
@property (nonatomic, assign) BOOL isSearch;

//商品数组
@property (nonatomic, strong) NSMutableArray * goodsArray;

@property (nonatomic, strong) WHNoneGoodsView * noneGoodsView;

//页码
@property (nonatomic, assign) NSInteger pageIndex;
//商品数量
@property (nonatomic, assign) NSInteger pageSize;
//加载结果数组
@property (nonatomic, strong) NSArray * resultArray;
@end

@implementation WHSearchController

- (NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc]init];
    }
    return _goodsArray;
}

- (NSMutableArray *)baseArray{
    if (!_baseArray) {
        _baseArray = [[NSMutableArray alloc]init];
    }
    return _baseArray;
}

- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc]init];
    }
    return _searchArray;
    
}

//隐藏taber
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
}
//显示taber
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.创建搜索试图
    [self createSearchView];
    
    //2.创建TableView
    [self createTableView];
    
    self.isSearch = YES;
    
    self.pageIndex = 0;
    self.pageSize = 10;
    //[self setupRefresh];
    
}
- (void)setupRefresh{
    
    //下拉刷新
    self.mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefersh)];
    self.mianTableView.mj_header.automaticallyChangeAlpha = YES;
    //[self.mianTableView.mj_header beginRefreshing];
    
    //上拉加载
    //self.mianTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefersh)];
    
    self.mianTableView.mj_footer.automaticallyChangeAlpha = YES;
    self.mianTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefersh)];
    
    
}
//下拉响应方法
- (void)headerRefersh{
    if (!self.isSearch) {
        
        self.pageIndex = 0;
        [self sendRequest];
    }
    
}
//上拉响应方法
- (void)footerRefersh{
    
    if (!self.isSearch) {
        if (self.resultArray.count >= self.pageSize) {
            self.pageIndex ++;
            [self sendRequest];
            
        }else{
            [self.mianTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    
}

//创建搜索北京及搜索框
- (void)createSearchView{
    self.searchView = [WHSearchTopView view];
    self.searchView.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.width * 37.0/375);
    [self.view addSubview:self.searchView];
    [self.searchView.cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.searchView.searchTextField.delegate = self;
    [self.searchView.searchTextField addTarget:self action:@selector(dishTextFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    //设置键盘返回键的文字
    self.searchView.searchTextField.returnKeyType = UIReturnKeySearch;
    
    //读取搜索历史
    [self getSearchHistory];
}
//创建列表
- (void)createTableView{
    self.mianTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30 + self.searchView.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.height - 30 - self.searchView.frame.size.height - 10)];
    [self.view addSubview:self.mianTableView];
    
    
    self.mianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mianTableView.delegate = self;
    self.mianTableView.dataSource = self;
    
    //tableView上面的横线
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(0, 30 + self.searchView.frame.size.height + 9.5, self.view.frame.size.width, 0.5)];
    label.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [self.view addSubview:label];
    
}

//滑动屏幕取消键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}

//取消按钮响应方法
- (void)clickCancelButton:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//搜索框响应方法
- (void)dishTextFieldDidChange:(UITextField *)sender{
    [self.searchArray removeAllObjects];
    self.isSearch = YES;
    if (sender.text.length > 0) {
        for (NSString * str in self.baseArray) {
            NSRange foundObj=[str rangeOfString:sender.text options:NSCaseInsensitiveSearch];
            
            if (foundObj.length > 0) {
                [self.searchArray addObject:str];
            }
            
        }
    }else{
        [self.searchArray addObjectsFromArray:self.baseArray];
    }
    [self.noneGoodsView removeFromSuperview];
    [self.mianTableView reloadData];
    //[self reloadData];
}

//搜索并取消键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        [textField resignFirstResponder];
        BOOL isAdd = YES;
        for (NSString * str in self.baseArray) {
            if ([textField.text isEqualToString:str]) {
                isAdd = NO;
            }
        }
        if (isAdd) {
            [self.baseArray addObject:textField.text];
            [NSKeyedArchiver archiveRootObject:self.baseArray toFile:SearchHistory];
        }
        //发送网络请求
        self.pageIndex = 0;
        [self sendRequest];
    }
    return YES;
}


#pragma mark -- tableView协议方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.isSearch) {
        self.mianTableView.mj_footer = nil;
        self.mianTableView.mj_header = nil;
    }else{
        [self setupRefresh];
    }
    
    return 1;
}

//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isSearch){
        return 45;
    }else{
        return 110;
    }
}
//设置cell的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.isSearch){
        if (self.searchArray.count > 0) {
            return self.searchArray.count + 2;
        }
        else{
            return 0;
        }
    
    }else{
    
        return self.goodsArray.count;
    }

}
//加载cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSearch) {
        WHSearchViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHSearchViewCell" owner:nil options:nil].lastObject;
        }
        cell.textLabel.font = LDViewFont;
        
        if (indexPath.row == 0) {
            cell.subLabel.text = @"搜索历史";
            cell.subLabel.textColor = ColorFromRGB(0x474747);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        else if (indexPath.row == self.searchArray.count+1) {
            cell.subLabel.text = @"清空历史记录";
            cell.subLabel.textColor = ColorFromRGB(0x474747);
            cell.subLabel.textAlignment = NSTextAlignmentCenter;
        }
        else{
            cell.subLabel.text = self.searchArray[indexPath.row - 1];
        }
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, cell.frame.size.height -0.5, self.view.frame.size.width -10, 0.5)];
        label.backgroundColor = WHColorFromRGB(0xf0f0f0);
        [cell addSubview:label];
        
        return cell;
    }
    else{
        WHSearchGoodCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell2"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHSearchGoodCell" owner:nil options:nil].lastObject;
        }
        WHHomeGoodsModel * good = self.goodsArray[indexPath.row];
        
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
    if (good.star > 0 && good.star < 1.0) {//评分0.5
        
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
    
    if (self.isSearch) {
        if (indexPath.row == 0) {
            
        }
        else if (indexPath.row == self.searchArray.count + 1) {
            //清楚历史，重新归档
            [self.baseArray removeAllObjects];
            [NSKeyedArchiver archiveRootObject:self.baseArray toFile:SearchHistory];
            
            [self.searchArray removeAllObjects];
            [self.mianTableView reloadData];
            //[self reloadData];
        }else{
            
            self.searchView.searchTextField.text = self.searchArray[indexPath.row - 1];
            //发送网络请求
            self.pageIndex = 0;
            [self sendRequest];
        }
        [self.searchView.searchTextField resignFirstResponder];
    }else{
        
        WHHomeGoodsModel * good = self.goodsArray[indexPath.row];
        LDTaoBaoVC * goodVC = [[LDTaoBaoVC alloc]init];
        goodVC.goodsID = good.id;
        [self.navigationController pushViewController:goodVC animated:YES];
        
    }
}

//解档读取数据
- (void)getSearchHistory{
    
    //解档获取数据
    NSMutableArray * array = [[NSMutableArray alloc]init];
    array = [NSKeyedUnarchiver unarchiveObjectWithFile:SearchHistory];
    [self.baseArray addObjectsFromArray:[array copy]];
    //数组倒数
    NSArray * arr = [[array reverseObjectEnumerator] allObjects];
    [self.searchArray addObjectsFromArray:[arr copy]];
    
    [self.mianTableView reloadData];
    //[self reloadData];
}

//网络请求
- (void)sendRequest{
    
    
    [self showWithImageWithString:@"正在搜索"];
    
    NSString * str = [NSString stringWithFormat:@"%@commodityList/",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:self.searchView.searchTextField.text forKey:@"key"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageIndex] forKey:@"pageIndex"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageSize] forKey:@"pageSize"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        [self.mianTableView.mj_footer endRefreshing];
        [self.mianTableView.mj_header endRefreshing];
        
        if (error != nil) {
            
            // 显示失败信息
            [self showFailViewWithString:@"网络错误"];
            LDLog(@"%@",error);
        }else{
            
            NSString * code = [response objectForKey:@"code"] ;
            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
                
                
                
                [self analysisResponse:response];
                
            }else{
                
                // 显示失败信息
                [self showFailViewWithString:[response objectForKey:@"message"]];
            }
            LDLog(@"%@",response);
        }
    }];
}
//解析返回数据
- (void)analysisResponse:(id)response{
    self.resultArray = [response objectForKey:@"result"];
    if (self.pageIndex == 0) {
        [self.goodsArray removeAllObjects];
    }
    
    if (self.resultArray.count > 0) {
        for (NSDictionary * dict in self.resultArray) {
            WHHomeGoodsModel * good = [WHHomeGoodsModel paresGoodWithDictionary:dict];
            [self.goodsArray addObject:good];
        }
        [self.noneGoodsView removeFromSuperview];
        self.isSearch = NO;
        [self dismissHDLoading];
        [self.mianTableView reloadData];
        //[self reloadData];
    }
    else{
        if (self.pageIndex == 0){
            [self dismissHDLoading];
            [self createNoneGoodsView];
        
        }
    }
    
}
- (void)createNoneGoodsView{
    self.noneGoodsView = [WHNoneGoodsView view];
    self.noneGoodsView.frame = self.mianTableView.frame;
    self.noneGoodsView.TishiLabel.text = @"未搜索到商品";
    [self.view addSubview:self.noneGoodsView];

}

- (void)reloadData{
    if (!self.isSearch) {
        [self setupRefresh];
    }
    
    [self.mianTableView reloadData];
}
@end
