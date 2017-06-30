//
//  LDSecondTaoBaoCell.h
//  OCLDProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDGoodsDetailModel;

@interface LDSecondTaoBaoCell : UITableViewCell
@property (nonatomic,strong) LDGoodsDetailModel * goodsDetailModel;
@property (nonatomic,assign) BOOL isRule;

@end
