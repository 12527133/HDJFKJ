

#import <UIKit/UIKit.h>
#import "HDARZhifuSubView.h"

@interface HDARZhifufangshiView : UIView

/** 标题Label */
@property (nonatomic, strong) UILabel * titleLabel;

/** 支付方式数组 */
@property (nonatomic, strong) NSArray * zhifuArray;

/** 当前选中的支付方式视图 */
@property (nonatomic, strong) HDARZhifuSubView * currentZhifu;


/** 创建子视图 */
- (void)createSubViews;













@end
