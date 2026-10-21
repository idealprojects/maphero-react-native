//
//  MLRNUserLocation.h
//  MLRN

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapHero/MHUserLocationAnnotationView.h>

@interface MLRNUserLocation : NSObject

+ (id)sharedInstance;

- (MHUserLocationAnnotationView*)hiddenUserAnnotation;

@end
