

#import "WHGetAddressBook.h"
#import "WHAddressBookModel.h"
@implementation WHGetAddressBook


//询问通讯录权限，并获取通讯录
+ (BOOL)getAddressBookMessage{
    
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addressBooks =nil;
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        //创建通讯簿的引用
        addressBooks=ABAddressBookCreateWithOptions(NULL, NULL);
        //创建一个出事信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        //IOS6之前
        addressBooks =ABAddressBookCreate();
    }
    if (!tip) {
        
        /** 本地保存允许访问过通讯录 */
        [NSKeyedArchiver archiveRootObject:@"是" toFile:AddressBook];
        
        return YES;
    }
    else{
        
        /** 本地保存允许访问过通讯录 */
        [NSKeyedArchiver archiveRootObject:@"否" toFile:AddressBook];
        
        return NO;
    }
    
}
//询问通讯录权限，并获取通讯录
+ (NSMutableArray *)returnAddressBookMessage{
    
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addressBooks =nil;
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        //创建通讯簿的引用
        addressBooks=ABAddressBookCreateWithOptions(NULL, NULL);
        //创建一个出事信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        //IOS6之前
        addressBooks =ABAddressBookCreate();
    }
    if (!tip) {
        //获取通讯录中的所有人
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
        //通讯录中人数
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
        
        NSLog(@"%@",allPeople);
        NSMutableArray * addressBoolArray = [[NSMutableArray alloc]init];
        //NSMutableString * addressBookStr = [[NSMutableString alloc]init];
        
        //循环，获取每个人的个人信息
        for (NSInteger i = 0; i < nPeople; i++)
        {
            //新建一个addressBook model类
            WHAddressBookModel *addressBook = [[WHAddressBookModel alloc] init];
            //获取个人
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            //获取个人名字
            CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            NSString *nameString = (__bridge NSString *)abName;
            NSString *lastNameString = (__bridge NSString *)abLastName;
            
            if ((__bridge id)abFullName != nil) {
                nameString = (__bridge NSString *)abFullName;
            } else {
                if ((__bridge id)abLastName != nil)
                {
                    nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                    
                }
            }
            
            addressBook.name = nameString;
            //addressBook.recordID = (int)ABRecordGetRecordID(person);;
            
            ABPropertyID multiProperties[] = {
                kABPersonPhoneProperty,
                kABPersonEmailProperty
            };
            NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
            for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
                ABPropertyID property = multiProperties[j];
                ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
                NSInteger valuesCount = 0;
                if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
                
                if (valuesCount == 0) {
                    CFRelease(valuesRef);
                    continue;
                }
                //获取电话号码和email
                for (NSInteger k = 0; k < valuesCount; k++) {
                    CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                    switch (j) {
                        case 0: {// Phone number
                            addressBook.mobile = (__bridge NSString*)value;
                            //NSLog(@"%@",addressBook.telephone);
                            break;
                        }
                            
                    }
                    CFRelease(value);
                }
                CFRelease(valuesRef);
            }
            if (addressBook.mobile != nil && addressBook.name != nil) {
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                
                [dict setValue:addressBook.mobile forKey:@"mobile"];
                [dict setValue:addressBook.name forKey:@"name"];
                
                [addressBoolArray addObject:dict];
            }
            
            
            
            //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
            //        NSLog(@"姓名：%@  电话：%@",addressBook.name,addressBook.telephone);
            
            if (abName) CFRelease(abName);
            if (abLastName) CFRelease(abLastName);
            if (abFullName) CFRelease(abFullName);
        }
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:addressBoolArray options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString* sInvalid = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        // 从服务器收到的类似上一行的数据 // 转换
        NSString*sValid = [sInvalid stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        sValid= [sValid stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        sValid= [sValid stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        sValid= [sValid stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSData * data =[sValid dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *jsonString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"%@",jsonString);
        
        
        if ([LDUserInformation sharedInstance].UserId != nil && [LDUserInformation sharedInstance].UserId.length > 0) {
            
            
            NSString * str = [NSString stringWithFormat:@"%@addressBook",KBaseUrl ];
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            
            [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"userId"];
            [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
            [params setObject:jsonString forKey:@"addressList"];
            
            
            
            [[LDNetworkTools sharedToolsForAddressBook] request:POST url:str params:params callback:^(id response, NSError *error) {
                if (error != nil) {
                    
                    LDLog(@"%@",error);
                }else{
                    
                    LDLog(@"%@",response);
                }
            }];
        }
        
        
        return addressBoolArray;
    }
    else{
        return nil;
    }
    
}


+ (NSMutableArray *)returnAddressBookArray{

    ABAddressBookRef addressBooks=ABAddressBookCreateWithOptions(NULL, NULL);;
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    NSLog(@"allPeople == %@",allPeople);
    NSMutableArray * addressBoolArray = [[NSMutableArray alloc]init];
    //NSMutableString * addressBookStr = [[NSMutableString alloc]init];
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        WHAddressBookModel *addressBook = [[WHAddressBookModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                
            }
        }
        
        addressBook.name = nameString;
        //addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.mobile = (__bridge NSString*)value;
                        //NSLog(@"%@",addressBook.telephone);
                        break;
                    }
                        
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        if (addressBook.mobile != nil && addressBook.name != nil) {
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            
            [dict setValue:addressBook.mobile forKey:@"mobile"];
            [dict setValue:addressBook.name forKey:@"name"];
            
            [addressBoolArray addObject:dict];
        }
        
        
        
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        //        NSLog(@"姓名：%@  电话：%@",addressBook.name,addressBook.telephone);
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    
    
    return addressBoolArray;
}

@end
