//
//  LDBusnessController.m
//  HDJFKJ
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBusnessController.h"
#import "LDBeiYongCell.h"
#import "LDHeaderCell.h"
#import "LDBeiYoneDownCell.h"
#import "LDTaoBaoVC.h"
#import "MJRefresh.h"
#import "LDTaoBaoVC.h"

#define heightProportion 200 * LDScreenHeight / 667
#define pageSize @"10"
@interface LDBusnessController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  头部试图数据模型
 */
@property (nonatomic,strong) LDBusinessDetailHeaderModel * headerModel;
/**
 *  cell数据模型
 */
@property (nonatomic,strong) LDBusinessDetailCellModel * cellModel;
//商品数据源
@property (nonatomic,strong) NSMutableArray * cellDataArray;
//上拉数据源
@property (nonatomic,strong) NSMutableArray * array;

@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation LDBusnessController
static NSString * const LDBeiYong = @"LDBeiYongCell";
static NSString * const HeaderCell = @"LDHeaderCell";
static NSString * const downCell = @"downCell";
- (NSMutableArray *)cellDataArray
{
    if (!_cellDataArray) {
        
        _cellDataArray = [NSMutableArray array];
        
    }
    
    return _cellDataArray;
}
- (NSMutableArray *)array
{
    if (!_array) {
        
        _array = [NSMutableArray array];
        
    }
    
    return _array;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupRefesh];
    
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupRefesh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoods)];
}

- (void)loadNewUsers{
    
    self.pageIndex = 0;
    
    [self.cellDataArray removeAllObjects];
    
    [self.array removeAllObjects];
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@detail/business",KBaseUrl];
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageIndex] forKey:@"pageIndex"];
    
    [params setObject:pageSize forKey:@"pageSize"];
    
    [params setObject:[LDGoodsIDAndZhuanAnId sharedInstance].busnessID forKey:@"businessId"];
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^( id response, NSError *error) {
        
        if (error != nil) {
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
        
            [self.tableView.mj_header endRefreshing];

        }else{
            
            [self dismissHDLoading];
            
            LDLog(@"%@",response);
            
            [self.tableView.mj_header endRefreshing];
            
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                if (backInfo.result != nil) {
                    self.headerModel = [LDBusinessDetailHeaderModel mj_objectWithKeyValues:backInfo.result];
                    
                    self.array  = [LDBusinessDetailCellModel mj_objectArrayWithKeyValuesArray:self.headerModel.list];
                    
                    [self.cellDataArray addObjectsFromArray:self.array];
                }
                [self.tableView reloadData];
                
                [self checkFooterState];
            }
            else{
                [self showFailViewWithString:backInfo.message];
            }
            

        }
        
    }];


}
- (void)loadMoreGoods{
    
    self.pageIndex++;

    NSString * str = [NSString stringWithFormat:@"%@detail/business",KBaseUrl];
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDGoodsIDAndZhuanAnId sharedInstance].busnessID forKey:@"businessId"];

    
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageIndex] forKey:@"pageIndex"];
    
    [params setObject:pageSize forKey:@"pageSize"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^( id response, NSError *error) {
        
        if (error != nil) {
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
        
            [self.tableView.mj_header endRefreshing];

            
        }else{
            
            LDLog(@"%@",response);
            
            /** 3.解析返回信息  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                if (backInfo.result != nil) {
                    self.headerModel = [LDBusinessDetailHeaderModel mj_objectWithKeyValues:backInfo.result];
                    
                    self.array  = [LDBusinessDetailCellModel mj_objectArrayWithKeyValuesArray:self.headerModel.list];
                }
                
            }
            
            LDLog(@"%lu",(unsigned long)self.array.count);
            
            for (LDBusinessDetailCellModel * model in self.array) {
                
                LDLog(@"%@",model.id);
            }
            
            LDLog(@"%lu",(unsigned long)self.cellDataArray.count);
            
            [self.cellDataArray addObjectsFromArray:self.array];
            
            LDLog(@"%lu",(unsigned long)self.cellDataArray.count);
            
            [self.tableView reloadData];
            
            [self checkFooterState];
            
            
        }
        
    }];

}

- (void)topButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)checkFooterState{
    
    if (self.array.count == [pageSize integerValue]) {//该商户下还有商品
        
        [self.tableView.mj_footer endRefreshing];
        
        
    }else{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }

    
}


- (void)setupTableView{
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDBeiYongCell class]) bundle:nil] forCellReuseIdentifier:LDBeiYong];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDHeaderCell class]) bundle:nil] forCellReuseIdentifier:HeaderCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDBeiYoneDownCell class]) bundle:nil] forCellReuseIdentifier:downCell];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return self.cellDataArray.count;
        
    }else{
        
        return 2;
    
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.section == 0)) {
        
       
        
        if ((indexPath.row == 0)) {
            
            LDHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:HeaderCell];
            
            [cell.backButton addTarget:self action:@selector(topButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            cell.headerModel = self.headerModel;
            
            
             cell.hidden = (self.headerModel.piclist.count == 0);
            
             return cell;
            
        }else{
            
            LDBeiYongCell *cell = [tableView dequeueReusableCellWithIdentifier:LDBeiYong];
            
            cell.headerModel = self.headerModel;
            
             cell.hidden = (self.headerModel.piclist.count == 0);
            
            return cell;
        }
        
    }else{
        
        if (self.cellDataArray.count != 0) {
            
            self.cellModel = self.cellDataArray[indexPath.row];
        }
        
        
        
        LDBeiYoneDownCell * cell = [tableView dequeueReusableCellWithIdentifier:downCell];
        
        cell.cellModel = self.cellModel;
        
        cell.headerModel = self.headerModel;
        if (indexPath.row != 0) {
            cell.topView.alpha = 0;
        }else{
            
            cell.topView.alpha = 0.2;

        }
        return cell;

        

    
    }
    
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return heightProportion;

        }else{
            
            return 95;
        }
        
    }else{
        
        return 110;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 20;

    }else{
        
        return 0.1;

    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==1) {
        
        self.cellModel = self.cellDataArray[indexPath.row];
        
        LDTaoBaoVC * goodsVC = [[LDTaoBaoVC alloc] init];
        
        goodsVC.goodsID = self.cellModel.id;
        
        
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}

@end
