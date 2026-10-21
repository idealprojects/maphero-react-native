#import "MLRNHeatmapLayer.h"
#import "MLRNStyle.h"

@implementation MLRNHeatmapLayer

- (MHHeatmapStyleLayer*)makeLayer:(MHStyle*)style
{
    MHSource *source = [self layerWithSourceIDInStyle:style];
    if (source == nil) { return nil; }
    MHHeatmapStyleLayer *layer = [[MHHeatmapStyleLayer alloc] initWithIdentifier:self.id source:source];
    layer.sourceLayerIdentifier = self.sourceLayerID;
    return layer;
}

- (void)addStyles
{
    MLRNStyle *style = [[MLRNStyle alloc] initWithMLNStyle:self.style];
    style.bridge = self.bridge;
    [style heatmapLayer:(MHHeatmapStyleLayer *)self.styleLayer withReactStyle:self.reactStyle isValid:^{
        return [self isAddedToMap];
    }];
}

@end
