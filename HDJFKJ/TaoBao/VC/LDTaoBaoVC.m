//
//  LDTaoBaoVC.m
//  OCLDProject
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDTaoBaoVC.h"
#import "LDTaoBaoTopCell.h"
#import "LDFirstCell.h"
#import "LDSecondTaoBaoCell.h"
#import "LDBottomTaoBaoCell.h"
#import "LDGoodsDetailModel.h"
#import "AttributeView.h"
#import "SDCycleScrollView.h"
#import "LDReViewInformation.h"
#import "LDSignInViewController.h"
#import "HDSubmitOrder.h"
#import "LDNavgationVController.h"
#define PopViewPadding 15
#define heightProportion 375 * LDScreenHeight / 667

@interface LDTaoBaoVC ()<UITableViewDataSource,UITableViewDelegate,AttributeViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *middleTableView;
@property (weak, nonatomic) IBOutlet UIView *boottomView;
@property (weak, nonatomic) IBOutlet UIView *navView;


@property (weak, nonatomic) IBOutlet UIButton *BottomFirstButton;

/** 轮播图  */
@property (nonatomic,strong) UIScrollView * scrollowView;
/** uimageView  */
@property (nonatomic,strong) UIImageView * topImageView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

/**
 *  数据模型
 */
@property (nonatomic,strong) LDGoodsDetailModel * goodsDetailModel;
@property (nonatomic,strong) NSArray * cases;
/**
 *  商品名称
 */
@property (nonatomic,strong) NSString  * goodsName;
@property (nonatomic,strong) UILabel * monthMoney;
/**
 *  firstButtonClick
 */
@property (strong, nonatomic) UIView *maskView;// 遮罩视图
@property (strong, nonatomic) UIView *popView; // 弹出底部视图
/** pop  ScrollowView  */
@property (nonatomic,strong) UIScrollView * popScrollowView;
/** pop  headerImage  */
@property (nonatomic,strong) UIImageView * PopHeaderImageView;
/** pop  priceLable  */
@property (nonatomic,strong) UILabel * popPriceLable;
/** pop  分期视图  */
@property (nonatomic ,weak) AttributeView *attributeViewDS;
/** 分期数组  */
@property (nonatomic,strong) NSMutableArray * dsData;

/** 购买数量  */
@property (nonatomic,strong) UILabel * goodsCount;
/** 第二个button  */
@property (nonatomic,strong) UIButton * sectionButton;
/** 分期金额 + 分期数  */
@property (nonatomic,strong) NSString * AttributeString;
/** 最终选择的分期专案 */

@end

@implementation LDTaoBaoVC
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navView.hidden = YES;


}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (IBAction)navButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
        self.navView.hidden = NO;
    self.headerView.height = 260;
    
    self.navigationController.navigationBarHidden = YES;
}
/**
 *  点击分期拿到分期数
 */
-(void)Attribute_View:(AttributeView *)view didClickBtn:(UIButton *)btn{
    
    if (btn.selected) {
        
        NSString *title = btn.titleLabel.text;
        self.AttributeString = title;

        for (int i = 0; i < self.cases.count; i++) {
            
            
            LDGoodsDetailIDModel * model = self.cases[i];
            
            NSString * str = [NSString stringWithFormat:@"￥%@ x %@期",[self decimalwithFormat:@"0.00" floatV:[model.periodamount floatValue]],model.duration];
            
            if ([str isEqualToString:title]) {
                [[HDSubmitOrder shardSubmitOrder] setCaseId:model.id];
            }
        }
        
        
    }else{
    
        self.AttributeString = NULL;

    }
    
    
}

