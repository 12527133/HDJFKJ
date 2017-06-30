

#import "WHCheckTopView.h"

@implementation WHCheckTopView

/** 销毁*/

- (void)createSubViews{

    /** 设置背景色 */
    self.backgroundColor = [UIColor whiteColor];
    
    /** 创建 账单日期 */
    self.checkDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*bili, 18*bili, 200*bili, 21*bili)];
    self.checkDateLabel.backgroundColor = [UIColor clearColor];
    self.checkDateLabel.textColor = WHColorFromRGB(0x858585);
    self.checkDateLabel.text = @"2016年08月应还(元)";
    self.checkDateLabel.textAlignment = NSTextAlignmentLeft;
    self.checkDateLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.checkDateLabel];
    
    /** 账单金额Label */
    self.checkMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*bili, 47*bili, 200*bili, 52*bili)];
    self.checkMoneyLabel.backgroundColor = [UIColor clearColor];
    self.checkMoneyLabel.textColor = WHColorFromRGB(0x202020);
    self.checkMoneyLabel.text = @"963.09";
    self.checkMoneyLabel.textAlignment = NSTextAlignmentLeft;
    self.checkMoneyLabel.font = [UIFont systemFontOfSize:44*bili];
    [self addSubview:self.checkMoneyLabel];
    
    /** 滞纳金Label */
    self.lateFeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(157*bili, 72*bili, 200*bili, 21*bili)];
    self.lateFeeLabel.backgroundColor = [UIColor clearColor];
    self.lateFeeLabel.textColor = WHColorFromRGB(0x969696);
    self.lateFeeLabel.text = @"（含滞纳金23.75）";
    self.lateFeeLabel.textAlignment = NSTextAlignmentLeft;
    self.lateFeeLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.lateFeeLabel];
    
    /** 结清标示icon */
    self.settledImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 113*bili, 9*bili, 102*bili, 102*bili)];
    self.settledImageView.image = [UIImage imageNamed:@"check_jieqing"];
    [self addSubview:self.settledImageView];

    
    /** 创建横线Label */
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, LDScreenWidth, 0.5)];
    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
    [self addSubview:lineLabel];
}

- (void)setSubViewsFrame{

    /** 根据字数计算大小 账单金额label大小，重置滞纳金Label的位置 */
    CGSize size = [self.checkMoneyLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.checkMoneyLabel.frame.size.height)];
    /** 重置账单金额控制的大小 */
    self.checkMoneyLabel.frame =CGRectMake(self.checkMoneyLabel.frame.origin.x, self.checkMoneyLabel.frame.origin.y, size.width, self.checkMoneyLabel.frame.size.height);
    /** 调整滞纳金控件的位置 */
    self.lateFeeLabel.frame = CGRectMake(self.checkMoneyLabel.frame.origin.x+ self.checkMoneyLabel.frame.size.width, self.lateFeeLabel.frame.origin.y, self.lateFeeLabel.frame.size.width, self.lateFeeLabel.frame.size.height);
}

























@end
