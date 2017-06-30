//
//  LDFirstViewController.m
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDFirstViewController.h"
#import "WHLeftButtonView.h"
#import "WHRightButtonView.h"
#import "WHClassifySubView.h"
#import "WHClassifyContentView.h"
#import "WHMessageController.h"
#import "WHSearchController.h"
#import "WHShouYeModel.h"
#import "WHBannerdownModel.h"
#import "WHBannerModel.h"
#import "WHCategoryadcommoditys.h"
#import "WHCommodity.h"

#import "WHGoodsListController.h"
#import "LDTaoBaoVC.h"
#import "WHImageSaveAndLoad.h"
#import "WHUserLoginModel.h"
#import "LDSignInViewController.h"
#import "LDThirdViewController.h"
#import "CashLoanController.h"
#import "LDPaymentPasswordController.h"
#import "WHWorkViewController.h"
#import "LDContactInformationViewController.h"
#import "LDNavgationVController.h"
#import "GYZChooseCityController.h"
#import "LDBaseInformationTableViewController.h"
#import "LDPostIDCard.h"
#import "WHSaveAndReadInfomation.h"

#import "HDBaseButton.h"
#import "LDTaoBaoVC.h"

@interface LDFirstViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,GYZChooseCityDelegate>

// 导航栏左侧按钮视图
@property (nonatomic, strong) WHLeftButtonView * leftTitleButtonView;
// 导航栏右侧按钮视图
@property (nonatomic, strong) WHRightButtonView * rightTitleButtonView;
//还款计划视图
@property (nonatomic, strong) UIView * repaymentView;
//还款计划提示Label
@property (nonatomic, strong)  UILabel * rightLabel;
//分类视图
@property (nonatomic, strong) UIView * classifyView;
//广告轮换视图
@property (nonatomic, strong) UIScrollView * advertisementView;
@property (nonatomic, strong) UIPageControl * pageCl;
//控制广告轮换的计时器
@property (nonatomic, strong) NSTimer * timer;
//广告轮换的位置
@property (nonatomic, assign) NSInteger indexAdver;
//轮换广告的模型数组
@property (nonatomic, strong) NSMutableArray * advertisArray;
//轮换广告是顺时针个，还是逆时针
@property (nonatomic, assign) BOOL isShunshizhen;


//固定广告视图
@property (nonatomic, strong) UIView * regularSetView;

@property (nonatomic, strong) NSMutableArray * categoryadcommodityArray;

//ScrolleView用于添加更多内容
@property (nonatomic, strong) UIScrollView * scrollView;

//scrollView的contentSize的大小
@property (nonatomic, assign) float  contentHeight;

//首页模型
@property (nonatomic, strong) NSDictionary * resultDict;
@property (nonatomic, strong)  WHShouYeModel * shouyeModel;

@property (nonatomic, strong) WHUserLoginModel * user;
@property (nonatomic,strong) UITableView *  mapTableView;
@property (nonatomic,assign) BOOL isAdd;
@property (nonatomic,strong) UIWindow * rootWindow;


@end

@implementation LDFirstViewController
//导航栏左侧按钮响应方法
- (void)clickLeftTitleButton:(UIButton *)sender{
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    
    [cityPickerVC setDelegate:self];
    
    // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    [self.navigationController pushViewController:cityPickerVC animated:YES];
    
    
    
    
    
}

#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    //    [chooseCityBtn setTitle:city.cityName forState:UIControlStateNormal];
    self.leftTitleButtonView.titleLabel.text = city.cityName;
    [[NSUserDefaults standardUserDefaults] setObject:city.cityName forKey:@"cityName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)categoryadcommodityArray{
    if (!_categoryadcommodityArray) {
        _categoryadcommodityArray = [[NSMutableArray alloc]init];
    }
    return _categoryadcommodityArray;
}

