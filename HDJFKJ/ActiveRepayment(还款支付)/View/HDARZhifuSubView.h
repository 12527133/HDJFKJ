

#import <UIKit/UIKit.h>

@interface HDARZhifuSubView : UIView

/** 京东icon*/
@property (nonatomic, strong) UIImageView * icon;

/** 支付名称 */
@property (nonatomic, strong) UILabel * zhifuLabel;

/** 选中icon */
@property (nonatomic, strong) UIImageView * selectIcon;

/** 按钮 */
@property (nonatomic, strong) UIButton * selectButton;

/** 创建子视图 */
- (void)createSubViews;
@end
