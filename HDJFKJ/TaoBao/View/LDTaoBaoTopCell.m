//
//  LDTaoBaoTopCell.m
//  OCLDProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDTaoBaoTopCell.h"
#import "LDGoodsDetailModel.h"


@interface LDTaoBaoTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *buyCount;

@end

@implementation LDTaoBaoTopCell
- (void)setGoodsDetailModel:(LDGoodsDetailModel *)goodsDetailModel{
    
    _goodsDetailModel = goodsDetailModel;
    self.goodsName.text = goodsDetailModel.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥ %@",goodsDetailModel.commodityprice];
    self.buyCount.text = [NSString stringWithFormat:@"%@人已购买",goodsDetailModel.sale];
    
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIImageView * image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:@"Group11111"];
    [self.contentView insertSubview:image atIndex:0];
//    self.backgroundColor = [UIColor redColor];
    [image makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