- (NSMutableArray *)advertisArray{
    if (!_advertisArray) {
        _advertisArray = [[NSMutableArray alloc]init];
    }
    return _advertisArray;
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /** 设置导航栏背景 */
    [self setNavgationBackground];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    /** 设置导航啦背景 */
    [self setNavgationBackgroundWight];
    
}
- (void)setNavgationBackground{
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /** 设置导航栏字体为白色 */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    /** 设置导航背景图 */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    
    /** 是否显示下划线 */
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}
/** 设置二级界面导航栏背景色为白色 */
- (void)setNavgationBackgroundWight{
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    /** 设置导航栏字体为白色 */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHColorFromRGB(0x323232)}];
    
    /** 设置导航背景图 */
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    
    /** 是否显示下划线 */
    self.navigationController.navigationBar.shadowImage = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置试图背景
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    //1.初始化scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    
    _contentHeight= 40 + 200 ;
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _contentHeight);
    _scrollView.backgroundColor = WHColorFromRGB(0xf6f6f6);
    
    
    /**
     * 2.导航栏中间按钮
     **/
    [self createMiddleNavButton];
    
    /**
     * 3.创建左侧导航了按钮
     **/
    [self createLeftNavButton];
    
    /**
     * 4.创建分类视图
     **/
    [self createClassifyView];
    
    /**
     * 5.获取首页数据模型，创建更多试视图
     *   如果数据模型为空，发送网络请求获取数据
     *   如果不为空，暂时根据现有数据创建属性界面，然后请求数据刷新界面
     **/
    
    [self sendRequest];
    
}
#pragma mark -- 根据模型数据直接创建视图
- (void)createMoreSubViews{
    
    NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithFile:ShouYeInfoDict];
    _shouyeModel= [WHShouYeModel paresShouYeWithDictionary:dict];
    //1.更新地区信息
    if ( _shouyeModel.region == nil || _shouyeModel.region.length == 0) {
        
        NSString * area = [NSKeyedUnarchiver unarchiveObjectWithFile:LoacationArea];
        
        if (area != nil) {
            
            self.leftTitleButtonView.titleLabel.text = area;
            
        }else{
            
        }
        
    }else{
        self.leftTitleButtonView.titleLabel.text = _shouyeModel.region;
    }
    
    
    //4.解析轮换广广告列表
    [self analysisBannerWithArray:_shouyeModel.banner];
    
    //5.解析轮换广告下方的广告
    [self analysisBannerdownWithArray:_shouyeModel.bannerdown];
    
    //6.解析分类广告列表
    [self analysisCategoryadcommoditysWithArray:_shouyeModel.categoryadcommoditys];
    
}

#pragma mark -- 创建搜索框视图
- (void)createMiddleNavButton{
    
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120*bili, 30)];
    [button setTitle:@"搜索商品" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickTitleViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.cornerRadius = 15;
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(4,20*bili, 4, 80*bili)];
    
    button.layer.borderWidth = 0;
    
    button.layer.borderColor = [[UIColor clearColor] CGColor];
    
    self.navigationItem.titleView = button;
    
}
#pragma mark -- 点击搜索框
- (void)clickTitleViewButton:(UIButton *)button{
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    WHSearchController * searchController = [[WHSearchController alloc]init];
    
    [self.navigationController pushViewController:searchController animated:YES];
    
}


#pragma mark -- 创建导航栏左侧显示地理位置的按钮
- (void)createLeftNavButton{
    
    /** 导航栏返回按钮  */
    HDBaseButton * backButton = [[HDBaseButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"nav_back_3.0"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBackSuperVC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //初始化当行列左侧按钮的视图
    self.leftTitleButtonView = [WHLeftButtonView view];
    self.leftTitleButtonView.frame = CGRectMake(-100, 0, 64, 30);
    NSString * cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    
    if ((cityName == nil)||(cityName.length == 0)) {
        cityName = @"北京";
    }
    self.leftTitleButtonView.titleLabel.text = cityName;
    [self.leftTitleButtonView.subButton addTarget:self action:@selector(clickLeftTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftTitleButtonView];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem1, negativeSpacer,leftItem, nil];
    
    
}
/** 返回上一级*/
- (void)clickBackSuperVC:(HDBaseButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark --  创建8个分类视图
- (void)createClassifyView{
    
    NSArray * imageNameArray = @[@"shouji",@"jiaoyu",@"lvyou",@"zufang",@"zuche",@"zhuangxiu",@"meirong",@"xianjin"];
    NSArray * labeTitleArray = @[@"数码贷",@"趣学贷",@"趣旅游",@"安居贷",@"租好车",@"装好房",@"美颜贷",@"现金贷"];
    
    //1.创建分类的背景视图
    _classifyView = [[UIView alloc]initWithFrame:CGRectMake(0, _repaymentView.frame.size.height, self.view.frame.size.width, 200)];
    _classifyView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_classifyView];
    
    float subViewWidth = 50;
    float subViewHeight = 80;
    float distance = (_classifyView.frame.size.width - subViewWidth * 4)/5;
    float subViewY = 0.0;
    
    //2.分类的子视图
    for (int i = 0; i<8; i++) {
        if (i < 4) {
            subViewY = 15;
        }else{
            subViewY = 115;
        }
        
        WHClassifySubView * classifySubView = [WHClassifySubView view];
        classifySubView.frame = CGRectMake(distance + (subViewWidth +distance)*(i%4), subViewY, subViewWidth, subViewHeight);
        [_classifyView addSubview:classifySubView];
        classifySubView.imageView.image = [UIImage imageNamed:imageNameArray[i]];
        classifySubView.label.text = labeTitleArray[i];
        
        [classifySubView.button addTarget:self action:@selector(clickClissify:) forControlEvents:UIControlEventTouchUpInside];
        classifySubView.button.tag = i;
    }
    
    //3.label作为分割线
    UILabel * bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _classifyView.frame.size.height-0.5, _classifyView.frame.size.width, 0.5)];
    bottomLabel.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_classifyView addSubview:bottomLabel];
}
#pragma mark -- 点击分类视图响应方法
- (void)clickClissify:(UIButton *)button{
    NSArray * labeTitleArray = @[@"数码贷",@"趣学贷",@"趣旅游",@"安居贷",@"租好车",@"装好房",@"美颜贷",@"现金贷"];
    
    
    //现金贷不查询商品信息
    if (button.tag == 7){
//        //用户未登陆前去登陆
//        if ([LDUserInformation sharedInstance].token == nil || [LDUserInformation sharedInstance].UserId == nil){
//            LDSignInViewController * signIn = [[LDSignInViewController alloc]init];
//            signIn.indexFlag = 41;
//            [self.navigationController pushViewController:signIn animated:YES];
//            
//            //用户登陆后验证资料是否完善
//        }else{
//            
//            [self yanzhengyonghuziliaoRequest];
//            
//        }
        [self showSuccessViewWithString:@"此功能暂未开通"];
        //非薪金贷查询商品信息
    }else {
        WHGoodsListController * goodsList = [[WHGoodsListController alloc]init];
        goodsList.title = labeTitleArray[button.tag];
        [self.navigationController pushViewController:goodsList animated:YES];
        
    }
    
    
    
}

