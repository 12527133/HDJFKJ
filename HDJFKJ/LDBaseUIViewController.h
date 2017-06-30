//
//  LDBaseUIViewController.h
//  HDJFKJ
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDBaseUIViewController : UIViewController

@property (nonatomic, assign) BOOL gifFirst;


- (void)showWithImageWithString:(NSString *)string;
- (void)showFailViewWithString:(NSString *)string;
- (void)showSuccessViewWithString:(NSString *)string;
- (void)dismissHDLoading;

//加载jif动画
- (void)showJifWithString:(NSString *)string toView:(UIView *)view;

/** 移除加载 */
- (void)hiddenLodJifToView:(UIView *)view;

@end
