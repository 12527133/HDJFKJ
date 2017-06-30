

#import <Foundation/Foundation.h>

@interface HDARRepayConfirm : NSObject

/** 商品名称 */
@property (nonatomic, strong) NSString * commodityName;

/** 还款金额 */
@property (nonatomic, strong) NSString * repayAmt;

/** 手续费 */
@property (nonatomic, strong) NSString * paymentFee;

/** 应还本金 */
@property (nonatomic, strong) NSString * psInstmAmt;

/** 滞纳金 */
@property (nonatomic, strong) NSString * lateFee;

/** 优惠金额 */
@property (nonatomic, strong) NSString * discountAmt;

/** 银行卡id */
@property (nonatomic, strong) NSString * bankCardId;

/** 银行名称 */
@property (nonatomic, strong) NSString * bankName;

/** 银行卡号 */
@property (nonatomic, strong) NSString * bankNo;




















@end