#pragma mark -- 创建广告banner轮换视图
-(void)createAdvertisementView:(NSArray * )array
{
    
    float currentWidth = self.view.frame.size.width;
    float currentHeight = currentWidth * 240/750;
    _contentHeight += currentHeight;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _contentHeight );
    
    
    //初始化scrollVIew
    
    if (self.advertisementView == nil) {
        _advertisementView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _repaymentView.frame.size.height+_classifyView.frame.size.height + 5,currentWidth , currentHeight)];
        [_scrollView addSubview:_advertisementView];
    }
    
    _advertisementView.backgroundColor = [UIColor whiteColor];
    
    _advertisementView.contentSize = CGSizeMake(currentWidth* array.count, currentHeight);
    _advertisementView.pagingEnabled = YES;
    _advertisementView.showsHorizontalScrollIndicator = NO;
    _advertisementView.showsVerticalScrollIndicator = NO;
    _advertisementView.directionalLockEnabled = YES;
    _advertisementView.bounces = NO;
    _advertisementView.delegate = self;
    
    for (int i = 0; i< array.count; i++) {
        
        WHBannerModel * banner = array[i];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentWidth * i, 0, currentWidth, currentHeight)];
        
        UIImage * bannerImage = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"banner%d.png",i]];
        if (bannerImage == nil) {
            bannerImage = [UIImage imageNamed:@"banner_zhanwei"];
        }
        
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:banner.pic] placeholderImage:bannerImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //下载完成把图片保存在沙河目录
            [WHImageSaveAndLoad saveImage:image withFileName:[NSString stringWithFormat:@"banner%d.png",i] ofType:@"png"];
        }];
        
        
        
        [_advertisementView addSubview:imageView];
        
        //覆盖在图片是的按钮
        HDBaseButton * button = [[HDBaseButton alloc]initWithFrame:imageView.frame];
        button.tag = [banner.id integerValue];
        button.tagString = banner.id;
        [button addTarget:self action:@selector(clickBannerButton:) forControlEvents:UIControlEventTouchUpInside];
        [_advertisementView addSubview:button];
        
        
    }
    
    _pageCl = [[UIPageControl alloc] initWithFrame:CGRectMake(LDScreenWidth -80,  _repaymentView.frame.size.height+_classifyView.frame.size.height+currentHeight-10, 100, 10)];
    [_scrollView addSubview:_pageCl];
    _pageCl.currentPage=0;
    _pageCl.hidesForSinglePage = YES;
    _pageCl.currentPageIndicatorTintColor = WHColorFromRGB(0xd33a31);
    
    _pageCl.numberOfPages = array.count;
    
    self.indexAdver = 0;
    
    
    if (array.count < 2) {
        [_timer invalidate];
    }else{
        if (!_timer) {
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeCurrentView) userInfo:nil repeats:YES];
        }
    }
    
    
    //3.label作为分割线
    UILabel * bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _advertisementView.frame.size.height-0.5, LDScreenWidth *array.count, 0.5)];
    bottomLabel.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_advertisementView addSubview:bottomLabel];
    
    UILabel * topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth*array.count, 0.5)];
    topLabel.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_advertisementView addSubview:topLabel];
    
}
#pragma mark -- 广告Banner的切换算法
-(void)changeCurrentView
{
    if (self.indexAdver == self.advertisArray.count - 1) {
        self.isShunshizhen = NO;
    }
    
    if (self.indexAdver == 0) {
        self.isShunshizhen = YES;
    }
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.advertisementView.contentOffset = CGPointMake(LDScreenWidth * (float)_indexAdver, 0);
        _pageCl.currentPage = _indexAdver;
        if (self.isShunshizhen) {
            _indexAdver += 1;
        }
        else{
            _indexAdver -= 1;
        }
    }];
}
#pragma mark -- 显示Banner轮滑视图上的小圆点
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageCl.currentPage = page;
    
}

