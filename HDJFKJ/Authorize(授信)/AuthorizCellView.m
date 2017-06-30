

#import "AuthorizCellView.h"

@implementation AuthorizCellView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"AuthorizCellView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
@end
