#import "MLRNOfflineModule.h"
#import "MLRNUtils.h"
#import "MLRNEvent.h"
#import "MLRNEventTypes.h"

@implementation MLRNOfflineModule
{
    NSUInteger lastPackState;
    double lastPackTimestamp;
    double eventThrottle;
    BOOL hasListeners;
    NSMutableArray<RCTPromiseResolveBlock> *packRequestQueue;
}

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (void)startObserving
{
    [super startObserving];
    hasListeners = YES;
}

- (void)stopObserving
{
    [super stopObserving];
    hasListeners = NO;
}

NSString *const RCT_MAPBOX_OFFLINE_CALLBACK_PROGRESS = @"MapboxOfflineRegionProgress";
NSString *const RCT_MAPBOX_OFFLINE_CALLBACK_ERROR = @"MapboOfflineRegionError";

- (instancetype)init
{
    if (self = [super init]) {
        packRequestQueue = [NSMutableArray new];
        eventThrottle = 300;
        lastPackState = -1;

        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(offlinePackProgressDidChange:) name:MHOfflinePackProgressChangedNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(offlinePackDidReceiveError:) name:MHOfflinePackErrorNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(offlinePackDidReceiveMaxAllowedMapboxTiles:) name:MHOfflinePackMaximumMapboxTilesReachedNotification object:nil];

        [[MHOfflineStorage sharedOfflineStorage] addObserver:self forKeyPath:@"packs" options:NSKeyValueObservingOptionInitial context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [[MHOfflineStorage sharedOfflineStorage] removeObserver:self forKeyPath:@"packs"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[RCT_MAPBOX_OFFLINE_CALLBACK_PROGRESS, RCT_MAPBOX_OFFLINE_CALLBACK_ERROR];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"] && [object isKindOfClass:[MHOfflinePack class]]) {
        MHOfflinePack* pack = (MHOfflinePack*)object;
        [self observerStateForPack:pack context:context];
        return;
    }

    if (packRequestQueue.count == 0) {
        return;
    }

    NSArray<MHOfflinePack *> *packs = [[MHOfflineStorage sharedOfflineStorage] packs];
    if (packs == nil) {
        return;
    }

    while (packRequestQueue.count > 0) {
        RCTPromiseResolveBlock resolve = [packRequestQueue objectAtIndex:0];
        resolve([self _convertPacksToJson:packs]);
        [packRequestQueue removeObjectAtIndex:0];
    }
}

RCT_EXPORT_METHOD(createPack:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *styleURL = options[@"styleURL"];
    MHCoordinateBounds bounds = [MLRNUtils fromFeatureCollection:options[@"bounds"]];

    id<MHOfflineRegion> offlineRegion = [[MHTilePyramidOfflineRegion alloc] initWithStyleURL:[NSURL URLWithString:styleURL]
                                                                              bounds:bounds
                                                                              fromZoomLevel:[options[@"minZoom"] doubleValue]
                                                                              toZoomLevel:[options[@"maxZoom"] doubleValue]];
    NSData *context = [self _archiveMetadata:options[@"metadata"]];

    [[MHOfflineStorage sharedOfflineStorage] addPackForRegion:offlineRegion
                                              withContext:context
                                              completionHandler:^(MHOfflinePack *pack, NSError *error) {
                                                 if (error != nil) {
                                                     reject(@"createPack", error.description, error);
                                                     return;
                                                 }
                                                 resolve([self _convertPackToDict:pack]);
                                                 [pack resume];
                                              }];
}

RCT_EXPORT_METHOD(mergeOfflineRegions:(NSString *)path
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *absolutePath;
    if ([path isAbsolutePath]) {
        absolutePath = path;
    } else {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *fileName = [path stringByDeletingPathExtension];
        NSString *extension = [path pathExtension];
        absolutePath = [mainBundle pathForResource:fileName ofType:extension];
        if (!absolutePath) {
            return reject(@"asset_does_not_exist", [NSString stringWithFormat:@"The given assetName, %@, can't be found in the app's bundle.", path], nil);
        }
    }

    [[MHOfflineStorage sharedOfflineStorage] addContentsOfFile:absolutePath withCompletionHandler:^(NSURL *fileURL, NSArray<MHOfflinePack *> *packs, NSError *error) {
        if (error != nil) {
            reject(@"mergeOfflineRegions", error.description, error);
            return;
        }
        resolve(nil);
    }];
}

RCT_EXPORT_METHOD(getPacks:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray<MHOfflinePack *> *packs = [[MHOfflineStorage sharedOfflineStorage] packs];

        if (packs == nil) {
            // packs have not loaded yet
            [self->packRequestQueue addObject:resolve];
            return;
        }

        resolve([self _convertPacksToJson:packs]);
    });
}

