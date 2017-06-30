//
//  UIView+LDFrameExtension.m
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "UIView+LDFrameExtension.h"

@implementation UIView (LDFrameExtension)

-(void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;

}

-(CGSize)size{
    return self.frame.size;
}


- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;

}
- (CGFloat)height{
    return self.frame.size.height;
    
}
- (CGFloat)width{
    return self.frame.size.width;
}
-(CGFloat)x{
    return self.frame.origin.x;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
@end









