

#import "HDARVerificationCodeView.h"

@implementation HDARVerificationCodeView

- (void)dealloc{
    
    LDLog(@"销毁y验证码半窗");
}


- (NSMutableArray *)labelArray{

    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc]init];
    }
    
    return _labelArray;
}

/** 创建子视图 */
- (void)createSubView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = 8.0;
    self.layer.borderWidth = 0.0;
    
    
    /** 标题Label */
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 13*bili, self.frame.size.width, 24*bili)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = WHColorFromRGB(0x3e3e3e);
    titleLabel.text = @"输入验证码 完成支付";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17*bili];
    [self addSubview:titleLabel];
    
    /** 副标题 Label */
    self.smallLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40*bili, self.frame.size.width, 14*bili)];
    self.smallLabel.backgroundColor = [UIColor clearColor];
    self.smallLabel.textColor = WHColorFromRGB(0x4279d6);
    //self.smallLabel.text = @"验证码手机号已发送至185****7080";
    self.smallLabel.textAlignment = NSTextAlignmentCenter;
    self.smallLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.smallLabel];
    
    /** 创建关闭按钮 */
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 60*bili, 60*bili)];
    [self.cancelButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.cancelButton];
    
    /** 重新发送验证码按钮 */
    self.againButton = [[UIButton alloc]initWithFrame:CGRectMake( self.frame.size.width - 100*bili, 0, 100*bili, 60*bili)];
    [self.againButton setTitle:@"重新发送(20S)" forState:UIControlStateNormal];
    [self.againButton setTitleColor:WHColorFromRGB(0xbdbdbd) forState:UIControlStateNormal];
    self.againButton.titleLabel.textAlignment = NSTextAlignmentRight;
    self.againButton.titleLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.againButton];
    
    /** 创建分割线 */
    UILabel * lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 60*bili-0.5, self.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = WHColorFromRGB(0xdddddd);
    [self addSubview:lineLabel1];
    
    
    /** 创建textField  */
    self.textField = [[UITextField alloc]initWithFrame: CGRectMake(0, 0, 0, 0)];
    [self addSubview:self.textField];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textField becomeFirstResponder];
    [self.textField addTarget:self action:@selector(UIControlEventEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    /** 创建验证码窗 */
    float originY = 100*bili;
    float originX = 84*bili;
    float width = 30*bili;
    float height = 56*bili;
    float distance = (LDScreenWidth - 168*bili - width*6)/5;
    
    
    for (int i = 0; i < 6; i++) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(originX + (width+distance)*i, originY, width, height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = WHColorFromRGB(0x454545);
        label.text = @"-";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:40*bili];
        [self addSubview:label];
        [self.labelArray addObject:label];
    }
    
}
//textField的方法
- (void)UIControlEventEditingChanged:(UITextField *)textField{
    
    if (textField.text.length > 6){
        textField.text = [textField.text substringToIndex:6];
        
    }
    
    if (textField.text.length > 0) {
        int verificCode = [textField.text intValue];
        
        int yushu = verificCode % 10;
        
        UILabel * label = self.labelArray[textField.text.length - 1];
        
        label.text = [NSString stringWithFormat:@"%d",yushu];
        
        if (textField.text.length < 7) {
            for (int i = (int)textField.text.length ; i < self.labelArray.count; i++) {
                UILabel * label2 = self.labelArray[i];
                label2.text = @"-";
            }
        }
    }
    else{
        for (UILabel * label3 in self.labelArray) {
            label3.text = @"-";
        }
    }
    
    
    LDLog(@"%@",textField.text);
    
    if (textField.text.length >5) {
        [textField resignFirstResponder];
        _complationBlock(textField.text);
    }
    
}

- (void)clearYanZhengMa{
    
    self.textField.text = @"";
    for (UILabel * label in self.labelArray) {
        label.text = @"-";
    }

}


@end