RCT_EXPORT_METHOD(invalidateAmbientCache:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[MHOfflineStorage sharedOfflineStorage] invalidateAmbientCacheWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            reject(@"invalidateAmbientCache", error.description, error);
            return;
        }
        resolve(nil);
    }];
}

RCT_EXPORT_METHOD(clearAmbientCache:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[MHOfflineStorage sharedOfflineStorage] clearAmbientCacheWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            reject(@"clearAmbientCache", error.description, error);
            return;
        }
        resolve(nil);
    }];
}

RCT_EXPORT_METHOD(setMaximumAmbientCacheSize:(NSUInteger)cacheSize
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[MHOfflineStorage sharedOfflineStorage] setMaximumAmbientCacheSize:cacheSize withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            reject(@"setMaximumAmbientCacheSize", error.description, error);
            return;
        }
        resolve(nil);
    }];

}

RCT_EXPORT_METHOD(resetDatabase:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[MHOfflineStorage sharedOfflineStorage] resetDatabaseWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            reject(@"resetDatabase", error.description, error);
            return;
        }
        resolve(nil);
    }];

}

RCT_EXPORT_METHOD(getPackStatus:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    MHOfflinePack *pack = [self _getPackFromName:name];

    if (pack == nil) {
        resolve(nil);
        NSLog(@"getPackStatus - Unknown offline region");
        return;
    }

    if (pack.state == MHOfflinePackStateUnknown) {
        [pack addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:(__bridge_retained void*)resolve];
        [pack requestProgress];
    } else {
        resolve([self _makeRegionStatusPayload:name pack:pack]);
    }
}

-(void)observerStateForPack:(MHOfflinePack*)pack context:(nullable void*) context {
    RCTPromiseResolveBlock resolve = (__bridge_transfer RCTPromiseResolveBlock)context;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* metadata = [self _unarchiveMetadata:pack];
        NSString* name = metadata[@"name"];
        resolve([self _makeRegionStatusPayload:name pack:pack]);
    });
    [pack removeObserver:self forKeyPath:@"state" context:context];
}

RCT_EXPORT_METHOD(invalidatePack:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    MHOfflinePack *pack = [self _getPackFromName:name];

    if (pack == nil) {
        resolve(nil);
        return;
    }
    [[MHOfflineStorage sharedOfflineStorage] invalidatePack:pack  withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            reject(@"invalidatePack", error.description, error);
            return;
        }
        resolve(nil);
    }];
}

RCT_EXPORT_METHOD(deletePack:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    MHOfflinePack *pack = [self _getPackFromName:name];

    if (pack == nil) {
        resolve(nil);
        return;
    }
    if (pack.state == MHOfflinePackStateInvalid) {
        NSError *error = [NSError errorWithDomain:MHErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Pack has already been deleted", nil)}];
        reject(@"deletePack", error.description, error);
        return;
    }
    [[MHOfflineStorage sharedOfflineStorage] removePack:pack withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            reject(@"deletePack", error.description, error);
            return;
        }
        resolve(nil);
    }];
}

RCT_EXPORT_METHOD(pausePackDownload:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    MHOfflinePack *pack = [self _getPackFromName:name];

    if (pack == nil) {
        reject(@"pausePackDownload", @"Unknown offline region", nil);
        return;
    }

    if (pack.state == MHOfflinePackStateInactive || pack.state == MHOfflinePackStateComplete) {
        resolve(nil);
        return;
    }

    [pack suspend];
    resolve(nil);
}

