

#import "HDLoginRagisterRequest.h"

@implementation HDLoginRagisterRequest


+ (id)loginRequestWithDict:(NSMutableDictionary *)params{

    NSString * str = [NSString stringWithFormat:@"%@login/",KBaseUrl];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            // 显示失败信息
            [HDLoading showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            /** 解析返回结果 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** code值为0，请求正常*/
            if ([backInfor.code isEqualToString:@"0"]) {
                
                
                /** 移除指示器*/
                [HDLoading dismissHDLoading];
                
                
                if (backInfor.result != nil) {
                    
                    /** 1.保存登录后的信息到本地*/
                    /** 归档存储用户信息*/
                    [NSKeyedArchiver archiveRootObject:backInfor.result toFile:UserInfoDict];
                    
                    
                    
                }
                
                
                
                
                /** 6.数据统计  */
                [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:Login];
                
                
                
                
            }
            /** 9.处理返回结果异常，提示异常信息*/
            else
            {
                [HDLoading showFailViewWithString:backInfor.message];
                
            }
            
        }
    }];

    
    return nil;
}

@end
