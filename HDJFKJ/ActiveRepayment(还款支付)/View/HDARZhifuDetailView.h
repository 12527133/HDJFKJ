

#import <UIKit/UIKit.h>

@interface HDARZhifuDetailView : UIView

/** 顶部Label  */
@property (nonatomic, strong) UILabel * topLabel;

/** 还款总额 */
@property (nonatomic, strong) UILabel * totalMoneyLabel;

/** 手续费 label  */
@property (nonatomic, strong) UILabel * shouxufeiLeftLabel;
@property (nonatomic, strong) UILabel * shouxufeiRightLabel;

/** 应还款金额 */
@property (nonatomic, strong) UILabel * payBackLeftLabel;
@property (nonatomic, strong) UILabel * payBackRightLabel;

/** 滞纳金 */
@property (nonatomic, strong) UILabel * lateFreeLeftLabel;
@property (nonatomic, strong) UILabel * lateFreerightLabel;

/** 优惠金额 */
@property (nonatomic, strong) UILabel * youhuiLeftLabel;
@property (nonatomic, strong) UILabel * youhuiRightLabel;

/** 创建子视图 */
- (void)createSubView;

/** 滞纳金为0不显示滞纳金 */
- (void)setLateFreeNilFrame;




























@end
