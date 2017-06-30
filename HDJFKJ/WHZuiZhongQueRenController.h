//
//  WHZuiZhongQueRenController.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/4/6.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDOrderDetailModel.h"
@interface WHZuiZhongQueRenController : LDBaseUIViewController



//上半部分的背景视图，透明
@property (weak, nonatomic) IBOutlet UIView *topView;
//中间部分的背景视图
@property (weak, nonatomic) IBOutlet UIView *middleView;
//下半部分的背景视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *signButton;

@property (weak, nonatomic) IBOutlet UIButton *aginSignButton;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;




//订单号label
@property (nonatomic, strong) UILabel * orderIDLabel ;
//订单时间label
@property (nonatomic, strong) UILabel * orderTimeLabel ;

//支付方式label
@property (nonatomic, strong) UILabel * paywayLabel;
//分期数label
@property (nonatomic, strong) UILabel * fenqiLabel;
//每期金额
@property (nonatomic, strong) UILabel * qigongjinELabel;
//签名ImageView
@property (nonatomic, strong) UIImageView * imageView;



@property (nonatomic, strong) LDOrderDetailModel * orderDetailModel;

@end
