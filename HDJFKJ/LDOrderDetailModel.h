//
//  LDOrderDetailModel.h
//  HDJFKJ
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>


//bankcardtailno = 7069;
//bankname = "北京银行京卡";
//businessid = 65;
//businessname = "东莞资优教育";
//commodityname = "智能领袖课程";
//downpayment = 0;
//duration = 12;
//feedback = "同意";
//orderno = 341144;
//periodamount = "1453.33";
//pic = "http://123.56.136.151:8180/STCash/mobile/picture/showpic?pid=/upload/48f322178ce9465f859a972c09b2c14f.png";
//status = "已通过";
//time = "2016-04-08 19:25:56";
//totalamount = 17440;


/**
 *  界面赋值元素
 */
@interface LDOrderDetailModel : NSObject
/**
 *  初始化方法
 */
+(instancetype)sharedInstance;

/**
 *  商户id
 */
@property (nonatomic,strong) NSString * businessId;
/**
 *  商户名称
 */
@property (nonatomic,strong) NSString * businessName;
/**
 *  商品图片url
 */
@property (nonatomic,strong) NSString * pic;
/**
 *  商品名称
 */
@property (nonatomic,strong) NSString * commodityname;
/**
 *  订单号
 */
@property (nonatomic,strong) NSString * orderNo;
/**
 *  下单时间
 */
@property (nonatomic,strong) NSString * time;
/**
 *  期贡金额
 */
@property (nonatomic,strong) NSString * periodAmount;
/**
 *  商品价格
 */
@property (nonatomic,strong) NSString * price;
/**
 *  总期数
 */
@property (nonatomic,strong) NSString * duration;
/**
 *  首付金额
 */
@property (nonatomic,strong) NSString * downpayment;
/**
 *  订单状态(有七种)
 */
@property (nonatomic,strong) NSString * status;
/**
 *  审核反馈信息,仅存在于已打回，已取消，已拒绝三种状态
 */
@property (nonatomic,strong) NSString * feedback;
/**
 *  银行名称
 */
@property (nonatomic,strong) NSString * bankName;
/**
 *  银行卡尾号（4位）
 */
@property (nonatomic,strong) NSString * cardNo;

/**
 *  商品总价
 */
@property (nonatomic,strong) NSString * totalPrice;

//现金或商品订单的标示，0表示商品，1标示现金贷
@property (nonatomic,strong) NSString * loanType;
//商品列表
@property (nonatomic, strong) NSArray * orderCommodity;
@end


/**
 *  服务器返回信息
 */
@interface LDOrderDetailBackModel : NSObject
/**
 *  返回码,正确：code = 0,错误：code <> 0
 */
@property (nonatomic,strong) NSString * code;
/**
 *  错误描述
 */
@property (nonatomic,strong) NSString * message;

@end