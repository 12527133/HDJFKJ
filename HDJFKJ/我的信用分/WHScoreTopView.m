

#import "WHScoreTopView.h"

@implementation WHScoreTopView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHScoreTopView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
