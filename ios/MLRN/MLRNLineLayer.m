#import "MLRNLineLayer.h"
#import "MLRNStyle.h"
#import <React/RCTLog.h>

@implementation MLRNLineLayer

- (MHLineStyleLayer*)makeLayer:(MHStyle*)style
{
    MHSource *source = [self layerWithSourceIDInStyle:style];
    if (source == nil) { return nil; }
    MHLineStyleLayer *layer = [[MHLineStyleLayer alloc] initWithIdentifier:self.id source:source];
    layer.sourceLayerIdentifier = self.sourceLayerID;
    return layer;
}

- (void)addStyles
{
    MLRNStyle *style = [[MLRNStyle alloc] initWithMLNStyle:self.style];
    style.bridge = self.bridge;
    [style lineLayer:(MHLineStyleLayer *)self.styleLayer withReactStyle:self.reactStyle isValid:^{
        return [self isAddedToMap];
    }];
}

@end
