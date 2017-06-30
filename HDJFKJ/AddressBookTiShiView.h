

#import <UIKit/UIKit.h>
typedef void(^addressBookSureBlock)();
@interface AddressBookTiShiView : UIView


/** 标题Label */
@property (nonatomic, strong) UILabel * titleLabel;
/** 确定按钮 */
@property (nonatomic, strong) UIButton * sureButton;

@property (nonatomic, strong ) UIView * bgView;

@property (nonatomic, strong) addressBookSureBlock addressBookSure;

- (void)createViewWithTitle:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle;
@end
