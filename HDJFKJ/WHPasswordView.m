

#import "WHPasswordView.h"
#define WHColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation WHPasswordView

- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [[NSMutableArray alloc]init];
    }
    return _pointArray;
}


//初始化密码框View
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //初始化textField
        self.textField = [[UITextField alloc]initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.textField];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.textField becomeFirstResponder];
        [self.textField addTarget:self action:@selector(UIControlEventEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        self.passwordView = [[UIView alloc]initWithFrame:self.textField.frame];
        self.passwordView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.passwordView];
        
        //绘制密码框
        [self createLineViewWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        [self createLineViewWithFrame: CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        for (int i = 0; i < 7; i ++) {
            [self createLineViewWithFrame:CGRectMake(0 + frame.size.width/6 * i, 0, 0.5, frame.size.height)];
        }
        float pointWidth = 20 * [UIScreen mainScreen].bounds.size.width/375;
        //绘制密码框内的圆点
        for (int i = 0; i < 6; i++) {
            UIView * ponitView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width/6 -pointWidth)/2 + frame.size.width/6 * i, (frame.size.width/6 -pointWidth)/2, pointWidth, pointWidth)];
            [self addSubview:ponitView];
            [self.pointArray addObject:ponitView];
            
            ponitView.layer.cornerRadius = pointWidth/2;
            ponitView.layer.borderColor = [WHColorFromRGB(0x2b2b2b) CGColor];
            ponitView.layer.borderWidth = pointWidth/2;
            ponitView.hidden = YES;
        }
        self.button = [[UIButton alloc]initWithFrame:self.passwordView.frame];
        [self addSubview:self.button];
        [self.button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}
//绘制密码框的线
- (void)createLineViewWithFrame:(CGRect)frame{
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = WHColorFromRGB(0x9e9e9e);
    [self addSubview:line];
}

//textField的方法
- (void)UIControlEventEditingChanged:(UITextField *)textField{
    
    if (textField.text.length > 6){
        textField.text = [textField.text substringToIndex:6];
    
    }
    NSLog(@"%@",textField.text);
    for (int i = 0; i < 6; i ++) {
        UIView * subview = self.pointArray[i];
        if (i < textField.text.length) {
            subview.hidden = NO;
        }
        else{
            subview.hidden = YES;
        }
    }
    if (textField.text.length >5) {
        [textField resignFirstResponder];
        _complationBlock(textField.text);
    }
    
}

//按钮的点击事件
- (void)clickButton{
    [self.textField becomeFirstResponder];

}








@end