- (void)setupHeadView {
  
    self.scrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 260)];
    
    
    if (self.goodsDetailModel.piclist.count == 0) {
        
        // 添加多张图片
        for (int i=0; i<1; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 260)];
            
         
            imageView.image = [UIImage imageNamed:@"商品 1:1"];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.scrollowView addSubview:imageView];
        }
        
        self.scrollowView.contentSize = CGSizeMake(LDScreenWidth, 260);
        
    }else{
    
        // 添加多张图片
        for (int i=0; i<self.goodsDetailModel.piclist.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*LDScreenWidth, 0, LDScreenWidth, 260)];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.goodsDetailModel.piclist[i]] placeholderImage:[UIImage imageNamed:@"商品 1:1"]];
            
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.scrollowView addSubview:imageView];
        }
        
        self.scrollowView.contentSize = CGSizeMake(LDScreenWidth * self.goodsDetailModel.piclist.count, 260);
        
    
    
    }
    
        
        self.scrollowView.pagingEnabled = YES;
        
        self.scrollowView.showsHorizontalScrollIndicator = NO;
        
        
        [self.headerView addSubview:self.scrollowView];
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
        

        [UIView animateWithDuration:0.2 animations:^{
            
            
            self.view.layer.transform = [self firstStepTransform];
            self.maskView.alpha = 1.0;
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.view.layer.transform = [self secondStepTransform];
                self.popView.transform = CGAffineTransformTranslate(self.popView.transform, 0, -LDScreenHeight / 1.5f);
                [self creatDetailView];
                
            }];
        }];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    
  
    if (scrollView == self.middleTableView) {
        

        
        // 重新赋值，就不会有淘宝用力拖拽时的回弹
        self.scrollowView.contentOffset = CGPointMake(self.scrollowView.contentOffset.x, 0);
        
        
        

        if (self.middleTableView.contentOffset.y >= 0 &&  self.middleTableView.contentOffset.y <= LDScreenWidth) {

            self.scrollowView.contentOffset = CGPointMake(self.scrollowView.contentOffset.x, -offset / 2.0f);
            
         
            
        }
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = LDRGBColor(240, 240, 240, 1);
        
        return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.00000001;
    }else{
    
        return 20;
    }
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
static NSString * const Section0 = @"TaoBaoSection0";
static NSString * const Section1 = @"TaoBaoSection1";
static NSString * const Section2 = @"TaoBaoSection2";
static NSString * const Section3 = @"TaoBaoSection3";
static NSString * const Section4 = @"TaoBaoSection4";
- (void)setupTableView{

    [self.middleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDTaoBaoTopCell class]) bundle:nil] forCellReuseIdentifier:Section0];
    
    [self.middleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDFirstCell class]) bundle:nil] forCellReuseIdentifier:Section1];
    
    [self.middleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDSecondTaoBaoCell class]) bundle:nil] forCellReuseIdentifier:Section2];
    [self.middleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDBottomTaoBaoCell class]) bundle:nil] forCellReuseIdentifier:Section3];
  
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        
        LDTaoBaoTopCell * cell = [tableView dequeueReusableCellWithIdentifier:Section0];
        
        cell.goodsDetailModel = self.goodsDetailModel;
        return cell;
        
        
    }else if (indexPath.section == 1){
    
        LDFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:Section1];
        cell.AttributeString = self.AttributeString;
        
        cell.goodsDetailModel = self.goodsDetailModel;
        return cell;
        
    }else if (indexPath.section == 2){
        
        LDSecondTaoBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:Section2];
        cell.isRule = YES;
                cell.goodsDetailModel = self.goodsDetailModel;
        return cell;
    
    }else if (indexPath.section == 3){
        
        LDSecondTaoBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:Section2];
        
        cell.isRule = NO;
        cell.goodsDetailModel = self.goodsDetailModel;
        return cell;
        
    
    }else{
        
        LDBottomTaoBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:Section3];
        cell.goodsDetailModel = self.goodsDetailModel;
        [cell.callPhoneButton addTarget:self action:@selector(callPhoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    
    }
 

}
- (void)callPhoneButtonClick
{

//    NSString * phoneNum = @"110";
//   
//    
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTableView];
    self.view.backgroundColor = LDRGBColor(240, 240, 240, 1);
    self.middleTableView.backgroundColor =LDRGBColor(240, 240, 240, 1);
    
    
    /** 删除缓存的下单数据 */
    [[HDSubmitOrder shardSubmitOrder] setAttributeNull];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 100;
    }else if (indexPath.section == 1){
    
        return 90;
    }else if (indexPath.section == 2){
    
        // 字符串模型数据
        NSString *topic = self.goodsDetailModel.parameter;
        
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 15, MAXFLOAT);
        
        CGFloat textH = [topic boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
        
        // cell的高度
        CGFloat cellH = 40 + textH + 2 * 15;
        
        return cellH;
    
    
    }else if (indexPath.section == 3){
        
        // 字符串模型数据
        NSString *topic = self.goodsDetailModel.desc;
        
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2* 15, MAXFLOAT);
        
        // 字符串模型数据高度
        CGFloat textH = [topic boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
        

        
        // cell的高度
        CGFloat cellH = 40 + textH + 2 * 15;
        
        return cellH;
        
    }else{
    
        return 202;

    }
}

