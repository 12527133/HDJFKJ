

#import <UIKit/UIKit.h>

@interface LDPaymentPasswordSureController : LDBaseUIViewController

@property(nonatomic,copy) NSString * passWordText;
/**
 *  哪个流程"zhuce","xiadan","wode","xianjindai","anquanzhongxin"取值情况:四个字符串,
 */
@property (nonatomic,copy) NSString * fromeWhere;

@property (nonatomic,copy)NSString * zaiciPassWord;
@end
