

#import "HDZuFangScondCell.h"
#import "HDQRCommodity.h"

@implementation HDZuFangScondCell

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
    
    self.kehuxingmingLabel.text = _detailModel.name;
    
    self.kehushoujiLabel.text = _detailModel.phone;
    
    if (_detailModel.commoditys.count > 0) {
        HDQRCommodity * qrComm = _detailModel.commoditys[0];
        
        self.qizuriqiLabel.text = qrComm.startDate;
        
        self.daoqiriqiLabel.text = qrComm.endDate;
        
        self.shoufufangshiLabel.text = qrComm.downpaymentType;
        
    }
}

@end