/**
 *  商品ID
 */
-(void)setGoodsID:(NSString *)goodsID{
    
    _goodsID = goodsID;
    
    [self sendRequest];
    
}
- (NSMutableArray *)dsData{

    if (!_dsData) {
        
        _dsData = [NSMutableArray array];
        
    }
    return _dsData;
}
- (void)setFromWhere:(NSString *)fromWhere{
    
    _fromWhere = fromWhere;
    
}
//网络请求(加载页面数据)
- (void)sendRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * url = [NSString stringWithFormat:@"%@detail/commodity",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.goodsID forKey:@"id"];
    
    LDLog(@"%@",self.goodsID);
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            [self showFailViewWithString:@"网络错误"];
            LDLog(@"%@",error);
        }else{
            [self dismissHDLoading];
            
            LDLog(@"%@",response);
            
            
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                
                /** 4.解析商品详情 */
                if (backInfo.result != nil){
                    self.goodsDetailModel = [LDGoodsDetailModel mj_objectWithKeyValues:backInfo.result];
                    
                    [self setupHeadView];
                    
                    [self.middleTableView reloadData];
                    
                    
                    
                    self.cases = [LDGoodsDetailIDModel mj_objectArrayWithKeyValuesArray:self.goodsDetailModel.cases];
                    for (int i = 0; i < self.cases.count; i++) {
                        
                        
                        LDGoodsDetailIDModel * model = self.cases[i];
                        
                        NSString * str = [NSString stringWithFormat:@"￥%@ x %@期",[self decimalwithFormat:@"0.00" floatV:[model.periodamount floatValue]],model.duration];
                        
                        [self.dsData addObject:str];
                    }
                    
                    
                    [[LDGoodsIDAndZhuanAnId sharedInstance] setId:self.goodsID];
                    
                    
                    //专案ID,专案期次,专案月供金额.
                    
                    if (self.cases.count > 0) {
                        LDGoodsDetailIDModel * IDModel = self.cases[0];
                        [[LDGoodsIDAndZhuanAnId sharedInstance] setZhuanAnID:IDModel.id];
                    }
                    
                    [[LDGoodsIDAndZhuanAnId sharedInstance] setCommodityno:self.goodsDetailModel.commodityno];
                    
                    [[LDGoodsIDAndZhuanAnId sharedInstance] setCategory:self.goodsDetailModel.category];
                    
                    [[LDGoodsIDAndZhuanAnId sharedInstance] setBusinessname:self.goodsDetailModel.businessname];
                    
                    [[LDGoodsIDAndZhuanAnId sharedInstance] setName:self.goodsDetailModel.name];
                    
                    [[LDGoodsIDAndZhuanAnId sharedInstance] setName:self.goodsDetailModel.commodityprice];
                    
                    [[LDGoodsIDAndZhuanAnId sharedInstance] setBusnessID:self.goodsDetailModel.businessid];
                    
                }
                
                
                
            }
            
            

            
           

        }
    }];
}
//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

/**
 *  分期弹窗赋值//模型建好可在创建时赋值.
 */
- (void)creatDetailView{
    
    
}
/**
 *  (先)未选择分期  --->   就点击确认分期
 */
- (IBAction)clickFirstButton:(id)sender {
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:self.goodsID oprType:GMSPXQ];
    //是否登录:  登录 ---> 选择分期  -->  是否可以下单
    [self isLogin];
    
    
}


