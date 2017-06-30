//
//  LDScrolowView.m
//  HDJFKJ
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDScrolowView.h"

@interface LDScrolowView ()<UITextFieldDelegate>
@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,assign) int count;

@end

@implementation LDScrolowView
- (void)viewWillAppear:(BOOL)animated{

    IQKeyboardManager * manager  = [IQKeyboardManager sharedManager];
    manager.keyboardDistanceFromTextField = 20;
    manager.enableAutoToolbar = NO;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 20;

    [self creatSubView];

    
}
- (NSArray *)dataArray{

    if (_dataArray == nil) {
        
        _dataArray = [NSArray array];
        
        _dataArray = @[@"请输入姓名",@"请输入年龄",@"请输入职业",@"请输入生日",@"请输入身份证号",@"请输入公司名称",@"请输入婚姻状况",@"请输入居住地址",@"请输入详细地址",@"请输入邮箱,QQ邮箱优先",@"请输入电话号码",@"请输入姓名",@"请输入年龄",@"请输入职业",@"请输入生日",@"请输入身份证号",@"请输入公司名称",@"请输入婚姻状况",@"请输入居住地址",@"请输入详细地址",@"请输入邮箱,QQ邮箱优先",@"请输入电话号码"];
    }
    
    return _dataArray;
}
- (void)creatSubView{
    
    UIScrollView * scrol = [UIScrollView new];
    scrol.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrol];

    [scrol makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *container = [UIView new];
    [scrol addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrol);
        make.width.equalTo(LDScreenWidth);
    }];


    
    UIView *lastView = nil;
    
    for ( int i = 0 ; i <= self.count ; i++ )
    {


        
        UITextField * text = [UITextField new];
        text.textAlignment = NSTextAlignmentCenter;
        text.placeholder = self.dataArray[i];
        text.borderStyle = UITextBorderStyleBezel;
        text.background = [UIImage imageNamed:@"app_slogan"];
        text.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FollowBtnClickBg"]];
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.adjustsFontSizeToFitWidth = YES;
        text.minimumFontSize = 1;
        text.font = [UIFont systemFontOfSize:30];
//        text.clearsOnBeginEditing = YES;
        text.tag = i;
        text.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        UIImage * leftImage = [UIImage imageNamed:@"bills"];

        UIImageView * image = [[UIImageView alloc] initWithImage:leftImage];
       
        text.rightViewMode = UITextFieldViewModeWhileEditing;
        text.leftViewMode = UITextFieldViewModeAlways;
        text.leftView = image;
        text.returnKeyType = UIReturnKeyNext;
        text.delegate = self;
        text.keyboardAppearance = UIKeyboardAppearanceDefault;
        [container addSubview:text];
        
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(container);
            make.height.equalTo(45);
            
            if ( lastView )
            {
                make.top.equalTo(lastView.bottom);
            }
            else
            {
                make.top.equalTo(container.top);
            }
        }];
        
        lastView = text;
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.bottom);
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    LDLog(@"%@",textField.text);
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
        LDLog(@"%@",textField.text);
    textField.keyboardAppearance = UIKeyboardAppearanceLight;
 
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
        LDLog(@"%@",textField.text);
    return YES;

}
@end
