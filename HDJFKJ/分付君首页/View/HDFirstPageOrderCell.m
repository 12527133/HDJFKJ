

#import "HDFirstPageOrderCell.h"

@implementation HDFirstPageOrderCell

- (void)setOrderInfo:(HDFirstPageOrderInfo *)orderInfo{

    _orderInfo = orderInfo;
    
    if (_orderInfo.applyId != nil) {
        
        
        
        
        self.commodityNameLabel.text = _orderInfo.commodityName;
        
        self.orderDateLabel.text = _orderInfo.applyDate;
        
        self.statusLabel.text = _orderInfo.status;
        
    
    }
}


- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
