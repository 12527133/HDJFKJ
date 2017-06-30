//
//  LDTestViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/25.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDTestViewController.h"

@interface LDTestViewController ()
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIScrollView * scrolView;
@property (nonatomic,strong) UIButton * buyNow;

@end

@implementation LDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self creatScrolViewAndContentView];
//    [self creatHeaderView];
    [self sendRequest];
    
}
//网络请求
- (void)sendRequest{
    NSString * url = [NSString stringWithFormat:@"%@detail/commodity",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"73" forKey:@"id"];
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
        
            LDLog(@"%@",error);
        }else{
            
            LDLog(@"%@",response);
        }
    }];
     }
- (void)creatHeaderView{

    UIImageView * headerView = [[UIImageView alloc] init];
    headerView.image = [UIImage imageNamed:@"header_cry_icon"];
    [self.scrolView addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(LDPadding);
        make.right.equalTo(self.contentView).offset(-LDPadding);
        make.height.equalTo(200);
    }];
    //分割线
    UILabel * line  =[UILabel new];
    [self.contentView addSubview:line];
    line.alpha = 0.1;
    line.backgroundColor = [UIColor blackColor];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(headerView.bottom);
        make.height.equalTo(10);
    }];
    
    UILabel * goodsName = [UILabel new];
    [self.contentView addSubview:goodsName];
    goodsName.text = @"雅思备考课程 (16课时)";
    goodsName.font = [UIFont systemFontOfSize:17];
    [goodsName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(10);
        make.left.equalTo(self.contentView).offset(LDPadding);
        make.right.equalTo(self.contentView).offset(-LDPadding);
        make.height.equalTo(40);
    }];
    
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

    [self.contentView addSubview:image2];
    [self.contentView addSubview:image3];
    [self.contentView addSubview:image4];
    [self.contentView addSubview:image5];
    [self.contentView addSubview:image1];
    
    [image1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom).offset(8);
        make.left.equalTo(self.contentView).offset(LDPadding);
    }];
    [image2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom).offset(8);
        make.left.equalTo(image1.right).offset(LDPadding);
    }];
    [image3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom).offset(8);
        make.left.equalTo(image2.right).offset(LDPadding);
    }];
    [image4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom).offset(8);
        make.left.equalTo(image3.right).offset(LDPadding);
    }];
    [image5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsName.bottom).offset(8);
        make.left.equalTo(image4.right).offset(LDPadding);
    }];
    
    //购买数
    UILabel * buyCount = [UILabel new];
    [self.contentView addSubview:buyCount];
    buyCount.alpha = 0.5;
    buyCount.numberOfLines = 0;
    buyCount.font = [UIFont systemFontOfSize:10];
    buyCount.text = @"2013人已购买";
    [buyCount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image5.right).offset(15);
        make.top.equalTo(image5);
    }];
    
    //人名币
    UILabel * yuan = [UILabel new];
    yuan.text  =@"￥";
    yuan.textColor = [UIColor redColor];
    yuan.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:yuan];

    [yuan makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(LDPadding);
        make.top.equalTo(buyCount.bottom).offset(20);
    }];
    
    //多少钱
    UILabel * moneyCount = [UILabel new];
    moneyCount.text  =@"4400";
    moneyCount.textColor = [UIColor redColor];
    moneyCount.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:moneyCount];
    [moneyCount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yuan.right);
        make.top.equalTo(buyCount.bottom).offset(20);
    }];

    //免
    UIImageView * freeImage = [UIImageView new];
    freeImage.image = [UIImage imageNamed:@"free"];
    [self.contentView addSubview:freeImage];
    [freeImage sizeToFit];
    [freeImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyCount.right).offset(20);
        make.centerY.equalTo(moneyCount);
    }];
    
    //首付
    UILabel * firstPay = [UILabel new];
    [self.contentView addSubview:firstPay];
    firstPay.textColor = [UIColor redColor];
    firstPay.font = [UIFont systemFontOfSize:12];
    firstPay.text = [NSString stringWithFormat:@"0首付 + ...."];
    [firstPay makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(freeImage.right).offset(7);
        make.bottom.equalTo(freeImage.bottom);
    }];
    
    //分割线
    UILabel * line2 = [UILabel new];
    [self.contentView addSubview:line2];
    line2.backgroundColor = [UIColor brownColor];
    line2.alpha = 0.2;
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(freeImage.bottom).offset(20);
        make.height.equalTo(10);
    }];
    
    //商家
    UILabel * business = [UILabel new];
    [self.contentView addSubview:business];
    business.font = [UIFont systemFontOfSize:15];
    business.alpha = 0.5;
    business.text = @"商家";
    [business makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(LDPadding);
        make.top.equalTo(line2.bottom).offset(LDPadding);
    }];
    
    //商品名称
    UILabel * bottomGoodsName = [UILabel new];
    [self.contentView addSubview:bottomGoodsName];
    bottomGoodsName.font = [UIFont systemFontOfSize:15];
    bottomGoodsName.text  = @"华尔街英语";
    [bottomGoodsName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(business);
        make.left.equalTo(self.contentView).offset(90);
    }];
    //箭头
    UIImageView * arrow = [UIImageView new];
    [self.contentView addSubview:arrow];
    arrow.image = [UIImage imageNamed:@"返回"];
    [arrow sizeToFit];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-LDPadding);
        make.centerY.equalTo(bottomGoodsName);
    }];
    //line3
    UILabel * line3 = [UILabel new];
    [self.contentView addSubview:line3];
    line3.backgroundColor = [UIColor brownColor];
    line3.alpha = 0.2;
    [line3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(business.bottom).offset(LDPadding);
        make.height.equalTo(1);
    }];
    
    //添加button,即监听事件
    UIButton * jumpBusiness = [[UIButton alloc] init];
    [self.contentView addSubview:jumpBusiness];
    
    [jumpBusiness addTarget:self action:@selector(jumpBusinessVC) forControlEvents:UIControlEventTouchUpInside];
    
    jumpBusiness.backgroundColor = [UIColor redColor];
    [jumpBusiness makeConstraints:^(MASConstraintMaker *make) {
    }];
    [jumpBusiness makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(line2);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(line3);
    }];
    //地址
    UILabel * place = [UILabel new];
    [self.contentView addSubview:place];
    place.font = [UIFont systemFontOfSize:15];
    place.alpha = 0.5;
    place.text = @"地址";
    [place makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(LDPadding);
        make.top.equalTo(line3.bottom).offset(LDPadding);
    }];
    //地址text
    UILabel * address = [UILabel new];
    address.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:address];
    address.text  = @"北京市海淀区";
    [address makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(place);
        make.left.equalTo(bottomGoodsName);
        
    }];
    
    //line4
    UILabel * line4 = [UILabel new];
    line4.backgroundColor = [UIColor brownColor];
    line4.alpha = 0.2;
    [self.contentView addSubview:line4];
    [line4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(address.bottom).offset(LDPadding);
        make.height.equalTo(10);
    }];
    
    //商品规格
    UILabel * goodsFormat = [UILabel new];
    [self.contentView addSubview:goodsFormat];
    goodsFormat.font = [UIFont systemFontOfSize:17];
    goodsFormat.text = @"商品规格";
    [goodsFormat makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(LDPadding);
        make.top.equalTo(line4.bottom).offset(LDPadding);
    }];
    
    //line5
    UILabel * line5 = [UILabel new];
    [self.contentView addSubview:line5];
    line5.backgroundColor = [UIColor brownColor];
    line5.alpha = 0.2;
    [line5 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(goodsFormat.bottom).offset(LDPadding);
        make.height.equalTo(1);
    }];
    //商品规格
    UILabel * goodsDetail = [UILabel new];
    [self.contentView addSubview:goodsDetail];
    goodsDetail.font = [UIFont systemFontOfSize:15];
    goodsDetail.alpha = 0.5;
    goodsDetail.numberOfLines = 0;
    goodsDetail.text = @"规格规格规格规格规格规格规格规格规格规格文／简书（简书作者//www.jianshu.com/p权，并标注“简书作者我们致力于开发维护一套集合文字的书写、编集、发布功能于一体的在线写作编辑工具。规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格规格";
    [goodsDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsFormat);
        make.top.equalTo(line5.bottom).offset(LDPadding);
        make.right.equalTo(self.contentView.right).offset(-LDPadding);
    }];
    
    //line6
    UILabel * line6 = [UILabel new];
    [self.contentView addSubview:line6];
    line6.backgroundColor  = [UIColor brownColor];
    line6.alpha = 0.2;
    [line6 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(goodsDetail.bottom).offset(LDPadding);
        make.height.equalTo(10);
    }];
    
    //商品介绍
    UILabel * goodsIntroduce = [UILabel new];
    [self.contentView addSubview:goodsIntroduce];
    goodsIntroduce.font = [UIFont systemFontOfSize:15];
    goodsIntroduce.text = @"商品介绍";
    [goodsIntroduce makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsFormat);
        make.top.equalTo(line6.bottom).offset(LDPadding);
        make.right.equalTo(self.contentView.right).offset(-LDPadding);
    }];
    //商品介绍详情
    UILabel * goodsIntroduceDetail = [UILabel new];
    [self.contentView addSubview:goodsIntroduceDetail];
    goodsIntroduceDetail.font = [UIFont systemFontOfSize:15];
    goodsIntroduceDetail.alpha = 0.5;
    goodsIntroduceDetail.numberOfLines = 0;
    goodsIntroduceDetail.text = @"商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品介绍";
    [goodsIntroduceDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(LDPadding);
        make.top.equalTo(goodsIntroduce.bottom).offset(LDPadding);
        make.right.equalTo(self.contentView.right).offset(-LDPadding);
    }];
    
    //line7
    UILabel * line7 = [UILabel new];
    [self.contentView addSubview:line7];
    line7.backgroundColor  = [UIColor brownColor];
    line7.alpha = 0.2;
    [line7 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(goodsIntroduceDetail.bottom).offset(LDPadding);
        make.height.equalTo(10);
    }];
    //月供
    UILabel * monthPay = [UILabel new];
    [self.scrolView addSubview:monthPay];
    monthPay.text = @"月供:";
    monthPay.font = [UIFont systemFontOfSize:15];
    [monthPay makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line7.bottom).offset(LDPadding);
        make.left.equalTo(self.contentView).offset(LDPadding);
    }];
    
    //lastMoneyCount
    UILabel * lastMoneyCount = [UILabel new];
    [self.contentView addSubview:lastMoneyCount];
    lastMoneyCount.textColor = [UIColor redColor];
    lastMoneyCount.font = [UIFont systemFontOfSize:17];
    lastMoneyCount.text = @"1324";
    [lastMoneyCount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthPay.right);//.offset(LDPadding);
        make.bottom.equalTo(monthPay.bottom);
    }];
    //起
    UILabel * begin = [UILabel new];
    [self.contentView addSubview:begin];
    begin.text = @"起";
    begin.font = [UIFont systemFontOfSize:15];
    [begin makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastMoneyCount.right);
        make.bottom.equalTo(monthPay);
    }];
    
    //本金加服务费 principal
    UILabel * principal = [UILabel new];
    [self.contentView addSubview:principal];
    principal.alpha = 0.2;
    principal.font = [UIFont systemFontOfSize:15];
    principal.text = @"(本金300元 + 服务费66.7元)";
    [principal makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(LDPadding);
        make.top.equalTo(monthPay.bottom).offset(LDPadding);
    }];
    
    //立刻购买
    UIButton * buyNow = [UIButton buttonWithType:UIButtonTypeCustom];
    buyNow.backgroundColor  =[UIColor redColor];
    [self.contentView addSubview:buyNow];
    [buyNow setTitle:@"立刻购买" forState:UIControlStateNormal];
    buyNow.titleLabel.font = [UIFont systemFontOfSize:15];
    buyNow.titleLabel.textColor = [UIColor whiteColor];
    
    [buyNow addTarget:self action:@selector(buyNow) forControlEvents:UIControlEventTouchUpInside];
    
    [buyNow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line7.bottom);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(principal.bottom).offset(LDPadding);
        make.width.equalTo(125);
    }];
    self.buyNow = buyNow;
}
//立刻购买
- (void)buyNow{

    LDLogFunc;
}
//跳转控制器
- (void)jumpBusinessVC{
    
    LDLogFunc;
}
- (void)creatScrolViewAndContentView{
    UIScrollView * scro = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrolView = scro;
    scro.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scro];
    scro.scrollEnabled = YES;
    scro.userInteractionEnabled = YES;
    scro.contentSize = CGSizeMake(LDScreenWidth, 870);
    
    UIView * content = [UIView new];
    
    self.contentView = content;
    content.userInteractionEnabled  = YES;
//    content.
    [scro addSubview:content];
    content.backgroundColor = [UIColor whiteColor];
    content.frame = CGRectMake(0, 0, LDScreenWidth, 0);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/











@end
