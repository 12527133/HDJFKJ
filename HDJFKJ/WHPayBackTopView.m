

#import "WHPayBackTopView.h"

@implementation WHPayBackTopView

- (void)dealloc{

    LDLog(@"销毁账单顶部试图");
}

- (void)createSubViews{

    /** 设置背景色 */
    self.backgroundColor = WHColorFromRGB(0x4279d6);
    
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"nav_bg_3.0"];
    [self addSubview:bgImageView];
    
    
    /** 创建 topLabel */
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 26*bili, self.frame.size.width, 21*bili)];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.text = @"近7日应还款(元)";
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.topLabel];
    
    /** 创建 totalPriceLabel */
    
    self.totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 69*bili, self.frame.size.width, 52*bili)];
    self.totalPriceLabel.backgroundColor = [UIColor clearColor];
    self.totalPriceLabel.textColor = LDRGBColor(255, 255, 255, 1);
    self.totalPriceLabel.text = @"0.00";
    self.totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    self.totalPriceLabel.font = [UIFont boldSystemFontOfSize:44*bili];
    [self addSubview:self.totalPriceLabel];

}





















@end
