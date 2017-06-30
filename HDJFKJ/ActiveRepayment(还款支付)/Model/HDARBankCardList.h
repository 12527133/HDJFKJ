

#import <Foundation/Foundation.h>

@interface HDARBankCardList : NSObject

/** 所属银行名称  */
@property (nonatomic, strong) NSString * bank;

/** 卡号后四位 */
@property (nonatomic, strong) NSString * cardtailno;

/** 交易id */
@property (nonatomic, strong) NSString * paymentId;

/** bankCardId */
@property (nonatomic, strong) NSString * bankCardId;

/** 签约手机号 */
@property (nonatomic, strong) NSString * phone;

























































@end
