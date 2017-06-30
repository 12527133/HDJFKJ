

#import "HDWHLoadSubView.h"

@implementation HDWHLoadSubView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HDWHLoadSubView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
