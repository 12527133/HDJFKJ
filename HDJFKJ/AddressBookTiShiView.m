

#import "AddressBookTiShiView.h"

@implementation AddressBookTiShiView

- (void)createViewWithTitle:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle{

    /** 设置视图 */
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10.0;
    self.layer.borderWidth = 0.0;
    
    
    /** 标题Label  */
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50*bili)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = WHColorFromRGB(0x292929);
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:titleLabel];
    
    
    /** 分割线Label */
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*bili - 0.5, self.frame.size.width, 0.5)];
    lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
    [self addSubview:lineLabel];
    
    /** 取消按钮  */
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 55*bili, 0, 55*bili, 55*bili)];
    [self addSubview:cancelButton];
    
    [cancelButton setImage:[UIImage imageNamed:@"quxiao"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    
    
    /** 内容label */
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50*bili, 70*bili, self.frame.size.width - 100*bili, 50*bili)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = WHColorFromRGB(0x474747);
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:contentLabel];
    
    
    
    
    /** 图标 **/
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 175*bili)/2, 130*bili, 175*bili, 170*bili)];
    imageView.image = [UIImage imageNamed:@"addressBook_tc"];
    [self addSubview:imageView];
    
    /** 确定按钮 */
    self.sureButton = [[UIButton alloc]initWithFrame:CGRectMake(15*bili, self.frame.size.height - 75*bili, self.frame.size.width - 30*bili, 50*bili)];
    [self.sureButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureButton.layer.cornerRadius = 5.0;
    self.sureButton.layer.borderWidth = 0.0;
    [self addSubview:self.sureButton];
    [self.sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight)];
    self.bgView.backgroundColor = LDRGBColor(0, 0, 0, 0.5);
    [window addSubview:self.bgView];
    
    
    [window addSubview:self];
    
    self.center = window.center;

}

- (void)clickSureButton{

    //_addressBookSure();
    
    [self.bgView removeFromSuperview];
    
    
}
- (void)removeView{
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}
@end
