//
//  LDOrderListCell.m
//  HDJFKJ
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDOrderListCell.h"
#import "LDNewOrderListModel.h"


@interface LDOrderListCell ()
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/**
 *  商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
/**
 *  商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;

@end


@implementation LDOrderListCell

- (void)setSmallModel:(LDSmallOrderListModel *)smallModel{

    _smallModel = smallModel;
//    
//    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:smallModel.pic] placeholderImage:[UIImage imageNamed:@"商品 1:1"]];
//    
//    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",[smallModel.commodityPrice floatValue]];
//    
//    self.goodsCount.text = [NSString stringWithFormat:@"x%@",smallModel.commodityCount];
//    
//    self.goodsName.text = [NSString stringWithFormat:@"%@",smallModel.commodityName];
    

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
