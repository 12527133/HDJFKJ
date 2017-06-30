//
//  AttributeCollectionView.m
//  天巢新1期
//
//  Created by 唐建平 on 15/12/15.
//  Copyright © 2015年 JP. All rights reserved.
//

#import "AttributeView.h"

#define AppColor  Color(245, 58, 64)

#define margin 15
// 屏幕的宽
#define JPScreenW [UIScreen mainScreen].bounds.size.width
// 屏幕的高
#define JPScreenH [UIScreen mainScreen].bounds.size.height
//RGB
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@interface AttributeView ()

@property (nonatomic ,weak) UIButton *btn;
@end

@implementation AttributeView

/**
 *  返回一个创建好的属性视图,并且带有标题.创建好之后必须设置视图的Y值.
 *
 *  @param texts 属性数组
 *
 *  @param viewWidth 视图宽度
 *
 *  @return attributeView
 */
+ (AttributeView *)attributeViewWithTitle:(NSString *)title titleFont:(UIFont *)font attributeTexts:(NSArray *)texts viewWidth:(CGFloat)viewWidth{
    int count = 0;
    float btnW = 0;
    AttributeView *view = [[AttributeView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%@ : ",title];
    label.font = font;
    label.textColor = Color(160, 160, 160);
    CGSize size = [label.text sizeWithFont:font];
    label.frame = (CGRect){{10,10},size};
    [view addSubview:label];
    for (int i = 0; i<texts.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        [btn addTarget:view action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        NSString *str = texts[i];
        [btn setTitle:str forState:UIControlStateNormal];
        CGSize strsize = [str sizeWithFont:[UIFont boldSystemFontOfSize:13]];
        
        btn.LDWidth = strsize.width + margin;
        btn.LDHeight = strsize.height+ margin;
        
        
        if (i == 0) {
            btn.LDX = margin;
            btnW += CGRectGetMaxX(btn.frame);
        }
        else{
            btnW += CGRectGetMaxX(btn.frame)+margin;
            if (btnW > viewWidth) {
                count++;
                btn.LDX = margin;
                btnW = CGRectGetMaxX(btn.frame);
            }
            else{
                
                btn.LDX += btnW - btn.LDWidth;
                
            }
        }
        btn.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.15f];
        btn.userInteractionEnabled = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:Color(104, 97, 97) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.LDY += count * (btn.LDHeight + margin) + margin + label.LDHeight +8;
        
        btn.layer.cornerRadius = btn.LDHeight/2;
        
        btn.clipsToBounds = YES;
        btn.tag = i;
        [view addSubview:btn];
        if (i == texts.count - 1) {
            view.LDHeight = CGRectGetMaxY(btn.frame) + 10;
            view.LDX = 0;
            view.LDWidth = viewWidth;
        }
    }
    return view;
}

- (void)btnClick:(UIButton *)sender{
    if (![self.btn isEqual:sender]) {
        self.btn.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.15f];
        self.btn.selected = NO;
        sender.backgroundColor = WHColorFromRGB(0x4279d6);
        sender.selected = YES;
    }else if([self.btn isEqual:sender]){
        if (sender.selected == YES) {
            sender.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.15f];
            sender.selected = NO;
        }else{
            sender.backgroundColor = WHColorFromRGB(0x4279d6);
            sender.selected = YES;
        }
    }else{
        
    }
    if ([self.Attribute_delegate respondsToSelector:@selector(Attribute_View:didClickBtn:)] ) {
        [self.Attribute_delegate Attribute_View:self didClickBtn:sender];
    }
    self.btn = sender;
    
}

@end
