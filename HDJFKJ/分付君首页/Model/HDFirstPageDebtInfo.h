

#import <Foundation/Foundation.h>

@interface HDFirstPageDebtInfo : NSObject
/** 贷款申请id*/
@property (nonatomic, strong)NSString * applyId;

/** 还款额 */
@property (nonatomic, strong) NSString * repaymentAmt;

/** 立即还款按钮的标示 */
@property (nonatomic, strong) NSString * activePayFlag;
@end
