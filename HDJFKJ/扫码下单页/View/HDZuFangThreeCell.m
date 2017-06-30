

#import "HDZuFangThreeCell.h"

@implementation HDZuFangThreeCell

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
    
    
    if (_detailModel.scanDate != nil) {
        self.shenqingriqiLabel.text = _detailModel.scanDate;
    }
    else{
        self.shenqingriqiLabel.text = _detailModel.scanTime;
    }
    
    self.shenqingBianhaoLabel.text = _detailModel.packageId;
    
    self.yewuyuanLabel.text = _detailModel.saleMan;
    
    
    if (_detailModel.businessName != nil) {
        self.shangjiaLabel.text = _detailModel.businessName;
    }
    else{
        self.shangjiaLabel.text = _detailModel.bussinessName;
    }
    
    
}


@end
