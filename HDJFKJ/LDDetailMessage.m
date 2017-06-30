//
//  LDDetailMessage.m
//  HDJFKJ
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDDetailMessage.h"
#import "WHMessageModel.h"

@interface LDDetailMessage ()
@property (nonatomic,assign) CGFloat backViewHeight;
@property (nonatomic,strong) UILabel * detaileLable;

@end

@implementation LDDetailMessage
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)setDetaileModel:(WHMessageModel *)detaileModel{

    _detaileModel = detaileModel;
    
    static CGFloat titleH = 40;
    static CGFloat margin = 5;
    static CGFloat downMargin = 45;
    NSString *topic = detaileModel.content;

    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2* LDPadding - 15*2, MAXFLOAT);
    
    CGFloat textH = [topic boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    self.backViewHeight = textH + titleH + margin + downMargin;
    
    [self creatSubView];


}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = LDBackroundColor;
    self.navigationItem.title = @"分期通知";
   
    
}
- (void)creatSubView{
    
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(LDPadding);
        make.right.equalTo(self.view).offset(-LDPadding);
        make.top.equalTo(self.view).offset(40 + 64);
        make.height.equalTo(self.backViewHeight);
    }];
    
    UILabel * titleLable = [UILabel new];
    [backView addSubview:titleLable];
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.text = self.detaileModel.title;
    [titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(15);
        make.right.equalTo(backView).offset(-15);
        make.top.equalTo(backView);
        make.height.equalTo(40);
    }];
    
    UILabel * detailLable = [UILabel new];
    self.detaileLable = detailLable;
    [backView addSubview:detailLable];
    detailLable.font = [UIFont systemFontOfSize:14];
    detailLable.alpha = 0.5;
    detailLable.numberOfLines = 0;
    detailLable.text = self.detaileModel.content;
    
    [detailLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLable);
        make.top.equalTo(titleLable.bottom).offset(5);
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequest{
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * urlString = [NSString stringWithFormat:@"%@message/read",KBaseUrl];
    // 参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [parameter setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [parameter setObject:[LDUserInformation sharedInstance].UserId forKey:@"cumid"];
    
    
    [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter callback:^(id response, NSError *error) {
        if (error != nil) {//失败
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
        }else{//成功
            
            [self dismissHDLoading];
            LDLog(@"%@",response);
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                
                
            }
            
        }
        
    }];
    
}


@end
