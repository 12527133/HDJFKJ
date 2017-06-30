

#import "WHPersonProcessTopView.h"
@interface WHPersonProcessTopView()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView3;


@end
@implementation WHPersonProcessTopView


+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHPersonProcessTopView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)initImageNameWithIconImageNameArr:(NSArray *)iconImageNameArr arrowImageNameArr:(NSArray *)arrowImageNameArr{
    for (int i = 0; i < iconImageNameArr.count; i ++) {
        switch (i) {
            case 0:
                self.iconImageView1.image = [UIImage imageNamed:iconImageNameArr[i]];
                break;
            case 1:
                self.iconImageView2.image = [UIImage imageNamed:iconImageNameArr[i]];
                break;
            case 2:
                self.iconImageView3.image = [UIImage imageNamed:iconImageNameArr[i]];
                break;
            case 3:
                self.iconImageView4.image = [UIImage imageNamed:iconImageNameArr[i]];
                break;
        }
    }
    
    for (int i = 0; i < arrowImageNameArr.count; i ++) {
        switch (i) {
            case 0:
                self.arrowImageView1.image = [UIImage imageNamed:arrowImageNameArr[i]];
                break;
            case 1:
                self.arrowImageView2.image = [UIImage imageNamed:arrowImageNameArr[i]];
                break;
            case 2:
                self.arrowImageView3.image = [UIImage imageNamed:arrowImageNameArr[i]];
                break;
        }
    }
}
@end