#pragma mark -- 轮换视图的点击响应方法,轮播试图下的固定试图
- (void)clickBannerButton:(HDBaseButton * )sender{
    
    
    LDTaoBaoVC * goodVC = [[LDTaoBaoVC alloc]init];
    goodVC.goodsID = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self.navigationController pushViewController:goodVC animated:YES];}

#pragma mark -- Banner下方固定的广告视图
- (void)createRagularSetViewWithArray:(NSArray *)array{
    
    float currentWidth = self.view.frame.size.width;
    float currentHeight = currentWidth * 400/750;
    _contentHeight += currentHeight;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _contentHeight );
    
    
    //1.初始化固定广告背景视图
    
    if (self.regularSetView == nil) {
        _regularSetView = [[UIView alloc]initWithFrame:CGRectMake(0, _repaymentView.frame.size.height+_classifyView.frame.size.height+ 10 + _advertisementView.frame.size.height, currentWidth, currentHeight)];
    }
    
    _regularSetView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_regularSetView];
    
    //2.左侧图片
    UIImageView * headfreeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, currentHeight * 250/400, currentHeight)];
    headfreeImageView.image = [UIImage imageNamed:@"商品 1:1"];;
    [_regularSetView addSubview:headfreeImageView];
    

    //3.优惠商品图片
    UIImageView * topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headfreeImageView.frame.size.width, 0, currentWidth - headfreeImageView.frame.size.width, currentHeight/2)];
    topImageView.image = [UIImage imageNamed:@"商品 1:1"];
    [_regularSetView addSubview:topImageView];
    
    
    //4.左侧广告图片
    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headfreeImageView.frame.size.width, topImageView.frame.size.height, topImageView.frame.size.width/2, currentHeight/2)];
    leftImageView.image = [UIImage imageNamed:@"商品 1:1"];
    [_regularSetView addSubview:leftImageView];
    

    //5.右侧广告视图
    UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headfreeImageView.frame.size.width + leftImageView.frame.size.width, topImageView.frame.size.height, topImageView.frame.size.width/2, currentHeight/2)];
    rightImageView.image = [UIImage imageNamed:@"商品 1:1"];
    [_regularSetView addSubview:rightImageView];
    
    if (array.count == 1) {
        [self headerFreeImageView:array headerFreeImageView:headfreeImageView];
    }
    if (array.count == 2) {
        [self headerFreeImageView:array headerFreeImageView:headfreeImageView];
        [self topImageView:array topImageView:topImageView];
    }
    if (array.count == 3) {
        [self headerFreeImageView:array headerFreeImageView:headfreeImageView];
        [self topImageView:array topImageView:topImageView];
        [self leftImageView:array leftImageView:leftImageView];
    }
    if (array.count > 3) {
        [self headerFreeImageView:array headerFreeImageView:headfreeImageView];
        [self topImageView:array topImageView:topImageView];
        [self leftImageView:array leftImageView:leftImageView];
        [self rightImageView:array rightImageView:rightImageView];
    }
    
    
    
    //6.分隔线
    UILabel * bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _regularSetView.frame.size.height-0.5, _regularSetView.frame.size.width, 0.5)];
    bottomLabel.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_regularSetView addSubview:bottomLabel];
    
    UILabel * topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _regularSetView.frame.size.width, 0.5)];
    topLabel.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_regularSetView addSubview:topLabel];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(headfreeImageView.frame.size.width, 0, 0.5, _regularSetView.frame.size.height)];
    label1.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_regularSetView addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(headfreeImageView.frame.size.width, topImageView.frame.size.height, topImageView.frame.size.width, 0.5)];
    label2.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_regularSetView addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(headfreeImageView.frame.size.width + leftImageView.frame.size.width, leftImageView.frame.size.height, 0.5, leftImageView.frame.size.height)];
    label3.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [_regularSetView addSubview:label3];
}

