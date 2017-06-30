

#import "HDFirstPageScoreCell.h"

@implementation HDFirstPageScoreCell


- (void)setFirstPageModel:(HDFirstPageModel *)firstPageModel{

    _firstPageModel = firstPageModel;
    
    if (_firstPageModel != nil) {
        self.scoreLabel.text = _firstPageModel.creditScore;
        self.levelLabel.text = [NSString stringWithFormat:@"您的信用分等级：%@",_firstPageModel.level];
    }
    else{
        self.scoreLabel.text = @"100";
        self.levelLabel.text = [NSString stringWithFormat:@"您的信用分等级：中等"];
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
