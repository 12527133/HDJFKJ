//
//  LDGoodsDetailsScroViewController.m
//  
//
//  Created by apple on 16/3/25.
//
//

#import "LDGoodsDetailsScroViewController.h"

@interface LDGoodsDetailsScroViewController ()
@property (nonatomic,strong) UIScrollView * scrol;

@end

@implementation LDGoodsDetailsScroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatScrolView];
}
- (void)creatScrolView{
    
    self.scrol = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    self.scrol.backgroundColor = [UIColor redColor];
    
    self.scrol.contentSize = CGSizeMake(LDScreenWidth, 700);
    
    [self.view addSubview:self.scrol];
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
