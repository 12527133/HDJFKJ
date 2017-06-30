

#import <Foundation/Foundation.h>

/**
 * 首页分类列出的广告的模型
 */

@interface WHCommodity : NSObject

//商品id
@property (nonatomic, strong) NSString * id;
//商品图片url
@property (nonatomic, strong) NSString * pic;
//商品名称
@property (nonatomic, strong) NSString * name;
//月供金额
@property (nonatomic, assign) float periodamount;
//总期数
@property (nonatomic, assign) NSInteger duration;

+ (instancetype)paresCommodityWithDictionary:(NSDictionary *)dict;














@end
