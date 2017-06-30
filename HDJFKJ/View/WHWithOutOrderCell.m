

#import "WHWithOutOrderCell.h"
#import "WHQROrderModel.h"
#import "WHOrderListModel.h"
#import "HDQRCommodity.h"

@interface WHWithOutOrderCell ()
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
//扫码时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
//申请ID
@property (weak, nonatomic) IBOutlet UILabel *applyId;
//申请分期金额
@property (weak, nonatomic) IBOutlet UILabel *fenqijineLabel;

//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;


@end




@implementation WHWithOutOrderCell


- (void)setOrderModel:(WHQROrderModel *)orderModel{

    _orderModel = orderModel;
    if ([orderModel.status isEqualToString:@"0"]) {
        self.orderStatusLabel.text = @"订单未提交";
    }else{
        self.orderStatusLabel.text = @"订单已提交";
    }
    
    if (_orderModel.commoditys.count > 0) {
        HDQRCommodity * commodity = _orderModel.commoditys[0];
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:commodity.pic] placeholderImage:[UIImage imageNamed:@"商品 1:1"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        NSMutableString * commodityName = [[NSMutableString alloc]init];
        for (HDQRCommodity * commodity in _orderModel.commoditys) {
            if (commodityName.length == 0) {
                [commodityName appendString:commodity.commodityName];
            }
            else{
                [commodityName appendString:@","];
                [commodityName appendString:commodity.commodityName];
            }
        }
        
        self.goodsName.text = commodityName;
    }
    
    
    
    self.timeLabel.text = _orderModel.scanDate;
    
    self.applyId.text = orderModel.packageId;
    self.fenqijineLabel.text = @"";
    //[NSString stringWithFormat:@"￥%.2f",[orderModel.totalPrice floatValue]];
    
}
- (void)setOrderListModel:(WHOrderListModel *)orderListModel{

    _orderListModel = orderListModel;
    self.orderStatusLabel.text = orderListModel.status;
    self.timeLabel.text = orderListModel.applyTime;
    self.goodsName.text = orderListModel.commodityname;
    self.applyId.text = orderListModel.id;
    self.fenqijineLabel.text = [NSString stringWithFormat:@"￥%@",orderListModel.applyamount];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
