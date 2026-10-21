//
//  MLRNUserLocation.m
//  MLRN
//

#import "MLRNUserLocation.h"
#import <MapHero/MHUserLocationAnnotationView.h>

@interface HiddenUserLocationAnnotationView : MHUserLocationAnnotationView

@end

@implementation HiddenUserLocationAnnotationView


- (void)update {
    self.frame = CGRectNull;
}

@end


@implementation MLRNUserLocation : NSObject

+ (id)sharedInstance
{
    static MLRNUserLocation *userLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ userLocation = [[self alloc] init]; });
    return userLocation;
}

- (MHUserLocationAnnotationView*)hiddenUserAnnotation
{
    return [[HiddenUserLocationAnnotationView alloc] init];
}

@end
