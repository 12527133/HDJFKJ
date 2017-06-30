//
//  LDOtherInforCell.h
//  HDJFKJ
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDReviewModel.h"
#import "WHCustomInfoInfoStepAll.h"
#import "HDForceAuthFlag.h"


@interface LDOtherInforCell : UITableViewCell
@property (nonatomic, strong) LDReviewModel * reviewModel;

@property (nonatomic, strong) WHCustomInfoInfoStepAll * customInfo;

/** 授权信息 */
@property (nonatomic, strong)  HDForceAuthFlag * force;

@end
