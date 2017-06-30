//
//  LDBusinessDetails.m
//  HDJFKJ
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//
#import "SDCycleScrollView.h"
#import "LDDiscoverBusinessDetail.h"
#import "LDGodsDetailViewCell.h"
#import "LDGoodsDetailsVC.h"
#import "LDBusinessDetailHeaderModel.h"
@interface LDDiscoverBusinessDetail ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) NSArray * cellDataArray;
/**
 *  头部试图数据模型
 */
@property (nonatomic,strong) LDBusinessDetailHeaderModel * headerModel;
/**
 *  cell数据模型
 */
@property (nonatomic,strong) LDBusinessDetailCellModel * cellModel;
@end

@implementation LDDiscoverBusinessDetail

static NSString * const GodsDetailViewCell = @"LDGodsDetailViewCell";
/**
 *  全部商品  视图高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
/**
 *  tabbleView  section头部视图
 */
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * lable = [[UILabel alloc] init];
    lable.text = @"全部商品";
    lable.font = [UIFont systemFontOfSize:15];
    UIView * sectionHeaderView = [[UIView alloc]init];
    [sectionHeaderView addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionHeaderView).offset(10);
        make.centerY.equalTo(sectionHeaderView);
        make.right.equalTo(sectionHeaderView);
    }];
    return sectionHeaderView;
}
/**
 *  返回多少行cell
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellDataArray.count;
}
- (LDGodsDetailViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LDGodsDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GodsDetailViewCell];
    
    self.cellModel = self.cellDataArray[indexPath.row];
    
    //设置商品名称
    cell.godsName.text = self.cellModel.name;
    //购买数
    cell.buyCount.text = self.cellModel.sale;
    //地址
    cell.place.text = self.headerModel.address;
    
    //左侧商品图片
    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.cellModel.pic] placeholderImage:[UIImage imageNamed:@"header_cry_icon"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        LDLog(@"下载进度：%f", 1.0 * receivedSize / expectedSize);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        LDLog(@"下载完成");
    }];
    
    
    return cell;
}



/**
 *  底部视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 1)];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //背景色
    self.tableView.backgroundColor = [UIColor whiteColor];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDGodsDetailViewCell class]) bundle:nil] forCellReuseIdentifier:GodsDetailViewCell];

    //cell分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //title
    self.navigationItem.title = @"商户详情";
}


/**
 *  商户唯一标识
 *
 *  @param busnessID busnessID description
 */
-(void)setBusnessID:(NSString *)busnessID{

    _busnessID = busnessID;
    LDLog(@"%@-===-%@",_busnessID,busnessID);
    [self sendRequest];
}

/**
 *  发送网络请求
 */
- (void)sendRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@detail/business",KBaseUrl];
    

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.busnessID forKey:@"businessId"];
    
    LDLog(@"%@",[params objectForKey:@"businessId"]);
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            // 显示失败信息
            [SVProgressHUD showErrorWithStatus:@"加载信息失败!"];
            LDLog(@"%@",error);
            
            
        }else{
            
            [SVProgressHUD dismiss];
        
            self.headerModel = [LDBusinessDetailHeaderModel mj_objectWithKeyValues:response[@"result"]];
            
            self.cellDataArray = [LDBusinessDetailCellModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"list"]];
            
            for (int i = 0; i < self.cellDataArray.count; i++) {
                
                LDBusinessDetailCellModel * yyModel = self.cellDataArray[i];
                
                LDLog(@"%@",yyModel.id);
            }
            
//            LDLog(@"%@",response);
            


            
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self creatHeaderView];
            });
            
            LDLog(@"%@",self.headerModel.piclist);
            [self.tableView reloadData];

        }
        
    }];
    
}
/**
 *  创建tableView头部视图
 */
