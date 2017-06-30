//
//  LDTestMessageView.m
//  HDJFKJ
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDTestMessageView.h"
#import "WHMessageModel.h"

@interface LDTestMessageView ()
@property (nonatomic,assign) CGFloat backViewHeight;
@property (nonatomic,strong) UILabel * detaileLable;

@end

@implementation LDTestMessageView

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setDetaileModel:(WHMessageModel *)detaileModel{
    
    _detaileModel = detaileModel;
    
    static CGFloat titleH = 40;
    static CGFloat margin = 5;
    static CGFloat downMargin = 45;
    NSString *topic = @"NSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOrigirawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOrigirawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOriginNSStringDrawingUsesLineFragmentOrigin";//detaileModel.content;
    
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2* LDPadding - 15*2, MAXFLOAT);
    
    CGFloat textH = [topic boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    self.backViewHeight = textH + titleH + margin + downMargin;
    
    [self creatSubView];
    
    
}
- (void)creatSubView{
    
    UIView * lastView = nil;
    UIScrollView * scro = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scro.backgroundColor = LDBackroundColor;
    [self.view addSubview:scro];
    scro.contentSize = CGSizeMake(LDScreenWidth, 1222);

    
    UIView * sub = [[UIView alloc] initWithFrame:self.view.frame];
    sub.backgroundColor = [UIColor redColor];
    [scro addSubview:sub];

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"圆角矩形-7"] forState:UIControlStateNormal];
    button.font = [UIFont systemFontOfSize:11];
    [button setTitle:@"2016年12月24日" forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    [scro addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scro);
        make.top.equalTo(self.view.top).offset(74);
        make.size.equalTo(CGSizeMake(100, 22));
    }];
//
//    UIView * back = [UIView new];
//    back.backgroundColor = [UIColor whiteColor];
//    [sub addSubview:back];
//    
//    
//    UILabel * titleLable = [UILabel new];
//    titleLable.numberOfLines = 0;
//    titleLable.font  =[UIFont systemFontOfSize:14];
//    titleLable.text = self.detaileModel.title;
//    [back addSubview:titleLable];
//    [titleLable makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(back).offset(LDPadding);
//        make.right.equalTo(back).offset(-LDPadding);
//        make.height.equalTo(40);
//        make.top.equalTo(back);
//    }];
//    
//    UILabel * detailLable = [UILabel new];
//    detailLable.numberOfLines = 0;
//    detailLable.alpha = 0.5;
//    detailLable.font  =[UIFont systemFontOfSize:14];
//    detailLable.text = self.detaileModel.content;
//    [back addSubview:detailLable];
//    [detailLable makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(titleLable);
//        make.right.equalTo(titleLable);
//        make.top.equalTo(titleLable.bottom).offset(5);
//    }];
//    
//    [back makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(sub).offset(LDPadding);
//        make.right.equalTo(sub).offset(-LDPadding);
//        make.height.equalTo(self.backViewHeight);
//        make.top.equalTo(self.view.top).offset(114);
//            
//
//    }];
//    lastView  = back;
//    
//    [sub makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(lastView.bottom);
//    }];
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
