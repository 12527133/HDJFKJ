

#import <Foundation/Foundation.h>

@interface WHOrderListModel : NSObject
//贷款申请id
@property (nonatomic, strong) NSString * id;

//商户id
@property (nonatomic, strong) NSString * businessid ;

//商户名称
@property (nonatomic, strong) NSString * businessname;

//图片Url
@property (nonatomic, strong) NSString * pic;

//商品名称
@property (nonatomic, strong) NSString * commodityname;

//商品种类
@property (nonatomic, strong) NSString * category;

//贷款总额
@property (nonatomic, strong) NSString * applyamount;

//期供金额
@property (nonatomic, strong) NSString * periodamount;

//总期数
@property (nonatomic, strong) NSString * duration;

//首付金额
@property (nonatomic, strong) NSString * downpayment;

//订单状态
@property (nonatomic, strong) NSString * status;

@property(nonatomic,copy) NSString * commodityPrice;

@property(nonatomic,copy) NSString * applyTime;








@end
