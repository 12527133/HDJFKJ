

#import <UIKit/UIKit.h>

@interface HDCreditScoreTopView : UIView

/** 背景图 */
@property (nonatomic, strong) UIImageView * bgImageView;

/** 分数Label */
@property (nonatomic, strong) UILabel * scoreLabel;

/** 顶部Label */
@property (nonatomic, strong) UILabel * topLabel;

/** 底部Label */
@property (nonatomic, strong) UILabel * bottomLabel;


/** 创建子视图 */
- (void)createSubViews;

@end
