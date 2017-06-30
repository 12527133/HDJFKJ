

#import "WHQROrderController.h"
#import "LDSignInViewController.h"
#import "LDNavgationVController.h"

@interface WHQROrderController ()
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation WHQROrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录提醒";
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)clickGoLogin:(UIButton *)sender {
    
    
    LDSignInViewController * signVC = [[LDSignInViewController alloc] init];
    
    LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:signVC];

    [self.navigationController presentViewController:nav animated:YES completion:^{
        
       
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(pop) userInfo:nil repeats:NO];
//    [self.navigationController pushViewController:signVC animated:YES];
    
    
}
- (void)pop{
    [self.timer invalidate];
    [self.navigationController popViewControllerAnimated:NO];
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
