#import "MLRNFillExtrusionLayer.h"
#import "MLRNStyle.h"
#import <React/RCTLog.h>

@implementation MLRNFillExtrusionLayer

- (MHFillExtrusionStyleLayer*)makeLayer:(MHStyle*)style
{
    MHSource *source = [self layerWithSourceIDInStyle:style];
    if (source == nil) { return nil; }
    MHFillExtrusionStyleLayer *layer = [[MHFillExtrusionStyleLayer alloc] initWithIdentifier:self.id source:source];
    layer.sourceLayerIdentifier = self.sourceLayerID;
    return layer;
}

- (void)addStyles
{
    MLRNStyle *style = [[MLRNStyle alloc] initWithMLNStyle:self.style];
    style.bridge = self.bridge;
    [style fillExtrusionLayer:(MHFillExtrusionStyleLayer*)self.styleLayer withReactStyle:self.reactStyle isValid:^{ return [self isAddedToMap];
    }];
}

@end
