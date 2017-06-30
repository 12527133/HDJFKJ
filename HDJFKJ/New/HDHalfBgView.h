

#import <UIKit/UIKit.h>
#import "HDComfirmComitView.h"
#import "HDChooseBankView.h"
typedef void(^AddBankCardBlock)();
typedef void(^PasswordSuccessBlock)(NSString * bankID);

@interface HDHalfBgView : UIView
@property (nonatomic, strong) AddBankCardBlock addbankCard;

@property (nonatomic, strong) PasswordSuccessBlock successBlock;

/**  选择银行卡 */
@property (nonatomic, strong) HDChooseBankView * chooseBankView;

//分期数组
@property (nonatomic, strong) NSArray * stagesArray;

//银行卡数组
@property (nonatomic, strong) NSArray * bankCardArray;

//当前银行卡id
@property (nonatomic, strong) NSString * bankCardID;

/**  分期详情  */
@property (nonatomic, strong) HDComfirmComitView * comfimView;

//创建视图
+ (HDHalfBgView *)createHDHalfBgViewWithView:(UIView *)view;

//加载确认分期试图
- (void)addComfimComiteView;

- (void)reloadAddBankTableViewWith:(NSArray *)bankCardArr;

@end
