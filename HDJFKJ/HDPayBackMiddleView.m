

#import "HDPayBackMiddleView.h"

@implementation HDPayBackMiddleView

-(void)dealloc{
    LDLog(@"销毁账单视图中间的View");
}

- (void)createSubViews{
    
    /** 设置背景色 */
    self.backgroundColor = [UIColor whiteColor];
    
    /** 创建 leftTopLabel */
    self.leftTopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*bili, self.frame.size.width/2, 21*bili)];
    self.leftTopLabel.backgroundColor = [UIColor clearColor];
    self.leftTopLabel.textColor = WHColorFromRGB(0x43484e);
    self.leftTopLabel.text = @"已结清";
    self.leftTopLabel.textAlignment = NSTextAlignmentCenter;
    self.leftTopLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.leftTopLabel];
    
    /** 创建 leftBottomLabel */
    self.leftBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*bili, self.frame.size.width/2, 24*bili)];
    self.leftBottomLabel.backgroundColor = [UIColor clearColor];
    self.leftBottomLabel.textColor = WHColorFromRGB(0x9fa8b7);
    self.leftBottomLabel.text = @"0.00";
    self.leftBottomLabel.textAlignment = NSTextAlignmentCenter;
    self.leftBottomLabel.font = [UIFont systemFontOfSize:17*bili];
    [self addSubview:self.leftBottomLabel];
    
    /** 创建 rightTopLabel */
    self.rightTopLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 15*bili, self.frame.size.width/2, 21*bili)];
    self.rightTopLabel.backgroundColor = [UIColor clearColor];
    self.rightTopLabel.textColor = WHColorFromRGB(0x43484e);
    self.rightTopLabel.text = @"未到期";
    self.rightTopLabel.textAlignment = NSTextAlignmentCenter;
    self.rightTopLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.rightTopLabel];
    
    /** 创建 rightBottomLabel */
    self.rightBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 50*bili, self.frame.size.width/2, 24*bili)];
    self.rightBottomLabel.backgroundColor = [UIColor clearColor];
    self.rightBottomLabel.textColor = WHColorFromRGB(0x9fa8b7);
    self.rightBottomLabel.text = @"0.00";
    self.rightBottomLabel.textAlignment = NSTextAlignmentCenter;
    self.rightBottomLabel.font = [UIFont systemFontOfSize:17*bili];
    [self addSubview:self.rightBottomLabel];
    
    
    /** 创建中间的竖线 */
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width - 1)/2, 0, 1, self.frame.size.height)];
    lineView.backgroundColor = WHColorFromRGB(0xf5f5f9);
    [self addSubview:lineView];
    
    /** 底部灰色边条 */
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 5*bili, self.frame.size.width, 5*bili)];
    bottomView.backgroundColor = WHColorFromRGB(0xf5f5f9);
    [self addSubview:bottomView];
    
}


















@end
