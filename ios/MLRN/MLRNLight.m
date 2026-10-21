#import "MLRNLight.h"
#import "MLRNStyle.h"

@implementation MLRNLight
{
    MHLight *internalLight;
}

- (void)setReactStyle:(NSDictionary *)reactStyle
{
    _reactStyle = reactStyle;
    
    if (_map != nil) {
        [self addStyles];
    }
}

- (void)setMap:(MHMapView *)map
{
    _map = map;
    [self addStyles];
}

- (BOOL)isAddedToMap {
    return _map != NULL;
}

- (void)addStyles
{
    MHLight *light = [[MHLight alloc] init];
    MLRNStyle *style = [[MLRNStyle alloc] init];
    [style lightLayer:light withReactStyle:_reactStyle isValid:^{
        return [self isAddedToMap];
    }];
    _map.style.light = light;
}

@end
