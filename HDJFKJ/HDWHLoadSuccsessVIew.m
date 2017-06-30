

#import "HDWHLoadSuccsessVIew.h"

@implementation HDWHLoadSuccsessVIew

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HDWHLoadSuccsessVIew" owner:nil options:nil] lastObject];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
