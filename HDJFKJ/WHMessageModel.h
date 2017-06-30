

#import <Foundation/Foundation.h>
/**
 * x消息界面的消息模型
 */

@interface WHMessageModel : NSObject

//消息id
@property (nonatomic, assign) NSInteger mid;

//消息图片
@property (nonatomic, strong) NSString * icon;

//消息阅读状态
@property (nonatomic, assign) NSInteger isread;

//与客户关联的id
@property (nonatomic, assign) NSInteger cumid;

//消息标题
@property (nonatomic, strong) NSString * title;

//消息发布时间
@property (nonatomic, strong) NSString * publishtime;

//消息内容
@property (nonatomic, strong) NSString * content;



+ (instancetype)paresMessageWithDictionary:(NSDictionary *)dict;



























@end
