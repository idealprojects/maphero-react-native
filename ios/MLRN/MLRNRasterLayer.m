#import "MLRNRasterLayer.h"
#import "MLRNStyle.h"

@implementation MLRNRasterLayer

- (MHStyleLayer*)makeLayer:(MHStyle*)style
{
    MHSource *source =  [style sourceWithIdentifier:self.sourceID];
    if (source == nil) { return nil; }
    MHRasterStyleLayer *layer = [[MHRasterStyleLayer alloc] initWithIdentifier:self.id source:source];
    return layer;
}

- (void)addStyles
{
    MLRNStyle *style = [[MLRNStyle alloc] initWithMLNStyle:self.style];
    style.bridge = self.bridge;
    [style rasterLayer:(MHRasterStyleLayer*)self.styleLayer withReactStyle:self.reactStyle isValid:^{ return [self isAddedToMap];
    }];
}

@end
