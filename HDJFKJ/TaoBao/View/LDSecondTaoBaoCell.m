//
//  LDSecondTaoBaoCell.m
//  OCLDProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDSecondTaoBaoCell.h"
#import "LDGoodsDetailModel.h"


@interface LDSecondTaoBaoCell ()
@property (weak, nonatomic) IBOutlet UILabel *goodsRule;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@end


@implementation LDSecondTaoBaoCell
- (void)setGoodsDetailModel:(LDGoodsDetailModel *)goodsDetailModel{
    
    _goodsDetailModel = goodsDetailModel;
    if (self.isRule) {
        
        self.titleName.text = @"商品规格";
        
        self.goodsRule.text = goodsDetailModel.parameter;
        
    }else{
        
        self.titleName.text = @"商品介绍";
        
        self.goodsRule.text = goodsDetailModel.desc;
    
    }
    
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