- (void)headerFreeImageView:(NSArray *)array headerFreeImageView:(UIImageView *)headfreeImageView {


    WHBannerdownModel * bannerdown = array[0];
    
    UIImage * bannerdownheadfree = [WHImageSaveAndLoad loadImage:@"bannerdownheadfree.png"];
    if (bannerdownheadfree == nil) {
        bannerdownheadfree = [UIImage imageNamed:@"商品 1:1"];
    }
    
    
    [headfreeImageView sd_setImageWithURL:[NSURL URLWithString:bannerdown.pic] placeholderImage:bannerdownheadfree options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //下载完成把图片保存在沙河目录
        [WHImageSaveAndLoad saveImage:image withFileName:@"bannerdownheadfree.png" ofType:@"png"];
    }];
    
    
    
    //覆盖在图片是的按钮
    HDBaseButton * headfreeButton = [[HDBaseButton alloc]initWithFrame:headfreeImageView.frame];
    headfreeButton.tag = [bannerdown.id integerValue];
    headfreeButton.tagString = bannerdown.id;
    [headfreeButton addTarget:self action:@selector(clickBannerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_regularSetView addSubview:headfreeButton];
}

- (void)topImageView:(NSArray *)array topImageView:(UIImageView *)topImageView {

    WHBannerdownModel * bannerdown2 = array[1];
    
    UIImage * bannerdowntop = [WHImageSaveAndLoad loadImage:@"bannerdowntop.png"];
    
    if (bannerdowntop == nil) {
        bannerdowntop = [UIImage imageNamed:@"商品 1:1"];
    }
    
    [topImageView sd_setImageWithURL:[NSURL URLWithString:bannerdown2.pic] placeholderImage:bannerdowntop options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [WHImageSaveAndLoad saveImage:image withFileName:@"bannerdowntop.png" ofType:@"png"];
        
    }];
    
    
    //覆盖在图片是的按钮
    HDBaseButton * topButton = [[HDBaseButton alloc]initWithFrame:topImageView.frame];
    topButton.tag = [bannerdown2.id integerValue];
    topButton.tagString = bannerdown2.id;
    [topButton addTarget:self action:@selector(clickBannerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_regularSetView addSubview:topButton];
}

- (void)leftImageView:(NSArray *)array leftImageView:(UIImageView *)leftImageView {


    WHBannerdownModel * bannerdown3 = array[2];
    
    UIImage * bannerdownleft = [WHImageSaveAndLoad loadImage:@"bannerdownleft.png"];
    
    if (bannerdownleft == nil) {
        bannerdownleft = [UIImage imageNamed:@"商品 1:1"];
    }
    
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:bannerdown3.pic] placeholderImage:bannerdownleft options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [WHImageSaveAndLoad saveImage:image withFileName:@"bannerdownleft.png" ofType:@"png"];
        
    }];
    
    
    //覆盖在图片是的按钮
    HDBaseButton * letfButton = [[HDBaseButton alloc]initWithFrame:leftImageView.frame];
    letfButton.tag = [bannerdown3.id integerValue];
    letfButton.tagString = bannerdown3.id;
    [letfButton addTarget:self action:@selector(clickBannerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_regularSetView addSubview:letfButton];
}

- (void)rightImageView:(NSArray *)array rightImageView:(UIImageView *)rightImageView{

    WHBannerdownModel * bannerdown4 = array[3];
    
    UIImage * bannerdownright = [WHImageSaveAndLoad loadImage:@"bannerdownright.png"];
    
    if (bannerdownright == nil) {
        bannerdownright = [UIImage imageNamed:@"商品 1:1"];
    }
    
    [rightImageView sd_setImageWithURL:[NSURL URLWithString:bannerdown4.pic] placeholderImage:bannerdownright options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [WHImageSaveAndLoad saveImage:image withFileName:@"bannerdownright.png" ofType:@"png"];
    }];
    
    //覆盖在图片是的按钮
    HDBaseButton * rightButton = [[HDBaseButton alloc]initWithFrame:rightImageView.frame];
    rightButton.tag = [bannerdown4.id integerValue];
    rightButton.tagString = bannerdown4.id;
    [rightButton addTarget:self action:@selector(clickBannerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_regularSetView addSubview:rightButton];
}


