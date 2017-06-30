

#import "WHUserLoginModel.h"

@implementation WHUserLoginModel

+ (instancetype)createuserInfoModel{
    return [[self alloc]initDealWithDictionary];
    
}

- (id)initDealWithDictionary{
    
    NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoDict];
    
    //如果字典不为空
    if (dict != nil) {
        if (self == [super init]) {
  
            self.token = NULLOBJ([dict objectForKey:@"token"]);
            self.id = NULLOBJ([dict objectForKey:@"id"]);
            self.avatar =NULLOBJ([dict objectForKey:@"avatar"]);
            self.idName = NULLOBJ([dict objectForKey:@"idName"]);
            self.sex = NULLOBJ([dict objectForKey:@"sex"]);
            //self.idName = NULLOBJ([dict objectForKey:@"idname"]);
            self.creditscore = [[dict objectForKey:@"creditscore"] integerValue];
            self.weekdebt = [[dict objectForKey:@"weekDebt"] floatValue];
            self.monthdebt = [[dict objectForKey:@"monthDebt"] floatValue];
            self.debt = [[dict objectForKey:@"debt"] floatValue];
            self.examwait = [[dict objectForKey:@"examwait"] integerValue];
            self.phone = NULLOBJ([dict objectForKey:@"phone"]);
            self.taobaoName = NULLOBJ([dict objectForKey:@"taobaoName"]);
            self.xuexinName = NULLOBJ([dict objectForKey:@"xuexinName"]);
            self.OperatorAuth = NULLOBJ([dict objectForKey:@"OperatorAuth"]);
            self.syCustId = NULLOBJ([dict objectForKey:@"syCustId"]);
            
        }
        return self;
    }
    else{
        return nil;
    }
}

//删除归档文件,删除登录信息
+ (void)deleteUserLogin{
    
    //获取文件操作对象
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    //判断要删除的文件是否存在
    if ([defaultManager isDeletableFileAtPath:UserInfoDict]) {
        //如果存在，删除。
        [defaultManager removeItemAtPath:UserInfoDict error:nil];
    }

}








@end
