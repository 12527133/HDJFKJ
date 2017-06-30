

#import <Foundation/Foundation.h>

@interface HDQRCommodity : NSObject


//商品数量
@property (nonatomic, strong) NSString * commodityCount;

//商品id
@property (nonatomic, strong) NSString * commodityId;

//商品名称
@property (nonatomic, strong) NSString * commodityName;

//商品价格
@property (nonatomic, strong) NSString * commodityPrice;

//图片url
@property (nonatomic, strong) NSString * pic;


/** 租房添加  */
//租房地址 地区
@property (nonatomic, strong) NSString * addrArea;
//市
@property (nonatomic, strong) NSString * addrCounty;
//详细地址
@property (nonatomic, strong) NSString * addrDetail;
//省
@property (nonatomic, strong) NSString * addrProvince;
//支付方式：@“押一付一，押二付一”
@property (nonatomic, strong) NSString * downpaymentType;
//期数
@property (nonatomic, strong) NSString * duration;
//开始日期
@property (nonatomic, strong) NSString * startDate;
//结束日期
@property (nonatomic, strong) NSString * endDate;
//每月租金
@property (nonatomic, strong) NSString * monthRent;



@end