#pragma mark -- 创建分类详细视图
- (void)createMoreClassifyContentView:(WHCategoryadcommoditys *)categoryadcommodity ViewY:(int) y{
    //NSArray * labeTitleArray = @[@"数码贷",@"趣学贷",@"趣旅游",@"安居贷",@"租好车",@"装好房",@"美颜贷",@"现金贷"];
    
    float viewBaseY = _regularSetView.frame.size.height + _advertisementView.frame.size.height + _classifyView.frame.size.height + _repaymentView.frame.size.height + 15;
    NSLog(@"%f",viewBaseY);
    float  scrollViewHeight = viewBaseY;
    float currentWidth = self.view.frame.size.width;
    float currentHeight = self.view.frame.size.width * 394 / 750;
    
    _contentHeight += currentHeight;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _contentHeight );
    
    WHClassifyContentView * classifyContentView = [WHClassifyContentView view];
    
    classifyContentView.frame = CGRectMake(0, viewBaseY +(5+currentHeight)*y,currentWidth, currentHeight);
    classifyContentView.classifyTitleLabel.text = categoryadcommodity.category;
    [_scrollView addSubview: classifyContentView];
    
    classifyContentView.moreButton.tag = y;
    [classifyContentView.moreButton addTarget:self action:@selector(clickClissifyMore:) forControlEvents:UIControlEventTouchUpInside];
    
    scrollViewHeight += (currentHeight + 5);
    
    for (int i = 0; i < categoryadcommodity.commoditys.count; i++) {
        NSDictionary * dict = categoryadcommodity.commoditys[i];
        
        WHCommodity * commodity = [WHCommodity paresCommodityWithDictionary:dict];
        
        if (i == 0) {
            classifyContentView.leftadvertisementTitleLabel.text = commodity.name;
            classifyContentView.leftadvertisementStagesLabel.text = [NSString stringWithFormat:@"%.2f x %ld期",commodity.periodamount,(long)commodity.duration];
            
            UIImage * classifyleft = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"classifyleft%d.png",y ]];
            if (classifyleft == nil) {
                classifyleft = [UIImage imageNamed:@"商品 1:1"];
            }
            
            [classifyContentView.leftadvertisementImageView sd_setImageWithURL:[NSURL URLWithString:commodity.pic] placeholderImage:classifyleft options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [WHImageSaveAndLoad saveImage:image withFileName:[NSString stringWithFormat:@"classifyleft%d.png",y ] ofType:@"png"];
            }];
            
            classifyContentView.leftadvertisementImageView.layer.cornerRadius = 0.0;
            classifyContentView.leftadvertisementImageView.layer.borderColor = [WHColorFromRGB(0xf0f0f0) CGColor];
            classifyContentView.leftadvertisementImageView.layer.borderWidth = 0.5f;
            
            classifyContentView.leftButton.tag = [commodity.id integerValue];
            [classifyContentView.leftButton setTitle:commodity.id forState:UIControlStateNormal];
            
            [classifyContentView.leftButton addTarget:self action:@selector(clickClissifyMoreDetail:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if (i == 1){
            classifyContentView.middleadvertisementTitleLabel.text = commodity.name;
            classifyContentView.middleadvertisementStagesLabel.text = [NSString stringWithFormat:@"%.2f x %ld期",commodity.periodamount,(long)commodity.duration];
            
            
            UIImage * classifymiddle = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"classifymiddle%d.png",y ]];
            if (classifymiddle == nil) {
                classifymiddle = [UIImage imageNamed:@"商品 1:1"];
            }
            
            
            [classifyContentView.middleadvertisementImageView sd_setImageWithURL:[NSURL URLWithString:commodity.pic] placeholderImage:classifymiddle options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [WHImageSaveAndLoad saveImage:image withFileName:[NSString stringWithFormat:@"classifymiddle%d.png",y ] ofType:@"png"];
                
            }];
            
            
            classifyContentView.middleadvertisementImageView.layer.cornerRadius = 0.0;
            classifyContentView.middleadvertisementImageView.layer.borderColor = [WHColorFromRGB(0xf0f0f0) CGColor];
            classifyContentView.middleadvertisementImageView.layer.borderWidth = 0.5f;
            classifyContentView.middleButton.tag = [commodity.id integerValue];
            
            [classifyContentView.middleButton setTitle:commodity.id forState:UIControlStateNormal];
            [classifyContentView.middleButton addTarget:self action:@selector(clickClissifyMoreDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            classifyContentView.rightadvertisementTitleLabel.text = commodity.name;
            classifyContentView.rightadvertisementStagesLabel.text = [NSString stringWithFormat:@"%.2f x %ld期",commodity.periodamount,(long)commodity.duration];
            
            UIImage * classifyright = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"classifyright%d.png",y ]];
            
            if (classifyright == nil) {
                classifyright = [UIImage imageNamed:@"商品 1:1"];
            }
            
            [classifyContentView.rightadvertisementImageView sd_setImageWithURL:[NSURL URLWithString:commodity.pic] placeholderImage:classifyright options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [WHImageSaveAndLoad saveImage:image withFileName:[NSString stringWithFormat:@"classifyright%d.png",y ] ofType:@"png"];
                
            }];
            
            
            classifyContentView.rightadvertisementImageView.layer.cornerRadius = 0.0;
            classifyContentView.rightadvertisementImageView.layer.borderColor = [WHColorFromRGB(0xf0f0f0) CGColor];
            classifyContentView.rightadvertisementImageView.layer.borderWidth = 0.5f;
            classifyContentView.rightButton.tag = [commodity.id integerValue];
            
            [classifyContentView.rightButton setTitle:commodity.id forState:UIControlStateNormal];
            
            [classifyContentView.rightButton addTarget:self action:@selector(clickClissifyMoreDetail:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
}

#pragma mark -- 点击分类详细左上角
- (void)clickClissifyMore:(UIButton *)sender{
    WHCategoryadcommoditys * categoryadcommodity = self.categoryadcommodityArray[sender.tag];
    
    WHGoodsListController * goodsList = [[WHGoodsListController alloc]init];
    goodsList.title = categoryadcommodity.category;
    [self.navigationController pushViewController:goodsList animated:YES];
    
}
- (void)clickClissifyMoreDetail:(UIButton * )sender{
    
    
    LDTaoBaoVC * goodVC = [[LDTaoBaoVC alloc]init];
    goodVC.goodsID = sender.titleLabel.text;
    //[NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self.navigationController pushViewController:goodVC animated:YES];
}

#pragma mark -- 分期数据网络请求
- (void)sendRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@index/",KBaseUrl];
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    if ([LDUserInformation sharedInstance].UserId != nil && [LDUserInformation sharedInstance].token != nil) {
        
        [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
        [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
        
    }else{
        
        [params setObject:@"" forKey:@"id"];
        [params setObject:@"" forKey:@"token"];
    }
    
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            [self dismissHDLoading];
            
            self.resultDict = [WHSaveAndReadInfomation readFenQiData];
            
            NSLog(@"%@",self.resultDict);
            
            if (self.resultDict != nil) {
                
                self.shouyeModel = [WHShouYeModel mj_objectWithKeyValues:self.resultDict];
                //不为空根据模型直接创建
                [self createMoreSubViews];
            }
            
            
            LDLog(@"%@",error);
        }else{
            
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
        
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                if (backInfo.result != nil) {
                    [self analysisResponse:backInfo.result];
                }
                
                
                
            }else{
                // 显示失败信息
                [self showFailViewWithString:backInfo.message];
            }
            LDLog(@"%@",response);
        }
    }];
}
- (void)analysisResponse:(id)result{
    
    
    /**
     * 归档存储用户信息
     */
    [NSKeyedArchiver archiveRootObject:result toFile:ShouYeInfoDict];
    
    _shouyeModel= [WHShouYeModel mj_objectWithKeyValues:result];
    //1.更新地区信息
    if ( _shouyeModel.region == nil || _shouyeModel.region.length == 0) {
    }else{
        self.leftTitleButtonView.titleLabel.text = _shouyeModel.region;
    }
    
    //4.解析轮换广广告列表
    [self analysisBannerWithArray:_shouyeModel.banner];
    
    //5.解析轮换广告下方的广告
    [self analysisBannerdownWithArray:_shouyeModel.bannerdown];
    
    //6.解析分类广告列表
    [self analysisCategoryadcommoditysWithArray:_shouyeModel.categoryadcommoditys];
    
}
//解析轮换广告列表
- (void)analysisBannerWithArray:(NSArray *)array{
    
    if (array.count > 0) {
        [self.advertisArray removeAllObjects];
        
        self.advertisArray = [WHBannerModel mj_objectArrayWithKeyValuesArray:array];
        
        [self createAdvertisementView:self.advertisArray];
    }
 
}


