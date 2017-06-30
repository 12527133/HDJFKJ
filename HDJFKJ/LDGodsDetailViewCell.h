//
//  LDGodsDetailViewCell.h
//  HDJFKJ
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDGodsDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *place;
/**
 *  首付价格lable
 */
@property (weak, nonatomic) IBOutlet UILabel *fistPayMoney;
/**
 *  左侧imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
/**
 *  课程名称
 */
@property (weak, nonatomic) IBOutlet UILabel *godsName;
/**
 *  星星数
 */
@property (weak, nonatomic) IBOutlet UIView *starView;
/**
 *  购买数
 */
@property (weak, nonatomic) IBOutlet UILabel *buyCount;
/**
 *  中线
 */
@property (weak, nonatomic) IBOutlet UIView *lineView;
/**
 *  底部imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@end
