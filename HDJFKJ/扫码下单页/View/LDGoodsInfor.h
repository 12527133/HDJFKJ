//
//  LDGoodsInfor.h
//  HDJFKJ
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDGoodsInfor : UITableViewCell

//总价label
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

//首付金额label
@property (weak, nonatomic) IBOutlet UILabel *shoufuLabel;
//分期金额label
@property (weak, nonatomic) IBOutlet UILabel *fenqiLabel;

@end
