

#import "WHPayBackCell.h"

@implementation WHPayBackCell

- (void)dealloc{

    LDLog(@"销毁账单一级界面的账单Cell");
}

- (void)createSubViews{


   
    
    /** 创建账单时间  */
    self.checkTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 15*bili, 200*bili, 21*bili)];
    self.checkTimeLabel.backgroundColor = [UIColor clearColor];
    self.checkTimeLabel.textColor = WHColorFromRGB(0x070707);
    self.checkTimeLabel.text = @"最后账单日：2016/08/31";
    self.checkTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.checkTimeLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.checkTimeLabel];
    
    /** 账单期数label */
    self.periodCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 47*bili, 70*bili, 21*bili)];
    self.periodCountLabel.backgroundColor = [UIColor clearColor];
    self.periodCountLabel.textColor = WHColorFromRGB(0x818181);
    self.periodCountLabel.text = @"第03/12期";
    self.periodCountLabel.textAlignment = NSTextAlignmentLeft;
    self.periodCountLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.periodCountLabel];
    
    /** 逾期标识label */
    self.yuqiLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*bili, 47*bili, 150*bili, 21*bili)];
    self.yuqiLabel.backgroundColor = [UIColor clearColor];
    self.yuqiLabel.textColor = WHColorFromRGB(0xc75e5f);
    self.yuqiLabel.text = @"";
    self.yuqiLabel.textAlignment = NSTextAlignmentLeft;
    self.yuqiLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.yuqiLabel];
    
    /** 右侧蓝色箭头 */
    self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 23*bili, 33*bili, 8*bili, 14*bili)];
    self.arrowImageView.image = [UIImage imageNamed:@"arrow_blue_8x14"];
    [self addSubview:self.arrowImageView];
    
    /** 期供金额Label */
    self.periodPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth - 184*bili, 30*bili, 150*bili, 20*bili)];
    self.periodPriceLabel.backgroundColor = [UIColor clearColor];
    self.periodPriceLabel.textColor = WHColorFromRGB(0x070707);
    self.periodPriceLabel.text = @"¥333.33";
    self.periodPriceLabel.textAlignment = NSTextAlignmentRight;
    self.periodPriceLabel.font = [UIFont systemFontOfSize:18*bili];
    [self addSubview:self.periodPriceLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

















@end
