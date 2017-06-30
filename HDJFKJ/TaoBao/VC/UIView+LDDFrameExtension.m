//
//  UIView+LDFrameExtension.m
//  OCLDProject
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "UIView+LDDFrameExtension.h"

@implementation UIView (LDDFrameExtension)

-(void)setLDSize:(CGSize)size{
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
}

-(CGSize)LDSize{
    return self.frame.size;
}


- (void)setLDWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}
- (void)setLDHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setLDX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setLDY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
}
- (CGFloat)LDHeight{
    return self.frame.size.height;
    
}
- (CGFloat)LDWidth{
    return self.frame.size.width;
}
-(CGFloat)LDX{
    return self.frame.origin.x;
}
- (CGFloat)LDY{
    return self.frame.origin.y;
}
- (void)setLDCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setLDCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)LDCenterY
{
    return self.center.y;
}

- (CGFloat)LDCenterX
{
    return self.center.x;
}
- (CGFloat)LDRight
{
    //    return self.xmg_x + self.xmg_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)LDBottom
{
    //    return self.xmg_y + self.xmg_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setLDRight:(CGFloat)LDRight
{
    self.LDX = LDRight - self.LDWidth;
}

- (void)setLDBottom:(CGFloat)LDBottom
{
    self.LDY = LDBottom - self.LDHeight;
}

@end
