

#import "LDZuFangFirstCell.h"
#import "HDQRCommodity.h"
@implementation LDZuFangFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailModel:(WHQROrderModel *)detailModel{

    _detailModel = detailModel;
    
    if (_detailModel.commoditys.count > 0) {
        HDQRCommodity * qrComm = _detailModel.commoditys[0];
        
        self.goodsNameLabel.text = qrComm.commodityName;
        
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",qrComm.addrProvince,qrComm.addrCounty,qrComm.addrArea,qrComm.addrDetail];
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f x %@期",[ _detailModel.periodAmount floatValue],_detailModel.duration];
        
    }
    

}


@end
