

#import <UIKit/UIKit.h>
#import "HDBaseButton.h"
@interface WHClassifyContentView : UIView

//1.上半部分

//更多按钮
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
//分类标题label
@property (weak, nonatomic) IBOutlet UILabel *classifyTitleLabel;

//2.左侧广告
//左侧广告视图
@property (weak, nonatomic) IBOutlet UIView *leftAdvertisementView;
//左侧广告名称
@property (weak, nonatomic) IBOutlet UILabel *leftadvertisementTitleLabel;
//左侧广告分期
@property (weak, nonatomic) IBOutlet UILabel *leftadvertisementStagesLabel;
//左侧广告图片
@property (weak, nonatomic) IBOutlet UIImageView *leftadvertisementImageView;



//3.中间广告视图
@property (weak, nonatomic) IBOutlet UIView *middleAdvertisementView;
//中间广告的名称
@property (weak, nonatomic) IBOutlet UILabel *middleadvertisementTitleLabel;
//中间广告分期
@property (weak, nonatomic) IBOutlet UILabel *middleadvertisementStagesLabel;
//中间广告图片
@property (weak, nonatomic) IBOutlet UIImageView *middleadvertisementImageView;


//3.中间广告视图
@property (weak, nonatomic) IBOutlet UIView *rightAdvertisementView;
//中间广告的名称
@property (weak, nonatomic) IBOutlet UILabel *rightadvertisementTitleLabel;
//中间广告分期
@property (weak, nonatomic) IBOutlet UILabel *rightadvertisementStagesLabel;
//中间广告图片
@property (weak, nonatomic) IBOutlet UIImageView *rightadvertisementImageView;

//4.从左到右是哪个广告的按钮

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *middleButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

+ (id)view;

@end
