

#import "HDARZhifuCell.h"

@implementation HDARZhifuCell


- (void)dealloc{
    
    LDLog(@"销毁账单一级界面的账单Cell");
}

- (void)createSubViews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    /** 滞纳金Label   */
    self.lateFreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth - 267*bili, 47*bili, 260*bili, 18*bili)];
    self.lateFreeLabel.backgroundColor = [UIColor clearColor];
    self.lateFreeLabel.textColor = WHColorFromRGB(0x818181);
    self.lateFreeLabel.text = @"（含滞纳金0.00元）";
    self.lateFreeLabel.textAlignment = NSTextAlignmentRight;
    self.lateFreeLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.lateFreeLabel];
    
    /** 账单期数label */
    self.periodCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 15*bili, 200*bili, 21*bili)];
    self.periodCountLabel.backgroundColor = [UIColor clearColor];
    self.periodCountLabel.textColor = WHColorFromRGB(0x070707);
    self.periodCountLabel.text = @"第03/12期";
    self.periodCountLabel.textAlignment = NSTextAlignmentLeft;
    self.periodCountLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.periodCountLabel];
    
    /** 逾期标识label */
    self.yuqiLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 47*bili, 70*bili, 21*bili)];
    self.yuqiLabel.backgroundColor = [UIColor clearColor];
    self.yuqiLabel.textColor = WHColorFromRGB(0xc75e5f);
    self.yuqiLabel.text = @"代还款";
    self.yuqiLabel.textAlignment = NSTextAlignmentLeft;
    self.yuqiLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.yuqiLabel];

    /** 期供金额Label */
    self.periodPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth - 200*bili, 15*bili, 180*bili, 21*bili)];
    self.periodPriceLabel.backgroundColor = [UIColor clearColor];
    self.periodPriceLabel.textColor = WHColorFromRGB(0x070707);
    self.periodPriceLabel.text = @"¥333.33";
    self.periodPriceLabel.textAlignment = NSTextAlignmentRight;
    self.periodPriceLabel.font = [UIFont systemFontOfSize:18*bili];
    [self addSubview:self.periodPriceLabel];
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
