#import "MLRNModule.h"
#import "MLRNEventTypes.h"
#import "MLRNOfflineModule.h"
#import "CameraMode.h"
#import "MLRNSource.h"
#import "MLRNCustomHeaders.h"
@import MapHero;

@implementation MHRNModule

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (NSDictionary<NSString *, id> *)constantsToExport
{
    // style urls
    NSMutableDictionary *styleURLS = [[NSMutableDictionary alloc] init];

    for (MHDefaultStyle* style in [MHStyle predefinedStyles]) {
      [styleURLS setObject:[style.url absoluteString] forKey:style.name];
    }
    [styleURLS setObject:[[MHStyle defaultStyleURL] absoluteString] forKey:@"Default"];

    // event types
    NSMutableDictionary *eventTypes = [[NSMutableDictionary alloc] init];
    [eventTypes setObject:RCT_MAPBOX_EVENT_TAP forKey:@"MapClick"];
    [eventTypes setObject:RCT_MAPBOX_EVENT_LONGPRESS forKey:@"MapLongClick"];
    [eventTypes setObject:RCT_MAPBOX_REGION_WILL_CHANGE_EVENT forKey:@"RegionWillChange"];
    [eventTypes setObject:RCT_MAPBOX_REGION_IS_CHANGING forKey:@"RegionIsChanging"];
    [eventTypes setObject:RCT_MAPBOX_REGION_DID_CHANGE forKey:@"RegionDidChange"];
    [eventTypes setObject:RCT_MAPBOX_WILL_START_LOADING_MAP forKey:@"WillStartLoadingMap"];
    [eventTypes setObject:RCT_MAPBOX_DID_FINISH_LOADING_MAP forKey:@"DidFinishLoadingMap"];
    [eventTypes setObject:RCT_MAPBOX_DID_FAIL_LOADING_MAP forKey:@"DidFailLoadingMap"];
    [eventTypes setObject:RCT_MAPBOX_WILL_START_RENDERING_FRAME forKey:@"WillStartRenderingFrame"];
    [eventTypes setObject:RCT_MAPBOX_DID_FINSIH_RENDERING_FRAME forKey:@"DidFinishRenderingFrame"];
    [eventTypes setObject:RCT_MAPBOX_DID_FINISH_RENDERING_FRAME_FULLY forKey:@"DidFinishRenderingFrameFully"];
    [eventTypes setObject:RCT_MAPBOX_WILL_START_RENDERING_MAP forKey:@"WillStartRenderingMap"];
    [eventTypes setObject:RCT_MAPBOX_DID_FINISH_RENDERING_MAP forKey:@"DidFinishRenderingMap"];
    [eventTypes setObject:RCT_MAPBOX_DID_FINISH_RENDERING_MAP_FULLY forKey:@"DidFinishRenderingMapFully"];
    [eventTypes setObject:RCT_MAPBOX_DID_FINISH_LOADING_STYLE forKey:@"DidFinishLoadingStyle"];

    // location module events
    NSMutableDictionary *locationModuleEvents = [[NSMutableDictionary alloc] init];
    [locationModuleEvents setObject:RCT_MAPBOX_USER_LOCATION_UPDATE forKey:@"Update"];

    // user tracking modes
    NSMutableDictionary *userTrackingModes = [[NSMutableDictionary alloc] init];
    [userTrackingModes setObject:[NSNumber numberWithInt:MHUserTrackingModeNone] forKey:@"None"];
    [userTrackingModes setObject:[NSNumber numberWithInt:MHUserTrackingModeFollow] forKey:@"Follow"];
    [userTrackingModes setObject:[NSNumber numberWithInt:MHUserTrackingModeFollowWithHeading] forKey:@"FollowWithHeading"];
    [userTrackingModes setObject:[NSNumber numberWithInt:MHUserTrackingModeFollowWithCourse] forKey:@"FollowWithCourse"];

    // user location vertical alignment
    NSMutableDictionary *userLocationVerticalAlignment = [[NSMutableDictionary alloc] init];
    [userLocationVerticalAlignment setObject:[NSNumber numberWithInt:MHAnnotationVerticalAlignmentTop] forKey:@"Top"];
    [userLocationVerticalAlignment setObject:[NSNumber numberWithInt:MHAnnotationVerticalAlignmentCenter] forKey:@"Center"];
    [userLocationVerticalAlignment setObject:[NSNumber numberWithInt:MHAnnotationVerticalAlignmentBottom] forKey:@"Bottom"];

    // camera modes
    NSMutableDictionary *cameraModes = [[NSMutableDictionary alloc] init];
    [cameraModes setObject:[NSNumber numberWithInt:RCT_MAPBOX_CAMERA_MODE_FLIGHT] forKey:@"Flight"];
    [cameraModes setObject:[NSNumber numberWithInt:RCT_MAPBOX_CAMERA_MODE_EASE] forKey:@"Ease"];
    [cameraModes setObject:[NSNumber numberWithInt:RCT_MAPBOX_CAMERA_MODE_LINEAR] forKey:@"Linear"];
    [cameraModes setObject:[NSNumber numberWithInt:RCT_MAPBOX_CAMERA_MODE_NONE] forKey:@"None"];

    // style sources
    NSMutableDictionary *styleSourceConsts = [[NSMutableDictionary alloc] init];
    [styleSourceConsts setObject:DEFAULT_SOURCE_ID forKey:@"DefaultSourceID"];

    // line layer constants
    NSMutableDictionary *lineJoin = [[NSMutableDictionary alloc] init];
    [lineJoin setObject:@(MHLineJoinBevel) forKey:@"Bevel"];
    [lineJoin setObject:@(MHLineJoinRound) forKey:@"Round"];
    [lineJoin setObject:@(MHLineJoinMiter) forKey:@"Miter"];

    NSMutableDictionary *lineCap = [[NSMutableDictionary alloc] init];
    [lineCap setObject:@(MHLineCapButt) forKey:@"Butt"];
    [lineCap setObject:@(MHLineCapRound) forKey:@"Round"];
    [lineCap setObject:@(MHLineCapSquare) forKey:@"Square"];

    NSMutableDictionary *lineTranslateAnchor = [[NSMutableDictionary alloc] init];
    [lineTranslateAnchor setObject:@(MHLineTranslationAnchorMap) forKey:@"Map"];
    [lineTranslateAnchor setObject:@(MHLineTranslationAnchorViewport) forKey:@"Viewport"];

    // circle layer constants
    NSMutableDictionary *circlePitchScale = [[NSMutableDictionary alloc] init];
    [circlePitchScale setObject:@(MHCircleScaleAlignmentMap) forKey:@"Map"];
    [circlePitchScale setObject:@(MHCircleScaleAlignmentViewport) forKey:@"Viewport"];

    NSMutableDictionary *circlePitchAlignment = [[NSMutableDictionary alloc] init];
    [circlePitchAlignment setObject:@(MHCirclePitchAlignmentMap) forKey:@"Map"];
    [circlePitchAlignment setObject:@(MHCirclePitchAlignmentViewport) forKey:@"Viewport"];

    NSMutableDictionary *circleTranslateAnchor = [[NSMutableDictionary alloc] init];
    [circleTranslateAnchor setObject:@(MHCircleTranslationAnchorMap) forKey:@"Map"];
    [circleTranslateAnchor setObject:@(MHCircleTranslationAnchorViewport) forKey:@"Viewport"];

    // fill extrusion layer constants
    NSMutableDictionary *fillExtrusionTranslateAnchor = [[NSMutableDictionary alloc] init];
    [fillExtrusionTranslateAnchor setObject:@(MHFillExtrusionTranslationAnchorMap) forKey:@"Map"];
    [fillExtrusionTranslateAnchor setObject:@(MHFillExtrusionTranslationAnchorViewport) forKey:@"Viewport"];

    // fill layer constants
    NSMutableDictionary *fillTranslateAnchor = [[NSMutableDictionary alloc] init];
    [fillTranslateAnchor setObject:@(MHFillTranslationAnchorMap) forKey:@"Map"];
    [fillTranslateAnchor setObject:@(MHFillTranslationAnchorViewport) forKey:@"Viewport"];

    // symbol layer constants
    NSMutableDictionary *iconRotationAlignment = [[NSMutableDictionary alloc] init];
    [iconRotationAlignment setObject:@(MHIconRotationAlignmentAuto) forKey:@"Auto"];
    [iconRotationAlignment setObject:@(MHIconRotationAlignmentMap) forKey:@"Map"];
    [iconRotationAlignment setObject:@(MHIconRotationAlignmentViewport) forKey:@"Viewport"];

    NSMutableDictionary *iconTextFit = [[NSMutableDictionary alloc] init];
    [iconTextFit setObject:@(MHIconTextFitNone) forKey:@"None"];
    [iconTextFit setObject:@(MHIconTextFitWidth) forKey:@"Width"];
    [iconTextFit setObject:@(MHIconTextFitHeight) forKey:@"Height"];
    [iconTextFit setObject:@(MHIconTextFitBoth) forKey:@"Both"];

    NSMutableDictionary *iconAnchor = [[NSMutableDictionary alloc] init];
    [iconAnchor setObject:@(MHIconAnchorCenter) forKey:@"Center"];
    [iconAnchor setObject:@(MHIconAnchorTop) forKey:@"Top"];
    [iconAnchor setObject:@(MHIconAnchorBottom) forKey:@"Bottom"];
    [iconAnchor setObject:@(MHIconAnchorLeft) forKey:@"Left"];
    [iconAnchor setObject:@(MHIconAnchorRight) forKey:@"Right"];
    [iconAnchor setObject:@(MHIconAnchorTopLeft) forKey:@"TopLeft"];
    [iconAnchor setObject:@(MHIconAnchorTopRight) forKey:@"TopRight"];
    [iconAnchor setObject:@(MHIconAnchorBottomLeft) forKey:@"BottomLeft"];
    [iconAnchor setObject:@(MHIconAnchorBottomRight) forKey:@"BottomRight"];

    NSMutableDictionary *iconTranslateAnchor = [[NSMutableDictionary alloc] init];
    [iconTranslateAnchor setObject:@(MHIconTranslationAnchorMap) forKey:@"Map"];
    [iconTranslateAnchor setObject:@(MHIconTranslationAnchorViewport) forKey:@"Viewport"];

    NSMutableDictionary *iconPitchAlignment = [[NSMutableDictionary alloc] init];
    [iconPitchAlignment setObject:@(MHIconPitchAlignmentAuto) forKey:@"Auto"];
    [iconPitchAlignment setObject:@(MHIconPitchAlignmentMap) forKey:@"Map"];
    [iconPitchAlignment setObject:@(MHIconPitchAlignmentViewport) forKey:@"Viewport"];

    NSMutableDictionary *symbolPlacement = [[NSMutableDictionary alloc] init];
    [symbolPlacement setObject:@(MHSymbolPlacementLine) forKey:@"Line"];
    [symbolPlacement setObject:@(MHSymbolPlacementPoint) forKey:@"Point"];

    NSMutableDictionary *textAnchor = [[NSMutableDictionary alloc] init];
    [textAnchor setObject:@(MHTextAnchorCenter) forKey:@"Center"];
    [textAnchor setObject:@(MHTextAnchorLeft) forKey:@"Left"];
    [textAnchor setObject:@(MHTextAnchorRight) forKey:@"Right"];
    [textAnchor setObject:@(MHTextAnchorTop) forKey:@"Top"];
    [textAnchor setObject:@(MHTextAnchorBottom) forKey:@"Bottom"];
    [textAnchor setObject:@(MHTextAnchorTopLeft) forKey:@"TopLeft"];
    [textAnchor setObject:@(MHTextAnchorTopRight) forKey:@"TopRight"];
    [textAnchor setObject:@(MHTextAnchorBottomLeft) forKey:@"BottomLeft"];
    [textAnchor setObject:@(MHTextAnchorBottomRight) forKey:@"BottomRight"];

    NSMutableDictionary *textJustify = [[NSMutableDictionary alloc] init];
    [textJustify setObject:@(MHTextJustificationCenter) forKey:@"Center"];
    [textJustify setObject:@(MHTextJustificationLeft) forKey:@"Left"];
    [textJustify setObject:@(MHTextJustificationRight) forKey:@"Right"];

    NSMutableDictionary *textPitchAlignment = [[NSMutableDictionary alloc] init];
    [textPitchAlignment setObject:@(MHTextPitchAlignmentAuto) forKey:@"Auto"];
    [textPitchAlignment setObject:@(MHTextPitchAlignmentMap) forKey:@"Map"];
    [textPitchAlignment setObject:@(MHTextPitchAlignmentViewport) forKey:@"Viewport"];

    NSMutableDictionary *textRotationAlignment = [[NSMutableDictionary alloc] init];
    [textRotationAlignment setObject:@(MHTextRotationAlignmentAuto) forKey:@"Auto"];
    [textRotationAlignment setObject:@(MHTextRotationAlignmentMap) forKey:@"Map"];
    [textRotationAlignment setObject:@(MHTextRotationAlignmentViewport) forKey:@"Viewport"];

    NSMutableDictionary *textTransform = [[NSMutableDictionary alloc] init];
    [textTransform setObject:@(MHTextTransformNone) forKey:@"None"];
    [textTransform setObject:@(MHTextTransformLowercase) forKey:@"Lowercase"];
    [textTransform setObject:@(MHTextTransformUppercase) forKey:@"Uppercase"];

    NSMutableDictionary *textTranslateAnchor = [[NSMutableDictionary alloc] init];
    [textTranslateAnchor setObject:@(MHTextTranslationAnchorMap) forKey:@"Map"];
    [textTranslateAnchor setObject:@(MHTextTranslationAnchorViewport) forKey:@"Viewport"];

    // light constants
    NSMutableDictionary *lightAnchor = [[NSMutableDictionary alloc] init];
    [lightAnchor setObject:@(MHLightAnchorMap) forKey:@"Map"];
    [lightAnchor setObject:@(MHLightAnchorViewport) forKey:@"Viewport"];

    // offline module callback names
    NSMutableDictionary *offlineModuleCallbackNames = [[NSMutableDictionary alloc] init];
    [offlineModuleCallbackNames setObject:RCT_MAPBOX_OFFLINE_CALLBACK_ERROR forKey:@"Error"];
    [offlineModuleCallbackNames setObject:RCT_MAPBOX_OFFLINE_CALLBACK_PROGRESS forKey:@"Progress"];

    NSMutableDictionary *offlinePackDownloadState = [[NSMutableDictionary alloc] init];
    [offlinePackDownloadState setObject:@(MHOfflinePackStateInactive) forKey:@"Inactive"];
    [offlinePackDownloadState setObject:@(MHOfflinePackStateActive) forKey:@"Active"];
    [offlinePackDownloadState setObject:@(MHOfflinePackStateComplete) forKey:@"Complete"];

    return @{
         @"StyleURL": styleURLS,
         @"EventTypes": eventTypes,
         @"UserTrackingModes": userTrackingModes,
         @"UserLocationVerticalAlignment": userLocationVerticalAlignment,
         @"CameraModes": cameraModes,
         @"StyleSource": styleSourceConsts,
         @"LineJoin": lineJoin,
         @"LineCap": lineCap,
         @"LineTranslateAnchor": lineTranslateAnchor,
         @"CirclePitchScale": circlePitchScale,
         @"CircleTranslateAnchor": circleTranslateAnchor,
         @"CirclePitchAlignment": circlePitchAlignment,
         @"FillExtrusionTranslateAnchor": fillExtrusionTranslateAnchor,
         @"FillTranslateAnchor": fillTranslateAnchor,
         @"IconRotationAlignment": iconRotationAlignment,
         @"IconTextFit": iconTextFit,
         @"IconTranslateAnchor": iconTranslateAnchor,
         @"IconAnchor": iconAnchor,
         @"IconPitchAlignment": iconPitchAlignment,
         @"SymbolPlacement": symbolPlacement,
         @"TextAnchor": textAnchor,
         @"TextJustify": textJustify,
         @"TextPitchAlignment": textPitchAlignment,
         @"TextRotationAlignment": textRotationAlignment,
         @"TextTransform": textTransform,
         @"TextTranslateAnchor": textTranslateAnchor,
         @"LightAnchor": lightAnchor,
         @"OfflineCallbackName": offlineModuleCallbackNames,
         @"OfflinePackDownloadState": offlinePackDownloadState,
         @"LocationCallbackName": locationModuleEvents
    };
}

// The MapHero API key. The SDK sends it as X-API-Key on every request the map makes, with this
// app's bundle identifier beside it for keys restricted to named apps.
RCT_EXPORT_METHOD(setAccessToken:(NSString *)accessToken)
{
    if (accessToken.length > 0) {
      [MHSettings setApiKey:accessToken];
    }
}

RCT_EXPORT_METHOD(addCustomHeader:(NSString *)headerName forHeaderValue:(NSString *) headerValue)
{
    [MLRNCustomHeaders.sharedInstance addHeader:headerValue forHeaderName:headerName];
}

RCT_EXPORT_METHOD(removeCustomHeader:(NSString *)headerName)
{
    [MLRNCustomHeaders.sharedInstance removeHeader:headerName];
}

RCT_EXPORT_METHOD(getAccessToken:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString* accessToken = MHSettings.apiKey;

    if (accessToken != nil) {
        resolve(accessToken);
        return;
    }

    reject(@"missing_access_token", @"No access token has been set", nil);
}

@end
