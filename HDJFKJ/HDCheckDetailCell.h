

#import <UIKit/UIKit.h>

@interface HDCheckDetailCell : UITableViewCell


/** 左侧label  */
@property (nonatomic, strong) UILabel * leftlabel;

/** 右侧Label */
@property (nonatomic, strong) UILabel * rightLabel;

- (void)createSubViews;
@end
