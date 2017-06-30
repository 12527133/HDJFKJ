//
//  LDTypeViewController.m
//  HDJFKJ
//
//  Created by apple on 16/3/6.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//
#import "LDBaseInformationTableViewController.h"
#import "LDTypeViewController.h"
#import "LDTypeWorkGroupModel.h"
#import "LDTypeWorkModel.h"
#import "LDTabBarController.h"
#import "LDtest2222ViewController.h"
#import "LDPostIDCard.h"
#import "LDJobStudentInforController.h"
#import "LDJobTabbleViewController.h"
#import "LDEntrepreneursTableViewController.h"

@interface LDTypeViewController ()<UITableViewDelegate>
@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,copy) NSString * jobType;

@property (nonatomic, strong) NSString * oldJobType;
@end

@implementation LDTypeViewController
static NSString * ID = @"workTypeCell";
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
/**
 *  返回哪个控制器
 */
- (void)backButtonClick{
    
    
    [self whichControllerToBack];
}

//返回哪个控制器
- (void)whichControllerToBack{
    
    
    if ([self.fromeWhere isEqualToString:@"wode"]) {
        
        LDLog(@"返回到我的界面");
        
        for (UIViewController * vc in self.navigationController.viewControllers) {
            
            NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
            
            if ([vcClass isEqualToString:@"LDForthViewController"]) {
                
                //如果是确认订单控制器,就pop到该控制器
                [self.navigationController popToViewController:vc animated:NO];
                
                
            }
            
        }
        
    }else if ([self.fromeWhere isEqualToString:@"zhuce"]){
        
        //返回到首页,可能需要发送登录请求
        LDLog(@"返回到首页,可能需要发送登录请求");
        LDTabBarController * tabbar = [[LDTabBarController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
        
        
    }else if ([self.fromeWhere isEqualToString:@"xianjindai"]) {
        
        LDLog(@"返回到现金贷");
        
        LDTabBarController * tabbar = [[LDTabBarController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
        

    }else{//下单
        
        for (UIViewController * vc in self.navigationController.viewControllers) {
            
            NSString * vcClass = [NSString stringWithFormat:@"%@",[vc class]];
            
            if ([vcClass isEqualToString:@"LDConformOrderViewController"]||[vcClass isEqualToString:@"LDOrderDetailViewController"]) {
                
                //如果是确认订单控制器,就pop到该控制器
                [self.navigationController popToViewController:vc animated:NO];
                
            }
        }

        
    }
    
}

-(instancetype)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];

    return self;
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        // 加载plist中的字典数组
        NSString *path = [[NSBundle mainBundle] pathForResource:@"typeWork.plist" ofType:nil];
        
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *allArray = [NSMutableArray array];
        
        for (NSArray *array  in dictArray) {
            // 字典数组 -> 模型数组
            NSMutableArray *dealArray = [NSMutableArray array];
            
            for (NSDictionary *dict in array) {
                
                LDTypeWorkModel *workModel = [LDTypeWorkModel modelWithDict:dict];
                
                [dealArray addObject:workModel];
            }
            
            [allArray addObject:dealArray];
        }
        
        _dataArray = allArray;

    }
    return _dataArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    self.navigationItem.title = @"工作类型";
    self.tableView.rowHeight = 90;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"quxiao" highImage:@"quxiao" target:self action:@selector(backButtonClick)];
    

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   
    //选中不同cell,置为true
    if (indexPath.section == 0) {
        self.jobType = @"1";
        LDLog(@"我是学生");
    }
    
    if (indexPath.section == 1){
        self.jobType = @"2";
        LDLog(@"我是上班族");

    }
    if(indexPath.section == 2){
        LDLog(@"创业者");
        self.jobType = @"3";

    }
    
    
    [self sendRequest:self.jobType];
 
}

- (void)sendRequest:(NSString *)str{
    
    [HDLoading showWithImageWithString:@"正在提交"];
    
    NSString * url = [NSString stringWithFormat:@"%@register/customInfo",KBaseUrl];
    
    [[LDNetworkTools sharedTools] request:POST url:url params:[self getPar:str] callback:^(id response, NSError *error) {
        if (error != nil) {
            
            
            LDLog(@"error%@",error);
            
            [HDLoading showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                [HDLoading dismissHDLoading];
                
                 [NSKeyedArchiver archiveRootObject:@"0" toFile:VCIndex];
                
                if ([self.fromeWhere isEqualToString:@"xinyongfen"]) {
                    
                    [self whichControllerJump];
                    
                }else{
                 
                    LDPostIDCard * tabbleVC = [[LDPostIDCard alloc] init];
                    
                    tabbleVC.fromeWhere = self.fromeWhere;
                   
                    [self.navigationController pushViewController:tabbleVC animated:YES];
                }
               
               

            }else{
                
                [HDLoading showFailViewWithString:backInfor.message];
            }
        }
    }];
    
}

#pragma mark - 跳转哪个控制器
- (void)whichControllerJump{
    
    if ([self.jobType isEqualToString:@"1"]) {
        
        LDJobStudentInforController * student = [[LDJobStudentInforController alloc] init];
        
        student.fromeWhere = self.fromeWhere;
        
        student.jobType = self.jobType;
        //student.oldJobType = self.oldJobType;
        
        [self.navigationController pushViewController:student animated:YES];
    }
    if ([self.jobType isEqualToString:@"2"]) {
        
        
        LDJobTabbleViewController * viewVC = [[LDJobTabbleViewController alloc] init ];//WihtString:self.fromeWhere];
        
        viewVC.fromeWhere = self.fromeWhere;
        
        viewVC.jobType = self.jobType;
        //viewVC.oldJobType = self.oldJobType;
        
        [self.navigationController pushViewController:viewVC animated:YES];
        
    }
    if ([self.jobType isEqualToString:@"3"]) {
        LDEntrepreneursTableViewController * entrepreneurs = [[LDEntrepreneursTableViewController alloc] init];
        
        entrepreneurs.fromeWhere = self.fromeWhere;
        
        entrepreneurs.jobType = self.jobType;
        //entrepreneurs.oldJobType = self.oldJobType;
        
        [self.navigationController pushViewController:entrepreneurs animated:YES];
    }
    
}
- (NSMutableDictionary *)getPar:(NSString *)str{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    //工作类型
    [parameters setObject:str forKey:@"occupation"];
    
    return parameters;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * string = @"workTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workTypeCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:string];
    }

    
    NSArray *array = self.dataArray[indexPath.section];
    
    LDTypeWorkModel *workModel = array[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:workModel.imageName];
    cell.textLabel.text = workModel.lableText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//网络请求,获取用户的部分基本信息
- (void)requestUserBaseRequest{
    
    [HDLoading showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            [HDLoading showFailViewWithString:@"网络错误"];
        }else{
            
            NSString * code = [response objectForKey:@"code"] ;
            
            
            //code == 0请求成功
            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
                [HDLoading dismissHDLoading];
                
                NSDictionary * dict = [response objectForKey:@"result"];
                

                self.oldJobType = NULLOBJ([dict objectForKey:@"occupation"]) ;
               
                
            }else{
                [HDLoading showFailViewWithString:[response objectForKey:@"message"]];
            }
            
            LDLog(@"%@",response);
        }
    }];
}

@end
