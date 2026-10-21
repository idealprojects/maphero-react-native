#import "MLRNBackgroundLayer.h"
#import "MLRNStyle.h"

@implementation MLRNBackgroundLayer

- (MHStyleLayer*)makeLayer:(MHStyle*)style
{
    return [[MHBackgroundStyleLayer alloc] initWithIdentifier:self.id];
}

- (void)addStyles
{
    MLRNStyle *style = [[MLRNStyle alloc] initWithMLNStyle:self.style];
    style.bridge = self.bridge;
    [style backgroundLayer:(MHBackgroundStyleLayer*)self.styleLayer withReactStyle:self.reactStyle isValid:^{ return [self isAddedToMap];
    }];
}

@end
