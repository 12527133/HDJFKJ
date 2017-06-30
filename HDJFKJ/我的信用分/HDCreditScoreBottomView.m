

#import "HDCreditScoreBottomView.h"

@implementation HDCreditScoreBottomView

- (void)dealloc{

    LDLog(@"销毁信用分底部视图");
}

- (void)createSubViews{

    self.backgroundColor = [UIColor whiteColor];
    
    /** 创建 topLabel */
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 13*bili, self.frame.size.width, 18*bili)];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.textColor = WHColorFromRGB(0x9fa8b7);
    self.topLabel.text = @"我的资料(已完善0/4)";
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.topLabel];


    /** 创建 icon */
    self.icon1 = [[UIImageView alloc]initWithFrame:CGRectMake(30*bili, 80*bili, 31*bili, 21*bili)];
    self.icon1.image = [UIImage imageNamed:@"xinyongfen_shiming"];
    [self addSubview:self.icon1];
    
    self.icon2 = [[UIImageView alloc]initWithFrame:CGRectMake(128*bili, 66*bili, 30*bili, 36*bili)];
    self.icon2.image = [UIImage imageNamed:@"xinyongfen_shenfen"];
    [self addSubview:self.icon2];
    
    self.icon3 = [[UIImageView alloc]initWithFrame:CGRectMake(223*bili, 66*bili, 23*bili, 36*bili)];
    self.icon3.image = [UIImage imageNamed:@"xinyongfen_lianxiren"];
    [self addSubview:self.icon3];
    
    self.icon4 = [[UIImageView alloc]initWithFrame:CGRectMake(310*bili, 70*bili, 33*bili, 30*bili)];
    self.icon4.image = [UIImage imageNamed:@"xinyongfen_shouquan"];
    [self addSubview:self.icon4];
    
    /** 创建 信息类型Label */
    float labelWidth = self.frame.size.width/4.0;
    
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 130*bili, labelWidth, 17*bili)];
    self.label1.backgroundColor = [UIColor clearColor];
    self.label1.textColor = WHColorFromRGB(0x9fa8b7);
    self.label1.text = @"实名信息";
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.font = [UIFont systemFontOfSize:12*bili];
    [self addSubview:self.label1];
    
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth, 130*bili, labelWidth, 17*bili)];
    self.label2.backgroundColor = [UIColor clearColor];
    self.label2.textColor = WHColorFromRGB(0x9fa8b7);
    self.label2.text = @"身份信息";
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.font = [UIFont systemFontOfSize:12*bili];
    [self addSubview:self.label2];
    
    self.label3 = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*2, 130*bili, labelWidth, 17*bili)];
    self.label3.backgroundColor = [UIColor clearColor];
    self.label3.textColor = WHColorFromRGB(0x9fa8b7);
    self.label3.text = @"联系人信息";
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.font = [UIFont systemFontOfSize:12*bili];
    [self addSubview:self.label3];
    
    self.label4 = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*3, 130*bili, labelWidth, 17*bili)];
    self.label4.backgroundColor = [UIColor clearColor];
    self.label4.textColor = WHColorFromRGB(0x9fa8b7);
    self.label4.text = @"授权信息";
    self.label4.textAlignment = NSTextAlignmentCenter;
    self.label4.font = [UIFont systemFontOfSize:12*bili];
    [self addSubview:self.label4];
    
    
    /** 创建分割线 */
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 158*bili - 0.5, self.frame.size.width - 30*bili, 0.5)];
    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
    [self addSubview:lineLabel];
    
    /** 创建Button  */
    self.button1 = [[UIButton alloc]initWithFrame:CGRectMake( 0, 66*bili, labelWidth, 80*bili)];
    [self addSubview:self.button1];
    
    self.button2 = [[UIButton alloc]initWithFrame:CGRectMake( labelWidth, 66*bili, labelWidth, 80*bili)];
    [self addSubview:self.button2];
    
    self.button3 = [[UIButton alloc]initWithFrame:CGRectMake( labelWidth*2, 66*bili, labelWidth, 80*bili)];
    [self addSubview:self.button3];
    
    self.button4 = [[UIButton alloc]initWithFrame:CGRectMake( labelWidth*3, 66*bili, labelWidth, 80*bili)];
    [self addSubview:self.button4];
    

}

























@end
