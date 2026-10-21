#import "MLRNShapeSource.h"
#import "MLRNUtils.h"
#import "MLRNMapView.h"

@implementation MLRNShapeSource

static UIImage * _placeHolderImage;

- (void)setUrl: (NSString*) url
{
    _url = url;
    if (self.source != nil) {
        MHShapeSource *source = (MHShapeSource *)self.source;
        [source setURL: url == nil ? nil : [NSURL URLWithString:url]];
    }
}

- (void)setShape:(NSString *)shape
{
    _shape = shape;

    if (self.source != nil) {
        MHShapeSource *source = (MHShapeSource *)self.source;
        [source setShape: shape == nil ? nil : [MLRNUtils shapeFromGeoJSON:_shape]];
    }
}

- (void)addToMap
{
    if (self.map.style == nil) {
        return;
    }
    [super addToMap];
}

- (void)removeFromMap
{
    if (self.map.style == nil) {
        return;
    }

    [super removeFromMap];
}

- (nullable MHSource*)makeSource
{
    NSDictionary<MHShapeSourceOption, id> *options = [self _getOptions];

    if (_shape != nil) {
        MHShape *shape = [MLRNUtils shapeFromGeoJSON:_shape];
        return [[MHShapeSource alloc] initWithIdentifier:self.id shape:shape options:options];
    }

    if (_url != nil) {
        NSURL *url = [[NSURL alloc] initWithString:_url];
        return [[MHShapeSource alloc] initWithIdentifier:self.id URL:url options:options];
    }
    return nil;
}

- (NSDictionary<MHShapeSourceOption, id>*)_getOptions
{
    NSMutableDictionary<MHShapeSourceOption, id> *options = [[NSMutableDictionary alloc] init];

    if (_cluster != nil) {
        options[MHShapeSourceOptionClustered] = [NSNumber numberWithBool:[_cluster intValue] == 1];
    }

    if (_clusterRadius != nil) {
        options[MHShapeSourceOptionClusterRadius] = _clusterRadius;
    }

    if (_clusterMaxZoomLevel != nil) {
        options[MHShapeSourceOptionMaximumZoomLevelForClustering] = _clusterMaxZoomLevel;
    }

    if (_clusterProperties != nil) {
       NSMutableDictionary<NSString *, NSArray *> *properties = [NSMutableDictionary new];

        for (NSString *propertyName in _clusterProperties.allKeys) {
            NSArray<NSExpression *> *expressions = [_clusterProperties objectForKey: propertyName];
            NSExpression *firstExpression = [NSExpression expressionWithMHJSONObject:[expressions objectAtIndex: 0]];
            NSExpression *secondExpression = [NSExpression expressionWithMHJSONObject:[expressions objectAtIndex: 1]];

            [properties setObject:@[firstExpression, secondExpression] forKey:propertyName];
        }

        options[MHShapeSourceOptionClusterProperties] = properties;
    }
    
    if (_maxZoomLevel != nil) {
        options[MHShapeSourceOptionMaximumZoomLevel] = _maxZoomLevel;
    }

    if (_buffer != nil) {
        options[MHShapeSourceOptionBuffer] = _buffer;
    }

    if (_tolerance != nil) {
        options[MHShapeSourceOptionSimplificationTolerance] = _tolerance;
    }

    if (_lineMetrics != nil) {
        options[MHShapeSourceOptionLineDistanceMetrics] = _lineMetrics;
    }

    return options;
}

- (nonnull NSArray<id <MHFeature>> *)featuresMatchingPredicate:(nullable NSPredicate *)predicate
{
    MHShapeSource *shapeSource = (MHShapeSource *)self.source;

    return [shapeSource featuresMatchingPredicate:predicate];
}

- (double)getClusterExpansionZoom:(nonnull NSString *)featureJSON
{
    MHShapeSource *shapeSource = (MHShapeSource *)self.source;

    MHPointFeature *feature = (MHPointFeature*)[MLRNUtils shapeFromGeoJSON:featureJSON];
 
    return [shapeSource zoomLevelForExpandingCluster:(MHPointFeatureCluster *)feature];
}

- (nonnull NSArray<id <MHFeature>> *)getClusterLeaves:(nonnull NSString *)featureJSON
    number:(NSUInteger)number
    offset:(NSUInteger)offset
{
    MHShapeSource *shapeSource = (MHShapeSource *)self.source;

    MHPointFeature *feature = (MHPointFeature*)[MLRNUtils shapeFromGeoJSON:featureJSON];

    MHPointFeatureCluster * cluster = (MHPointFeatureCluster *)feature;
    return [shapeSource leavesOfCluster:cluster offset:offset limit:number];
}

- (nonnull NSArray<id <MHFeature>> *)getClusterChildren:(nonnull NSString *)featureJSON
{
    MHShapeSource *shapeSource = (MHShapeSource *)self.source;
    
    MHPointFeature *feature = (MHPointFeature*)[MLRNUtils shapeFromGeoJSON:featureJSON];
    
    MHPointFeatureCluster * cluster = (MHPointFeatureCluster *)feature;
    return [shapeSource childrenOfCluster:cluster];
}


// Deprecated. Will be removed in 9+ ver.
- (double)getClusterExpansionZoomById:(nonnull NSNumber *)clusterId
{
    MHShapeSource *shapeSource = (MHShapeSource *)self.source;
    NSArray<id<MHFeature>> *features = [shapeSource featuresMatchingPredicate: [NSPredicate predicateWithFormat:@"%K = %i", @"cluster_id", clusterId.intValue]];
    if (features.count == 0) {
        return -1;
    }
    return [shapeSource zoomLevelForExpandingCluster:(MHPointFeatureCluster *)features[0]];
}

// Deprecated. Will be removed in 9+ ver.
- (nonnull NSArray<id <MHFeature>> *)getClusterLeavesById:(nonnull NSNumber *)clusterId
    number:(NSUInteger)number
    offset:(NSUInteger)offset
{
    MHShapeSource *shapeSource = (MHShapeSource *)self.source;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"cluster_id == %@", clusterId];
    NSArray<id<MHFeature>> *features = [shapeSource featuresMatchingPredicate:predicate];
    
    MHPointFeatureCluster * cluster = (MHPointFeatureCluster *)features[0];
    return [shapeSource leavesOfCluster:cluster offset:offset limit:number];
}

// Deprecated. Will be removed in 9+ ver.
- (nonnull NSArray<id <MHFeature>> *)getClusterChildrenById:(nonnull NSNumber *)clusterId
{
    MHShapeSource *shapeSource = (MHShapeSource *)self.source;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"cluster_id == %@", clusterId];
    NSArray<id<MHFeature>> *features = [shapeSource featuresMatchingPredicate:predicate];
    
    MHPointFeatureCluster * cluster = (MHPointFeatureCluster *)features[0];
    return [shapeSource childrenOfCluster:cluster];
}

@end
