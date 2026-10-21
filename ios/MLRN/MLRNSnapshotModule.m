#import "MLRNSnapshotModule.h"
#import "MLRNUtils.h"
#import "MLRNImageUtils.h"
@import MapHero;

@implementation MLRNSnapshotModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_METHOD(takeSnap:(NSDictionary *)jsOptions
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MHMapSnapshotOptions *options = [self _getOptions:jsOptions];
        __block MHMapSnapshotter *snapshotter = [[MHMapSnapshotter alloc] initWithOptions:options];

        [snapshotter startWithCompletionHandler:^(MHMapSnapshot * _Nullable snapshot, NSError * _Nullable err) {         
            if (err != nil) {
                reject(@"takeSnap", @"Could not create snapshot", err);
                snapshotter = nil;
                return;
            }
            
            NSString *result = nil;
            if ([jsOptions[@"writeToDisk"] boolValue]) {
                result = [MLRNImageUtils createTempFile:snapshot.image];
            } else {
                result = [MLRNImageUtils createBase64:snapshot.image];
            }
            
            resolve(result);
            snapshotter = nil;
        }];
    });
}

- (MHMapSnapshotOptions *)_getOptions:(NSDictionary *)jsOptions
{
    MHMapCamera *camera = [[MHMapCamera alloc] init];
    
    camera.pitch = [jsOptions[@"pitch"] doubleValue];
    camera.heading = [jsOptions[@"heading"] doubleValue];
    
    if (jsOptions[@"centerCoordinate"] != nil) {
        camera.centerCoordinate = [MLRNUtils fromFeature:jsOptions[@"centerCoordinate"]];
    }
    
    NSNumber *width = jsOptions[@"width"];
    NSNumber *height = jsOptions[@"height"];
    CGSize size = CGSizeMake([width doubleValue], [height doubleValue]);
    
    MHMapSnapshotOptions *options = [[MHMapSnapshotOptions alloc] initWithStyleURL:[NSURL URLWithString:jsOptions[@"styleURL"]]
                                                                   camera:camera
                                                                   size:size];
    if (jsOptions[@"zoomLevel"] != nil) {
        options.zoomLevel = [jsOptions[@"zoomLevel"] doubleValue];
    }
    
    if (jsOptions[@"bounds"] != nil) {
        options.coordinateBounds = [MLRNUtils fromFeatureCollection:jsOptions[@"bounds"]];
    }

    return options;
}

@end
