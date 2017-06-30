

#import <Foundation/Foundation.h>


@interface HDNSNotificModel : NSObject


/** 单利 */
+(instancetype)sharedInstance;


@property (nonatomic, strong) NSString * sound;

/** 提示内容 */
@property (nonatomic, strong) NSDictionary * aps;

/** 订单id */
@property (nonatomic, strong) NSString * applyId;

/** 消息类型 */
@property (nonatomic, strong) NSString * pushType;

/** 不知道是啥  */
@property (nonatomic, strong) NSString * d;
@property (nonatomic, strong) NSString * p;












@end
