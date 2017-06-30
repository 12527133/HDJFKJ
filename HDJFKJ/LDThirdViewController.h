//
//  LDThirdViewController.h
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDThirdViewController : LDBaseUIViewController

//跳转隐藏tabBer的标示,0代表它作为一级界面，1标示它作为其他界面的二级界面，以此类推
@property (nonatomic, assign) NSInteger indexflag;

@end
