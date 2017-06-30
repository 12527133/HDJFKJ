

#import <UIKit/UIKit.h>

@interface WHRightButtonView : UIView


//消息提示view
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

//视图上的Button
@property (weak, nonatomic) IBOutlet UIButton *button;
//message背景图
@property (weak, nonatomic) IBOutlet UIView *messageBgView;

+ (id)view;
@end
