

#import <UIKit/UIKit.h>

@interface WHPayBackChooseView : UIView

/** 图标 */
@property (nonatomic, strong) UIImageView * iconImage;

/** 左侧的Label */
@property (nonatomic, strong) UILabel * leftLabel;

/** 右侧的Button */
@property (nonatomic, strong) UIButton * rightButton;

/** 右侧箭头ImageView */
@property (nonatomic, strong) UIImageView * arrowImageView;

/** 右侧账单状态Label */
@property (nonatomic, strong) UILabel * statusLabel;

/** */
- (void)createSubViews;

@end
