//
//  LDTabBarView.m
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDTabBarView.h"

@interface LDTabBarView()




@end

@implementation LDTabBarView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        // 添加发布按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"saomakongbai.png"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"saomakongbai.png"] forState:UIControlStateHighlighted];
       
        publishButton.size = publishButton.currentBackgroundImage.size;
        [publishButton setTitle:@"扫码" forState:UIControlStateNormal];
        [publishButton setTitleColor:WHColorFromRGB(0x808080) forState:UIControlStateNormal];

        publishButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [publishButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -32, 0)];
        
        [self addSubview:publishButton];
        self.publishButton = publishButton;
        
        //[self.publishButton addTarget:self action:@selector(clickSaoMaView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


//重新布局tabBar子控件
- (void)layoutSubviews{
    
    [super layoutSubviews];

    //tabBar宽度和高度
    CGFloat width = LDScreenWidth;
    CGFloat height = 44;
    //设置发布按钮的frame
    self.publishButton.width = self.publishButton.currentBackgroundImage.size.width;
    self.publishButton.height = self.publishButton.currentBackgroundImage.size.height;
    self.publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    //设置其他UITabBarButton的frame
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 5;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
    }
}

@end













