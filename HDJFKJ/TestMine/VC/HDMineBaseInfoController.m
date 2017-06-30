

#import "HDMineBaseInfoController.h"
#import "LDMySore.h"
#import "WHSaveAndReadInfomation.h"
@interface HDMineBaseInfoController ()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *scoreButton;

@end

@implementation HDMineBaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息";
    
    
    
    self.nameLabel.text = [LDUserInformation sharedInstance].userName != nil ? [LDUserInformation sharedInstance].userName : @"";
    
    self.phoneNumLabel.text = [LDUserInformation sharedInstance].phoneNumber;
    
    NSString * score = [WHSaveAndReadInfomation readXinYongFen];
    NSArray * array = [score componentsSeparatedByString:@"-"];
    score = array[0];
    self.scoreLabel.text = [NSString stringWithFormat:@"信用分：%@",score] ;
}

- (IBAction)clickScoreButton:(UIButton *)sender {
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:ZLWD];
    
    LDMySore * myscore = [[LDMySore alloc]init];
    [self.navigationController pushViewController:myscore animated:YES];
    
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
