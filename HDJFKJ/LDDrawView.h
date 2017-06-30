//
//  LDDrawView.h
//  HDJFKJ
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDDrawView : UIView
@property (nonatomic, strong) UIColor *pathColor;
@property (nonatomic, assign) NSInteger lineWidth;


@property (nonatomic, strong) UIImage *image;

/**
 *  清屏
 */
- (void)clear;

/**
 *  撤销
 */
- (void)undo;

@end
