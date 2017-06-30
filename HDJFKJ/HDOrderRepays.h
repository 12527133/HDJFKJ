

#import <Foundation/Foundation.h>

@interface HDOrderRepays : NSObject

/** 订单号 */
@property (nonatomic, strong) NSString * orderNo;
///** 借据号 */
//@property (nonatomic, strong) NSString * loanNo;

/** 总期数 */
@property (nonatomic, strong) NSString * duration;

/** 账单列表 */
@property (nonatomic, strong) NSArray * list;





/** 已还总金额 */
@property (nonatomic, strong) NSString * settledAmount;

/** 未到期总金额 */
@property (nonatomic, strong) NSString * unDueAmount;

/** 近期日应还款 */
@property (nonatomic, strong) NSString * sevenAmount;
























@end
