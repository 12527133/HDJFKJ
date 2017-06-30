

#import <UIKit/UIKit.h>

@interface WHCheckTopView : UIView


/** 账单日期Label */
@property (nonatomic, strong) UILabel * checkDateLabel;

/** 账单金额label */
@property (nonatomic, strong) UILabel * checkMoneyLabel;

/** 截取标示icon */
@property (nonatomic, strong) UIImageView * settledImageView;

/** 滞纳金Label */
@property (nonatomic, strong) UILabel * lateFeeLabel;

/** 创建子视图 */
- (void)createSubViews;

/**调整控件的位置 */
- (void)setSubViewsFrame;




















@end
