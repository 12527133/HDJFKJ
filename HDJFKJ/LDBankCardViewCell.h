//
//  LDBankCardViewCell.h
//  HDJFKJ
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDBankCardViewCell : UITableViewCell
/**
 *  银行名称
 */
@property (weak, nonatomic) IBOutlet UILabel *bankName;
/**
 *  卡类型
 */
@property (weak, nonatomic) IBOutlet UILabel *bankType;
/**
 *  卡号
 */
@property (weak, nonatomic) IBOutlet UILabel *bankNumber;
@property (weak, nonatomic) IBOutlet UIImageView *bankImage;

@property (weak, nonatomic) IBOutlet UILabel *xinghaoLabel;

@end
