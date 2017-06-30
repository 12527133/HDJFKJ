

#import "HDARZhifuBankView.h"

@implementation HDARZhifuBankView

- (void)createSubView{

    self.backgroundColor = [UIColor whiteColor];
    
    /** 设置图片圆角 */
    self.iconImage.layer.cornerRadius = self.iconImage.size.width/2.0;
    self.iconImage.layer.masksToBounds = YES;
    
    /** 银行名称label  */
    self.bankNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65*bili, 0, LDScreenWidth-65*bili, self.frame.size.height)];
    self.bankNameLabel.backgroundColor = [UIColor whiteColor];
    self.bankNameLabel.textColor = WHColorFromRGB(0x202020);
    self.bankNameLabel.text = @"中国银行（4320）";
    self.bankNameLabel.textAlignment = NSTextAlignmentLeft;
    self.bankNameLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.bankNameLabel];
    
    /** 银行卡Icon*/
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20*bili, (self.frame.size.height - 30*bili)/2.0, 30*bili, 30*bili)];
    self.iconImage.image = [UIImage imageNamed:@"zufangjiage"];
    [self addSubview:self.iconImage];
    
    /** 右侧蓝色箭头 */
    UIImageView * arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 23*bili, (self.frame.size.height - 14*bili)/2.0, 8*bili, 14*bili)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_blue_8x14"];
    [self addSubview:arrowImageView];
    
    
    /** 创建按钮  */
    self.bankButton = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.bankButton];
    
    
}















@end
