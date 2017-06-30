

#import <UIKit/UIKit.h>

@interface HDCreditScoreBottomView : UIView

/** 完善程度Label */
@property (nonatomic, strong) UILabel * topLabel;

/** 从左至右 四个icon */
@property (nonatomic, strong) UIImageView * icon1;
@property (nonatomic, strong) UIImageView * icon2;
@property (nonatomic, strong) UIImageView * icon3;
@property (nonatomic, strong) UIImageView * icon4;

/** 从左至右 四个资料类型Label */
@property (nonatomic, strong) UILabel * label1;
@property (nonatomic, strong) UILabel * label2;
@property (nonatomic, strong) UILabel * label3;
@property (nonatomic, strong) UILabel * label4;


/** 底部分割线 */
@property (nonatomic, strong) UILabel * lineLabel;

/** 从左至右四个按钮 */
@property (nonatomic, strong) UIButton * button1;
@property (nonatomic, strong) UIButton * button2;
@property (nonatomic, strong) UIButton * button3;
@property (nonatomic, strong) UIButton * button4;


/** 创建subViews */
- (void)createSubViews;



















@end
