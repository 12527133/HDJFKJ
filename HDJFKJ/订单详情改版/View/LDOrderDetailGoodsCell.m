//
//  LDOrderDetailGoodsCell.m
//  HDJFKJ
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDOrderDetailGoodsCell.h"
#import "LDOrderDetailModel.h"
#import "LDNewOrderDetailModel.h"


@interface LDOrderDetailGoodsCell ()


/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/**
 *  商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@end


@implementation LDOrderDetailGoodsCell
- (void)setSmallDetailModel:(LDSmallNewOrderDetailModel *)smallDetailModel{

    _smallDetailModel = smallDetailModel;
    
    
    
    self.goodsName.text = [NSString stringWithFormat:@"%@",smallDetailModel.commodityName];
    
    self.goodsPrice.text = [NSString stringWithFormat:@" ￥%.2f",[smallDetailModel.commodityPrice floatValue]];
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.goodsName.font = [UIFont systemFontOfSize:13*bili];
    
    self.goodsPrice.font = [UIFont systemFontOfSize:15*bili];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
