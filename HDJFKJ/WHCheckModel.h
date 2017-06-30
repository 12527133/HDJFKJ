

#import <Foundation/Foundation.h>

@interface WHCheckModel : NSObject

/** 还款月份 */
@property (nonatomic, strong) NSString * curDate;

/** 应还本金 */
@property (nonatomic, strong) NSString * psInstmAmt;

/** 滞纳金 */
@property (nonatomic, strong) NSString * lateFee;

/** 最晚还款日 */
@property (nonatomic, strong) NSString * dueDate;

/** 总期数 */
@property (nonatomic, strong) NSString * duration;

/** 当前期数 */
@property (nonatomic, strong) NSString * curPeriod;

/** 银行卡信息 */
@property (nonatomic, strong) NSString * bankCard;

/**  扣款状态  */
@property (nonatomic, strong) NSString * settleStatus;

/** 扣款日期 */
@property (nonatomic, strong) NSString * settleDate;

/** 失败原因 */
@property (nonatomic, strong) NSString * failReson;

/** 逾期天数 */
@property (nonatomic, strong) NSString * lateDays;

/** 账单详情状态 1：待还款  0：已还清  -1：逾期 */
@property (nonatomic, strong) NSString * status;

















@end
