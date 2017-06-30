//
//  LDBeiYoneDownCell.h
//  HDJFKJ
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDBusinessDetailHeaderModel.h"

@interface LDBeiYoneDownCell : UITableViewCell
/**
 *  商品cell数据模型
 */
@property (nonatomic,strong) LDBusinessDetailCellModel * cellModel;
/** 模型数据 */
@property (nonatomic, strong) LDBusinessDetailHeaderModel *headerModel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
