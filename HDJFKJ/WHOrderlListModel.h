//
//  WHOrderlListModel.h
//  HDJFKJ
//
//  Created by 石伟浩 on 16/4/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHOrderlListModel : NSObject
//贷款申请id
@property (nonatomic, assign) NSInteger ids;
//商户id
@property (nonatomic, assign) NSInteger businessid;
//商户名称
@property (nonatomic, strong) NSString * businessname;
//商品图片Url
@property (nonatomic, strong) NSString * pic;
//商品名称
@property (nonatomic, strong) NSString * commodityname;
//商品种类
@property (nonatomic, strong) NSString * category;
//贷款总额
@property (nonatomic, assign) float apply_amount;
//优惠编号
@property (nonatomic, assign) NSInteger privilege;
//贷款期数
@property (nonatomic, assign) NSInteger duration;
//期供金额
@property (nonatomic, assign) float periodamount;
//订单状态
@property (nonatomic, strong) NSString * status;






+ (instancetype)paresOrderListWithDictionary:(NSDictionary *)dict;

























@end
