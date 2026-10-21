#import "MLRNRasterSource.h"

@implementation MLRNRasterSource

- (nullable MHSource*)makeSource
{
    if (self.url != nil) {
        NSURL *url = [NSURL URLWithString:self.url];
        if (self.tileSize != nil) {
            return [[MHRasterTileSource alloc] initWithIdentifier:self.id configurationURL:url tileSize:[self.tileSize floatValue]];
        }
        return [[MHRasterTileSource alloc] initWithIdentifier:self.id configurationURL:url];
    }
    return [[MHRasterTileSource alloc] initWithIdentifier:self.id tileURLTemplates:self.tileUrlTemplates options:[self getOptions]];
}

- (NSDictionary<MHTileSourceOption,id> *)getOptions {
    NSMutableDictionary<MHTileSourceOption, id> *options = [[NSMutableDictionary alloc] initWithDictionary:[super getOptions]];
    
    if (self.tileSize != nil) {
        options[MHTileSourceOptionTileSize] = _tileSize;
    }
    
    return options;
}

@end
