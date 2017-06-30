

#import "WHSearchTopView.h"

@implementation WHSearchTopView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
