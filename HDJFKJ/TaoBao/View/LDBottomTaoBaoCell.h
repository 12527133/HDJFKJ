//
//  LDBottomTaoBaoCell.h
//  OCLDProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDGoodsDetailModel;

@interface LDBottomTaoBaoCell : UITableViewCell
@property (nonatomic,strong) LDGoodsDetailModel * goodsDetailModel;


@property (weak, nonatomic) IBOutlet UIButton *callPhoneButton;

@end
