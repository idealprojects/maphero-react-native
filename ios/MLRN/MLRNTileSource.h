//
//  MLRNTileSource.h
//  MLRN
//

#import "MLRNSource.h"
@import MapHero;

@interface MLRNTileSource : MLRNSource

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSArray<NSString *> *tileUrlTemplates;
@property (nonatomic, copy) NSString *attribution;

@property (nonatomic, strong) NSNumber *minZoomLevel;
@property (nonatomic, strong) NSNumber *maxZoomLevel;

@property (nonatomic, assign) BOOL tms;

- (NSDictionary<MHTileSourceOption, id>*)getOptions;

@end
