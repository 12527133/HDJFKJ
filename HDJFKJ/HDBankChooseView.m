

#import "HDBankChooseView.h"

@implementation HDBankChooseView

- (void)createSubView{


    self.backgroundColor = [UIColor whiteColor];
    
    self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    
    [self.leftButton setTitle:@"扣款银行卡" forState:UIControlStateSelected];
    [self.leftButton setTitle:@"扣款银行卡" forState:UIControlStateNormal];

    [self.leftButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateSelected];
    [self.leftButton setTitleColor:WHColorFromRGB(0x363636) forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.leftButton];
    self.leftButton.selected = YES;
    
    
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    
    [self.rightButton setTitle:@"还款银行卡" forState:UIControlStateSelected];
    [self.rightButton setTitle:@"还款银行卡" forState:UIControlStateNormal];
    
    [self.rightButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateSelected];
    [self.rightButton setTitleColor:WHColorFromRGB(0x363636) forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.rightButton];
    self.rightButton.selected = NO;
    
    
    self.bottomLine = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width/2.0 - 100*bili)/2.0, self.frame.size.height - 1, 100*bili, 1)];
    self.bottomLine.backgroundColor = WHColorFromRGB(0x4279d6);
    [self addSubview:self.bottomLine];
    
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickRightButton:(UIButton *)sender{
    self.rightButton.selected = !self.rightButton.selected;
    self.leftButton.selected = !self.rightButton.selected;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.frame = CGRectMake(self.frame.size.width/2.0+(self.frame.size.width/2.0 - 100*bili)/2.0, self.frame.size.height - 1, 100*bili, 1);
    }];

}
- (void)clickLeftButton:(UIButton *)sender{
    self.leftButton.selected = !self.leftButton.selected;
    self.rightButton.selected = !self.leftButton.selected;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.frame = CGRectMake((self.frame.size.width/2.0 - 100*bili)/2.0, self.frame.size.height - 1, 100*bili, 1);
    }];

}




























@end
