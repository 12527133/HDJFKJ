

#import <UIKit/UIKit.h>

@interface WHMessageCell : UITableViewCell
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//消息标题
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
//消息内容
@property (weak, nonatomic) IBOutlet UILabel *messageContent;
//消息时间
@property (weak, nonatomic) IBOutlet UILabel *messageTime;

@property (weak, nonatomic) IBOutlet UIImageView *isreadImageView;
@end
