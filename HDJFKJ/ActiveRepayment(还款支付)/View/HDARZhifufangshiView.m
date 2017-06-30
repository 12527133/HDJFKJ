

#import "HDARZhifufangshiView.h"

@implementation HDARZhifufangshiView

- (void)dealloc{
    LDLog(@"销毁支付方式视图 ");
}

/** 创建子视图 */
- (void)createSubViews{
    
    self.backgroundColor = [UIColor clearColor];
    
    /** 创建标题 */
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 17*bili, 100*bili, 18*bili)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = WHColorFromRGB(0x9fa8b7);
    self.titleLabel.text = @"选择支付方式";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.titleLabel];
    
    
    /** 创建支付方式视图 */
    for (int i = 0; i < self.zhifuArray.count; i++) {
        
        /** 创建支付方式视图  */
        HDARZhifuSubView * zhifuSubView = [[HDARZhifuSubView alloc]initWithFrame:CGRectMake(0, 45*bili + i*50*bili, self.frame.size.width, 50*bili)];
        
        /** 创建支付方式子视图 */
        [zhifuSubView createSubViews];
        
        /** 添加子视图 */
        [self addSubview:zhifuSubView];
        
        /** 如果不是第一个子视图创建横线 */
        if (i != 0) {
            
            zhifuSubView.selectIcon.hidden = YES;
            
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, zhifuSubView.frame.size.width, 0.5)];
            lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
            [zhifuSubView addSubview:lineLabel];
        }
        else{
        
            self.currentZhifu = zhifuSubView;
            self.currentZhifu.selectIcon.hidden = NO;
            
        }
    }
    
    
    /** 测试 ---- 用 ---- 创建支付方式视图  */
    HDARZhifuSubView * zhifuSubView = [[HDARZhifuSubView alloc]initWithFrame:CGRectMake(0, 45*bili, self.frame.size.width, 50*bili)];
    
    /** 创建支付方式子视图 */
    [zhifuSubView createSubViews];
    
    /** 添加子视图 */
    [self addSubview:zhifuSubView];
}



























@end