- (UIView *)popView {
    
    if (!_popView) {
        
        _popView = [[UIView alloc] initWithFrame:CGRectMake(0, LDScreenHeight, LDScreenWidth, LDScreenHeight / 1.5f)];
        
        _popView.backgroundColor = [UIColor clearColor];
        UIView * headerClearView = [UIView new];
        headerClearView.backgroundColor = [UIColor clearColor];
        [_popView addSubview:headerClearView];
        [headerClearView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_popView);
            make.height.equalTo(PopViewPadding);
        }];
        

        UIView * headerClearView1 = [[UIView alloc] initWithFrame:CGRectMake(0, PopViewPadding, LDScreenWidth, 200)];
        
        headerClearView1.backgroundColor = [UIColor whiteColor];
        [_popView addSubview:headerClearView1];
        
        UIView * imageBackView = [UIView new];
        imageBackView.backgroundColor = [UIColor whiteColor];
        
        [_popView addSubview:imageBackView];
        
        [imageBackView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.popView).offset(PopViewPadding);
            make.width.height.equalTo(120);
            make.top.equalTo(self.popView);

        }];
        
        UIImageView * backImage = [[UIImageView alloc] init];
        backImage.image = [UIImage imageNamed:@"Rectangle 6"];
        [imageBackView addSubview:backImage];
        [backImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(imageBackView);
        }];
        
        
        self.PopHeaderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdantishi"]];

        [imageBackView addSubview:self.PopHeaderImageView];

        [self.PopHeaderImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.popView).offset(PopViewPadding + 5 );
            make.width.height.equalTo(110);
            make.top.equalTo(imageBackView).offset(5);
        }];

        self.popPriceLable = [UILabel new];
        self.popPriceLable.textColor = LDRGBColor(232, 76, 61, 1);
        [_popView addSubview:self.popPriceLable];
        [self.popPriceLable makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.PopHeaderImageView.right).offset(PopViewPadding - 5);
            make.top.equalTo(_popView).offset(PopViewPadding + 10);
            make.right.equalTo(_popView).offset(3 *PopViewPadding);
        }];
        
        UILabel * line = [UILabel new];
        [_popView addSubview:line];
        line.alpha = 0.2;
        line.backgroundColor = [UIColor blackColor];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_popView).offset(PopViewPadding);
            make.right.equalTo(_popView).offset(-PopViewPadding);
            make.height.equalTo(0.5);
            make.bottom.equalTo(imageBackView.bottom).offset(20);
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"错误"] forState:UIControlStateNormal];
        [_popView addSubview:button];
        [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_popView).offset(25);
            make.right.equalTo(_popView).offset(-15);
            make.width.height.equalTo(2 * LDPadding);
        }];
        
        //第一条分割线最大Y值,选择分期视图Y值 = 该值 + padding(15)

        //整个 popView高度 = LDScreenHeight / 1.5f,
        //popView高度  减去 底部Button高度(45) - LineY  = popScrollowView 的高度
        CGFloat  ScrollowY = 145;

        self.popScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScrollowY, LDScreenWidth, LDScreenHeight / 1.5f - ScrollowY - 45)];
        
        self.popScrollowView.backgroundColor = [UIColor whiteColor];
        
        [_popView addSubview:self.popScrollowView];
        
        // 创建电商属性视图
       
        
        AttributeView *attributeViewDS = [AttributeView attributeViewWithTitle:@"选择分期" titleFont:[UIFont boldSystemFontOfSize:13] attributeTexts:self.dsData viewWidth:LDScreenWidth];
        
        self.attributeViewDS = attributeViewDS;
        self.attributeViewDS.backgroundColor = [UIColor clearColor];
        attributeViewDS.y = 0;

        attributeViewDS.Attribute_delegate = self;
        [self.popScrollowView addSubview:self.attributeViewDS];
        
        CGFloat LineY = CGRectGetMaxY(self.attributeViewDS.frame);
        
        UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(PopViewPadding, LineY + 5, LDScreenWidth - 2 * PopViewPadding, 0.5)];
        [self.popScrollowView addSubview:line1];
        line1.alpha = 0.2;
        line1.backgroundColor = [UIColor blackColor];
        
        CGFloat LineY1 = CGRectGetMaxY(line1.frame);

        UILabel * count = [[UILabel alloc] initWithFrame:CGRectMake(PopViewPadding, LineY1 + PopViewPadding, 4 * PopViewPadding, 18)];
        count.text = @"购买数量";
        count.font = [UIFont systemFontOfSize:13];
        [self.popScrollowView addSubview:count];
        

        self.goodsCount = [[UILabel alloc] initWithFrame:CGRectMake(4 * PopViewPadding + PopViewPadding, LineY1 + PopViewPadding, LDScreenWidth - 6 * PopViewPadding, 18)];
        self.goodsCount.textAlignment = NSTextAlignmentRight;
        self.goodsCount.font = [UIFont systemFontOfSize:13];

        [self.popScrollowView addSubview:self.goodsCount];
        
        CGFloat LineY2 = CGRectGetMaxY(count.frame);

        
        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(PopViewPadding, LineY2 + PopViewPadding, LDScreenWidth - 2 * PopViewPadding, 0.5)];
        [self.popScrollowView addSubview:line2];
        line2.alpha = 0.2;
        line2.backgroundColor = [UIColor blackColor];
        
        
        self.sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sectionButton setTitle:@"确定" forState:UIControlStateNormal];
        ;
        self.sectionButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.sectionButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
        [self.sectionButton addTarget:self action:@selector(sectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:self.sectionButton];
        [self.sectionButton makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_popView);
            make.height.equalTo(3 * PopViewPadding + 4);
        }];
        
        //LDScreenHeight / 1.5f - 165
        // popView高度  = LDScreenHeight / 1.5f
        //底部button = 45
        //scrollowView 高度 = LDScreenHeight / 1.5f - 105 - 45
        // 最上部 高度 100
        //LineY2 = CGRectGetMaxY(count.frame);(购买数量最大Y值)
        
        CGFloat scrollowHeight = LDScreenHeight / 1.5f - ScrollowY - 45;
        
        CGFloat scrollowViewContentSizeHeight = LineY2 + 15;
        
        if (scrollowViewContentSizeHeight >  scrollowHeight) {
            
            self.popScrollowView.contentSize = CGSizeMake(LDScreenWidth, scrollowViewContentSizeHeight + PopViewPadding);

        }
        
    }
    //分期数组,在_PopView 创建赋值
    [self.PopHeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsDetailModel.pic] placeholderImage:[UIImage imageNamed:@"商品 1:1"]];
    self.popPriceLable.text =  [NSString stringWithFormat:@"￥ %@",self.goodsDetailModel.commodityprice];
    self.goodsCount.text = @"1";

    return _popView;
}