RCT_EXPORT_METHOD(resumePackDownload:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    MHOfflinePack *pack = [self _getPackFromName:name];

    if (pack == nil) {
        reject(@"resumePack", @"Unknown offline region", nil);
        return;
    }

    if (pack.state == MHOfflinePackStateActive || pack.state == MHOfflinePackStateComplete) {
        resolve(nil);
        return;
    }

    [pack resume];
    resolve(nil);
}

RCT_EXPORT_METHOD(setTileCountLimit:(nonnull NSNumber *)limit)
{
    [[MHOfflineStorage sharedOfflineStorage] setMaximumAllowedMapboxTiles:[limit intValue]];
}

RCT_EXPORT_METHOD(setProgressEventThrottle:(nonnull NSNumber *)throttleValue)
{
    eventThrottle = [throttleValue doubleValue];
}

- (void)offlinePackProgressDidChange:(NSNotification *)notification
{
    MHOfflinePack *pack = notification.object;

    if (pack.state == MHOfflinePackStateInvalid) {
        return; // Avoid invalid offline pack exception
    }

    if ([self _shouldSendProgressEvent:[self _getCurrentTimestamp] pack:pack]) {
        NSDictionary *metadata = [self _unarchiveMetadata:pack];
        MLRNEvent *event = [self _makeProgressEvent:metadata[@"name"] pack:pack];
        [self _sendEvent:RCT_MAPBOX_OFFLINE_CALLBACK_PROGRESS event:event];
        lastPackTimestamp = [self _getCurrentTimestamp];
    }

    lastPackState = pack.state;
}

- (void)offlinePackDidReceiveError:(NSNotification *)notification
{
    MHOfflinePack *pack = notification.object;
    if (pack.state == MHOfflinePackStateInvalid) {
        return; // Avoid invalid offline pack exception
    }
    NSDictionary *metadata = [self _unarchiveMetadata:pack];

    NSString *name = metadata[@"name"];
    if (name != nil) {
        NSError *error = notification.userInfo[MHOfflinePackUserInfoKeyError];
        MLRNEvent *event = [self _makeErrorEvent:name
                                   type:RCT_MAPBOX_OFFLINE_ERROR
                                   message:error.description];
        [self _sendEvent:RCT_MAPBOX_OFFLINE_CALLBACK_ERROR event:event];
    }
}

- (void)offlinePackDidReceiveMaxAllowedMapboxTiles:(NSNotification *)notification
{
    MHOfflinePack *pack = notification.object;
    NSDictionary *metadata = [self _unarchiveMetadata:pack];

    NSString *name = metadata[@"name"];
    if (name != nil) {
        MLRNEvent *event = [self _makeErrorEvent:name
                                   type:RCT_MAPBOX_OFFLINE_ERROR
                                   message:@"Mapbox tile limit exceeded"];
        [self _sendEvent:RCT_MAPBOX_OFFLINE_CALLBACK_ERROR event:event];
    }
}

- (double)_getCurrentTimestamp
{
    return CACurrentMediaTime() * 1000;
}

- (NSData *)_archiveMetadata:(NSString *)metadata
{
    return [NSKeyedArchiver archivedDataWithRootObject:metadata];
}

- (NSDictionary *)_unarchiveMetadata:(MHOfflinePack *)pack
{
    id data = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
    // Version v5 store data as NSDictionary while v6 store data as JSON string.
    // User might save offline pack in v5 and then try to read in v6.
    // In v5 are metadata stored nested which need to be handled in JS.
    // Example of how data are stored in v5
    // {
    //      name: "New York",
    //      metadata: {
    //          customMeta: "...",
    //      }
    // }
    if ([data isKindOfClass:[NSDictionary class]]) {
        return data;
    }

    if (data == nil) {
        return @{};
    }

    return [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                options:NSJSONReadingMutableContainers
                                error:nil];
}

