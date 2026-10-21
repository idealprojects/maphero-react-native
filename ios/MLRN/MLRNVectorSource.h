#import "MLRNTileSource.h"
@import MapHero;

@interface MLRNVectorSource : MLRNTileSource

- (nonnull NSArray<id <MHFeature>> *)featuresInSourceLayersWithIdentifiers:(nonnull NSSet<NSString *> *)sourceLayerIdentifiers predicate:(nullable NSPredicate *)predicate;

@end
