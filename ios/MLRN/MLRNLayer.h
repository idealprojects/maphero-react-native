#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>


@class MLRNMapView;

@import MapHero;

@interface MLRNLayer<T> : UIView

@property (nonatomic, weak, nullable) RCTBridge* bridge;

@property (nonatomic, strong, nullable) MHStyleLayer *styleLayer;
@property (nonatomic, strong, nullable) MHStyle *style;
@property (nonatomic, weak, nullable) MLRNMapView* map;
@property (nonatomic, strong, nullable) NSDictionary *reactStyle;
@property (nonatomic, strong, nullable) NSArray *filter;

@property (nonatomic, copy, nullable) NSString *id;
@property (nonatomic, copy, nullable) NSString *sourceID;

@property (nonatomic, copy, nullable) NSString *aboveLayerID;
@property (nonatomic, copy, nullable) NSString *belowLayerID;
@property (nonatomic, copy, nullable) NSNumber *layerIndex;

@property (nonatomic, copy, nullable) NSNumber *maxZoomLevel;
@property (nonatomic, copy, nullable) NSNumber *minZoomLevel;

- (void)addToMap:(nonnull MLRNMapView*)map style:(nonnull MHStyle*)style;
- (void)addedToMap;
- (void)removeFromMap:(nonnull MHStyle*)style;
- (nullable T)makeLayer:(nonnull MHStyle*)style;
- (void)addStyles;
- (void)insertAbove:(nonnull NSString*)layer;
- (void)insertBelow:(nonnull NSString*)layer;
- (void)insertAtIndex:(NSUInteger)index;
- (void)insertLayer;
- (void)setZoomBounds;

- (BOOL)isAddedToMap;

- (nullable MHSource*)layerWithSourceIDInStyle:(nonnull MHStyle*) style;

@end