- (NSDictionary *)_makeRegionStatusPayload:(NSString *)name pack:(MHOfflinePack *)pack
{
    uint64_t completedResources = pack.progress.countOfResourcesCompleted;
    uint64_t expectedResources = pack.progress.countOfResourcesExpected;
    float progressPercentage = (float)completedResources / expectedResources;

    // prevent NaN errors when expectedResources is 0
    if(expectedResources == 0) {
        progressPercentage = 0;
    }

    return @{
      @"state": @(pack.state),
      @"name": name,
      @"percentage": @(ceilf(progressPercentage * 100.0)),
      @"completedResourceCount": @(pack.progress.countOfResourcesCompleted),
      @"completedResourceSize": @(pack.progress.countOfBytesCompleted),
      @"completedTileSize": @(pack.progress.countOfTileBytesCompleted),
      @"completedTileCount": @(pack.progress.countOfTilesCompleted),
      @"requiredResourceCount": @(pack.progress.maximumResourcesExpected)
    };
}

- (MLRNEvent *)_makeProgressEvent:(NSString *)name pack:(MHOfflinePack *)pack
{
    return [MLRNEvent makeEvent:RCT_MAPBOX_OFFLINE_PROGRESS withPayload:[self _makeRegionStatusPayload:name pack:pack]];
}

- (MLRNEvent *)_makeErrorEvent:(NSString *)name type:(NSString *)type message:(NSString *)message
{
    NSDictionary *payload = @{ @"name": name, @"message": message };
    return [MLRNEvent makeEvent:type withPayload:payload];
}

- (NSArray<NSDictionary *> *)_convertPacksToJson:(NSArray<MHOfflinePack *> *)packs
{
    NSMutableArray<NSDictionary *> *jsonPacks = [NSMutableArray new];

    if (packs == nil) {
        return jsonPacks;
    }

    for (MHOfflinePack *pack in packs) {
        [jsonPacks addObject:[self _convertPackToDict:pack]];
    }

    return jsonPacks;
}

- (NSDictionary *)_convertPackToDict:(MHOfflinePack *)pack
{
    // format bounds
    MHTilePyramidOfflineRegion *region = (MHTilePyramidOfflineRegion *)pack.region;
    if (region == nil) {
        return nil;
    }

    NSArray *jsonBounds = @[
      @[@(region.bounds.ne.longitude), @(region.bounds.ne.latitude)],
      @[@(region.bounds.sw.longitude), @(region.bounds.sw.latitude)]
    ];

    // format metadata
    NSDictionary *metadata = [self _unarchiveMetadata:pack];
    NSData *jsonMetadata = [NSJSONSerialization dataWithJSONObject:metadata
                                            options:0
                                            error:nil];
    return @{
      @"metadata": [[NSString alloc] initWithData:jsonMetadata encoding:NSUTF8StringEncoding],
      @"bounds": jsonBounds
    };
}

- (MHOfflinePack *)_getPackFromName:(NSString *)name
{
    NSArray<MHOfflinePack *> *packs = [[MHOfflineStorage sharedOfflineStorage] packs];

    if (packs == nil) {
        return nil;
    }

    for (MHOfflinePack *pack in packs) {
        NSDictionary *metadata = [self _unarchiveMetadata:pack];

        if ([name isEqualToString:metadata[@"name"]]) {
            return pack;
        }
    }

    return nil;
}

- (void)_sendEvent:(NSString *)eventName event:(MLRNEvent *)event
{
    if (!hasListeners) {
        return;
    }
    [self sendEventWithName:eventName body:[event toJSON]];
}

- (BOOL)_shouldSendProgressEvent:(double)currentTimestamp pack:(MHOfflinePack *)currentPack
{
    if (lastPackState == -1) {
        return YES;
    }

    if (lastPackState != currentPack.state) {
        return YES;
    }

    if (currentTimestamp - lastPackTimestamp > eventThrottle) {
        return YES;
    }

    return NO;
}

@end
