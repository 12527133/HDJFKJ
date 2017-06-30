

#import <Foundation/Foundation.h>


/**
 * 用于商品列表的模型
 */

@interface WHHomeGoodsModel : NSObject
//商品id
@property (nonatomic, strong) NSString * id;
//商品图片Url
@property (nonatomic, strong) NSString * pic;
//商品星级
@property (nonatomic, assign) float star;
//商品名称
@property (nonatomic, strong) NSString *name;
//购买人数
@property (nonatomic, assign) NSInteger sale;
//商户名称
@property (nonatomic, strong) NSString * businessname;
//优惠标示服
@property (nonatomic, assign) NSInteger privilege;
//最低期供金额
@property (nonatomic, assign) float periodamount;
//最低期供专案总期数
@property (nonatomic, assign) NSInteger duration;
//首付金额
@property (nonatomic, assign) float downpayment;


+ (instancetype)paresGoodWithDictionary:(NSDictionary *)dict;










@end
