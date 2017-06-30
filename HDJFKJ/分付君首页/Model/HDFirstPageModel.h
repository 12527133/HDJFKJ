

#import <Foundation/Foundation.h>
#import "HDFirstPageDebtInfo.h"
#import "HDFirstPageOrderInfo.h"
#import "HDFirstPageBanner.h"


@interface HDFirstPageModel : NSObject

/** 信用分*/
@property (nonatomic, strong) NSString * creditScore;

/** 等级 */
@property (nonatomic, strong) NSString * level;

/** 消息数 */
@property (nonatomic, strong) NSString * messageCount;

/** 顶部banner图*/
@property (nonatomic, strong) NSArray * banner;

/** 还款计划 */
@property (nonatomic, strong) HDFirstPageDebtInfo * debtInfo;

/** 订单信息 */
@property (nonatomic, strong) HDFirstPageOrderInfo * orderInfo;

@end





































