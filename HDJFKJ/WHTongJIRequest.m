

#import "WHTongJIRequest.h"
#import "sys/utsname.h"

@implementation WHTongJIRequest



+(instancetype)sharedTongji{
    
    static WHTongJIRequest *instance;
    
    static dispatch_once_t oneceToken;
    
    dispatch_once(&oneceToken, ^{
        
        instance = [[WHTongJIRequest alloc] init];
        
    });
    
    return instance;
}

+ (void)sendTongjiRequestWithBusinessId:(NSString *)business_id oprType:(OperateType)opr_type{
      
    
    //全局的队列 (并行)
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);//DEFAULT
    
    dispatch_async(globalQueue, ^{
        [[WHTongJIRequest sharedTongji] setBusiness_id:business_id];
        [[WHTongJIRequest sharedTongji] setOpr_type:opr_type];
        
        
        [[self sharedTongji] sendTongjiRequest];
    });
    
    
}


- (void)sendTongjiRequest{
    

    
    if ([LDUserInformation sharedInstance].UserId != nil && [LDUserInformation sharedInstance].token != nil) {
        NSString * str = [NSString stringWithFormat:@"%@operation/recordOperation",KBaseUrl ];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
        [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
        
        //客户所在地区
        if ([LDUserInformation sharedInstance].locationName != nil){
            [params setObject:[LDUserInformation sharedInstance].locationName forKey:@"area"];
        }
        
        
        //机型
        __strong  WHTongJIRequest * strongSelf = self;
        [params setObject:[strongSelf deviceString] forKey:@"phone_model"];
        
        UIDevice *device = [UIDevice currentDevice] ;
        //系统版本
        [params setObject:device.systemVersion forKey:@"system_version"];
        
        //设备id
        NSString *UUID = [NSString stringWithFormat:@"%@",device.identifierForVendor];
        NSArray * UUIDArr = [UUID componentsSeparatedByString:@" "];
        if (UUIDArr.count == 3) {
            UUID = UUIDArr[2];
            UUID = [UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [params setObject:UUID forKey:@"device_id"];
        }
        
        //业务id：business_id（如订单ID，商品ID等）
        
        if ([WHTongJIRequest sharedTongji].business_id != nil) {
            [params setObject:[WHTongJIRequest sharedTongji].business_id forKey:@"business_id"];
        }
        
        [params setObject:[NSString stringWithFormat:@"%ld",(long)[WHTongJIRequest sharedTongji].opr_type] forKey:@"opr_type"];
        
        
        
        [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
            if (error != nil) {
                
            }else{
            
            }
            NSLog(@"%@",response);
        }];
        
    }
    
    
}


- (NSString *)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"]) {
        return @"iPhone 2G (A1203)";
    }
    
    if ([deviceString isEqualToString:@"iPhone1,2"]) {
        return @"iPhone 3G (A1241/A1324)";
    }
    
    if ([deviceString isEqualToString:@"iPhone2,1"]) {
        return @"iPhone 3GS (A1303/A1325)";
    }
    
    if ([deviceString isEqualToString:@"iPhone3,1"]) {
        return @"iPhone 4 (A1332)";
    }
    
    if ([deviceString isEqualToString:@"iPhone3,2"]) {
        return @"iPhone 4 (A1332)";
    }
    
    if ([deviceString isEqualToString:@"iPhone3,3"]) {
        return @"iPhone 4 (A1349)";
    }
    
    if ([deviceString isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S (A1387/A1431)";
    }
    
    if ([deviceString isEqualToString:@"iPhone5,1"]) {
        return @"iPhone 5 (A1428)";
    }
    
    if ([deviceString isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5 (A1429/A1442)";
    }
    
    if ([deviceString isEqualToString:@"iPhone5,3"]) {
        return @"iPhone 5c (A1456/A1532)";
    }
    
    if ([deviceString isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    }
    
    if ([deviceString isEqualToString:@"iPhone6,1"]) {
        return @"iPhone 5s (A1453/A1533)";
    }
    
    if ([deviceString isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    }
    
    if ([deviceString isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus (A1522/A1524)";
    }
    
    if ([deviceString isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6 (A1549/A1586)";
    }
    
    if ([deviceString isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    }
    
    if ([deviceString isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6s Plus (A1634/A1687/A1690A1699)";
    }
    
    if ([deviceString isEqualToString:@"iPhone8,4"]) {
        return @"iPhone SE (A1662/A1723/A1724)";
    }
    
    if ([deviceString isEqualToString:@"iPod1,1"]) {
        return @"iPod Touch 1G (A1213)";
    }
    
    if ([deviceString isEqualToString:@"iPod2,1"]) {
        return @"iPod Touch 2G (A1288)";
    }
    
    if ([deviceString isEqualToString:@"iPod3,1"]) {
        return @"iPod Touch 3G (A1318)";
    }
    
    if ([deviceString isEqualToString:@"iPod4,1"]) {
        return @"iPod Touch 4G (A1367)";
    }
    
    if ([deviceString isEqualToString:@"iPod5,1"]) {
        return @"iPod Touch 5G (A1421/A1509)";
    }
    
    if ([deviceString isEqualToString:@"iPod7,1"]) {
        return @"iPod touch 6G (A1574)";
    }
    
    if ([deviceString isEqualToString:@"iPad1,1"]) {
        return @"iPad 1G (A1219/A1337)";
    }
    
    if ([deviceString isEqualToString:@"iPad2,1"]) {
        return @"iPad 2 (A1395)";
    }
    
    if ([deviceString isEqualToString:@"iPad2,2"]) {
        return @"iPad 2 (A1396)";
    }
    
    if ([deviceString isEqualToString:@"iPad2,3"]) {
        return @"iPad 2 (A1397)";
    }
    
    if ([deviceString isEqualToString:@"iPad2,4"]) {
        return @"iPad 2 (A1395+New Chip)";
    }
    
    if ([deviceString isEqualToString:@"iPad2,5"]) {
        return @"iPad Mini 1G (A1432)";
    }
    
    if ([deviceString isEqualToString:@"iPad2,6"]) {
        return @"iPad Mini 1G (A1454)";
    }
    
    if ([deviceString isEqualToString:@"iPad2,7"]) {
        return @"iPad Mini 1G (A1455)";
    }
    
    if ([deviceString isEqualToString:@"iPad3,1"]) {
        return @"iPad 3 (A1416)";
    }
    
    if ([deviceString isEqualToString:@"iPad3,2"]) {
        return @"iPad 3 (A1403)";
    }
    
    if ([deviceString isEqualToString:@"iPad3,3"]) {
        return @"iPad 3 (A1430)";
    }
    
    if ([deviceString isEqualToString:@"iPad3,4"]) {
        return @"iPad 4 (A1458)";
    }
    
    if ([deviceString isEqualToString:@"iPad3,5"]) {
        return @"iPad 4 (A1459)";
    }
    
    if ([deviceString isEqualToString:@"iPad3,6"]) {
        return @"iPad 4 (A1460)";
    }
    
    if ([deviceString isEqualToString:@"iPad4,1"]) {
        return @"iPad Air (A1474)";
    }
    
    if ([deviceString isEqualToString:@"iPad4,2"]) {
        return @"iPad Air (A1475)";
    }
    
    if ([deviceString isEqualToString:@"iPad4,3"]) {
        return @"iPad Air (A1476)";
    }
    
    if ([deviceString isEqualToString:@"iPad4,4"]) {
        return @"iPad Mini 2G (A1489)";
    }
    
    if ([deviceString isEqualToString:@"iPad4,5"]) {
        return @"iPad Mini 2G (A1490)";
    }
    
    if ([deviceString isEqualToString:@"iPad4,6"]) {
        return @"iPad Mini 2G (A1491)";
    }
    
    if ([deviceString isEqualToString:@"i386"]) {
        return @"iPhone Simulator";
    }
    
    if ([deviceString isEqualToString:@"x86_64"]) {
        return @"iPhone Simulator";
    }
    
    return deviceString;
}
@end
