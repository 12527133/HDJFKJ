

#import "WHBaseInfoView.h"

@implementation WHBaseInfoView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WHBaseInfoView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
