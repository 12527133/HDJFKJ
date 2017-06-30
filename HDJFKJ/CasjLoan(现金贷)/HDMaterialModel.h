

#import <Foundation/Foundation.h>

@interface HDMaterialModel : NSObject

/** 银行卡流水数据 */
@property (nonatomic, strong) NSArray * liushui;

/** 资产证明数据 */
@property (nonatomic, strong) NSArray * zichan;

/** 其他资料数据 */
@property (nonatomic, strong) NSArray * others;

@end
