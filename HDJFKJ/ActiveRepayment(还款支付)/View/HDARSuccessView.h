

#import <UIKit/UIKit.h>

@interface HDARSuccessView : UIView

/** 创建标题View */
- (void)createTitleView;

/** 圆圈View  */
@property (nonatomic ,strong) UIView * circleView;

/** 圆弧View */
@property (nonatomic, strong) UIView * arcView;

/** 对号View */
@property (nonatomic, strong) UIView * matchView;


/** 绘制圆形View  */
- (void)drawCircleView;

/** 绘制弧形View */
- (void)drawArcView;

/** 绘制对号View */
- (void)drawmatchView;

/** 停止旋转 */
- (void)stopRotation;
@end
