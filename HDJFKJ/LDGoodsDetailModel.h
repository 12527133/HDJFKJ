//
//  LDGoodsDetailModel.h
//  HDJFKJ
//
//  Created by apple on 16/3/27.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LDGoodsDetailIDModel : NSObject
/**
 *  专案id
 */
@property (nonatomic,copy) NSString * id;
/**
 *  专案期次
 */
@property (nonatomic,copy) NSString * duration;
/**
 *  专案月供金额
 */
@property (nonatomic,copy) NSString * periodamount;
/**
 *  首付金额
 */
@property (nonatomic,copy) NSString * downpayment;

@end

@interface LDGoodsDetailModel : NSObject

/** 下个页面需要的信息,需要做保存
 *  商品名称
 */
@property (nonatomic,copy) NSString * name;

/**
 *  商户名称
 */
@property (nonatomic,copy) NSString * businessname;
/**
 *  商户ID
 */
@property (nonatomic,copy) NSString * businessid;

/**
 *  商品编号（作为“购买验证”参数）
 */
@property (nonatomic,copy) NSString * commodityno;
/**
 *  首付金额
 */
@property (nonatomic,copy) NSString * downpayment;

/**
 *  商品类别（在“确认订单”显示）
 */
@property (nonatomic,copy) NSString * category;
/**
 *  商品专案列表（在“确认订单”显示）
 */
@property (nonatomic,strong) NSArray * cases;

/**
 *  url
 */
@property (nonatomic,strong) NSString * pic;


/**
 *  调试信息
 */
@property (nonatomic,copy) NSString * code;
/**
 *  服务器返回信息
 */
@property (nonatomic,copy) NSString * message;
/**
 *  返回数据集合
 */
@property (nonatomic,copy) NSString * result;



/**
 *  商品图片url列表
 */
@property (nonatomic,copy) NSArray * piclist;
/**
 *  购买人数
 */
@property (nonatomic,copy) NSString * sale;
/**
 *  星星数
 */
@property (nonatomic,copy) NSString * star;
/**
 *  商品价格(总价)
 */
@property (nonatomic,copy) NSString * commodityprice;

/**
 *   优惠
 */
@property (nonatomic,copy) NSString * privilege;


/**
 *  申请总额
 */
@property (nonatomic,copy) NSString * applyamount;
/**
 *  期次（专案最长期次）
 */
@property (nonatomic,copy) NSString * duration;


/**
 *  最低月供金额
 */
@property (nonatomic,copy) NSString * periodamount;
/**
 *  商家地址
 */
@property (nonatomic,copy) NSString * address;
/**
 *  规格说明
 */
@property (nonatomic,copy) NSString * parameter;


/**
 *  商品描述
 */
@property (nonatomic,copy) NSString * desc;

///**
// *  专案期次
// */
//@property (nonatomic,copy) NSString * fee;

@end


