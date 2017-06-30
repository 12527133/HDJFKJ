

#import "HDARZhifuDetailView.h"

@implementation HDARZhifuDetailView

- (void)dealloc{
    
    LDLog(@"销毁在线支付详情 ");
}

/** 创建子视图 */
- (void)createSubView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    /** 支付名称 */
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*bili, 20*bili, self.frame.size.width - 60*bili, 31*bili)];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.textColor = WHColorFromRGB(0x3b3b3b);
    self.topLabel.text = @"";
    self.topLabel.numberOfLines = 2;
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.topLabel];
    
    
    /** 还款总额 */
    self.totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*bili, 64*bili, self.frame.size.width - 60*bili, 43*bili)];
    self.totalMoneyLabel.backgroundColor = [UIColor clearColor];
    self.totalMoneyLabel.textColor = WHColorFromRGB(0x202020);
    self.totalMoneyLabel.text = @"0.00";
    self.totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.totalMoneyLabel.font = [UIFont systemFontOfSize:36*bili];
    [self addSubview:self.totalMoneyLabel];
    
    /** 分割线 */
    UILabel * lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30*bili, 146*bili-0.5, self.frame.size.width - 60*bili, 0.5)];
    lineLabel1.backgroundColor = WHColorFromRGB(0xdddddd);
    [self addSubview:lineLabel1];
    
    
    /** 应还款 */
    self.payBackLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*bili, 165*bili, 100*bili, 18*bili)];
    self.payBackLeftLabel.backgroundColor = [UIColor clearColor];
    self.payBackLeftLabel.textColor = WHColorFromRGB(0x7c7c7c);
    self.payBackLeftLabel.text = @"应还金额：";
    self.payBackLeftLabel.textAlignment = NSTextAlignmentLeft;
    self.payBackLeftLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.payBackLeftLabel];
    
    self.payBackRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 225*bili, 165*bili, 200*bili, 18*bili)];
    self.payBackRightLabel.backgroundColor = [UIColor clearColor];
    self.payBackRightLabel.textColor = WHColorFromRGB(0x7c7c7c);
    self.payBackRightLabel.text = @"0.00元";
    self.payBackRightLabel.textAlignment = NSTextAlignmentRight;
    self.payBackRightLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.payBackRightLabel];
    
    
    /** 滞纳金 */
    self.lateFreeLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*bili, 193*bili, 100*bili, 18*bili)];
    self.lateFreeLeftLabel.backgroundColor = [UIColor clearColor];
    self.lateFreeLeftLabel.textColor = WHColorFromRGB(0x7c7c7c);
    self.lateFreeLeftLabel.text = @"滞纳金额：";
    self.lateFreeLeftLabel.textAlignment = NSTextAlignmentLeft;
    self.lateFreeLeftLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.lateFreeLeftLabel];
    
    self.lateFreerightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 225*bili, 193*bili, 200*bili, 18*bili)];
    self.lateFreerightLabel.backgroundColor = [UIColor clearColor];
    self.lateFreerightLabel.textColor = WHColorFromRGB(0x7c7c7c);
    self.lateFreerightLabel.text = @"0.00元";
    self.lateFreerightLabel.textAlignment = NSTextAlignmentRight;
    self.lateFreerightLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.lateFreerightLabel];
    
    
    /** 优惠金额 */
    self.youhuiLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*bili, 221*bili, 100*bili, 18*bili)];
    self.youhuiLeftLabel.backgroundColor = [UIColor clearColor];
    self.youhuiLeftLabel.textColor = WHColorFromRGB(0x7c7c7c);
    self.youhuiLeftLabel.text = @"优惠金额：";
    self.youhuiLeftLabel.textAlignment = NSTextAlignmentLeft;
    self.youhuiLeftLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.youhuiLeftLabel];
    
    self.youhuiRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 225*bili, 221*bili, 200*bili, 18*bili)];
    self.youhuiRightLabel.backgroundColor = [UIColor clearColor];
    self.youhuiRightLabel.textColor = WHColorFromRGB(0x7c7c7c);
    self.youhuiRightLabel.text = @"0.00元";
    self.youhuiRightLabel.textAlignment = NSTextAlignmentRight;
    self.youhuiRightLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.youhuiRightLabel];
    
    
    /** 手续费 */
    
    self.shouxufeiLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*bili, 249*bili, 100*bili, 18*bili)];
    self.shouxufeiLeftLabel.backgroundColor = [UIColor clearColor];
    self.shouxufeiLeftLabel.textColor = WHColorFromRGB(0x7c7c7c);
    self.shouxufeiLeftLabel.text = @"手续费：";
    self.shouxufeiLeftLabel.textAlignment = NSTextAlignmentLeft;
    self.shouxufeiLeftLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.shouxufeiLeftLabel];
    
    self.shouxufeiRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 225*bili, 249*bili, 200*bili, 18*bili)];
    self.shouxufeiRightLabel.backgroundColor = [UIColor clearColor];
    self.shouxufeiRightLabel.textColor = WHColorFromRGB(0x7c7c7c);
    self.shouxufeiRightLabel.text = @"0.00元";
    self.shouxufeiRightLabel.textAlignment = NSTextAlignmentRight;
    self.shouxufeiRightLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.shouxufeiRightLabel];
}


- (void)setLateFreeNilFrame{

    self.lateFreeLeftLabel.hidden = YES;
    
    self.lateFreerightLabel.hidden = YES;
    
    self.youhuiLeftLabel.frame = CGRectMake(25*bili, 193*bili, 100*bili, 18*bili);

    self.youhuiRightLabel.frame = CGRectMake(self.frame.size.width - 225*bili, 193*bili, 200*bili, 18*bili);
    
    self.shouxufeiLeftLabel.frame = CGRectMake(25*bili, 221*bili, 100*bili, 18*bili);
    
    self.shouxufeiRightLabel.frame = CGRectMake(self.frame.size.width - 225*bili, 221*bili, 200*bili, 18*bili);
    
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 28*bili);
}





















@end
