#import "ViewManager.h"
@import MapHero;

@interface MLRNMapViewManager : ViewManager

- (void)didTapMap:(UITapGestureRecognizer *)recognizer;
- (void)didLongPressMap:(UILongPressGestureRecognizer *)recognizer;

@end