/**
 *  (后)弹出分期选择框后 ---->  未选择分期 -->  点击确定
 */
- (void)sectionButtonClick:(UIButton *)button{

    if (self.AttributeString == NULL) {

        [MBProgressHUD showError:@"选择分期"];
        
    }else{
        
        LDLog(@"%@",self.AttributeString);
        
        [self close];
        
        [self.middleTableView reloadData];
        
        
         [self sendRequestBuyNow];
        
//        LDReViewInformation * reView = [[LDReViewInformation alloc] init];
//        
//        LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:reView];
//        
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
- (void)close {
    
    
        [UIView animateWithDuration:0.3 animations:^{
            
            
            self.view.layer.transform = [self firstStepTransform];
            
            self.popView.transform = CGAffineTransformIdentity;
            
            
        } completion:^(BOOL finished) {
            
            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
            [UIView animateWithDuration:0.2 animations:^{
                
                self.view.layer.transform = CATransform3DIdentity;
                
                self.maskView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                [self.maskView removeFromSuperview];
                
                [self.popView removeFromSuperview];
                
               
            }];
        }];
}
// 动画1
- (CATransform3D)firstStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DScale(transform, 0.98, 0.98, 1.0);
    transform = CATransform3DRotate(transform, 5.0 * M_PI / 180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -30.0);
    return transform;
}
// 动画2
- (CATransform3D)secondStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstStepTransform].m34;
    transform = CATransform3DTranslate(transform, 0, LDScreenHeight * -0.08, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
    return transform;
}
- (UIView *)maskView {
    if (!_maskView) {
        
        _maskView = [[UIView alloc] initWithFrame:LDScreenBounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        _maskView.alpha = 0.0f;
        
        // 添加点击背景按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:LDScreenBounds];
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}
/**
 *  验证是否登录
 */
- (void)isLogin{
    
    NSString * token = [LDUserInformation sharedInstance].token;
    
    NSString * ID = [LDUserInformation sharedInstance].UserId;
    
    if ((token == nil)||(ID == nil)){
        
        //未登录
        LDSignInViewController * vc = [[LDSignInViewController alloc] init];
        
        vc.fromWhere = @"goumai";
        
        LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
        
        
        
        
    }else{
        //没有选择分期 ---> 选择分期
        if (self.AttributeString == NULL) {
            
            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
            
            [UIView animateWithDuration:0.2 animations:^{
                
                
                self.view.layer.transform = [self firstStepTransform];
                self.maskView.alpha = 1.0;
                
                
            } completion:^(BOOL finished) {
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.layer.transform = [self secondStepTransform];
                    self.popView.transform = CGAffineTransformTranslate(self.popView.transform, 0, -LDScreenHeight / 1.5f);
                    [self creatDetailView];
                    
                }];
            }];
            
        }else
            //选择了分期 ---->控制器跳转
        {
            LDLog(@"%@",self.AttributeString);
            
            [self close];
            
            //已登录,发送购买验证
            [self sendRequestBuyNow];
        
        }

        
    }
    
    
}
/**
 *  网络请求,立即购买,购买验证
 */
