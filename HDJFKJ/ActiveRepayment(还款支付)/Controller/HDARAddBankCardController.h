

#import "LDBaseUIViewController.h"
#import "WHBaseInfoModel.h"
#import "HDARBankCardList.h"
#import "HDARRepayConfirm.h"
#import "HDOrderRepays.h"
#import "HDBankListModel.h"
#import "HDARBankDetail.h"

typedef void(^SignSuccessBlock)(HDARBankCardList * arBank);
@interface HDARAddBankCardController : LDBaseUIViewController


/** 签约成功回调Block */
@property (nonatomic, strong) SignSuccessBlock signSuccess;

@property (nonatomic, strong) HDBankListModel * bankModel;

@property (nonatomic, strong) WHBaseInfoModel * baseInfo;

@property (nonatomic, strong) HDARBankDetail * bankDetail;

@property (nonatomic, strong) HDARRepayConfirm * repayConfirm;

@property (nonatomic, strong) HDOrderRepays * orderRepays;

@end
