//
//  LDSignViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDSignViewController.h"
#import "LDDrawView.h"
@interface LDSignViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) LDDrawView * drawView;

@end

@implementation LDSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LDDrawView * drawView = [[LDDrawView alloc] initWithFrame:self.view.frame];
    
    drawView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:drawView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
