#import "MLRNFillLayer.h"
#import "MLRNStyle.h"
#import <React/RCTLog.h>

@implementation MLRNFillLayer

- (MHStyleLayer*)makeLayer:(MHStyle*)style
{
    MHSource *source = [self layerWithSourceIDInStyle:style];
    if (source == nil) { return nil; }
    MHFillStyleLayer *layer = [[MHFillStyleLayer alloc] initWithIdentifier:self.id source:source];
    layer.sourceLayerIdentifier = self.sourceLayerID;
    return layer;
}

- (void)addStyles
{
    MLRNStyle *style = [[MLRNStyle alloc] initWithMLNStyle:self.style];
    style.bridge = self.bridge;
    [style fillLayer:(MHFillStyleLayer*)self.styleLayer withReactStyle:self.reactStyle isValid:^{
        return [self isAddedToMap];
    }];
}

@end
