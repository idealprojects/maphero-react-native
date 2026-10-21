//
//  BaseSource.m
//  MLRN
//

#import "MLRNTileSource.h"

@implementation MLRNTileSource

- (NSDictionary<MHTileSourceOption, id>*)getOptions {
    NSMutableDictionary<MHTileSourceOption, id> *options = [[NSMutableDictionary alloc] init];
    
    if (self.maxZoomLevel != nil) {
        options[MHTileSourceOptionMaximumZoomLevel] = self.maxZoomLevel;
    }
    
    if (self.minZoomLevel != nil) {
        options[MHTileSourceOptionMinimumZoomLevel] = self.minZoomLevel;
    }
    
    if (self.tms) {
        options[MHTileSourceOptionTileCoordinateSystem] = [NSNumber numberWithUnsignedInteger:MHTileCoordinateSystemTMS];
    }
    
    if (self.attribution != nil) {
        options[MHTileSourceOptionAttributionHTMLString] = self.attribution;
    }
    
    return options;
}
@end
