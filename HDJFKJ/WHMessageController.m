

#import "WHMessageController.h"
#import "WHMessageCell.h"
#import "WHMessageModel.h"
#import "WHUserLoginModel.h"
#import "LDDetailMessage.h"

@interface WHMessageController ()

@property (nonatomic, strong) WHUserLoginModel * user;
@property (nonatomic,strong) NSArray * LDMessageArray;
@property (nonatomic,strong) WHMessageModel * model;

/** 无消息视图  */
@property (nonatomic, strong) UIView * nullOrderView;
@end

@implementation WHMessageController

/** 延迟加载无订单视图  */
- (UIView *)nullOrderView{
    if (!_nullOrderView) {
        _nullOrderView = [[UIView alloc]initWithFrame:self.view.bounds];
        _nullOrderView.backgroundColor =WHColorFromRGB(0xf5f5f9);
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((LDScreenWidth - 71)/2, (self.view.frame.size.height - 73)/2 - 20, 71, 73)];
        imageView.image = [UIImage imageNamed:@"firstpage_noLogin"];
        [_nullOrderView addSubview:imageView];
        
        UILabel * nullOrerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height+10 , LDScreenWidth, 20)];
        nullOrerLabel.text = @"暂无消息";
        nullOrerLabel.textColor = WHColorFromRGB(0x979797);
        nullOrerLabel.textAlignment = NSTextAlignmentCenter;
        nullOrerLabel.font = [UIFont systemFontOfSize:13];
        [_nullOrderView addSubview:nullOrerLabel];
    }
    return _nullOrderView;
}

- (void)dealloc{

    NSLog(@"message dealloc");
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置导航栏的背景色
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    
    self.user = [WHUserLoginModel createuserInfoModel];
    //发送网络请求
    if (self.LDMessageArray.count == 0) {
        [self sendRequest];

    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"消息";
    
    //界面最上面的线
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    
    label.backgroundColor = WHColorFromRGB(0x9e9e9e);
    
    [self.view addSubview:label];
    

}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.LDMessageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WHMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"WHMessageCell" owner:nil options:nil].lastObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
   


    
    WHMessageModel * whmessage = self.LDMessageArray[indexPath.row];
    
    cell.messageTitle.text = whmessage.title;
    
    cell.messageContent.text = whmessage.content;
    
    //后台返回unix时间戳
    LDLog(@"publishtime%@",whmessage.publishtime);
  
    NSTimeInterval interval = [whmessage.publishtime floatValue]/1000;
    
    LDLog(@"%@",[NSString stringWithFormat:@"%f",interval]);
    
    //时间戳转成date
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    //设置日期格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    //日期格式转成字符串
    NSString * date1 = [formatter stringFromDate:date];
    LDLog(@"%@",date1);
 
    cell.messageTime.text = date1;
    
    //isread == 1,表示已读；isread == 0,表示为读
    if (whmessage.isread == 1) {
        cell.isreadImageView.hidden = YES;
    }
    
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:whmessage.icon] placeholderImage:[UIImage imageNamed:@"商品 1:1"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(80, cell.frame.size.height - 1, self.view.frame.size.width - 80, 1)];
    label.backgroundColor = WHColorFromRGB(0xc8c7cc);
    [cell addSubview:label];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WHMessageCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.isreadImageView.hidden = YES;

    LDDetailMessage * detailMessageVC = [[LDDetailMessage alloc] init];
    
    detailMessageVC.detaileModel = self.LDMessageArray[indexPath.row];;
    
    [self.navigationController pushViewController:detailMessageVC animated:YES];
    
    [self sendMessageRequest];
    
}

- (void)sendMessageRequest{
    
    
    NSString * str = [NSString stringWithFormat:@"%@message/read",KBaseUrl ];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.user.id forKey:@"id"];
    [params setObject:self.user.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.model.mid] forKey:@"mid"];

    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            
        }else{
        
            LDLog(@"%@",response);

            
            NSString * code = [response objectForKey:@"code"] ;
            LDLog(@"%@",code);
            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
                
                LDLog(@"%@",response);

                self.LDMessageArray = [WHMessageModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
                
                
                
            }else{
                

            }
            
        }
    }];



}



//网络请求
- (void)sendRequest{
    
    [HDLoading showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@message/",KBaseUrl ];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.user.id forKey:@"id"];
    [params setObject:self.user.token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [HDLoading showFailViewWithString:@"网络错误"];
        }else{
            
            NSLog(@"%@",response);
            
            /** 3.解析返回结果  */
            
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            
          
            
            //code == 0请求成功
            if ([backInfo.code isEqualToString:@"0"]) {
                
                self.LDMessageArray = [WHMessageModel mj_objectArrayWithKeyValuesArray:backInfo.result];
                
                for (int i = 0; i < self.LDMessageArray.count; i++) {
                    WHMessageModel * model = self.LDMessageArray[i];
                    LDLog(@"%@",[NSString stringWithFormat:@"%ld",(long)model.cumid]);
                    LDLog(@"%@",[NSString stringWithFormat:@"%ld",(long)model.mid]);
                }
                
                [self.tableView reloadData];
                
                if (self.LDMessageArray.count == 0) {
                    
                    [self.view addSubview:self.nullOrderView];
                }
                
                [HDLoading dismissHDLoading];
                
                
            }else{
                // 显示失败信息
                [HDLoading showFailViewWithString:backInfo.message];
            }
            
        }
    }];
}










@end
