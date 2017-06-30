//
//  LDFirstCell.h
//  OCLDProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDGoodsDetailModel;

@interface LDFirstCell : UITableViewCell

@property (nonatomic, strong) NSString * AttributeString;

@property (nonatomic,strong) LDGoodsDetailModel * goodsDetailModel;

@end
