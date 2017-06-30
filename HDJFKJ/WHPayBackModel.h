

#import <Foundation/Foundation.h>

@interface WHPayBackModel : NSObject

/** 期次 */
@property (nonatomic, strong) NSString * period;

/** 期供金额 */
@property (nonatomic, strong) NSString * periodAmt;

/** 到期日期 */
@property (nonatomic, strong) NSString * dueDate;

/** 账单状态：1，待还款 0，已还清  -1；逾期  2，未到期 */
@property (nonatomic, strong) NSString * status;

@property (nonatomic, strong) NSString * loanNo;

/** 滞纳金 */
@property (nonatomic, strong) NSString * lateFee;













@end
