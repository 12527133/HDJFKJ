

#import <Foundation/Foundation.h>

@interface HDSubmitOrder : NSObject

//单利
+(instancetype)shardSubmitOrder;

//申请价格
@property (nonatomic, strong) NSString * applyAmount;

//首付款
@property (nonatomic, strong) NSString * downpayment;

//总价
@property (nonatomic, strong) NSString * totalAmount;

//商品包id
@property (nonatomic, strong) NSString * packageId;

//专案id
@property (nonatomic, strong) NSString * caseId;

//专案详情
@property (nonatomic, strong) NSString * caseDetail;

//商户id
@property (nonatomic, strong) NSString * businessId;

//银行卡id
@property (nonatomic, strong) NSString * bankcardId;

//订单号
@property (nonatomic, strong) NSString * orderNo;

//线下渠道
@property (nonatomic, strong) NSString * termial;

//商品列表
@property (nonatomic, strong) NSString * commoditys;

//提交订单类型
@property (nonatomic, strong) NSString * loanType;

//商品名称
@property (nonatomic, strong) NSString * goodsName;


- (void)setAttributeNull;


















@end
