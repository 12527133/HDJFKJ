

#import <Foundation/Foundation.h>

@interface HDFirstPageOrderInfo : NSObject
/** 订单id*/
@property (nonatomic, strong) NSString * applyId;

/** 订单时间*/
@property (nonatomic, strong) NSString * applyDate;

/** 商品名称 */
@property (nonatomic, strong) NSString * commodityName;

/** 订单状态 */
@property (nonatomic, strong) NSString * status;
@end
