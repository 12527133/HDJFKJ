

#import <UIKit/UIKit.h>

@interface CashLoanController : LDBaseUIViewController
/**
 *  分期数,(6,9,12...)
 */
@property (nonatomic,copy) NSString  * monthCount;
/**
 *  每月还款金额
 */
@property (nonatomic,copy) NSString  * moneyCount;
/**
 *  贷款总额
 */
@property (nonatomic,copy) NSString  * moneySumCount;

@end
