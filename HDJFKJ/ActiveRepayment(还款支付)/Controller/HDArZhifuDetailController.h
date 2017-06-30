

#import "LDBaseUIViewController.h"
#import "HDARRepayConfirm.h"
#import "HDOrderRepays.h"
#import "HDARBankDetail.h"
#import "LDHaveCardListModel.h"
#import "HDARBankCardList.h"
@interface HDArZhifuDetailController : LDBaseUIViewController

/** 确认信息 */
@property (nonatomic, strong) HDARRepayConfirm * repayConfirm;

/** 账单详情 */
@property (nonatomic, strong) HDOrderRepays * orderRepays;

/** 银行卡 */
@property (nonatomic, strong) LDHaveCardListModel * arBank;

/** 银行卡详情 */
@property (nonatomic, strong) HDARBankDetail * bankDetail;

/** 签约结果 */
@property (nonatomic, strong) HDARBankCardList * signResult;

@end