- (void)creatHeaderView{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 260)];
    //    headerView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = headerView;
    
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, LDScreenWidth, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = self.headerModel.piclist;
    [headerView addSubview:cycleScrollView3];
    
    //商品名称
    UILabel * goodsName = [UILabel new];
    [headerView addSubview:goodsName];
    
    goodsName.text = self.headerModel.name;
    goodsName.font = [UIFont systemFontOfSize:17];
    [goodsName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cycleScrollView3.bottom).offset(10);
        make.left.equalTo(headerView).offset(LDPadding);
        make.right.equalTo(headerView).offset(-LDPadding);
        make.height.equalTo(40);
    }];
    //五颗星
    UIImageView * image1 = [UIImageView new];
    UIImageView * image2 = [UIImageView new];
    UIImageView * image3 = [UIImageView new];
    UIImageView * image4 = [UIImageView new];
    UIImageView * image5 = [UIImageView new];
    
    image1.image = [UIImage imageNamed:@"star"];
    image2.image = [UIImage imageNamed:@"star"];
    image3.image = [UIImage imageNamed:@"star"];
    image4.image = [UIImage imageNamed:@"star"];
    image5.image = [UIImage imageNamed:@"star"];
    
    [headerView addSubview:image2];
    [headerView addSubview:image3];
    [headerView addSubview:image4];
    [headerView addSubview:image5];
    [headerView addSubview:image1];
    
    [image1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom);
        make.left.equalTo(headerView).offset(LDPadding);
    }];
    [image2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom);//.offset(8);
        make.left.equalTo(image1.right).offset(LDPadding);
    }];
    [image3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom);//.offset(8);
        make.left.equalTo(image2.right).offset(LDPadding);
    }];
    [image4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom);//.offset(8);
        make.left.equalTo(image3.right).offset(LDPadding);
    }];
    [image5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom);//.offset(8);
        make.left.equalTo(image4.right).offset(LDPadding);
    }];
    
    //购买数
    UILabel * buyCount = [UILabel new];
    [headerView addSubview:buyCount];
    buyCount.alpha = 0.5;
    buyCount.numberOfLines = 0;
    buyCount.font = [UIFont systemFontOfSize:10];
    buyCount.text = self.headerModel.privilege;
    [buyCount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image5.right).offset(15);
        make.top.equalTo(image5);
    }];
    
    //人名币
    UILabel * yuan = [UILabel new];
    yuan.text  =@"￥";
    yuan.textColor = [UIColor redColor];
    yuan.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:yuan];
    
    [yuan makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(10);
        make.top.equalTo(buyCount.bottom).offset(10);
    }];
    
    //多少钱
    UILabel * moneyCount = [UILabel new];
    moneyCount.text  =@"4400";
    moneyCount.textColor = [UIColor redColor];
    moneyCount.font = [UIFont systemFontOfSize:17];
    [headerView addSubview:moneyCount];
    [moneyCount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yuan.right);
        make.top.equalTo(buyCount.bottom).offset(10);
    }];
    
    //免
    UIImageView * freeImage = [UIImageView new];
    freeImage.image = [UIImage imageNamed:@"free"];
    [headerView addSubview:freeImage];
    [freeImage sizeToFit];
    [freeImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyCount.right).offset(20);
        make.centerY.equalTo(moneyCount);
    }];
    
    //首付
    UILabel * firstPay = [UILabel new];
    [headerView addSubview:firstPay];
    firstPay.textColor = [UIColor redColor];
    firstPay.font = [UIFont systemFontOfSize:12];
    firstPay.text = [NSString stringWithFormat:@"0首付 + ...."];
    [firstPay makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(freeImage.right).offset(7);
        make.bottom.equalTo(freeImage.bottom);
    }];
    
    //分割线
    UIView * HeaderLine = [UIView new];
    HeaderLine.backgroundColor = [UIColor brownColor];
    HeaderLine.alpha = 0.2;
    [headerView addSubview:HeaderLine];
    [HeaderLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(freeImage.bottom).offset(LDPadding);
        make.height.equalTo(10);
    }];
    
}
/**
 *  返回怎样的cell
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LDBusinessDetailCellModel * yyModel = self.cellDataArray[indexPath.row];
    
    /**
     *  商品ID
     */
    LDLog(@"本控制器模型商品ID%@",yyModel.id);
    
    
    LDGoodsDetailsVC * goodsVC = [[LDGoodsDetailsVC alloc] init];
    
    goodsVC.goodsID = yyModel.id;
    
    LDLog(@"传值Model商品ID%@",goodsVC.goodsID);
    
    [self.navigationController pushViewController:goodsVC animated:YES];
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
    
    self.tableView.rowHeight = 150;
    
    
    return self;
}

@end
