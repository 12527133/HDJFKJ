

#import "HDCreditScoreTopView.h"

@implementation HDCreditScoreTopView

- (void)dealloc{
    
    LDLog(@"销毁信用分顶部试图");
}

- (void)createSubViews{
    
    /** 设置背景色 */
    self.backgroundColor = [UIColor whiteColor];
    
    /** 创建背景视图 */
    self.bgImageView = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:self.bgImageView];
    self.bgImageView.image = [UIImage imageNamed:@"信用分"];

    
    /** 创建 topLabel */
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*bili, self.frame.size.width, 21*bili)];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.text = @"我的信用分";
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.topLabel];
    
    /** 创建 scoreLabel */
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 105*bili, self.frame.size.width, 56*bili)];
    self.scoreLabel.backgroundColor = [UIColor clearColor];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.text = @"0.00";
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:40*bili];
    [self addSubview:self.scoreLabel];
    
    /** 创建 bottomLabel */
    self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 164*bili, self.frame.size.width, 14*bili)];
    self.bottomLabel.backgroundColor = [UIColor clearColor];
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.text = @"完善信息获取更多信用分";
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.font = [UIFont systemFontOfSize:10*bili];
    [self addSubview:self.bottomLabel];
    
}

@end
