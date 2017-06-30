

#import "HDOrderListCell.h"



@implementation HDOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commodityNameLabel.font = [UIFont systemFontOfSize:13*bili];
    
    self.statusLabel.font = [UIFont systemFontOfSize:13*bili];
    
    self.priceLabel.font = [UIFont systemFontOfSize:15*bili];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(LDNewOrderListModel *)listModel{

    _listModel = listModel;
    
//    self.dayTimeLabel.text = _listModel.orderDate;
//    
//    self.hhssTimeLabel.text = _listModel.orderTime;
//    
//    self.cusNameLabel.text = _listModel.custName;
    
    
    /** 期供金额和期数 */
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2fx%@期",[listModel.periodAmount floatValue], listModel.duration];
    
    /** 订单状态 */
    self.statusLabel.text = _listModel.status;
    
    if ([_listModel.status isEqualToString:@"审核中"] || [_listModel.status isEqualToString:@"还款中"]) {
        self.statusLabel.textColor = WHColorFromRGB(0x4279d6);
    }
    else if ([_listModel.status isEqualToString:@"已打回"]){
    
        self.statusLabel.textColor = WHColorFromRGB(0xe84c3d);
    }
    else if ([_listModel.status isEqualToString:@"已通过"] || [_listModel.status isEqualToString:@"已完成"]){
    
        self.statusLabel.textColor = WHColorFromRGB(0x323232);
    }
    else{
        self.statusLabel.textColor = WHColorFromRGB(0xb8b8b8);
    }
    
    /**
     * 订单内容
     * 1、租房订单显示的是租房地址
     * 2、商品包显示的是商品名称拼接
     */
    if (_listModel.orderCommoditys.count > 0) {
        HDNewOrderGoods * commodity = _listModel.orderCommoditys[0];
        
        if (commodity.commodityAddress != nil) {
            self.commodityNameLabel.text = commodity.commodityAddress;
        }
        else
        {
            
            NSMutableString * string = [[NSMutableString alloc]initWithString:@""];
            for (HDNewOrderGoods * comm in _listModel.orderCommoditys) {
              
                if (string.length == 0) {
                    [string appendString:comm.commodityName];
                }
                else{
                
                    [string appendString:@","];
                    [string appendString:comm.commodityName];
                }
                
            }
            
            self.commodityNameLabel.text = string;
        
            
            
            
            /** 计算label 的大小*/
            CGSize size = [self.commodityNameLabel sizeThatFits:CGSizeMake(self.commodityNameLabel.frame.size.width, MAXFLOAT)];
            
            if (size.height > 60 *bili) {
                size.height = 60*bili;
            }
            self.commodityNameLabel.frame =CGRectMake(self.commodityNameLabel.frame.origin.x, self.commodityNameLabel.frame.origin.y, self.commodityNameLabel.frame.size.width, size.height);
            
            
        }
        
        
        
        
        
    }
}





@end
