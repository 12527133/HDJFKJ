

#import <UIKit/UIKit.h>

@interface WHCashAndSaomaView : UIView
+ (id)view;
//扫码背景图
@property (weak, nonatomic) IBOutlet UIView *leftView;
//扫码按钮
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
//现金贷背景图
@property (weak, nonatomic) IBOutlet UIView *rightView;
//现金贷按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


/** 左侧视图上的控件  */
@property (weak, nonatomic) IBOutlet UILabel *LeftTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftContentLabel;

/** 右侧视图上的控件  */
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightContentLabel;



@end
