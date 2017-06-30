

#import <Foundation/Foundation.h>

@interface HDARBankDetail : NSObject

/** 持卡人姓名  */
@property (nonatomic, strong) NSString * holder;

/** 持卡人身份证 */
@property (nonatomic, strong) NSString * holderNo;

/** 银行简称 */
@property (nonatomic, strong) NSString * bankCode;

/** 卡号 */
@property (nonatomic, strong) NSString * cardNo;

/** 预留手机号 */
@property (nonatomic, strong) NSString * phone;

/** 银行名称  */
@property (nonatomic, strong) NSString * bankName;




















































@end
