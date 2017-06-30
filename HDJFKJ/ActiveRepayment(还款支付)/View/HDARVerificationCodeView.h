

#import <UIKit/UIKit.h>

typedef void(^ComplationBlock)(NSString * password);
@interface HDARVerificationCodeView : UIView

/** 电话号码 */
@property (nonatomic, strong) NSString * phoneNo;

/** 副标题 */
@property (nonatomic, strong) UILabel * smallLabel;

/** 关闭按钮 */
@property (nonatomic, strong) UIButton * cancelButton;

/** 添加新的银行卡按钮 */
@property (nonatomic, strong) UIButton * againButton;

/** 输入验证码但不显示的TextFiled */
@property (nonatomic, strong) UITextField * textField;

/** 输入验证码为6位时自动返回*/
@property (nonatomic, copy) ComplationBlock complationBlock;

/** 验证码Lab了Array */
@property (nonatomic, strong) NSMutableArray * labelArray;

/** 创建子视图方法 */
- (void)createSubView;

/** 清空验证码 */
- (void)clearYanZhengMa;





































@end
