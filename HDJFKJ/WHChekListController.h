

#import <UIKit/UIKit.h>
#import "WHCheckModel.h"
@interface WHChekListController : LDBaseUIViewController


//审贷ID
@property (nonatomic, strong) NSString * orderID;

/** 显示状态 1，逾期，2，结清，3扣款失败，4，待还款
 *
 * 根据逾期天数 > 0  ，判断是逾期还是扣款失败。
 * 待还款只显示一个Sction。
 */
@property (nonatomic, assign) NSInteger checkStatus;

//还款详情模型
@property (nonatomic, strong) WHCheckModel * checkModel;




















@end
