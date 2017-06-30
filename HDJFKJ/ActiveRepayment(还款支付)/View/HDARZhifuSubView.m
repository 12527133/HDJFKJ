

#import "HDARZhifuSubView.h"

@implementation HDARZhifuSubView

- (void)dealloc{

    LDLog(@"销毁支付方式子视图 ");
}

/** 创建子视图 */
- (void)createSubViews{

    self.backgroundColor = [UIColor whiteColor];
    
    /** 支付icon */
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(15*bili, (self.frame.size.height - 22*bili)/2.0, 22*bili, 22*bili)];
    self.icon.image = [UIImage imageNamed:@"jd_pay_icon"];
    [self addSubview:self.icon];
    
    /** 支付名称 */
    self.zhifuLabel = [[UILabel alloc]initWithFrame:CGRectMake(51*bili, 0, 200, self.frame.size.height)];
    self.zhifuLabel.backgroundColor = [UIColor clearColor];
    self.zhifuLabel.textColor = WHColorFromRGB(0x181818);
    self.zhifuLabel.text = @"京东支付";
    self.zhifuLabel.textAlignment = NSTextAlignmentLeft;
    self.zhifuLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.zhifuLabel];

    /** 选中Icon */
    self.selectIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 38*bili, (self.frame.size.height - 22*bili)/2.0, 22*bili, 22*bili)];
    self.selectIcon.image = [UIImage imageNamed:@"zhifufangshi_select"];
    [self addSubview:self.selectIcon];
    
    /** 选择Button */
    self.selectButton = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.selectButton];
    
}


























@end
