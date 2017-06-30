

#import <UIKit/UIKit.h>

@interface WHPayBackCell : UITableViewCell

/** 账单时间 */
@property (nonatomic, strong) UILabel * checkTimeLabel;

/** 账单期数 */
@property (nonatomic, strong) UILabel * periodCountLabel;

/** 期供金额 */
@property (nonatomic, strong) UILabel * periodPriceLabel;

/** 试图最左边的 蓝色箭头 */
@property (nonatomic, strong) UIImageView * arrowImageView;

/** 逾期标识 */
@property (nonatomic, strong) UILabel * yuqiLabel;

- (void)createSubViews;
























@end
