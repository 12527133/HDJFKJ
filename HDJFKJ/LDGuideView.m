//
//  LDGuideView.m
//  HDJFKJ
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDGuideView.h"
#import "LDTabBarController.h"

@interface LDGuideView ()
@property (nonatomic,strong) UIImageView * image1;

@end

@implementation LDGuideView


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIScrollView * scro = [[UIScrollView alloc] initWithFrame:self.view.frame];
    UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight)];
    scro.showsHorizontalScrollIndicator = NO;
    self.image1 = image1;
    UIImageView * image2 = [[UIImageView alloc] initWithFrame:CGRectMake(LDScreenWidth, 0, LDScreenWidth, LDScreenHeight)];
    UIImageView * image3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*LDScreenWidth, 0, LDScreenWidth, LDScreenHeight)];
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier isEqualToString:@"cn.hdfex.hufenqi"]) {
        image1.image = [UIImage imageNamed:@"引导页1"];
        image2.image = [UIImage imageNamed:@"引导页2"];
        image3.image = [UIImage imageNamed:@"引导页3"];
        
    }else{
        image1.image = [UIImage imageNamed:@"贷鱼引导页1"];
        image2.image = [UIImage imageNamed:@"贷鱼引导页2"];
        image3.image = [UIImage imageNamed:@"贷鱼引导页3"];
        
    }
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    image3.userInteractionEnabled = YES;
    [image3 addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image3).offset(0);
        make.bottom.equalTo(image3).offset(0);
        make.right.equalTo(image3).offset(0);
        make.height.equalTo(140);
    }];
    
    [scro addSubview:image1];
    [scro addSubview:image2];
    [scro addSubview:image3];
    
    
    scro.pagingEnabled = YES;
    scro.contentSize = CGSizeMake(3*LDScreenWidth, LDScreenHeight);
    scro.contentInset = UIEdgeInsetsZero;
    scro.bounces  = NO;
    
    [self.view addSubview:scro];
    // 存储版本号
    NSString *key = @"CFBundleShortVersionString";
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];

    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}
- (void)buttonClick{
    
     [UIApplication sharedApplication].keyWindow.rootViewController = [[LDTabBarController alloc] init];
    
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
