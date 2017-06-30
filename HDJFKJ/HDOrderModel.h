

#import <Foundation/Foundation.h>

@interface HDOrderModel : NSObject
//贷款申请id
@property (nonatomic, strong) NSString * id;//
//商户id
@property (nonatomic, strong) NSString * businessid;
//商户名称
@property (nonatomic, strong) NSString * businessname;//
//商品图片Url
@property (nonatomic, strong) NSString * pic;
//商品名称
@property (nonatomic, strong) NSString * commodityname;
//商品种类
@property (nonatomic, strong) NSString * category;
//贷款总额
@property (nonatomic, strong) NSString * applyamount;//
//贷款期数
@property (nonatomic, strong) NSString * duration;//
//期供金额
@property (nonatomic, strong) NSString * periodamount;
//订单状态
@property (nonatomic, strong) NSString * status;
//首付金额
@property (nonatomic, strong) NSString * downpayment;//
//订单类型
@property (nonatomic, strong) NSString * loanType;//
//订单号
@property (nonatomic, strong) NSString * orderno;
//时间
@property (nonatomic, strong) NSString * time;//
//
@property (nonatomic, strong) NSString * commodityId;
@end
