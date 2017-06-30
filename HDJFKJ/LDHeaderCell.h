//
//  LDHeaderCell.h
//  HDJFKJ
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDBusinessDetailHeaderModel;
@interface LDHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *backButton;

/** 模型数据 */
@property (nonatomic, strong) LDBusinessDetailHeaderModel *headerModel;
@end
