

#import <UIKit/UIKit.h>

@interface WHLeftButtonView : UIView
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 图片*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 视图上的按钮 */
@property (weak, nonatomic) IBOutlet UIButton *subButton;


/** 加载Xib方法 */
+ (id)view;
@end
