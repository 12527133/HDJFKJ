

#import <Foundation/Foundation.h>

@interface WHWithOrder : NSObject

//商品包ID
@property (nonatomic, strong) NSString * packageId;

//商品名称
@property (nonatomic, strong) NSString * commodityName;

//商品价格
@property (nonatomic, strong) NSString * commodityPrice;

//商品图片url
@property (nonatomic, strong) NSString * commodityUrl;

//申请金额
@property (nonatomic, strong) NSString * applyAmount;

//扫码日期
@property (nonatomic, strong) NSString * scanDate;

//商户iD
@property (nonatomic, strong) NSString * bussinessId;

//商户名称
@property (nonatomic, strong) NSString * bussinessName;

//专案ID
@property (nonatomic, strong) NSString * caseId;

//商品ID
@property (nonatomic, strong) NSString * commodityId;

//首付金额
@property (nonatomic, strong) NSString * downpayment;

//期数
@property (nonatomic, strong) NSString * duration;

//商品金额
@property (nonatomic, strong) NSString * periodAmount;

//状态
@property (nonatomic, strong) NSString * status;





















@end
