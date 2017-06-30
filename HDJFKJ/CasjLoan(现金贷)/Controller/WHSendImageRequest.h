

#import <Foundation/Foundation.h>

@interface WHSendImageRequest : NSObject

+(void)SendImageRequestURL:(NSString *)str dict:(NSDictionary *)params data:(NSData *)imageData name:(NSString *)imageName;

@end
