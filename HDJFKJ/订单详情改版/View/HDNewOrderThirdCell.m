

#import "HDNewOrderThirdCell.h"

@implementation HDNewOrderThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderNoLabel.font = [UIFont systemFontOfSize:13*bili];
    
    self.orderTimeLabel.font = [UIFont systemFontOfSize:13*bili];
    
    self.yewuyuanLabel.font = [UIFont systemFontOfSize:13*bili];
    
    self.businessNameLabel.font = [UIFont systemFontOfSize:13*bili];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setOrderDetailModel:(LDNewOrderDetailModel *)orderDetailModel{

    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",orderDetailModel.orderNo];
    
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",orderDetailModel.time];
    
    self.businessNameLabel.text = [NSString stringWithFormat:@"商户名称：%@",orderDetailModel.businessName];

    self.yewuyuanLabel.text = [NSString stringWithFormat:@"业务员：%@",orderDetailModel.ownSaleMan];
}


@end
