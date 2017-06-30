

#import <Foundation/Foundation.h>

@interface WHShouYeModel : NSObject

//省份
@property (nonatomic, strong) NSString * region;
//还款状态
@property (nonatomic, strong) NSString * repaystatus;
//未读消息数
@property (nonatomic, strong) NSString * messagecount;
//轮换商品列表
@property (nonatomic, strong) NSArray * banner;
//轮换商品下方商品列表
@property (nonatomic, strong) NSArray * bannerdown;
//分类广告列表
@property (nonatomic, strong) NSArray * categoryadcommoditys;


+ (instancetype)paresShouYeWithDictionary:(NSDictionary *)dict;






















@end
