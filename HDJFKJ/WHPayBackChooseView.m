

#import "WHPayBackChooseView.h"

@implementation WHPayBackChooseView

- (void)dealloc{

    LDLog(@"销毁账单状态选择试图");
    
}

- (void)createSubViews{
    
    /** 设置背景色 */
    self.backgroundColor = [UIColor whiteColor];
    
    /** 创建图标icon*/
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(11*bili, 14*bili, 22*bili, 22*bili)];
    self.iconImage.image = [UIImage imageNamed:@"zufangjiage"];
    [self addSubview:self.iconImage];
    
    /** 创建 topLabel */
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(40*bili, 0, 80*bili, self.frame.size.height)];
    self.leftLabel.backgroundColor = [UIColor clearColor];
    self.leftLabel.textColor = WHColorFromRGB(0x070707);
    self.leftLabel.text = @"账单";
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    self.leftLabel.font = [UIFont boldSystemFontOfSize:15*bili];
    [self addSubview:self.leftLabel];
    
    
    /** 箭头图标 */
    self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 29*bili, 21*bili, 14*bili, 8*bili)];
    self.arrowImageView.image = [UIImage imageNamed:@"下拉"];
    [self addSubview:self.arrowImageView];
    
    /** 账单状态Label */
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenWidth - 200*bili, 0, 162*bili, self.frame.size.height)];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textColor = WHColorFromRGB(0x070707);
    self.statusLabel.text = @"近7日应还款";
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    self.statusLabel.font = [UIFont systemFontOfSize:14*bili];
    [self addSubview:self.statusLabel];
    
    /** 创建 右侧Button */
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake( LDScreenWidth - 85*bili, 0, 85*bili, self.frame.size.height)];
    [self addSubview:self.rightButton];
    
    /** 创建横线Label */
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, LDScreenWidth, 0.5)];
    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
    [self addSubview:lineLabel];
    
    
}



















@end