//解析广告图片
- (void)analysisBannerdownWithArray:(NSArray *)array{
    
    
    if (array.count > 0) {
        
        NSMutableArray * bannerdownArray = [WHBannerdownModel mj_objectArrayWithKeyValuesArray:array];
        [self createRagularSetViewWithArray:bannerdownArray];
    }
    
    
}

//解析分类广告列表
- (void)analysisCategoryadcommoditysWithArray:(NSArray *)array{
    [self.categoryadcommodityArray removeAllObjects];
    
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            NSDictionary * dict  = array[i];
            WHCategoryadcommoditys * categoryadcommodity = [WHCategoryadcommoditys mj_objectWithKeyValues:dict];
            //创建分类广告视图
            [self createMoreClassifyContentView:categoryadcommodity ViewY:i];
            [self.categoryadcommodityArray addObject:categoryadcommodity];
        }
    }
    
}

#pragma mark -- 现金贷验证用户信息是否完善请求
//网络请求
- (void)yanzhengyonghuziliaoRequest{
    
    [self showWithImageWithString:@"正在验证用户信息"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/infoStep",KBaseUrl ];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
        }else{
            [self dismissHDLoading];
            
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            NSInteger code = [backInfo.code integerValue];
            
            
            
            if (code == 0 || code == -7) {
                
                [self sendRequestBuyNow];
            }
            
            if (code == -100) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器端异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = -100;
                [alert show];
            }
            if (code == -21) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -21;
                [alert show];
            }
            if (code == -3) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -3;
                [alert show];
            }
            if (code == -4){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -4;
                [alert show];
                
            }
            if (code == -41) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -41;
                [alert show];
            }
            if (code == -42) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -42;
                [alert show];
            }
            if (code == -43) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -43;
                [alert show];
            }
            if (code == -5) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -5;
                [alert show];
            }
            if (code == -6) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，前去补充完善" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:nil];
                alert.tag = -6;
                [alert show];
            }
            LDLog(@"%@",response);
        }
    }];
}

