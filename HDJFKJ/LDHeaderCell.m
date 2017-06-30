//
//  LDHeaderCell.m
//  HDJFKJ
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDHeaderCell.h"
#import "LDBusinessDetailHeaderModel.h"
#import "SDCycleScrollView.h"

@interface LDHeaderCell ()<SDCycleScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@end

@implementation LDHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHeaderModel:(LDBusinessDetailHeaderModel *)headerModel{
    
    
    if (_headerModel != headerModel) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headerModel = headerModel;
      
        SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.headerImage.size.width, self.headerImage.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"商品 1:1"]];
        
        
        cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"椭圆-11"];
        cycleScrollView3.pageDotImage = [UIImage imageNamed:@"椭圆-11-拷贝"];
        cycleScrollView3.imageURLStringsGroup = self.headerModel.piclist;
        cycleScrollView3.backgroundColor = [UIColor whiteColor];
        cycleScrollView3.autoScroll = YES;
        [self.headerImage addSubview:cycleScrollView3];

        
    }

}



@end
