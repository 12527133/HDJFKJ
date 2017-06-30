

#import <Foundation/Foundation.h>

/**
 * 首页分类的模型
 */

@interface WHCategoryadcommoditys : NSObject
//商品类别
@property (nonatomic, strong) NSString * category;

//类别商品列表
@property (nonatomic, strong) NSArray * commoditys;


+ (instancetype)paresCategoryadcommoditysWithDictionary:(NSDictionary *)dict;






@end