- (void)sendRequestBuyNow{
    
    [self showWithImageWithString:@"正在验证"];
    
    NSString * url = [NSString stringWithFormat:@"%@order/buyCheck",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].phoneNumber) forKey:@"phoneNo"];
    
    
    [params setObject:NULLSTR([LDGoodsIDAndZhuanAnId sharedInstance].commodityno) forKey:@"commodityNo"];
    
    
    LDLog(@"传值%@",[LDGoodsIDAndZhuanAnId sharedInstance].commodityno);
    
    LDLog(@"参数%@",[params objectForKey:@"commodityNo"]);
    
    
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
                
                [self dismissHDLoading];
                
                [self performSelector:@selector(pushNextController) withObject:nil afterDelay:0.2];
                
            }else if ([backInfor.code intValue] == -100){
                
                //服务器异常
                [self showFailViewWithString:backInfor.message];
                
                return ;
                
            }else if ([backInfor.code intValue] == -2) {
                
                [self dismissHDLoading];
                //未登录
                LDSignInViewController * vc = [[LDSignInViewController alloc] init];
                
                vc.fromWhere = @"goumai";
                LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:vc];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
                
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
/** 推出下一个控制器 */
- (void)pushNextController{

    /**
     * 给提交订单模型赋值
     * 用一个单利类缓存提交商品当单需要的数据，这里获取到:商户id,申请价格,首付款,商品总价,商品列表 五个值，商品列表的格式参考接口文档
     **/
    //商户id
    [[HDSubmitOrder shardSubmitOrder] setBusinessId:self.goodsDetailModel.businessid];
    //申请价格
    [[HDSubmitOrder shardSubmitOrder] setApplyAmount:[NSString stringWithFormat:@"%.2f",[self.goodsDetailModel.commodityprice floatValue] - [self.goodsDetailModel.downpayment floatValue]]];
    //首付款
    [[HDSubmitOrder shardSubmitOrder] setDownpayment:self.goodsDetailModel.downpayment];
    //商品总价
    [[HDSubmitOrder shardSubmitOrder] setTotalAmount:self.goodsDetailModel.commodityprice];
    //商品列表
    [[HDSubmitOrder shardSubmitOrder] setCommoditys:[self returnCommoditys]];
    //专案详情
    [[HDSubmitOrder shardSubmitOrder] setCaseDetail:self.AttributeString];
    [[HDSubmitOrder shardSubmitOrder] setGoodsName:self.goodsDetailModel.name];
    
    LDReViewInformation * reView = [[LDReViewInformation alloc] init];
    
    LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:reView];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

//返回商品类别
- (NSString *)returnCommoditys{
    
    NSMutableArray * commoditys = [NSMutableArray array];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"1" forKey:@"commodityCount"];
    [dict setObject:self.goodsID forKey:@"commodityId"];
    
    [commoditys addObject:dict];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:commoditys options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* sInvalid = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 从服务器收到的类似上一行的数据 // 转换
    NSString*sValid = [sInvalid stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    sValid= [sValid stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData * data =[sValid dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    
    
    
    return jsonString;
    
}

@end
