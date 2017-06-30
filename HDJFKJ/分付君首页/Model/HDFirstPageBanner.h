

#import <Foundation/Foundation.h>

@interface HDFirstPageBanner : NSObject
/** 图片id  */
@property (nonatomic,strong) NSString * id;
/** 图片url */
@property (nonatomic,strong) NSString * pic;

/** 跳转方式 */
@property (nonatomic,strong) NSString * jumpType;

/** 跳转页面地址 */
@property (nonatomic, strong) NSString * pageUrl;


@end
