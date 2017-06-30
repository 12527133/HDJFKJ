

#import "HDBankNameCell.h"

@implementation HDBankNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)createSubViews{
    
    /** 设置图片圆角 */
    self.iconImage.layer.cornerRadius = self.iconImage.size.width/2.0;
    self.iconImage.layer.masksToBounds = YES;
    
    /** 银行名称label  */
    self.bankNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65*bili, 0, LDScreenWidth-65*bili, self.frame.size.height)];
    self.bankNameLabel.backgroundColor = [UIColor whiteColor];
    self.bankNameLabel.textColor = WHColorFromRGB(0x202020);
    self.bankNameLabel.text = @"银行";
    self.bankNameLabel.textAlignment = NSTextAlignmentLeft;
    self.bankNameLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.bankNameLabel];
    
    /** 银行卡Icon*/
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20*bili, (self.frame.size.height - 30*bili)/2.0, 30*bili, 30*bili)];
    self.iconImage.image = [UIImage imageNamed:@"zufangjiage"];
    [self addSubview:self.iconImage];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
