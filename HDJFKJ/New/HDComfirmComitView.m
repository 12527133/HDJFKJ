

#import "HDComfirmComitView.h"

@implementation HDComfirmComitView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HDComfirmComitView" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
