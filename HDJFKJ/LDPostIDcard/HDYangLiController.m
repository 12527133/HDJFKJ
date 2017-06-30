

#import "HDYangLiController.h"

@interface HDYangLiController ()
@property (nonatomic, strong) UIScrollView * coverView;

@property (nonatomic, strong) NSTimer * timer;
@end

@implementation HDYangLiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LDBackroundColor;
    self.title = @"身份证样例";
    [self createCoverView];
   
}

- (void)dealloc{
    
    LDLog(@"销毁样例控制器");

}

/** 创建视图 */
- (void)createCoverView{
    self.coverView = [[UIScrollView alloc]init];
    
    self.coverView.frame = CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 64);
    
    self.coverView.contentSize = self.coverView.frame.size;
    
    self.coverView.backgroundColor = LDBackroundColor;
    [self.view addSubview:self.coverView];
    
    
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, LDScreenWidth, 142*bili)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.coverView addSubview:topView];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 15*bili, 100, 21*bili)];
    label1.textColor = WHColorFromRGB(0x323232);
    label1.font = [UIFont systemFontOfSize:15*bili];
    label1.text = @"拍照需求";
    [topView addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 51*bili, 300, 18*bili)];
    label2.textColor = WHColorFromRGB(0x8d8d8d);
    label2.font = [UIFont systemFontOfSize:13*bili];
    label2.text = @"1、申请人的五官需要清晰。";
    [topView addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 78*bili, 300, 18*bili)];
    label3.textColor = WHColorFromRGB(0x8d8d8d);
    label3.font = [UIFont systemFontOfSize:13*bili];
    label3.text = @"2、身份证所有信息需要清晰。";
    [topView addSubview:label3];
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 105*bili, 300, 18*bili)];
    label4.textColor = WHColorFromRGB(0x8d8d8d);
    label4.font = [UIFont systemFontOfSize:13*bili];
    label4.text = @"3、请保证头部完整出现在照片内。";
    [topView addSubview:label4];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+142*bili, LDScreenWidth, 284*bili)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.coverView addSubview:bottomView];
    
    UILabel * bottomlabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 11*bili, 200, 21*bili)];
    bottomlabel.textColor = WHColorFromRGB(0x323232);
    bottomlabel.font = [UIFont systemFontOfSize:15*bili];
    bottomlabel.text = @"样例照片";
    [bottomView addSubview:bottomlabel];
    
    UIImageView * yangliView = [[UIImageView alloc]initWithFrame:CGRectMake(15*bili, 42*bili, 295*bili, 203*bili)];
    yangliView.image = [UIImage imageNamed:@"qinqianzhao"];
    [bottomView addSubview:yangliView];
    

    
    //拍照Button
    UIButton * subButton = [[UIButton alloc]init];
    [subButton setBackgroundColor:WHColorFromRGB(0x4279d6)];
    [subButton setTitle:@"开始拍照" forState:UIControlStateNormal];
    [subButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subButton.frame = CGRectMake(0, self.coverView.frame.size.height -45*LDScreenWidth/375  , LDScreenWidth, 45*LDScreenWidth/375);
    [self.coverView addSubview:subButton];
    [subButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)buttonAction:(UIButton *)sender{
    
    _completionBlock();
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(pop) userInfo:nil repeats:NO];

}
- (void)pop{
    [self.timer invalidate];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
