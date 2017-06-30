//
//  LDGoodsIDAndZhuanAnId.h
//  HDJFKJ
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDGoodsIDAndZhuanAnId : NSObject

+(instancetype)sharedInstance;

/**
 *  商品ID
 */
@property (nonatomic,copy) NSString * id;
/**
 *  商品名称
 */
@property (nonatomic,copy) NSString * name;
/**
 *  专案ID
 */
@property (nonatomic,copy) NSString * zhuanAnID;
/**
 *  总价
 */
@property (nonatomic,copy) NSString * commodityprice;

/**
 *  商品编号(购买验证参数)
 */
@property (nonatomic,copy) NSString * commodityno;

/**
 *  商品类别(在"确认订单"显示)
 */
@property (nonatomic,copy) NSString * category;
/**
 *  商户名称
 */
@property (nonatomic,copy) NSString * businessname;

/**
 *  商户ID
 */
@property (nonatomic,copy) NSString * busnessID;



//+ (instancetype)LDGoodsIDAndZhuanAnIdGoodsID:(NSString *)goodsID andZhuanAnId:(NSString *)ZhuanAnId andCommodityno:(NSString *)commodityno;
//
//- (instancetype)initWithGoodsID:(NSString *)GoodsID andZhuanAnId:(NSString *)ZhuanAnId andCommodityno:(NSString *)commodityno andCategory:(NSString *)category;
//

//+(void)removeData;

@end
