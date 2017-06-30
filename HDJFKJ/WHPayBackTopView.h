

#import <UIKit/UIKit.h>

@interface WHPayBackTopView : UIView

/** 显示“累计还款”的label*/
@property (nonatomic, strong) UILabel * topLabel;

/** 显示还款额的label */
@property (nonatomic, strong) UILabel * totalPriceLabel;

/** 创建子控件 方法 */
- (void)createSubViews;
@end
