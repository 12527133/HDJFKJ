

#import <Foundation/Foundation.h>

/**
 * 轮换广告的模型
 */

@interface WHBannerModel : NSObject


//商品id
@property (nonatomic, strong) NSString * id;
//商品图片url
@property (nonatomic, strong) NSString * pic;

+ (instancetype)paresBannerWithDictionary:(NSDictionary *)dict;
@end