#pragma mark -- 购买验证
- (void)sendRequestBuyNow{
    
    [self showWithImageWithString:@"购买验证"];
    NSString * url = [NSString stringWithFormat:@"%@order/buyCheck",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].phoneNumber) forKey:@"phoneNo"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
           
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            NSLog(@"%@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                CashLoanController * cashLoan = [[CashLoanController alloc]init];
                [self.navigationController pushViewController:cashLoan animated:YES];
                
                
            }else if ([backInfor.code intValue] == -100){
                
                //服务器异常
                [self showFailViewWithString:backInfor.message];
                
                return ;
                
            }else if ([backInfor.code intValue] == -2) {
                
                
                //未登录
                LDSignInViewController * vc = [[LDSignInViewController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                LDLog(@"未登录1234");
                
                return ;
                
            }else if([backInfor.code intValue] == -3) {
                //有未完结订单,无法购买
                [self showFailViewWithString:backInfor.message];
                return;
                
            }else if([backInfor.code intValue] == -4) {
                
                //三个月内有被拒绝订单,无法购买.
                [self showFailViewWithString:backInfor.message];
                return;
                
            }else{
                [self showFailViewWithString:backInfor.message];
            }
            
        }
    }];
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -21) {
        //完善用户支付密码
        LDPaymentPasswordController *password = [[LDPaymentPasswordController alloc]init];
        password.fromeWhere = @"fenqi";
        [self.navigationController pushViewController:password animated:YES];
    }
    if (alertView.tag == -3) {
        
        //完善基本信息
        LDPostIDCard * BaseInfo = [[LDPostIDCard alloc]init];
        BaseInfo.fromeWhere = @"fenqi";
        BaseInfo.requestImage = YES;
        [self.navigationController pushViewController:BaseInfo animated:YES];
    }
    if (alertView.tag == -4) {
        //完善基本信息
        LDPostIDCard * PostIDCard = [[LDPostIDCard alloc] init];
        PostIDCard.fromeWhere = @"fenqi";
        PostIDCard.requestImage = NO;
        [self.navigationController pushViewController:PostIDCard animated:YES];
    }
    if (alertView.tag == -41) {
        //完善工作信息
        WHWorkViewController * jobInfo = [[WHWorkViewController alloc]init];
        jobInfo.fromeWhere = @"fenqi";
        [self.navigationController pushViewController:jobInfo animated:YES];
    }
    if (alertView.tag == -42) {
        //完善学生信息
        WHWorkViewController * StudentInfo = [[WHWorkViewController alloc] init];
        StudentInfo.fromeWhere = @"fenqi";
        [self.navigationController pushViewController:StudentInfo animated:YES];
    }
    if (alertView.tag == -43) {
        //完善创业信息
        WHWorkViewController * Entrepreneurs = [[WHWorkViewController alloc] init];
        Entrepreneurs.fromeWhere = @"fenqi";
        [self.navigationController pushViewController:Entrepreneurs animated:YES];
    }
    if (alertView.tag == -5) {
        //完善高级信息
        LDPostIDCard * PostIDCard = [[LDPostIDCard alloc] init];
        PostIDCard.fromeWhere = @"fenqi";
        PostIDCard.requestImage = NO;
        [self.navigationController pushViewController:PostIDCard animated:YES];
    }
    if (alertView.tag == -6) {
        //完善联系人信息
        LDContactInformationViewController * ContactInfo = [[LDContactInformationViewController alloc] init];
        ContactInfo.fromeWhere = @"fenqi";
        [self.navigationController pushViewController:ContactInfo animated:YES];
    }
    
    
}




@end
