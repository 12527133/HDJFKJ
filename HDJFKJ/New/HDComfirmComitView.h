

#import <UIKit/UIKit.h>

@interface HDComfirmComitView : UIView
+ (id)view;
/** 关闭按钮  */
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
/** 选择银行卡按钮 */
@property (weak, nonatomic) IBOutlet UIButton *chooseCardBank;
/** 确认提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
/** 客户电话 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNmuLabel;
/** 银行卡  */
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
/** 分期情况  */
@property (weak, nonatomic) IBOutlet UILabel *caseLabel;



@end
