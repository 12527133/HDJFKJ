//
//  LDGoodsDetailsViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/24.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDGoodsDetailsViewController.h"
#import "LDDiscoverViewCell.h"
#import "LDDiscoverViewController.h"
#import "LDDiscoverModel.h"
#import "LDDiscoverViewCell.h"
#import "SDCycleScrollView.h"
#import "LDDiscoverBusinessDetail.h"
#import "LDGoodsDetailsHeaderView.h"
#import "LDBusinessAndPlaceView.h"
#import "LDGodsDetailViewCell.h"
#import "LDBusinessDetailHeaderModel.h"
#import "LDBusinessAndPlaceView.h"
@interface LDGoodsDetailsViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) LDGoodsDetailsHeaderView * headerView;
@property (nonatomic,strong) NSArray * cellDataArray;

@property (nonatomic,strong) LDBusinessDetailHeaderModel * headerModel;

@property (nonatomic,strong) LDBusinessDetailCellModel * cellModel;

@end

@implementation LDGoodsDetailsViewController

static NSString * const GodsDetailViewCell = @"LDGodsDetailViewCell";
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
    
    self.tableView.rowHeight = 40;
    self.tableView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0);
    
    return self;
}
//头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.headerView = [[LDGoodsDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 320)];
    
    self.headerView.backgroundColor = [UIColor redColor];
    
    self.tableView.tableHeaderView = self.headerView;
    
    
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, LDScreenWidth, 300) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    
    cycleScrollView3.imageURLStringsGroup = self.headerModel.piclist;
    
    [self.headerView.headerImageView addSubview:cycleScrollView3];
    
//    self.headerView.headerImageView.hidden = YES;
    
    self.headerView.separatorLine.height = 300;
    self.headerView.separatorLine.backgroundColor = [UIColor redColor];

//    self.headerView.godsName.text = self.headerModel.name;
//    self.headerView.godsNumber.text = self.headerModel.phone;
//    self.headerView.godsPlace.text = self.headerModel.address;
    
    return self.headerView;
    
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;//section头部高度
}


//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 1)];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor brownColor];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDGodsDetailViewCell class]) bundle:nil] forCellReuseIdentifier:GodsDetailViewCell];
    
    [self sendRequest];
}
- (void)sendRequest{
    
    NSString * str = @"http://123.56.136.151:8180/STCash/mobile/detail/business";
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:@"76" forKey:@"businessId"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            // 显示失败信息
            [SVProgressHUD showErrorWithStatus:@"加载信息失败!"];
            LDLog(@"%@",error);
            
            
        }else{
            
            [SVProgressHUD dismiss];
            
            self.headerModel = [LDBusinessDetailHeaderModel mj_objectWithKeyValues:response[@"result"]];
            
            self.cellDataArray = [LDBusinessDetailCellModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"list"]];
            
            LDLog(@"%@",response);
            
            [self.tableView reloadData];
            
        }
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }//self.cellDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    if (indexPath.section == 0) {
        
        LDBusinessAndPlaceView * cell = [[LDBusinessAndPlaceView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 80)];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        
        LDGodsDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GodsDetailViewCell];
        
        return cell;

    }

//    LDBusinessDetailCellModel * cellModel = self.cellDataArray[indexPath.row];
//    
//    //设置商品名称
//    cell.godsName.text = cellModel.name;
//    //购买数
//    cell.buyCount.text = cellModel.sale;
//    //地址
//    cell.place.text = self.headerModel.address;
//    //左侧商品图片
//    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.pic] placeholderImage:[UIImage imageNamed:@"header_cry_icon"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//        LDLog(@"下载进度：%f", 1.0 * receivedSize / expectedSize);
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        LDLog(@"下载完成");
//    }];
//    return cell;
}


@end
