//
//  LDBankCardViewController.h
//  HDJFKJ
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBaseUIViewController.h"
#import "Globaltypedef.h"
#import "SCCaptureCameraController.h"
#import "IOSOCRAPI.h"
#import "WHBaseInfoModel.h"
#import "HDBankListModel.h"
@interface LDBankCardViewController : LDBaseUIViewController

@property (nonatomic,copy)void(^gobackBlock)();

@property (nonatomic, strong) WHBaseInfoModel * baseInfo;

@property (nonatomic, strong) HDBankListModel * bankModel;

@property (nonatomic, strong) NSString * fromBankCard;
@end
