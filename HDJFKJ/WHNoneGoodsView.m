

#import "WHNoneGoodsView.h"

@implementation WHNoneGoodsView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHNoneGoodsView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
@end
