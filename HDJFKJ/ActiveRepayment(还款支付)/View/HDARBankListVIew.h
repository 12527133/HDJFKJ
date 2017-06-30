

#import <UIKit/UIKit.h>
#import "HDBankNameCell.h"
#import "LDHaveCardListModel.h"

typedef void(^SelectBankBlock)(LDHaveCardListModel * arBank);

@interface HDARBankListVIew : UIView

/** 银行卡数组 */
@property (nonatomic, strong) NSMutableArray * bankCardArray;



/** 关闭按钮 */
@property (nonatomic, strong) UIButton * cancelButton;

/** 添加新的银行卡按钮 */
@property (nonatomic, strong) UIButton * bankButton;

/** 银行卡列表 */
@property (nonatomic, strong) UITableView * bankTableView;

/** 点击cell Block回调 */
@property (nonatomic, strong) SelectBankBlock selectBank;

/** 创建子视图 */
- (void)createSubView;







@end
