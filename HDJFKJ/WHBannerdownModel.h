

#import <Foundation/Foundation.h>

/**
 * 轮换广告下面的广告模型
 */

@interface WHBannerdownModel : NSObject
//广告图片位置
@property (nonatomic, assign) NSInteger  pose;
//商品id
@property (nonatomic, strong) NSString * id;
//商品图片url
@property (nonatomic, strong) NSString * pic;

+ (instancetype)paresBannerdownWithDictionary:(NSDictionary *)dict;

@end
