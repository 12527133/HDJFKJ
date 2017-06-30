//
//  LDNewOrderListModel.h
//  HDJFKJ
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDNewOrderGoods.h"
//@interface LDSmallOrderListModel : NSObject
///** name  */
//@property (nonatomic,strong) NSString * commodityName;
///** name  */
//@property (nonatomic,strong) NSString * commodityPrice;
///** name  */
//@property (nonatomic,strong) NSString * commodityCount;
///** name  */
//@property (nonatomic,strong) NSString * pic;
//@end

@interface LDNewOrderListModel : NSObject

/** 业务员 */
@property (nonatomic,strong) NSString * ownSaleMan;

/** 商品列表  */
@property (nonatomic,strong) NSArray * orderCommoditys;

/**
 *  贷款申请id
 */
@property (nonatomic,strong) NSString * id;
/**
 *  商户id
 */
@property (nonatomic,strong) NSString * businessId;
/** 商户名称  */
@property (nonatomic,strong) NSString * businessName;
/** 总价  */
@property (nonatomic,strong) NSString * totalPrice;
/** 申请金额  */
@property (nonatomic,strong) NSString * applyAmount;
/** 期供金额  */
@property (nonatomic,strong) NSString * periodAmount;
/** 期限  */
@property (nonatomic,strong) NSString * duration;
/** 订单状态  */
@property (nonatomic,strong) NSString * status;
/** 订单编号  */
@property (nonatomic,strong) NSString * orderNo;
/** 下单时间  */
@property (nonatomic,strong) NSString * time;
/** 首付  */
@property (nonatomic,strong) NSString * downpayment;

@property (nonatomic,strong) NSString * discountAmount;
@property (nonatomic,strong) NSString * createDate;
@property (nonatomic,strong) NSString * loanType;
@property (nonatomic,strong) NSString * remarks;
@property (nonatomic,strong) NSString * updateDate;

@end




//@interface LDSmallNewOrderListModel : NSObject
///**
// *  贷款申请id
// */
//@property (nonatomic,strong) NSString * id;
///**
// *  贷款申请id
// */
//@property (nonatomic,strong) NSString * businessId;
///** 商品名称  */
//@property (nonatomic,strong) NSString * commodityName;
///** 商品价格  */
//@property (nonatomic,strong) NSString * commodityPrice;
///** 商品图片url  */
//@property (nonatomic,strong) NSString * pic;
///** 商品数量  */
//@property (nonatomic,strong) NSString * count;
//@property (nonatomic,strong) NSString * commodityCount;
//@end


