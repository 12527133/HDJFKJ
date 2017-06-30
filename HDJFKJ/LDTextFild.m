//
//  LDTextFild.m
//  HDJFKJ
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDTextFild.h"
#import <objc/runtime.h>

static NSString * const LDPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation LDTextFild


//+ (void)initialize
//{
//    [self getIvars];
//}
//
//+ (void)getProperties
//{
//    unsigned int count = 0;
//    
//    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
//    
//    for (int i = 0; i<count; i++) {
//        // 取出属性
//        objc_property_t property = properties[i];
//        
//        // 打印属性名字
//        LDLog(@"%s   <---->   %s", property_getName(property), property_getAttributes(property));
//    }
//    
//    free(properties);
//}

//+ (void)getIvars
//{
//    unsigned int count = 0;
//    
//    // 拷贝出所有的成员变量列表
//    Ivar *ivars = class_copyIvarList([UITextField class], &count);
//    
//    for (int i = 0; i<count; i++) {
//        // 取出成员变量
//        //        Ivar ivar = *(ivars + i);
//        Ivar ivar = ivars[i];
//        
//        // 打印成员变量名字
//        LDLog(@"%s %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
//    }
//    
//    // 释放
//    free(ivars);
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
        UILabel *placeholderLabel = [self valueForKeyPath:@"_placeholderLabel"];
    
        placeholderLabel.textColor = [UIColor blueColor];
    
        // 修改占位文字颜色
        [self setValue:[UIColor yellowColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    // 不成为第一响应者
    [self resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用,选中文本框时占位文字的颜色.
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] forKeyPath:LDPlacerholderColorKeyPath];
    
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用,不选中时的颜色
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色,
    [self setValue:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] forKeyPath:LDPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}

//- (void)setHighlighted:(BOOL)highlighted
//{
//    XMGLog(@"-----%d", highlighted);
//    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
//}

//- (void)setPlaceholderColor:(UIColor *)placeholderColor
//{
//    _placeholderColor = placeholderColor;
//
//    // 修改占位文字颜色
//    [self setValue:placeholderColor forKeyPath:XMGPlacerholderColorKeyPath];
//}

/**
 运行时(Runtime):
 * 苹果官方一套C语言库
 * 能做很多底层操作(比如访问隐藏的一些成员变量\成员方法....)
 */@end
