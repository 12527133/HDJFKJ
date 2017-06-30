//
//  LDBeiYongBusniess.m
//  HDJFKJ
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBeiYongBusniess.h"
#import "LDBeiYongCell.h"
#import "LDBusinessDetailHeaderModel.h"
#import "LDBeiYoneDownCell.h"
#import "LDGoodsDetailViewController.h"
#import "MJRefresh.h"
#import "LDGoodsDetailCell.h"
#import "LDGoodsDetailViewController.h"
@interface LDBeiYongBusniess ()
/**
 *  头部试图数据模型
 */
@property (nonatomic,strong) LDBusinessDetailHeaderModel * headerModel;
/**
 *  cell数据模型
 */
@property (nonatomic,strong) LDBusinessDetailCellModel * cellModel;
@property (nonatomic,strong) NSArray * cellDataArray;

@end

@implementation LDBeiYongBusniess

static NSString * const LDBeiYong = @"LDBeiYongCell";
static NSString * const LDBeiYongDown = @"DownCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDBeiYongCell class]) bundle:nil] forCellReuseIdentifier:LDBeiYong];
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDBeiYoneDownCell class]) bundle:nil] forCellReuseIdentifier:LDBeiYongDown];
    
    self.navigationItem.title  =@"商户详情";
    self.view.backgroundColor = LDBackroundColor;
    
    //添加刷新控件
    [self setupRefresh];
}


/**
 *  发送网络请求
 */
- (void)sendRequest{
    
    [HDLoading showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@detail/business",KBaseUrl];
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params setObject:[LDGoodsIDAndZhuanAnId sharedInstance].busnessID forKey:@"businessId"];
    
    LDLog(@"%@",[LDGoodsIDAndZhuanAnId sharedInstance].busnessID);
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^( id response, NSError *error) {
        
        if (error != nil) {
            //[self.tableView.mj_header endRefreshing];
            [HDLoading showFailViewWithString:@"网络错误"];
        }else{
            [HDLoading dismissHDLoading];
            self.headerModel = [LDBusinessDetailHeaderModel mj_objectWithKeyValues:response[@"result"]];
            
            self.cellDataArray = [LDBusinessDetailCellModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"list"]];
            
//            LDLog(@"%@",self.headerModel.piclist);

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        
    }];
    
}
- (void)loadMoreGoods{
    
//    LDLogFunc;
}
- (void)setupRefresh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(sendRequest)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
    //BackFooter
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoods)];
    
    self.tableView.mj_footer.hidden = YES;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.1;
    }else{
        
        return 30;
    
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView * header = [UIView new];
        UILabel * lable = [UILabel new];
        lable.text = @"全部商品";
        lable.font = [UIFont systemFontOfSize:11];
        [header addSubview:lable];
        [lable makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(LDPadding);
            make.right.top.bottom.equalTo(header);
        }];
        
        return header;
    }else{
    
        return nil;
    }
    

}
/**
 *  返回多少行cell
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return 1;
        
    }else if (section == 1){
        
        return 1;
        
    }else{
    
        return self.cellDataArray.count;
    
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        LDBeiYongCell *cell = [tableView dequeueReusableCellWithIdentifier:LDBeiYong];
        cell.headerModel = self.headerModel;
        return cell;
        
    }else if (indexPath.section == 1){
        
        LDBeiYongCell *cell = [tableView dequeueReusableCellWithIdentifier:LDBeiYong];
        cell.headerModel = self.headerModel;
        return cell;

        
    }else{
        
        self.cellModel = self.cellDataArray[indexPath.row];
        LDBeiYoneDownCell *cell = [tableView dequeueReusableCellWithIdentifier:LDBeiYongDown];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell.cellModel = self.cellModel;
        cell.headerModel = self.headerModel;
        return cell;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1){
        return 90;

    }else{
    
        return 120;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==1) {
        self.cellModel = self.cellDataArray[indexPath.row];

        LDGoodsDetailViewController * goodsVC = [[LDGoodsDetailViewController alloc] init];
        
        goodsVC.goodsID = self.cellModel.id;
        goodsVC.fromWhere = self.cellModel.id;
        
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;

    }else{
    
        return 20;
    }


}


- (NSArray *)cellDataArray
{
    if (!_cellDataArray) {
        
        _cellDataArray = [NSArray array];
        
    }
    
    return _cellDataArray;
}
#pragma mark - tabbleView初始化方法,返回Group模式
-(instancetype)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    
    return self;
}

@end
