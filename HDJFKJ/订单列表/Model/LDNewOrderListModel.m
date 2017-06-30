//
//  LDNewOrderListModel.m
//  HDJFKJ
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNewOrderListModel.h"

@implementation LDNewOrderListModel

- (void)setOrderCommoditys:(NSArray *)orderCommoditys{

    _orderCommoditys = [HDNewOrderGoods mj_objectArrayWithKeyValuesArray:orderCommoditys];
}

//- (NSArray *)orderCommoditys{
//    if (!_orderCommoditys) {
//        _orderCommoditys = [NSArray array];
//    }
//    return _orderCommoditys;
//
//}
//
//+ (NSDictionary *)mj_objectClassInArray{
//
//    return @{@"orderCommoditys":@"LDSmallOrderListModel"};
//
//}
@end


//@implementation LDSmallOrderListModel
//
//@end
