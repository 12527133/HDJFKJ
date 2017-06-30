

#import <UIKit/UIKit.h>

@interface HDPayBackMiddleView : UIView


/** 左侧topLabel */
@property (nonatomic, strong) UILabel * leftTopLabel;

/** 左侧bottomLabel */
@property (nonatomic, strong) UILabel * leftBottomLabel;

/** 右侧topLabel */
@property (nonatomic, strong) UILabel * rightTopLabel;

/** 右侧bottomLabel */
@property (nonatomic, strong) UILabel * rightBottomLabel;

- (void)createSubViews;
@end
