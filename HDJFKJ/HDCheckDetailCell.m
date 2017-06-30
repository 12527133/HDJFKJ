

#import "HDCheckDetailCell.h"

@implementation HDCheckDetailCell
- (void)dealloc{
    
    LDLog(@"销毁账单二级界面的账单Cell");
}

- (void)createSubViews{

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /** 创建账单时间  */
    self.leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 0, LDScreenWidth/2-15*bili, self.frame.size.height)];
    self.leftlabel.backgroundColor = [UIColor clearColor];
    self.leftlabel.textColor = WHColorFromRGB(0x1b1b1b);
    self.leftlabel.text = @"左侧";
    self.leftlabel.textAlignment = NSTextAlignmentLeft;
    self.leftlabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.leftlabel];
    
    /** 账单期数label */
    self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth - 300*bili, 0, 285*bili, self.frame.size.height)];
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.textColor = WHColorFromRGB(0x969696);
    self.rightLabel.text = @"右侧";
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.rightLabel];
    
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
