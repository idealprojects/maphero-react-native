#import <Foundation/Foundation.h>
#import "MLRNEvent.h"
#import "MLRNPointAnnotation.h"
@import MapHero;

@interface MLRNMapTouchEvent : MLRNEvent

@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CGPoint screenPoint;

+ (MLRNMapTouchEvent*)makeTapEvent:(MHMapView*)mapView withPoint:(CGPoint)point;
+ (MLRNMapTouchEvent*)makeLongPressEvent:(MHMapView*)mapView withPoint:(CGPoint)point;
+ (MLRNMapTouchEvent *)makeAnnotationTapEvent:(MLRNPointAnnotation *)pointAnnotation;
+ (MLRNMapTouchEvent *)makeAnnotationTapEventOnDrag:(MLRNPointAnnotation *)pointAnnotation;

@end
