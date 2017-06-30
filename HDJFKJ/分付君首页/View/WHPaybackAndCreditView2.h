

#import <UIKit/UIKit.h>

@interface WHPaybackAndCreditView2 : UIView
+ (id)view;
//信用分Label
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
//去登陆Label
@property (weak, nonatomic) IBOutlet UILabel *goLoginLabel;
//加载三角图标
@property (weak, nonatomic) IBOutlet UIImageView *goImageView;
//“还款计划”Label
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
