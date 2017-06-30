

#import <UIKit/UIKit.h>

@interface WHSearchGoodCell : UITableViewCell
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
//商户名称
@property (weak, nonatomic) IBOutlet UILabel *businessnameLabel;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//购买人数
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

//分期详情
@property (weak, nonatomic) IBOutlet UILabel *fenqiDetailLabel;
//星级1
@property (weak, nonatomic) IBOutlet UIImageView *stariImageView;
//星级2
@property (weak, nonatomic) IBOutlet UIImageView *starImageView2;
//星级3
@property (weak, nonatomic) IBOutlet UIImageView *starImageView3;
//星级4
@property (weak, nonatomic) IBOutlet UIImageView *starImageView4;
//星级5
@property (weak, nonatomic) IBOutlet UIImageView *staImageView5;

















@end
