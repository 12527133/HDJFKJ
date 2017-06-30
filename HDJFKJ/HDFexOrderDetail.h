//
//  HDFexOrderDetail.h
//  MerchantEdition
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBaseUIViewController.h"
#import "WHQROrderModel.h"
#import "WHWithOrder.h"
@interface HDFexOrderDetail : LDBaseUIViewController

@property (nonatomic,strong) WHQROrderModel * detailModel;

@property (nonatomic, strong) WHWithOrder* withOutOrder;
@end
