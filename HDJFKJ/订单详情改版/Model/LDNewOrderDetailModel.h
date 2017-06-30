//
//  LDNewOrderDetailModel.h
//  HDJFKJ
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDNewOrderDetailModel : NSObject

/** 业务员 */
@property (nonatomic,strong) NSString * ownSaleMan;

/** 打回原因  */
@property (nonatomic,strong) NSString * feedback;

/** name  */
@property (nonatomic,strong) NSString * applyAmount;
/** name  */
@property (nonatomic,strong) NSString * bankName;
/** name  */
@property (nonatomic,strong) NSString * businessName;
/** name  */
@property (nonatomic,strong) NSString * cardNo;
/** name  */
@property (nonatomic,strong) NSString * discountAmount;
/** name  */
@property (nonatomic,strong) NSString * downpayment;
/** name  */
@property (nonatomic,strong) NSString * duration;
/** name  */
@property (nonatomic,strong) NSString * id;

/** name  */
@property (nonatomic,strong) NSString * loanType;

/** name  */
@property (nonatomic,strong) NSString * orderNo;

/** name  */
@property (nonatomic,strong) NSString * periodAmount;

/** name  */
@property (nonatomic,strong) NSString * status;
/** name  */
@property (nonatomic,strong) NSString * time;
/** name  */
@property (nonatomic,strong) NSString * totalPrice;

/** name  */
@property (nonatomic,strong) NSArray * orderCommoditys;

/** 商户id */
@property (nonatomic,strong) NSString * businessId;


@end
@interface LDSmallNewOrderDetailModel : NSObject

/** name  */
@property (nonatomic,strong) NSString * commodityName;
/** name  */
@property (nonatomic,strong) NSString * commodityPrice;
/** name  */
@property (nonatomic,strong) NSString * count;
@property (nonatomic,strong) NSString * commodityCount;
/** name  */
@property (nonatomic,strong) NSString * pic;

@end
