

#import <UIKit/UIKit.h>

@interface WHPersonProcessTopView : UIView

+ (id)view;
- (void)initImageNameWithIconImageNameArr:(NSArray *)iconImageNameArr arrowImageNameArr:(NSArray *)arrowImageNameArr;
@property (nonatomic, strong) NSArray * iconImageArr;
@property (nonatomic, strong) NSArray * arrowImageArr;
@end
