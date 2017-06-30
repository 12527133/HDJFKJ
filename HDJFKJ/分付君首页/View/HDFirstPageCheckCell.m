

#import "HDFirstPageCheckCell.h"

@implementation HDFirstPageCheckCell


- (void)setDebtInfo:(HDFirstPageDebtInfo *)debtInfo{

    _debtInfo = debtInfo;
    
    if (debtInfo.applyId != nil) {
        self.repaymentAmtLabel.text = [NSString stringWithFormat:@"%.2f",[_debtInfo.repaymentAmt floatValue]];
    }
    else{
        self.repaymentAmtLabel.text = @"0.00";
    
    }
    
    if (![debtInfo.activePayFlag isEqualToString:@"1"]) {
        self.bottomLabel.frame = CGRectMake(0, 120, self.frame.size.width, 40);
        self.checkButton.frame = CGRectMake(0, 100, self.frame.size.width, 60);
        
        self.huankuanLabel.hidden = YES;
        self.huankuanLabel.hidden = YES;
        self.lineLabel.hidden = YES;
        
    }
    else{
        self.bottomLabel.frame = CGRectMake(0, 120, self.frame.size.width/2, 40);
        self.checkButton.frame = CGRectMake(0, 100, self.frame.size.width/2, 60);
        
        self.huankuanLabel.hidden = NO;
        self.huankuanLabel.hidden = NO;
        self.lineLabel.hidden = NO;
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
