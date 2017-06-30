

#import "HDMineMoreController.h"
#import "LDSafetyCenter.h"
#import "WHUserLoginModel.h"
#import "LDSignInViewController.h"
#import "LDNavgationVController.h"
#import "WHXinYongFenAgreementController.h"
@interface HDMineMoreController ()

@property (weak, nonatomic) IBOutlet UIButton *anquanButton;

@property (weak, nonatomic) IBOutlet UILabel *banbenLabel;

@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) IBOutlet UIButton *tuichuButton;


@property (weak, nonatomic) IBOutlet UILabel *xiaoxiLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *xiaoxiRightLabel;

@property (weak, nonatomic) IBOutlet UIButton *xiaoxiButton;

@property (weak, nonatomic) IBOutlet UILabel *xiaoxiLine;

@property (weak, nonatomic) IBOutlet UILabel *xiaoxiBottomLabel;


@property (weak, nonatomic) IBOutlet UIButton *bangzhuButton;

@end

@implementation HDMineMoreController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self panduanshifoukaiqitongzhi];

}

- (void)panduanshifoukaiqitongzhi{

    /** 判断通知是否开启 */
    if ([LDUserInformation sharedInstance].deviceToken.length == 0) {
        /** 未开启 */
        
        self.xiaoxiRightLabel.text = @"已关闭";
        
        self.xiaoxiButton.hidden = NO;
        self.xiaoxiLine.hidden = NO;
    }
    else{
        /** 已开启 */
        
        
        self.xiaoxiRightLabel.text = @"已开启";
        
        self.xiaoxiButton.hidden = YES;
        self.xiaoxiLine.hidden = YES;
    }
}

- (void)dealloc{

    LDLog(@"x销毁设置界面，控制器 ");

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhikaiqi" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    // 获得当前软件的版本号
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    self.banbenLabel.text = currentVersion;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panduanshifoukaiqitongzhi) name:@"tongzhikaiqi" object:nil];
    
    
    
}

- (BOOL)isMessageNotificationServiceOpen {

    return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
}


- (IBAction)clickBangzhuButton:(UIButton *)sender {
    
    WHXinYongFenAgreementController * vc = [[WHXinYongFenAgreementController alloc]initWithURL:helpCenterUrl title:@"帮助中心"];
    [self.navigationController pushViewController:vc animated:YES];
}




- (IBAction)clickXiaoButton:(UIButton *)sender {
    
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}




- (IBAction)clickTuChuButton:(id)sender {
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:TCDL];
    
    //删除本地保存的用户信息
    [WHUserLoginModel deleteUserLogin];
    [[LDUserInformation sharedInstance] setUserId:nil];
    [[LDUserInformation sharedInstance] setToken:nil];
    
    //推出登录界面
    LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
    signinVC.fromWhere = @"tuichu";
    LDNavgationVController * nav = [[LDNavgationVController alloc] initWithRootViewController:signinVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

- (IBAction)clickAnQuanButton:(id)sender {
    
    LDSafetyCenter * safety = [[LDSafetyCenter alloc] init];
    
    [self.navigationController pushViewController:safety animated:YES];
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
