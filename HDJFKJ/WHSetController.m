

#import "WHSetController.h"
#import "WHUserLoginModel.h"
#import "LDSignInViewController.h"
#import "LDNavgationVController.h"

@interface WHSetController ()
@property (weak, nonatomic) IBOutlet UILabel *banBenHaoLabel;

@property (nonatomic, strong) WHUserLoginModel * user;

@end

@implementation WHSetController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    self.user = [WHUserLoginModel createuserInfoModel];
    
    NSString *key = @"CFBundleShortVersionString";
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    self.banBenHaoLabel.text = currentVersion;
}
//关于我们
- (IBAction)clickAbout:(UIButton *)sender {
}
//平分
- (IBAction)clickOrdinaryScore:(UIButton *)sender {
}
//反馈
- (IBAction)clickFeedBack:(UIButton *)sender {
}
//退出
- (IBAction)clickCancel:(UIButton *)sender {
    
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:TCDL];
    
    //发送的退出登录请求
    [self sendRequest];
    
    //删除本地保存的用户信息
    [WHUserLoginModel deleteUserLogin];
    
    [[LDUserInformation sharedInstance] setUserId:nil];
    [[LDUserInformation sharedInstance] setToken:nil];
    
    //推出登录界面
    LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
    signinVC.number = self.user.phone;
    signinVC.indexFlag = 41;
    
    LDNavgationVController * nav = [[LDNavgationVController alloc] initWithRootViewController:signinVC];
   
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
   }

//退出登录网络请求
- (void)sendRequest{
    
    
    NSString * str = [NSString stringWithFormat:@"%@logout",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params setObject:self.user.id forKey:@"id"];
    [params setObject:self.user.token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
        }else{
            
            LDLog(@"%@",response);

            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {

                
            }

        }
    }];
}
@end
