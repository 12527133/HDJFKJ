//
//  LDBusinessDetailModel.h
//  HDJFKJ
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDBusinessDetailHeaderModel : NSObject
/**
 *  头部,商家地址
 */
@property(nonatomic,copy) NSString * address;
/**
 *  商家名称
 */
@property(nonatomic,copy) NSString * name;
/**
 *  星星数
 */
@property(nonatomic,copy) NSString * star;
/**
 *  电话
 */
@property(nonatomic,copy) NSString * phone;
/**
 *  购买数
 */
@property(nonatomic,copy) NSString * privilege;

/**
 *  轮播器图片URL数组
 */
@property (nonatomic,strong) NSArray * piclist;
/**
 *  cell数据数组
 */
@property (nonatomic,strong) NSArray * list;

@end
/**
 *  商品列表
 */
@interface LDBusinessDetailCellModel : NSObject
/**
 *  商品id
 */
@property(nonatomic,copy) NSString * id;


/**
 *  商品图片url
 */
@property(nonatomic,copy) NSString * pic;
///**
// *  商品名称
// */
//@property(nonatomic,copy) NSString * businessname;
/**
 *  商品名称
 */
@property(nonatomic,copy) NSString * name;

/**
 *  商品星级
 */
@property(nonatomic,copy) NSString * star;
/**
 *  购买人数
 */
@property(nonatomic,copy) NSString * sale;
/**
 *  优惠：
 */
@property(nonatomic,copy) NSString * privilege;
/**
 *  最低期供金额
 */
@property(nonatomic,copy) NSString * periodamount;
/**
 *  最低期供专案总期数
 */
@property(nonatomic,copy) NSString * duration;
@end




