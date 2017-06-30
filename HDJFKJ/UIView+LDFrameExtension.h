//
//  UIView+LDFrameExtension.h
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LDFrameExtension)
/**
 *  在分类中声明属性@property,只会生成方法的声明,不会生成方法的实现和带有_下划线的成员变量.只相当于写了set和get方法的声明没有实现
 *  分类中一般只添加方法,不添加成员变量.分类中特有的语法.
 */
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGSize size;
@property (nonatomic, assign) CGFloat LDRight;
@property (nonatomic, assign) CGFloat LDBottom;


@end
